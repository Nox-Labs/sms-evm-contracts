// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../../_MMS.Setup.t.sol";

contract RewardIntegrityHandler is Test {
    MMS internal mms;
    SMS internal sms;
    address internal minter;
    bytes internal mockData = "mockData";
    mapping(uint32 => uint256) public totalClaimedPerRound;
    address[] internal stakers;

    constructor(MMSSetup _setup) {
        mms = _setup.mms();
        sms = _setup.sms();
        minter = address(_setup);

        stakers.push(makeAddr("staker1"));
        stakers.push(makeAddr("staker2"));
        stakers.push(makeAddr("staker3"));
        stakers.push(makeAddr("staker4"));
        stakers.push(makeAddr("staker5"));
        stakers.push(makeAddr("staker6"));
        stakers.push(makeAddr("staker7"));
    }

    function bound(uint256 x, uint256 min, uint256 max)
        internal
        pure
        virtual
        override
        returns (uint256 result)
    {
        result = _bound(x, min, max);
    }

    function stake(uint96 amount) public {
        address staker = stakers[block.timestamp % stakers.length];

        amount = uint96(bound(amount, 1, 1e18));

        vm.startPrank(minter);
        sms.mint(minter, amount, mockData);
        sms.approve(address(mms), amount);
        mms.stake(staker, amount, mockData);
        vm.stopPrank();

        console.log("STAKED", amount);
    }

    function skipTime() public {
        (, uint32 duration) = mms.getRoundPeriod(0);
        vm.warp(block.timestamp + duration);
    }

    function finalizeRound(uint32 roundToFinalize) public {
        uint32 currentRoundId = mms.getCurrentRoundId();
        if (currentRoundId == 0) return;
        roundToFinalize = uint32(bound(roundToFinalize, 0, currentRoundId - 1));
        (,, bool isFinalized) = mms.getRoundInfo(roundToFinalize);
        if (isFinalized) {
            while (roundToFinalize != 0) {
                roundToFinalize--;
                (,, isFinalized) = mms.getRoundInfo(roundToFinalize);
                if (isFinalized) break;
            }
        }

        if (isFinalized) return;

        (, uint32 end) = mms.getRoundPeriod(roundToFinalize);
        if (block.timestamp < end) skipTime();

        uint256 totalRewards = mms.calculateTotalRewardsRound(roundToFinalize);
        if (totalRewards == 0) return;

        vm.startPrank(minter);
        sms.mint(minter, totalRewards, mockData);
        sms.approve(address(mms), totalRewards);
        mms.finalizeRound(roundToFinalize);
        vm.stopPrank();

        console.log("FINALIZED ROUND", roundToFinalize);
    }

    function claimRewards(uint32 roundToClaim) public {
        address staker = stakers[block.timestamp % stakers.length];
        uint32 currentRoundId = mms.getCurrentRoundId();
        if (currentRoundId == 0) return;
        roundToClaim = uint32(bound(roundToClaim, 0, currentRoundId - 1));
        (,, bool isFinalized) = mms.getRoundInfo(roundToClaim);
        if (!isFinalized) return;
        uint256 claimable = mms.calculateClaimableRewards(roundToClaim, staker);
        if (claimable == 0) return;

        vm.startPrank(minter);
        sms.mint(address(mms), claimable, mockData);
        mms.claimRewards(roundToClaim, staker, staker, claimable, mockData);

        totalClaimedPerRound[roundToClaim] += claimable;

        console.log("CLAIMED REWARDS", roundToClaim, staker, claimable);
    }

    function getStakers() public view returns (address[] memory) {
        return stakers;
    }
}
