// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_SMSDataHub.Setup.t.sol";

contract SetSMS is SMSDataHubSetup {
    function test_ShouldSetSMS() public {
        newSMSDataHub.setSMS(mockAddress);
        assertEq(newSMSDataHub.getSMS(), mockAddress);
    }

    function test_ShouldRevertIfAlreadySet() public {
        newSMSDataHub.setSMS(mockAddress);
        vm.expectRevert(ISMSDataHub.AlreadySet.selector);
        newSMSDataHub.setSMS(mockAddress);
    }

    function test_ShouldRevertIfNotAdmin() public {
        vm.prank(user);
        vm.expectRevert(Base.Unauthorized.selector);
        newSMSDataHub.setSMS(mockAddress);
    }

    function test_ShouldRevertIfZeroAddress() public {
        vm.expectRevert(Base.ZeroAddress.selector);
        newSMSDataHub.setSMS(address(0));
    }
}
