// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_MMS.Setup.t.sol";

contract CalculateTotalRewardsRound is MMSSetup {
    function _afterSetUp() internal override {
        sms.mint(address(this), MINT_AMOUNT, mockData);
    }

    function test_ShouldReturnZeroIfNoRewards() public view {
        assertEq(mms.totalSupply(), 0);
        assertEq(mms.calculateTotalRewardsRound(currentRoundId), 0);
    }

    function test_ShouldReturnTotalRewards() public {
        mms.stake(address(this), MINT_AMOUNT, mockData);

        skip(roundDuration);

        assertApproxEqAbs(
            mms.calculateTotalRewardsRound(currentRoundId),
            mms.calculateClaimableRewards(currentRoundId, address(this)),
            dust
        );
    }
}
