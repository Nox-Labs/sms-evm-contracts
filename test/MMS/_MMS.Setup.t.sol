// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "test/BaseSetup.sol";

contract MMSSetup is BaseSetup {
    uint256 dust = 1 wei; // math errors

    uint32 bp;
    uint32 currentRoundId;
    uint32 roundDuration;

    function _setUp() internal override {
        super._setUp();

        currentRoundId = mms.getCurrentRoundId();
        (bp, roundDuration,) = mms.getRoundInfo(currentRoundId);
    }

    function _multiplyAmountByBp(uint256 amount) internal view returns (uint256) {
        return (amount * bp) / mms.BP_PRECISION();
    }

    function _endCurrentTwabObservationPeriod() internal {
        skip(twabPeriodLength);
    }

    modifier test_roundTimestampModifier() {
        (, uint32 end) = mms.getRoundPeriod(currentRoundId);
        vm.warp(end);

        vm.expectEmit(true, true, true, true);
        emit IMMS.NewRound(currentRoundId + 1, end, end + roundDuration);
        _;

        uint32 _currentRoundId = mms.getCurrentRoundId();
        (uint32 _start, uint32 _end) = mms.getRoundPeriod(_currentRoundId);

        assertEq(_currentRoundId, currentRoundId + 1);
        assertEq(_start, end);
        assertEq(_end, end + roundDuration);
    }
}
