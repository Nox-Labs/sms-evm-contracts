// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_MMS.Setup.t.sol";

contract Redeem is MMSSetup {
    function _afterSetUp() internal override {
        mms.stake(address(this), MINT_AMOUNT, mockData);
    }

    function testFuzz_ShouldBurnMMS(uint256 amount) public {
        amount = bound(amount, 1, MINT_AMOUNT);

        uint256 totalSupplyMMSBefore = mms.totalSupply();
        mms.redeem(address(this), uint96(amount), mockData);
        uint256 balanceAfterMMS = mms.balanceOf(address(this));
        assertEq(balanceAfterMMS, totalSupplyMMSBefore - amount);
    }

    function test_RevertIfHighPaused() public {
        smsDataHub.setPauseLevel(PauseLevel.High);
        vm.expectRevert(Base.Paused.selector);
        mms.redeem(address(this), 1, mockData);
    }

    function test_RevertIfZeroAmount() public {
        vm.expectRevert(Base.ZeroAmount.selector);
        mms.redeem(address(this), 0, mockData);
    }

    function test_RevertIfZeroBytes() public {
        vm.expectRevert(Base.EmptyBytes.selector);
        mms.redeem(address(this), MINT_AMOUNT, "");
    }

    function test_ShouldEmitEvent() public {
        vm.expectEmit(true, true, true, true);
        emit IERC20.Transfer(address(this), address(0), MINT_AMOUNT);
        vm.expectEmit(true, true, true, true);
        emit IMMS.Redeem(address(this), MINT_AMOUNT, mockData);
        mms.redeem(address(this), MINT_AMOUNT, mockData);
    }

    function test_ShouldUpdateRoundTimestampAfterFirstRound() public test_roundTimestampModifier {
        mms.redeem(address(this), 1, mockData);
    }
}
