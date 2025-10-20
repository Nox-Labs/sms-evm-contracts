// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.20;

import "./_SMSOmnichainAdapter.Setup.t.sol";

contract SMSOmnichainAdapterTest is SMSOmnichainAdapterSetup {
    /* ======== upgradeToAndCall ======== */

    function test_upgradeToAndCall_ShouldUpgradeImplementation() public {
        address implementationBefore =
            address(uint160(uint256(vm.load(address(adapter), ERC1967Utils.IMPLEMENTATION_SLOT))));

        address newSMSOmnichainAdapter = address(new SMSOmnichainAdapter(address(1)));
        adapter.upgradeToAndCall(newSMSOmnichainAdapter, "");

        address implementationAfter =
            address(uint160(uint256(vm.load(address(adapter), ERC1967Utils.IMPLEMENTATION_SLOT))));

        assertNotEq(implementationAfter, implementationBefore);
        assertEq(implementationAfter, newSMSOmnichainAdapter);
    }

    function test_upgradeToAndCall_RevertIfNotAdmin() public {
        address implementation = address(new SMSOmnichainAdapter(address(1)));
        vm.expectRevert(abi.encodeWithSelector(Base.Unauthorized.selector));
        vm.prank(user);
        adapter.upgradeToAndCall(implementation, "");
    }

    /* ======== initialize ======== */

    function test_initialize_RevertIfAlreadyInitialized() public {
        vm.expectRevert(abi.encodeWithSelector(Initializable.InvalidInitialization.selector));
        adapter.initialize(smsDataHub);
    }

    /* ======== endpoint ======== */

    function test_endpoint_ShouldReturnEndpoint() public view {
        assertEq(address(adapter.endpoint()), address(endPointA));
    }

    /* ======== _bridgePong ======== */

    function test_ShouldEmitEvent() public {
        vm.recordLogs();
        _bridge(endPointB, adapter2, MINT_AMOUNT);

        bool isEventEmitted = false;

        Vm.Log[] memory entries = vm.getRecordedLogs();
        for (uint256 i = 0; i < entries.length; i++) {
            if (entries[i].topics[0] == ISMSOmnichainAdapter.BridgePong.selector) {
                isEventEmitted = true;
                break;
            }
        }
        assertEq(isEventEmitted, true);
    }
}
