// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_MMS.Setup.t.sol";

contract MMSTest is MMSSetup {
    /* ======== upgradeToAndCall ======== */

    function test_upgradeToAndCall_ShouldUpgradeImplementation() public {
        address implementationBefore =
            address(uint160(uint256(vm.load(address(mms), ERC1967Utils.IMPLEMENTATION_SLOT))));

        address newMMS = address(new MMS());
        mms.upgradeToAndCall(newMMS, "");

        address implementationAfter =
            address(uint160(uint256(vm.load(address(mms), ERC1967Utils.IMPLEMENTATION_SLOT))));

        assertNotEq(implementationAfter, implementationBefore);
        assertEq(implementationAfter, newMMS);
    }

    function test_upgradeToAndCall_RevertIfNotAdmin() public {
        address implementation = address(new MMS());
        vm.expectRevert(abi.encodeWithSelector(Base.Unauthorized.selector));
        vm.prank(user);
        mms.upgradeToAndCall(implementation, "");
    }

    /* ======== initialize ======== */

    function test_initialize_RevertIfAlreadyInitialized() public {
        vm.expectRevert(abi.encodeWithSelector(Initializable.InvalidInitialization.selector));
        mms.initialize(smsDataHub, 1, 1, 1, 1);
    }

    /* ======== getCurrentRoundId ======== */

    function test_getCurrentRoundId_ShouldReturnCurrentRoundId() public {
        assertEq(mms.getCurrentRoundId(), 0);
        skip(roundDuration + 1);
        mms.stake(address(this), 1, mockData);
        assertEq(mms.getCurrentRoundId(), 1);
    }

    /* ======== getRoundPeriod ======== */

    function test_getRoundPeriod_ShouldReturnRoundPeriod() public {
        (uint32 start0, uint32 end0) = mms.getRoundPeriod(0);
        assertEq(start0, block.timestamp);
        assertEq(end0, block.timestamp + roundDuration);

        skip(roundDuration + 1);
        mms.stake(address(this), 1, mockData);

        (uint32 start1, uint32 end1) = mms.getRoundPeriod(1);

        assertEq(start1, end0);
        assertEq(end1 + 1, block.timestamp + roundDuration);
    }

    /* ======== updateRoundTimestamps ======== */

    function test_updateRoundTimestamps_ShouldUpdateRoundTimestamps() public {
        uint32 roundId0 = currentRoundId;
        uint32 roundId1 = currentRoundId + 1;

        (uint32 bp0, uint32 duration0,) = mms.getRoundInfo(roundId0);
        (uint32 bp1, uint32 duration1,) = mms.getRoundInfo(roundId1);

        uint32 roundId1NewDuration = duration0 - 1 days;
        uint32 roundId1NewBp = bp0 - 100;

        assertNotEq(bp0, 0);
        assertNotEq(duration0, 0);
        assertEq(bp1, 0);
        assertEq(duration1, 0);

        mms.changeNextRoundDuration(roundId1NewDuration);
        mms.changeNextRoundBp(roundId1NewBp);

        skip(roundDuration);
        mms.stake(address(this), MINT_AMOUNT, mockData);

        assertEq(mms.getCurrentRoundId(), roundId1);

        (, uint32 end0) = mms.getRoundPeriod(roundId0);
        (uint32 start1, uint32 end1) = mms.getRoundPeriod(roundId1);

        assertEq(start1, end0);
        assertEq(end1, end0 + roundId1NewDuration);

        (bp1, duration1,) = mms.getRoundInfo(roundId1);

        assertEq(bp1, roundId1NewBp);
        assertEq(duration1, roundId1NewDuration);
    }

    /* ======== decimals ======== */

    function test_decimals_ShouldReturnDecimals() public view {
        assertEq(mms.decimals(), 6);
    }
}
