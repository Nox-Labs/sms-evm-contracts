// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_MMS.Setup.t.sol";

contract ChangeNextRoundBp is MMSSetup {
    function test_ShouldChangeNextRoundBp() public {
        uint32 newBp = 1000;

        mms.changeNextRoundBp(newBp);

        (uint32 nextBp,,) = mms.getRoundInfo(currentRoundId + 1);

        assertEq(nextBp, newBp);
    }

    function test_ShouldEmitEvent() public {
        uint32 newBp = 1000;

        vm.expectEmit(true, true, true, true);
        emit IMMS.RoundBpChanged(currentRoundId + 1, newBp);
        mms.changeNextRoundBp(newBp);
    }

    function test_ShouldRevertIfNotAdmin() public {
        vm.prank(user);
        vm.expectRevert(Base.Unauthorized.selector);
        mms.changeNextRoundBp(1000);
    }
}
