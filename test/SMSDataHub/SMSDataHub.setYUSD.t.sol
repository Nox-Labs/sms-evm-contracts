// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_SMSDataHub.Setup.t.sol";

contract SetMMS is SMSDataHubSetup {
    function test_ShouldSetMMS() public {
        newSMSDataHub.setMMS(mockAddress);
        assertEq(newSMSDataHub.getMMS(), mockAddress);
    }

    function test_ShouldRevertIfAlreadySet() public {
        newSMSDataHub.setMMS(mockAddress);
        vm.expectRevert(ISMSDataHub.AlreadySet.selector);
        newSMSDataHub.setMMS(mockAddress);
    }

    function test_ShouldRevertIfNotAdmin() public {
        vm.prank(user);
        vm.expectRevert(Base.Unauthorized.selector);
        newSMSDataHub.setMMS(mockAddress);
    }

    function test_ShouldRevertIfZeroAddress() public {
        vm.expectRevert(Base.ZeroAddress.selector);
        newSMSDataHub.setMMS(address(0));
    }
}
