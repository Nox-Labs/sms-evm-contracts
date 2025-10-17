// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_SMSDataHub.Setup.t.sol";

contract SetMinter is SMSDataHubSetup {
    function test_ShouldSetMinter() public {
        newSMSDataHub.setMinter(mockAddress);
        assertEq(newSMSDataHub.getMinter(), mockAddress);
    }

    function test_ShouldRevertIfNotAdmin() public {
        vm.prank(user);
        vm.expectRevert(Base.Unauthorized.selector);
        newSMSDataHub.setMinter(mockAddress);
    }

    function test_ShouldEmitEvent() public {
        vm.expectEmit(true, true, true, true);
        emit ISMSDataHub.MinterChanged(mockAddress);
        newSMSDataHub.setMinter(mockAddress);
    }
}
