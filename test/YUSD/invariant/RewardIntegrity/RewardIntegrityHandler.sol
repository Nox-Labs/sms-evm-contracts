// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../../_YUSD.Setup.t.sol";

contract RewardIntegrityHandler is Test {
    YUSD internal yusd;
    RUSD internal rusd;
    address internal minter;
    bytes internal mockData = "mockData";
    mapping(uint32 => uint256) public totalClaimedPerRound;
    address[] internal stakers;

    constructor(YUSDSetup _setup) {
        yusd = _setup.yusd();
        rusd = _setup.rusd();
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
        rusd.mint(minter, amount, mockData);
        rusd.approve(address(yusd), amount);
        yusd.stake(staker, amount, mockData);
        vm.stopPrank();

        console.log("STAKED", amount);
    }

    function skipTime() public {
        (, uint32 duration) = yusd.getRoundPeriod(0);
        vm.warp(block.timestamp + duration);
    }

    function finalizeRound(uint32 roundToFinalize) public {
        uint32 currentRoundId = yusd.getCurrentRoundId();
        if (currentRoundId == 0) return;
        roundToFinalize = uint32(bound(roundToFinalize, 0, currentRoundId - 1));
        (,, bool isFinalized) = yusd.getRoundInfo(roundToFinalize);
        if (isFinalized) {
            while (roundToFinalize != 0) {
                roundToFinalize--;
                (,, isFinalized) = yusd.getRoundInfo(roundToFinalize);
                if (isFinalized) break;
            }
        }

        if (isFinalized) return;

        (, uint32 end) = yusd.getRoundPeriod(roundToFinalize);
        if (block.timestamp < end) skipTime();

        uint256 totalRewards = yusd.calculateTotalRewardsRound(roundToFinalize);
        if (totalRewards == 0) return;

        vm.startPrank(minter);
        rusd.mint(minter, totalRewards, mockData);
        rusd.approve(address(yusd), totalRewards);
        yusd.finalizeRound(roundToFinalize);
        vm.stopPrank();

        console.log("FINALIZED ROUND", roundToFinalize);
    }

    function claimRewards(uint32 roundToClaim) public {
        address staker = stakers[block.timestamp % stakers.length];
        uint32 currentRoundId = yusd.getCurrentRoundId();
        if (currentRoundId == 0) return;
        roundToClaim = uint32(bound(roundToClaim, 0, currentRoundId - 1));
        uint256 claimable = yusd.calculateClaimableRewards(roundToClaim, staker);
        if (claimable == 0) return;

        vm.startPrank(minter);
        rusd.mint(address(yusd), claimable, mockData);
        yusd.claimRewards(roundToClaim, staker, staker, claimable);

        totalClaimedPerRound[roundToClaim] += claimable;

        console.log("CLAIMED REWARDS", roundToClaim, staker, claimable);
    }

    function getStakers() public view returns (address[] memory) {
        return stakers;
    }
}
