// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_SMS.Setup.t.sol";

contract BlacklistableTest is SMSSetup {
    function test_isBlacklisted_ShouldReturnFalseIfNotBlacklisted() public view {
        assertEq(sms.isBlacklisted(address(this)), false);
    }

    function test_blacklist_ShouldBlacklistAddress() public {
        sms.blacklist(address(this));
        assertEq(sms.isBlacklisted(address(this)), true);
    }

    function test_unBlacklist_ShouldUnblacklistAddress() public {
        sms.blacklist(address(this));
        sms.unBlacklist(address(this));
        assertEq(sms.isBlacklisted(address(this)), false);
    }

    function test_blacklist_RevertIfAddressIsZero() public {
        vm.expectRevert(Base.ZeroAddress.selector);
        sms.blacklist(address(0));
    }
}
