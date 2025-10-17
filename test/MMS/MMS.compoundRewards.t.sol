// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_MMS.Setup.t.sol";

contract CompoundRewards is MMSSetup {
    function _afterSetUp() internal override {
        sms.mint(address(mms), MINT_AMOUNT * 100, mockData);

        mms.stake(address(this), MINT_AMOUNT, mockData);
        (, uint32 end) = mms.getRoundPeriod(currentRoundId);
        vm.warp(end);
    }

    function test_ShouldCompoundAllRewardsForRound() public {
        uint256 claimableRewards = mms.calculateClaimableRewards(currentRoundId, address(this));

        uint256 mmsBalanceBefore = mms.balanceOf(address(this));
        uint256 smsBalanceBefore = sms.balanceOf(address(this));
        mms.compoundRewards(currentRoundId, address(this));
        uint256 mmsBalanceAfter = mms.balanceOf(address(this));
        uint256 smsBalanceAfter = sms.balanceOf(address(this));

        assertEq(smsBalanceAfter, smsBalanceBefore);
        assertEq(mmsBalanceAfter, mmsBalanceBefore + claimableRewards);
    }

    function test_RevertIfNotMinter() public {
        vm.expectRevert(Base.Unauthorized.selector);
        vm.prank(user);
        mms.compoundRewards(currentRoundId, address(this));
    }

    function test_ShouldEmitEvent() public {
        uint256 rewards = mms.calculateClaimableRewards(currentRoundId, address(this));

        vm.expectEmit(true, true, true, true);
        emit IMMS.RewardsCompounded(currentRoundId, address(this), rewards);
        mms.compoundRewards(currentRoundId, address(this));
    }

    function test_RevertIfHighPaused() public {
        smsDataHub.setPauseLevel(PauseLevel.High);
        vm.expectRevert(Base.Paused.selector);
        mms.compoundRewards(currentRoundId, address(this));
    }

    function test_ShouldUpdateRoundTimestampAfterFirstRound() public test_roundTimestampModifier {
        mms.compoundRewards(currentRoundId, address(this));
    }
}
