// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_MMS.Setup.t.sol";

contract ChangeNextRoundDuration is MMSSetup {
    function test_ShouldChangeNextRoundDuration() public {
        uint32 newDuration = 30 days;

        mms.changeNextRoundDuration(newDuration);

        (, uint32 duration,) = mms.getRoundInfo(currentRoundId + 1);

        assertEq(duration, newDuration);
    }

    function test_ShouldEmitEvent() public {
        uint32 newDuration = 30 days;

        vm.expectEmit(true, true, true, true);
        emit IMMS.RoundDurationChanged(currentRoundId + 1, newDuration);
        mms.changeNextRoundDuration(newDuration);
    }

    function test_ShouldRevertIfNotAdmin() public {
        vm.prank(user);
        vm.expectRevert(Base.Unauthorized.selector);
        mms.changeNextRoundDuration(30 days);
    }
}
