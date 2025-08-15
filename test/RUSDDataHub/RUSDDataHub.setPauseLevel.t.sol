// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_RUSDDataHub.Setup.t.sol";
import {PauseLevel} from "src/interface/IRUSDDataHub.sol";

contract SetPauseLevel is RUSDDataHubSetup {
    function testFuzz_ShouldSetPauseLevel(uint256 _pauseLevel) public {
        _pauseLevel = bound(_pauseLevel, 0, uint8(PauseLevel.Critical));
        newRUSDDataHub.setPauseLevel(PauseLevel(_pauseLevel));
        assertEq(uint256(newRUSDDataHub.getPauseLevel()), uint256(_pauseLevel));
    }

    function test_ShouldRevertIfNotAdmin() public {
        vm.prank(user);
        vm.expectRevert(Base.Unauthorized.selector);
        newRUSDDataHub.setPauseLevel(PauseLevel.High);
    }

    function test_ShouldEmitEvent() public {
        vm.expectEmit(true, true, true, true);
        emit IRUSDDataHub.PauseLevelChanged(PauseLevel.High);
        newRUSDDataHub.setPauseLevel(PauseLevel.High);
    }
}
