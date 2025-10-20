// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_MMS.Setup.t.sol";

contract FinalizeRound is MMSSetup {
    function _afterSetUp() internal override {
        sms.mint(address(this), MINT_AMOUNT * 100, mockData);
        sms.mint(address(mms), MINT_AMOUNT * 100, mockData);
    }

    function testFuzz_ShouldFinalizeRound(uint256 amount) public {
        amount = bound(amount, 1, MINT_AMOUNT);
        mms.stake(address(this), uint96(amount), mockData);
        skip(roundDuration);

        uint256 balanceBeforeAdmin = sms.balanceOf(address(this));
        uint256 balanceBeforeMMS = sms.balanceOf(address(mms));

        mms.finalizeRound(currentRoundId);

        uint256 balanceAfterAdmin = sms.balanceOf(address(this));
        uint256 balanceAfterMMS = sms.balanceOf(address(mms));

        uint256 totalRewards = mms.calculateTotalRewardsRound(currentRoundId);

        assertEq(balanceAfterAdmin, balanceBeforeAdmin - totalRewards);
        assertEq(balanceAfterMMS, balanceBeforeMMS + totalRewards);

        (,, bool isFinalized) = mms.getRoundInfo(currentRoundId);

        assertEq(isFinalized, true);
    }

    function testFuzz_ShouldRecalculateRewardsWithNewBp(uint256 amount) public {
        amount = bound(amount, 10, MINT_AMOUNT);
        mms.stake(address(this), uint96(amount), mockData);
        skip(roundDuration);

        assertApproxEqAbs(
            mms.calculateTotalRewardsRound(currentRoundId), _multiplyAmountByBp(amount), dust
        );

        mms.finalizeRound(currentRoundId, ROUND_BP / 2);

        assertApproxEqAbs(
            mms.calculateTotalRewardsRound(currentRoundId), _multiplyAmountByBp(amount) / 2, dust
        );
    }

    function test_ShouldFinalizeRoundAndChangeBp(uint256 amount) public {
        amount = bound(amount, 1, 10000);
        mms.stake(address(this), uint96(amount), mockData);
        skip(roundDuration);

        (uint32 bpBefore,,) = mms.getRoundInfo(currentRoundId);

        uint32 newBp = bpBefore - 100;

        mms.finalizeRound(currentRoundId, newBp);

        (uint32 bpAfter,,) = mms.getRoundInfo(currentRoundId);
        assertEq(bpAfter, newBp);
    }

    function test_RevertIfRoundNotEnded() public {
        vm.expectRevert(IMMS.RoundNotEnded.selector);
        mms.finalizeRound(currentRoundId);
    }

    function test_RevertIfTwabNotFinalized() public {
        uint32 breakDuration = 1000; // in base setup roundDuration end timestamp and twab finalize observation is the same, we need to break this to test the revert

        mms.changeNextRoundDuration(roundDuration + breakDuration);
        skip(roundDuration);
        mms.finalizeRound(currentRoundId);
        mms.stake(address(this), MINT_AMOUNT, mockData);
        skip(roundDuration + breakDuration);

        vm.expectRevert(IMMS.TwabNotFinalized.selector);
        mms.finalizeRound(currentRoundId + 1);
    }

    function test_ShouldEmitEvent() public {
        skip(roundDuration);

        uint256 totalRewards = mms.calculateTotalRewardsRound(currentRoundId);

        vm.expectEmit(true, true, true, true);
        emit IMMS.RoundFinalized(currentRoundId, totalRewards);
        mms.finalizeRound(currentRoundId);
    }
}
