// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./RewardIntegrityHandler.sol";

contract MMSRewardIntegrityTest is Test {
    MMSSetup internal setup;
    RewardIntegrityHandler internal handler;
    MMS internal mms;

    function setUp() public {
        setup = new MMSSetup();
        setup.setUp();
        mms = setup.mms();
        handler = new RewardIntegrityHandler(setup);
        targetContract(address(handler));
    }

    /// forge-config: default.invariant.runs = 40
    /// forge-config: default.invariant.depth = 100
    /// forge-config: default.invariant.fail-on-revert = true
    /// forge-config: default.invariant.call-override = false
    function invariant_RewardIntegrity() public view {
        uint32 currentRoundId = mms.getCurrentRoundId();
        if (currentRoundId == 0) return;
        for (uint32 roundId = 0; roundId < currentRoundId; roundId++) {
            (,, bool isFinalized) = mms.getRoundInfo(roundId);
            if (isFinalized) {
                uint256 totalCalculatedRewards = mms.calculateTotalRewardsRound(roundId);
                uint256 totalClaimed = handler.totalClaimedPerRound(roundId);
                assertGe(totalCalculatedRewards, totalClaimed, "Invariant Violated");
            }
        }
    }

    /// forge-config: default.invariant.runs = 40
    /// forge-config: default.invariant.depth = 100
    /// forge-config: default.invariant.fail-on-revert = true
    /// forge-config: default.invariant.call-override = false
    function invariant_SumOfIndividualRewards() public view {
        uint32 currentRoundId = mms.getCurrentRoundId();
        if (currentRoundId == 0) return;

        address[] memory _stakers = handler.getStakers();
        if (_stakers.length == 0) return;

        // Check the invariant for all rounds
        for (uint32 roundId = 0; roundId < currentRoundId; roundId++) {
            uint256 totalCalculatedRewards = mms.calculateTotalRewardsRound(roundId);
            uint256 sumOfIndividualRewards = 0;

            for (uint256 i = 0; i < _stakers.length; i++) {
                sumOfIndividualRewards += mms.calculateRewardsRound(roundId, _stakers[i]);
            }

            assertLe(
                sumOfIndividualRewards,
                totalCalculatedRewards,
                "Sum of individual rewards exceeds total rewards"
            );
        }
    }
}
