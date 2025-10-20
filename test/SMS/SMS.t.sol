// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_SMS.Setup.t.sol";

contract SMSTest is SMSSetup {
    /* ======== permit ======== */

    function test_ShouldTransferSMSWithPermit() public {
        (address owner, uint256 ownerPrivateKey) = makeAddrAndKey("owner");
        address spender = makeAddr("spender");
        address to = makeAddr("to");
        uint256 deadline = block.timestamp + 1 days;

        sms.mint(owner, MINT_AMOUNT, mockData);

        bytes32 structHash = keccak256(
            abi.encode(PERMIT_TYPEHASH, owner, spender, MINT_AMOUNT, sms.nonces(owner), deadline)
        );

        bytes32 hash = keccak256(abi.encodePacked(hex"1901", sms.DOMAIN_SEPARATOR(), structHash));

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, hash);

        uint256 balanceBefore = sms.balanceOf(owner);

        vm.prank(spender);
        sms.permit(owner, spender, MINT_AMOUNT, deadline, v, r, s);
        vm.prank(spender);
        sms.transferFrom(owner, to, MINT_AMOUNT);

        uint256 balanceAfter = sms.balanceOf(owner);

        assertEq(balanceAfter, balanceBefore - MINT_AMOUNT);
    }

    function test_RevertIfLowPaused() public {
        smsDataHub.setPauseLevel(PauseLevel.Low);
        vm.expectRevert(Base.Paused.selector);
        vm.prank(user);
        sms.permit(address(0), address(0), 0, 0, 0, 0, 0);
    }

    /* ======== transfer ======== */

    function test_transfer_RevertIfFromIsBlacklisted() public {
        sms.blacklist(address(this));
        vm.expectRevert(
            abi.encodeWithSelector(Blacklistable.BlacklistedAccount.selector, address(this))
        );
        sms.transfer(user, 100);
    }

    function testFuzz_transfer_ShouldTransferIfFromIsNotBlacklisted(address to, uint256 amount)
        public
    {
        vm.assume(to != address(this) && to != address(0));

        amount = bound(amount, 1, sms.balanceOf(address(this)));

        sms.transfer(to, amount);
        assertEq(sms.balanceOf(to), amount);
    }

    /* ======== upgradeToAndCall ======== */

    function test_upgradeToAndCall_ShouldUpgradeImplementation() public {
        address implementationBefore =
            address(uint160(uint256(vm.load(address(sms), ERC1967Utils.IMPLEMENTATION_SLOT))));

        address newSMS = address(new SMS());
        sms.upgradeToAndCall(newSMS, "");

        address implementationAfter =
            address(uint160(uint256(vm.load(address(sms), ERC1967Utils.IMPLEMENTATION_SLOT))));

        assertNotEq(implementationAfter, implementationBefore);
        assertEq(implementationAfter, newSMS);
    }

    function test_upgradeToAndCall_RevertIfNotAdmin() public {
        address implementation = address(new SMS());
        vm.expectRevert(abi.encodeWithSelector(Base.Unauthorized.selector));
        vm.prank(user);
        sms.upgradeToAndCall(implementation, "");
    }

    /* ======== initialize ======== */

    function test_initialize_RevertIfAlreadyInitialized() public {
        vm.expectRevert(abi.encodeWithSelector(Initializable.InvalidInitialization.selector));
        sms.initialize(smsDataHub);
    }

    /* ======== decimals ======== */

    function test_decimals_ShouldReturnDecimals() public view {
        assertEq(sms.decimals(), 6);
    }
}
