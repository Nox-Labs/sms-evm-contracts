// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_MMS.Setup.t.sol";

contract Stake is MMSSetup {
    function _afterSetUp() internal override {
        sms.mint(address(this), 1, mockData);
    }

    function testFuzz_ShouldMintMMS(uint256 amount) public {
        amount = bound(amount, 1, MINT_AMOUNT);

        mms.stake(address(this), uint96(amount), mockData);

        uint256 balanceAfterMMS = mms.balanceOf(address(this));
        uint256 totalSupplyMMSAfter = mms.totalSupply();

        assertEq(balanceAfterMMS, amount);
        assertEq(totalSupplyMMSAfter, amount);
    }

    function testFuzz_ShouldTransferSMS(uint256 amount) public {
        amount = bound(amount, 1, MINT_AMOUNT);

        uint256 balanceBeforeMMS = mms.balanceOf(address(this));
        mms.stake(address(this), uint96(amount), mockData);
        uint256 balanceAfterMMS = mms.balanceOf(address(this));

        assertEq(balanceAfterMMS, balanceBeforeMMS + amount);
    }

    function testFuzz_ShouldIncreaseTotalSupply(uint256 amount) public {
        amount = bound(amount, 1, MINT_AMOUNT);

        uint256 totalSupplyBefore = mms.totalSupply();
        mms.stake(address(this), uint96(amount), mockData);
        uint256 totalSupplyAfter = mms.totalSupply();

        assertEq(totalSupplyAfter, totalSupplyBefore + amount);
    }

    function test_RevertIfNotAdminOrOmnichainAdapter() public {
        vm.prank(user);
        vm.expectRevert(Base.Unauthorized.selector);
        mms.stake(address(this), uint96(MINT_AMOUNT), mockData);
    }

    function test_RevertIfHighPaused() public {
        smsDataHub.setPauseLevel(PauseLevel.High);
        vm.expectRevert(Base.Paused.selector);
        mms.stake(address(this), 1, mockData);
    }

    function test_RevertIfZeroAmount() public {
        vm.expectRevert(Base.ZeroAmount.selector);
        mms.stake(address(this), 0, mockData);
    }

    function test_RevertIfZeroAddress() public {
        vm.expectRevert(Base.ZeroAddress.selector);
        mms.stake(address(0), 1, mockData);
    }

    function test_RevertIfZeroBytes() public {
        vm.expectRevert(Base.EmptyBytes.selector);
        mms.stake(address(this), MINT_AMOUNT, "");
    }

    function test_ShouldEmitEvent() public {
        vm.expectEmit(true, true, true, true);
        emit IERC20.Transfer(address(0), address(this), MINT_AMOUNT);
        vm.expectEmit(true, true, true, true);
        emit IMMS.Stake(address(this), MINT_AMOUNT, mockData);
        mms.stake(address(this), uint96(MINT_AMOUNT), mockData);
    }

    function test_ShouldUpdateRoundTimestampAfterFirstRound() public test_roundTimestampModifier {
        mms.stake(address(this), 1, mockData);
    }
}
