// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_SMS.Setup.t.sol";

contract Mint is SMSSetup {
    bytes constant DATA = "https://example.com";

    /* ======== MINT ======== */

    function test_ShouldIncreaseBalance() public {
        uint256 balanceBefore = sms.balanceOf(address(this));
        vm.prank(address(adapter));
        sms.mint(address(this), MINT_AMOUNT);
        uint256 balanceAfter = sms.balanceOf(address(this));
        assertEq(balanceAfter, balanceBefore + MINT_AMOUNT);
    }

    function test_ShouldIncreaseTotalSupply() public {
        uint256 totalSupplyBefore = sms.totalSupply();
        vm.prank(address(adapter));
        sms.mint(address(this), MINT_AMOUNT);
        uint256 totalSupplyAfter = sms.totalSupply();
        assertEq(totalSupplyAfter, totalSupplyBefore + MINT_AMOUNT);
    }

    function test_RevertIfNotCrossChainMinter() public {
        vm.prank(user);
        vm.expectRevert(Base.Unauthorized.selector);
        sms.mint(user, MINT_AMOUNT);
    }

    function test_RevertIfZeroAmount() public {
        vm.expectRevert(Base.ZeroAmount.selector);
        vm.prank(address(adapter));
        sms.mint(address(this), 0);
    }

    function test_RevertIfZeroAddress() public {
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Errors.ERC20InvalidReceiver.selector, address(0))
        );
        vm.prank(address(adapter));
        sms.mint(address(0), MINT_AMOUNT);
    }

    function test_RevertIfHighPaused() public {
        smsDataHub.setPauseLevel(PauseLevel.High);
        vm.expectRevert(Base.Paused.selector);
        vm.prank(address(adapter));
        sms.mint(address(this), MINT_AMOUNT);
    }

    function test_ShouldEmitEvent() public {
        vm.expectEmit(true, true, true, true);
        emit IERC20.Transfer(address(0), address(this), MINT_AMOUNT);
        vm.expectEmit(true, true, true, true);
        emit ISMS.Mint(address(this), MINT_AMOUNT, abi.encodePacked(sms.CROSS_CHAIN()));
        vm.prank(address(adapter));
        sms.mint(address(this), MINT_AMOUNT);
    }

    /* ======== MINT WITH DATA ======== */

    function test_ShouldIncreaseBalanceWithData() public {
        uint256 balanceBefore = sms.balanceOf(address(this));
        sms.mint(address(this), MINT_AMOUNT, DATA);
        uint256 balanceAfter = sms.balanceOf(address(this));
        assertEq(balanceAfter, balanceBefore + MINT_AMOUNT);
    }

    function test_ShouldIncreaseTotalSupplyWithData() public {
        uint256 totalSupplyBefore = sms.totalSupply();
        sms.mint(address(this), MINT_AMOUNT, DATA);
        uint256 totalSupplyAfter = sms.totalSupply();
        assertEq(totalSupplyAfter, totalSupplyBefore + MINT_AMOUNT);
    }

    function test_ShouldRevertIfZeroAmountWithData() public {
        vm.expectRevert(Base.ZeroAmount.selector);
        sms.mint(address(this), 0, DATA);
    }

    function test_ShouldRevertIfZeroAddressWithData() public {
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Errors.ERC20InvalidReceiver.selector, address(0))
        );
        sms.mint(address(0), MINT_AMOUNT, DATA);
    }

    function test_ShouldRevertIfPausedWithData() public {
        smsDataHub.setPauseLevel(PauseLevel.High);
        vm.expectRevert(Base.Paused.selector);
        sms.mint(address(this), MINT_AMOUNT, DATA);
    }

    function test_ShouldEmitEventWithData() public {
        vm.expectEmit(true, true, true, true);
        emit IERC20.Transfer(address(0), address(this), MINT_AMOUNT);
        vm.expectEmit(true, true, true, true);
        emit ISMS.Mint(address(this), MINT_AMOUNT, DATA);

        sms.mint(address(this), MINT_AMOUNT, DATA);
    }

    function test_ShouldRevertIfNotMinterWithData() public {
        vm.prank(user);
        vm.expectRevert(Base.Unauthorized.selector);
        sms.mint(user, MINT_AMOUNT, DATA);
    }

    function test_RevertIfZeroBytesWithData() public {
        vm.expectRevert(Base.EmptyBytes.selector);
        sms.mint(address(this), MINT_AMOUNT, "");
    }

    function test_RevertIfCrossChainActionWithData() public {
        bytes memory data = abi.encodePacked(sms.CROSS_CHAIN());
        vm.expectRevert(ISMS.CrossChainActionNotAllowed.selector);
        sms.mint(address(this), MINT_AMOUNT, data);
    }
}
