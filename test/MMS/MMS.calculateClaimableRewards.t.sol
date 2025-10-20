// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_MMS.Setup.t.sol";

contract CalculateClaimableRewards is MMSSetup {
    function _afterSetUp() internal override {
        sms.mint(address(mms), MINT_AMOUNT * 100, mockData);

        mms.stake(address(this), MINT_AMOUNT, mockData);
        skip(roundDuration);
    }

    function test_ShouldReturnZeroIfNoRewards() public view {
        assertEq(mms.calculateClaimableRewards(currentRoundId, user), 0);
    }

    function test_ShouldReturnAllRewardsIfRewardsWasNotClaimed() public view {
        uint256 targetRewards = _multiplyAmountByBp(MINT_AMOUNT);

        uint256 claimableRewards = mms.calculateClaimableRewards(currentRoundId, address(this));

        assertApproxEqAbs(claimableRewards, targetRewards, dust);
    }

    function testFuzz_ShouldReturnLessRewardsIfRewardsWasClaimed(uint256 amount) public {
        uint256 claimableRewards = mms.calculateClaimableRewards(currentRoundId, address(this));

        amount = bound(amount, 1, claimableRewards);

        _finalizeCurrentRound();

        mms.claimRewards(currentRoundId, address(this), address(this), amount, mockData);

        assertEq(
            mms.calculateClaimableRewards(currentRoundId, address(this)), claimableRewards - amount
        );
    }
}
