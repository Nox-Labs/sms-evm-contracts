// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./_MMS.Setup.t.sol";

contract ClaimRewards is MMSSetup {
    function _afterSetUp() internal override {
        sms.mint(address(mms), MINT_AMOUNT * 100, mockData);

        mms.stake(address(this), MINT_AMOUNT, mockData);
        (, uint32 end) = mms.getRoundPeriod(currentRoundId);
        vm.warp(end);
        _finalizeCurrentRound();
    }

    function test_ShouldClaimAllRewardsForRound() public {
        uint256 targetRewards = _multiplyAmountByBp(MINT_AMOUNT);

        uint256 balanceBefore = sms.balanceOf(address(this));
        uint256 rewards = mms.claimRewards(currentRoundId, address(this), address(this), mockData);
        uint256 balanceAfter = sms.balanceOf(address(this));

        assertApproxEqAbs(rewards, targetRewards, dust);
        assertEq(balanceAfter, balanceBefore + rewards);
    }

    function testFuzz_ShouldClaimRewardsForRoundWhenAmountSpecified(uint256 amount) public {
        amount = bound(amount, 1, mms.calculateClaimableRewards(currentRoundId, address(this)));

        uint256 balanceBefore = sms.balanceOf(address(this));
        mms.claimRewards(currentRoundId, address(this), address(this), amount, mockData);
        uint256 balanceAfter = sms.balanceOf(address(this));

        assertEq(balanceAfter, balanceBefore + amount);
    }

    function test_RevertIfClaimingMoreThanAvailableRewards() public {
        uint256 targetRewards = _multiplyAmountByBp(MINT_AMOUNT);

        vm.expectRevert(
            abi.encodeWithSelector(
                IMMS.InsufficientRewards.selector,
                targetRewards + 1,
                mms.calculateClaimableRewards(currentRoundId, address(this))
            )
        );
        mms.claimRewards(currentRoundId, address(this), address(this), targetRewards + 1, mockData);
    }

    function test_RevertIfZeroAmount() public {
        vm.expectRevert(abi.encodeWithSelector(Base.ZeroAmount.selector));
        mms.claimRewards(currentRoundId, address(this), address(this), 0, mockData);
    }

    function test_RevertIfHighPaused() public {
        smsDataHub.setPauseLevel(PauseLevel.High);
        vm.expectRevert(Base.Paused.selector);
        mms.claimRewards(currentRoundId, address(this), address(this), mockData);
    }

    function test_RevertIfHighPausedWhenAmountSpecified() public {
        smsDataHub.setPauseLevel(PauseLevel.High);
        vm.expectRevert(Base.Paused.selector);
        mms.claimRewards(currentRoundId, address(this), address(this), 1, mockData);
    }

    function test_RevertIfNotMinter() public {
        vm.expectRevert(Base.Unauthorized.selector);
        vm.prank(user);
        mms.claimRewards(currentRoundId, address(this), address(this), mockData);
    }

    function test_RevertIfNotMinterWhenAmountSpecified() public {
        vm.expectRevert(Base.Unauthorized.selector);
        vm.prank(user);
        mms.claimRewards(currentRoundId, address(this), address(this), 1, mockData);
    }

    function test_ShouldEmitEvent() public {
        uint256 rewards = mms.calculateClaimableRewards(currentRoundId, address(this));

        vm.expectEmit(true, true, true, true);
        emit IMMS.RewardsClaimed(currentRoundId, address(this), address(this), rewards, mockData);
        mms.claimRewards(currentRoundId, address(this), address(this), mockData);
    }

    function test_ShouldEmitEventWhenAmountSpecified() public {
        vm.expectEmit(true, true, true, true);
        emit IMMS.RewardsClaimed(currentRoundId, address(this), address(this), 1, mockData);
        mms.claimRewards(currentRoundId, address(this), address(this), 1, mockData);
    }

    function test_ShouldUpdateRoundTimestampAfterFirstRoundA() public test_roundTimestampModifier {
        mms.claimRewards(currentRoundId, address(this), address(this), mockData);
    }

    function test_ShouldUpdateRoundTimestampAfterFirstRoundB() public test_roundTimestampModifier {
        mms.claimRewards(currentRoundId, address(this), address(this), 1, mockData);
    }
}
