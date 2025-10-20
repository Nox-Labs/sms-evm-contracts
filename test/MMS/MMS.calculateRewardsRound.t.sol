// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_MMS.Setup.t.sol";

contract CalculateRewardsRound is MMSSetup {
    uint32 start;
    uint32 middle;
    uint32 end;

    function _afterSetUp() internal override {
        sms.mint(address(mms), MINT_AMOUNT * 100, mockData);

        mms.stake(address(this), MINT_AMOUNT, mockData);

        sms.mint(address(this), MINT_AMOUNT, mockData);
        mms.stake(user, MINT_AMOUNT, mockData);

        (start, end) = mms.getRoundPeriod(currentRoundId);
        middle = start + (end - start) / 2;
    }

    function testFuzz_ShouldIncreaseRewardsWithTime(uint256 period) public {
        period = bound(period, twabPeriodLength, end - start);

        skip(period);

        assertGt(mms.calculateRewardsRound(currentRoundId, address(this)), 0);
    }

    function test_ShouldYieldHalfOfRewardsForPeriodByTheMiddle() public {
        vm.warp(middle);

        uint256 generatedRewards = mms.calculateRewardsRound(currentRoundId, address(this));
        uint256 targetRewards = _multiplyAmountByBp(MINT_AMOUNT) / 2;

        assertApproxEqAbs(generatedRewards, targetRewards, dust);
    }

    function test_ShouldYieldAllRewardsForPeriodByTheEnd() public {
        vm.warp(end);

        uint256 generatedRewards = mms.calculateRewardsRound(currentRoundId, address(this));
        uint256 targetRewards = _multiplyAmountByBp(MINT_AMOUNT);

        assertApproxEqAbs(generatedRewards, targetRewards, dust);
    }

    function test_ShouldYieldCorrectRewardsWhenClaimingRewardsInNotEndedRound() public {
        vm.warp(middle);

        uint256 generatedRewardsByThisBefore =
            mms.calculateRewardsRound(currentRoundId, address(this));
        uint256 generatedRewardsByUserBefore = mms.calculateRewardsRound(currentRoundId, user);

        assertEq(generatedRewardsByThisBefore, generatedRewardsByUserBefore);

        mms.redeem(address(this), MINT_AMOUNT, mockData);

        vm.warp(end);

        uint256 generatedRewardsByThisAfter =
            mms.calculateRewardsRound(currentRoundId, address(this));
        uint256 generatedRewardsByUserAfter = mms.calculateRewardsRound(currentRoundId, user);

        assertApproxEqAbs(generatedRewardsByThisAfter, generatedRewardsByThisBefore, dust);
        assertApproxEqAbs(generatedRewardsByThisAfter, generatedRewardsByUserBefore, dust);
        assertApproxEqAbs(generatedRewardsByUserAfter, generatedRewardsByUserBefore * 2, dust);
    }

    function test_ShouldYieldHalfOfRewardsByTheMiddleAndNoMore() public {
        vm.warp(middle);

        mms.redeem(address(this), MINT_AMOUNT, mockData);
        uint256 generatedRewardsBefore = mms.calculateRewardsRound(currentRoundId, address(this));

        vm.warp(end);

        uint256 generatedRewardsAfter = mms.calculateRewardsRound(currentRoundId, address(this));
        uint256 targetRewards = _multiplyAmountByBp(MINT_AMOUNT) / 2;

        assertApproxEqAbs(generatedRewardsAfter, targetRewards, dust);
        assertApproxEqAbs(generatedRewardsAfter, generatedRewardsBefore, dust);
    }

    function test_TwoStakersShouldYieldDifferentRewardsWhenStakingDifferentPeriods() public {
        vm.warp(middle);

        uint256 rewardsBeforeUser = mms.calculateRewardsRound(currentRoundId, user);
        uint256 rewardsBeforeThis = mms.calculateRewardsRound(currentRoundId, address(this));
        assertEq(rewardsBeforeUser, rewardsBeforeThis);

        mms.redeem(address(this), MINT_AMOUNT, mockData);

        vm.warp(end);

        uint256 rewardsAfterUser = mms.calculateRewardsRound(currentRoundId, user);
        uint256 rewardsAfterThis = mms.calculateRewardsRound(currentRoundId, address(this));

        assertApproxEqAbs(rewardsAfterUser, rewardsAfterThis * 2, dust);
        assertApproxEqAbs(rewardsAfterThis, rewardsBeforeThis, dust);
    }

    function test_ShouldYieldAllRewardsByTheEndAndNoMore() public {
        vm.warp(end);

        uint256 generatedRewardsBefore = mms.calculateRewardsRound(currentRoundId, address(this));
        vm.warp(end + 1e6);
        uint256 generatedRewardsAfter = mms.calculateRewardsRound(currentRoundId, address(this));

        assertEq(generatedRewardsAfter, generatedRewardsBefore);
    }
}
