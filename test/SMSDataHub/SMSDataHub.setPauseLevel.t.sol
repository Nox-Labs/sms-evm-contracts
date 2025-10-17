// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_SMSDataHub.Setup.t.sol";
import {PauseLevel} from "src/interface/ISMSDataHub.sol";

contract SetPauseLevel is SMSDataHubSetup {
    function testFuzz_ShouldSetPauseLevel(uint256 _pauseLevel) public {
        _pauseLevel = bound(_pauseLevel, 0, uint8(PauseLevel.Critical));
        newSMSDataHub.setPauseLevel(PauseLevel(_pauseLevel));
        assertEq(uint256(newSMSDataHub.getPauseLevel()), uint256(_pauseLevel));
    }

    function test_ShouldRevertIfNotAdmin() public {
        vm.prank(user);
        vm.expectRevert(Base.Unauthorized.selector);
        newSMSDataHub.setPauseLevel(PauseLevel.High);
    }

    function test_ShouldEmitEvent() public {
        vm.expectEmit(true, true, true, true);
        emit ISMSDataHub.PauseLevelChanged(PauseLevel.High);
        newSMSDataHub.setPauseLevel(PauseLevel.High);
    }
}
