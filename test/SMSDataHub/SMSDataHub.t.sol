// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.20;

import "./_SMSDataHub.Setup.t.sol";

contract SMSDataHubTest is SMSDataHubSetup {
    /* ======== upgradeToAndCall ======== */

    function test_upgradeToAndCall_ShouldUpgradeImplementation() public {
        address implementationBefore = address(
            uint160(uint256(vm.load(address(smsDataHub), ERC1967Utils.IMPLEMENTATION_SLOT)))
        );

        address newSMSDataHub = address(new SMSDataHub());
        smsDataHub.upgradeToAndCall(newSMSDataHub, "");

        address implementationAfter = address(
            uint160(uint256(vm.load(address(smsDataHub), ERC1967Utils.IMPLEMENTATION_SLOT)))
        );

        assertNotEq(implementationAfter, implementationBefore);
        assertEq(implementationAfter, newSMSDataHub);
    }

    function test_upgradeToAndCall_RevertIfNotAdmin() public {
        address implementation = address(new SMSDataHub());
        vm.expectRevert(abi.encodeWithSelector(Base.Unauthorized.selector));
        vm.prank(user);
        smsDataHub.upgradeToAndCall(implementation, "");
    }

    /* ======== getSMS ======== */

    function test_getSMS_ShouldReturnSMS() public view {
        assertEq(smsDataHub.getSMS(), address(sms));
    }

    /* ======== getMMS ======== */

    function test_getMMS_ShouldReturnMMS() public view {
        assertEq(smsDataHub.getMMS(), address(mms));
    }

    /* ======== initialize ======== */

    function test_initialize_RevertIfAlreadyInitialized() public {
        vm.expectRevert(abi.encodeWithSelector(Initializable.InvalidInitialization.selector));
        smsDataHub.initialize(address(this));
    }
}
