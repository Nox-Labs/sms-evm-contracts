// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_SMSDataHub.Setup.t.sol";

contract SetAdmin is SMSDataHubSetup {
    function test_ShouldSetAdmin() public {
        smsDataHub.setAdmin(mockAddress);
        assertEq(smsDataHub.getAdmin(), mockAddress);
    }

    function test_ShouldRevertIfNotAdmin() public {
        vm.prank(user);
        vm.expectRevert(Base.Unauthorized.selector);
        smsDataHub.setAdmin(mockAddress);
    }

    function test_ShouldEmitEvent() public {
        vm.expectEmit(true, true, true, true);
        emit ISMSDataHub.AdminChanged(mockAddress);
        smsDataHub.setAdmin(mockAddress);
    }
}
