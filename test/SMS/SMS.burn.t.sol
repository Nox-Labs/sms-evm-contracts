// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_SMS.Setup.t.sol";

contract Burn is SMSSetup {
    bytes constant DATA = abi.encodePacked(keccak256("mockData"));

    function _afterSetUp() internal override {
        vm.prank(address(adapter));
        sms.mint(address(adapter), MINT_AMOUNT);
    }

    /* ======== BURN  ======== */

    function test_ShouldDecreaseBalance() public {
        uint256 balanceBefore = sms.balanceOf(address(adapter));
        vm.prank(address(adapter));
        sms.burn(MINT_AMOUNT);
        uint256 balanceAfter = sms.balanceOf(address(adapter));
        assertEq(balanceAfter, balanceBefore - MINT_AMOUNT);
    }

    function test_ShouldDecreaseTotalSupply() public {
        uint256 totalSupplyBefore = sms.totalSupply();
        vm.prank(address(adapter));
        sms.burn(MINT_AMOUNT);
        uint256 totalSupplyAfter = sms.totalSupply();
        assertEq(totalSupplyAfter, totalSupplyBefore - MINT_AMOUNT);
    }

    function test_RevertIfNotCrossChainMinter() public {
        vm.prank(user);
        vm.expectRevert(Base.Unauthorized.selector);
        sms.burn(MINT_AMOUNT);
    }

    function test_RevertIfZeroAmount() public {
        vm.expectRevert(Base.ZeroAmount.selector);
        vm.prank(address(adapter));
        sms.burn(0);
    }

    function test_RevertIfHighPaused() public {
        smsDataHub.setPauseLevel(PauseLevel.High);
        vm.expectRevert(Base.Paused.selector);
        vm.prank(address(adapter));
        sms.burn(MINT_AMOUNT);
    }

    function test_ShouldEmitEvent() public {
        vm.expectEmit(true, true, true, true);
        emit IERC20.Transfer(address(adapter), address(0), MINT_AMOUNT);
        vm.expectEmit(true, true, true, true);
        emit ISMS.Burn(address(adapter), MINT_AMOUNT, abi.encodePacked(sms.CROSS_CHAIN()));
        vm.prank(address(adapter));
        sms.burn(MINT_AMOUNT);
    }

    /* ======== BURN WITH DATA ======== */

    function test_ShouldDecreaseBalanceWithData() public {
        uint256 balanceBefore = sms.balanceOf(address(this));
        sms.burn(MINT_AMOUNT, DATA);
        uint256 balanceAfter = sms.balanceOf(address(this));
        assertEq(balanceAfter, balanceBefore - MINT_AMOUNT);
    }

    function test_ShouldDecreaseTotalSupplyWithData() public {
        uint256 totalSupplyBefore = sms.totalSupply();
        sms.burn(MINT_AMOUNT, DATA);
        uint256 totalSupplyAfter = sms.totalSupply();
        assertEq(totalSupplyAfter, totalSupplyBefore - MINT_AMOUNT);
    }

    function test_RevertIfZeroAmountWithData() public {
        vm.expectRevert(Base.ZeroAmount.selector);
        sms.burn(0, DATA);
    }

    function test_RevertIfZeroBytesWithData() public {
        vm.expectRevert(Base.EmptyBytes.selector);
        sms.burn(MINT_AMOUNT, "");
    }

    function test_RevertIfCrossChainActionWithData() public {
        bytes memory data = abi.encodePacked(sms.CROSS_CHAIN());
        vm.expectRevert(ISMS.CrossChainActionNotAllowed.selector);
        sms.burn(MINT_AMOUNT, data);
    }

    function test_RevertIfHighPausedWithData() public {
        smsDataHub.setPauseLevel(PauseLevel.High);
        vm.expectRevert(Base.Paused.selector);
        sms.burn(MINT_AMOUNT, DATA);
    }

    function test_RevertIfNotMinterWithData() public {
        vm.prank(user);
        vm.expectRevert(Base.Unauthorized.selector);
        sms.burn(MINT_AMOUNT, DATA);
    }

    function test_ShouldEmitEventWithData() public {
        vm.expectEmit(true, true, true, true);
        emit IERC20.Transfer(address(this), address(0), MINT_AMOUNT);
        vm.expectEmit(true, true, true, true);
        emit ISMS.Burn(address(this), MINT_AMOUNT, DATA);
        vm.prank(address(this));
        sms.burn(MINT_AMOUNT, DATA);
    }
}
