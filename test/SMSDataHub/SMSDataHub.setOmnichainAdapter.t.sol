// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_SMSDataHub.Setup.t.sol";

contract SetOmnichainAdapter is SMSDataHubSetup {
    function test_ShouldSetOmnichainAdapter() public {
        newSMSDataHub.setOmnichainAdapter(mockAddress);
        assertEq(newSMSDataHub.getOmnichainAdapter(), mockAddress);
    }

    function test_ShouldRevertIfAlreadySet() public {
        newSMSDataHub.setOmnichainAdapter(mockAddress);
        vm.expectRevert(ISMSDataHub.AlreadySet.selector);
        newSMSDataHub.setOmnichainAdapter(mockAddress);
    }

    function test_ShouldRevertIfNotAdmin() public {
        vm.prank(user);
        vm.expectRevert(Base.Unauthorized.selector);
        newSMSDataHub.setOmnichainAdapter(mockAddress);
    }

    function test_ShouldRevertIfZeroAddress() public {
        vm.expectRevert(Base.ZeroAddress.selector);
        newSMSDataHub.setOmnichainAdapter(address(0));
    }
}
