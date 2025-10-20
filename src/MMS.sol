// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {IMMS} from "./interface/IMMS.sol";
import {ISMS} from "./interface/ISMS.sol";
import {ISMSDataHub, PauseLevel} from "./interface/ISMSDataHub.sol";

import {TWAB} from "./extensions/TWAB.sol";
import {SMSDataHubKeeper} from "./extensions/SMSDataHubKeeper.sol";

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

/**
 * @title MMS
 * @notice Has 6 decimals.
 * @notice This is yield-bearing stablecoin pegged to SMS 1:1.
 * Yielding is done by converting SMS to MMS and claiming rewards in SMS.
 * Each round has a different reward rate and duration specified by admin,
 * if admin didn't specify this data then the next round starts with previous conditions.
 * @notice During the rounds, staker's balance is tracked by TWAB
 * and rewards are calculated based on the average balance of the staker in the round.
 * After the round is finalized, the SMS rewards are transferred to the MMS contract from the admin.
 * Stakers can't claim rewards until the round is finalized.
 * @notice All actions are allowed only for minter except for admin functionalities.
 */
contract MMS is IMMS, TWAB, SMSDataHubKeeper, UUPSUpgradeable {
    using SafeERC20 for ISMS;

    /**
     * @notice The information of the round.
     * @param bp is the basis points of the reward rate.
     * @param duration is the duration of the round.
     * @param isBpSet is a flag to check if the bp is changed by admin.
     * @param isDurationSet is a flag to check if the duration is changed by admin.
     * @param isFinalized is a flag to check if the round is finalized.
     * @param claimedRewards is the rewards that have been claimed by the user.
     */
    struct RoundInfo {
        uint32 bp;
        uint32 duration;
        bool isBpSet;
        bool isDurationSet;
        bool isFinalized;
        mapping(address user => uint256 claimedRewards) claimedRewards;
    }

    /**
     * @notice The maximum number of rounds to .
     */
    uint8 public constant MAX_ROUND_REWIND = 5;

    /**
     * @notice The precision of the basis points.
     * @notice 1% = 100bp.
     * @notice BP stands for Basis Points.
     */
    uint16 public constant BP_PRECISION = 1e4;

    /**
     * @notice The precision of the internal math.
     */
    uint128 constant INTERNAL_MATH_PRECISION = 1e30;

    /**
     * @notice The timestamps of the rounds.
     * @dev The length of the array - 2 is the number of rounds.
     * @dev The first element is the start timestamp of the first round.
     * @dev The second element is the end timestamp of the first round and the start timestamp of the second round.
     * @dev [startTimestampOfRound0, startTimestampOfRound1, startTimestampOfRound2, ...]
     */
    uint32[] public roundTimestamps;

    /**
     * @notice The information of the rounds.
     * @notice roundInfo is the information of the round.
     */
    mapping(uint32 roundId => RoundInfo roundInfo) private _roundInfo;

    /**
     * @notice Initializes the MMS contract.
     * @param _smsDataHub The address of the SMSDataHub contract.
     * @param _periodLength The length of the period. (How often the TWAB is updated?)
     * @param _firstRoundStartTimestamp The start timestamp of the first round. (When the first round starts?)
     * @param _roundBp The basis points of the reward rate of the first round. (How much rewards are given per round in bp?)
     * @param _roundDuration The duration of the first round. (How long the first round lasts?)
     */
    function initialize(
        ISMSDataHub _smsDataHub,
        uint32 _periodLength,
        uint32 _firstRoundStartTimestamp,
        uint32 _roundBp,
        uint32 _roundDuration
    )
        external
        initializer
        noZeroAmount(_roundBp)
        noZeroAmount(_roundDuration)
        noZeroAmount(_periodLength)
        noZeroAmount(_firstRoundStartTimestamp)
    {
        if (_roundBp > BP_PRECISION) revert InvalidBp();

        __TWAB_init(_periodLength, _firstRoundStartTimestamp);
        __SMSDataHubKeeper_init(_smsDataHub);

        roundTimestamps.push(_firstRoundStartTimestamp);
        roundTimestamps.push(_firstRoundStartTimestamp + _roundDuration);

        RoundInfo storage round = _roundInfo[0];
        round.bp = _roundBp;
        round.duration = _roundDuration;
    }

    /* ======== METADATA ======== */

    function name() public pure returns (string memory) {
        return "MMS";
    }

    function symbol() public pure returns (string memory) {
        return "MMS";
    }

    function decimals() public pure returns (uint8) {
        return 6;
    }

    /* ======== MUTATIVE ======== */

    /**
     * @notice Stake SMS to MMS.
     * @param user The address of the user.
     * @param amount The amount of SMS to stake.
     * @param data The data to stake.
     * @notice Emits Stake event.
     */
    function stake(address user, uint96 amount, bytes calldata data)
        external
        updateRoundTimestamps
        onlyMinter
        noPauseLevel(PauseLevel.Medium)
        noZeroAmount(amount)
        noZeroAddress(user)
        noEmptyBytes(data)
    {
        _getSMS().safeTransferFrom(msg.sender, address(this), amount);
        _mint(user, amount);
        emit Stake(user, amount, data);
    }

    /**
     * @notice Redeem MMS to SMS.
     * @param user The address of the user.
     * @param amount The amount of MMS to redeem.
     * @param data The data to redeem.
     * @notice Emits Redeem event.
     */
    function redeem(address user, uint96 amount, bytes calldata data)
        external
        updateRoundTimestamps
        onlyMinter
        noPauseLevel(PauseLevel.Medium)
        noZeroAmount(amount)
        noZeroAddress(user)
        noEmptyBytes(data)
    {
        _burn(user, amount);
        _getSMS().safeTransfer(msg.sender, amount);

        emit Redeem(user, amount, data);
    }

    /**
     * @notice Claim rewards from the round.
     * @param roundId The id of the round.
     * @param user The address of the user.
     * @param to The address to transfer the rewards to.
     * @param amount The amount of rewards to claim.
     * @notice Emits RewardsClaimed event.
     */
    function claimRewards(
        uint32 roundId,
        address user,
        address to,
        uint256 amount,
        bytes calldata data
    ) external updateRoundTimestamps onlyMinter noZeroAmount(amount) {
        uint256 claimableRewards = calculateClaimableRewards(roundId, user);
        if (amount > claimableRewards) revert InsufficientRewards(amount, claimableRewards);

        _claimRewards(roundId, user, amount, to);

        emit RewardsClaimed(roundId, user, to, amount, data);
    }

    /**
     * @notice Claim rewards from the round.
     * @param roundId The id of the round.
     * @param user The address of the user.
     * @param to The address to transfer the rewards to.
     * @notice Emits RewardsClaimed event.
     */
    function claimRewards(uint32 roundId, address user, address to, bytes calldata data)
        external
        updateRoundTimestamps
        onlyMinter
        returns (uint256 smsAmount)
    {
        smsAmount = calculateClaimableRewards(roundId, user);
        _claimRewards(roundId, user, smsAmount, to);

        emit RewardsClaimed(roundId, user, to, smsAmount, data);
    }

    /**
     * @notice Compound rewards from the round.
     * @param roundId The id of the round.
     * @param user The address of the user.
     * @notice This function is used to claim rewards and stake them back.
     * @notice Emits RewardsCompounded event.
     */
    function compoundRewards(uint32 roundId, address user, bytes calldata data)
        external
        updateRoundTimestamps
        onlyMinter
    {
        uint256 claimableRewards = calculateClaimableRewards(roundId, user);
        _claimRewards(roundId, user, claimableRewards, address(this));
        _mint(user, uint96(claimableRewards));

        emit RewardsCompounded(roundId, user, claimableRewards, data);
    }

    /* ======== VIEW ======== */

    /**
     * @notice Get the current round id.
     * @return The current round id.
     * @notice The current round id is the length of the roundTimestamps array minus 2.
     * @notice The first round is the round with id 0.
     * @notice In initialize function first two elements of roundTimestamps array are set.
     */
    function getCurrentRoundId() public view returns (uint32) {
        return uint32(roundTimestamps.length - 2);
    }

    /**
     * @notice Get the period of the round.
     * @param roundId The id of the round.
     * @return start The start timestamp of the round.
     * @return end The end timestamp of the round.
     */
    function getRoundPeriod(uint32 roundId) public view returns (uint32 start, uint32 end) {
        if (roundId > getCurrentRoundId()) revert RoundIdUnavailable();

        start = roundTimestamps[roundId];
        end = roundTimestamps[roundId + 1];
    }

    /**
     * @notice Calculate the claimable rewards for the user in the round.
     * @param roundId The id of the round.
     * @param user The address of the user.
     * @return The claimable rewards for the user in the round.
     * @notice The claimable rewards is the rewards that have been calculated for the user in the round
     * minus the rewards that have been claimed by the user.
     */
    function calculateClaimableRewards(uint32 roundId, address user)
        public
        view
        returns (uint256)
    {
        return calculateRewardsRound(roundId, user) - _roundInfo[roundId].claimedRewards[user];
    }

    /**
     * @notice Calculate the rewards for the user in the round.
     * @param roundId The id of the round.
     * @param user The address of the user.
     * @return The rewards for the user in the round.
     * @notice The rewards are calculated based on the average balance of the user in the round.
     */
    function calculateRewardsRound(uint32 roundId, address user) public view returns (uint256) {
        (uint32 start, uint32 end) = getRoundPeriod(roundId);
        uint32 boundedEnd = _getBoundedEnd(end);
        uint256 twabInRound = getTwabBetween(user, start, boundedEnd);
        return _calculateRewardsForTwab(roundId, start, end, boundedEnd, twabInRound);
    }

    /**
     * @notice Calculate the total rewards for the round.
     * @param roundId The id of the round.
     * @return The total rewards for the round.
     * @notice The total rewards are calculated based on the average balance of the total supply in the round.
     */
    function calculateTotalRewardsRound(uint32 roundId) public view returns (uint256) {
        (uint32 start, uint32 end) = getRoundPeriod(roundId);
        uint32 boundedEnd = _getBoundedEnd(end);
        uint256 totalTwabInRound = getTotalSupplyTwabBetween(start, boundedEnd);
        return _calculateRewardsForTwab(roundId, start, end, boundedEnd, totalTwabInRound);
    }

    /**
     * @notice Get the information of the round.
     * @param roundId The id of the round.
     * @return bp The basis points of the reward rate of the round.
     * @return duration The duration of the round.
     * @return isFinalized The flag to check if the round is finalized.
     */
    function getRoundInfo(uint32 roundId)
        public
        view
        returns (uint32 bp, uint32 duration, bool isFinalized)
    {
        RoundInfo storage round = _roundInfo[roundId];
        return (round.bp, round.duration, round.isFinalized);
    }

    /* ======== PRIVATE ======== */

    /**
     * @notice Claim rewards from the round.
     * @param roundId The id of the round.
     * @param user The address of the user.
     * @param amount The amount of rewards to claim.
     * @param to The address to transfer the rewards to.
     * @notice Decreases the total debt of the MMS contract.
     */
    function _claimRewards(uint32 roundId, address user, uint256 amount, address to)
        private
        noPauseLevel(PauseLevel.Medium)
        noZeroAddress(to)
        noZeroAmount(amount)
    {
        if (!_roundInfo[roundId].isFinalized) revert RoundNotFinalized();
        _roundInfo[roundId].claimedRewards[user] += amount;
        _getSMS().safeTransfer(to, amount);
    }

    /**
     * @notice Get the bounded end timestamp of the round.
     * @param end The end timestamp of the round.
     * @return The bounded end timestamp of the round.
     * @notice The bounded end timestamp is the end timestamp of the round or the current timestamp, whichever is smaller.
     */
    function _getBoundedEnd(uint32 end) private view returns (uint32) {
        uint32 lastSafeTimestamp = uint32(currentOverwritePeriodStartedAt());
        uint32 boundedEnd = uint32(block.timestamp > end ? end : block.timestamp);
        return boundedEnd > lastSafeTimestamp ? lastSafeTimestamp : boundedEnd;
    }

    /**
     * @notice Calculate the rewards for the TWAB.
     * @param roundId The id of the round.
     * @param start The start timestamp of the round.
     * @param end The end timestamp of the round.
     * @param boundedEnd The bounded end timestamp of the round.
     * @param twabBalance The balance of the TWAB.
     * @return The rewards for the TWAB.
     */
    function _calculateRewardsForTwab(
        uint32 roundId,
        uint32 start,
        uint32 end,
        uint256 boundedEnd,
        uint256 twabBalance
    ) private view returns (uint256) {
        uint256 rewardPerSecond =
            Math.mulDiv(twabBalance * INTERNAL_MATH_PRECISION, _roundInfo[roundId].bp, end - start);

        return
            Math.mulDiv(rewardPerSecond, boundedEnd - start, BP_PRECISION * INTERNAL_MATH_PRECISION);
    }

    /**
     * @notice Start the next round.
     * @dev This function is called when the current round is ended and the transaction triggered with `updateRoundTimestamps` modifier.
     * @dev This function will create next round info base on previous round if admin didn't override it.
     * @dev This function will update the roundTimestamps array.
     * @notice Emits NewRound event.
     */
    function _startNextRound() private {
        uint32 currentRoundId = getCurrentRoundId();
        uint32 nextRoundId = currentRoundId + 1;

        (, uint32 end) = getRoundPeriod(currentRoundId);

        RoundInfo storage nextRound = _roundInfo[nextRoundId];
        RoundInfo storage currentRound = _roundInfo[currentRoundId];

        uint32 nextRoundDuration = nextRound.duration;
        uint32 nextRoundBp = nextRound.bp;

        if (!nextRound.isDurationSet) nextRoundDuration = currentRound.duration;
        if (!nextRound.isBpSet) nextRoundBp = currentRound.bp;

        roundTimestamps.push(end + nextRoundDuration);
        nextRound.bp = nextRoundBp;
        nextRound.duration = nextRoundDuration;

        emit NewRound(nextRoundId, end, end + nextRoundDuration);
    }

    /* ======== ADMIN ======== */

    /**
     * @notice Change the duration of the next round.
     * @param duration The duration of the next round.
     * @notice Emits RoundDurationChanged event.
     */
    function changeNextRoundDuration(uint32 duration) external noZeroAmount(duration) onlyAdmin {
        uint32 nextRoundId = getCurrentRoundId() + 1;
        _roundInfo[nextRoundId].duration = duration;
        _roundInfo[nextRoundId].isDurationSet = true;

        emit RoundDurationChanged(nextRoundId, duration);
    }

    /**
     * @notice Change the basis points of the next round.
     * @param bp The basis points of the next round.
     * @notice Emits RoundBpChanged event.
     */
    function changeNextRoundBp(uint32 bp) external onlyAdmin {
        _updateBpForRound(getCurrentRoundId() + 1, bp);
    }

    /**
     * @notice Finalize the round.
     * @dev This function is called by admin to finalize the round.
     * @dev This function will transfer the rewards to the MMS contract from caller.
     * @dev This function will increase the total debt of the MMS contract.
     * @notice Emits RoundFinalized event.
     */
    function finalizeRound(uint32 roundId) public onlyAdmin {
        RoundInfo storage round = _roundInfo[roundId];

        (, uint32 end) = getRoundPeriod(roundId);

        if (block.timestamp < end) revert RoundNotEnded();

        if (!hasFinalized(end)) revert TwabNotFinalized();

        if (round.isFinalized) revert RoundAlreadyFinalized();
        round.isFinalized = true;

        uint256 totalRewards = calculateTotalRewardsRound(roundId);
        _getSMS().safeTransferFrom(msg.sender, address(this), totalRewards);

        emit RoundFinalized(roundId, totalRewards);
    }

    /**
     * @notice Finalize the round and change the basis points of the round.
     * @notice Emits RoundBpChanged event.
     */
    function finalizeRound(uint32 roundId, uint32 bpForRound) public onlyAdmin {
        _updateBpForRound(roundId, bpForRound);
        finalizeRound(roundId);
    }

    function _updateBpForRound(uint32 roundId, uint32 bp) private {
        if (bp > BP_PRECISION) revert InvalidBp();
        _roundInfo[roundId].bp = bp;
        _roundInfo[roundId].isBpSet = true;
        emit RoundBpChanged(roundId, bp);
    }

    /**
     * @notice Authorize the upgrade of the contract.
     * @param newImplementation The address of the new implementation.
     * @notice Emits Upgrade event.
     * @dev This function is empty because we need only admin to authorize the upgrade.
     */
    function _authorizeUpgrade(address newImplementation) internal override onlyAdmin {}

    /* ======== MODIFIER ======== */

    /**
     * @notice Update the round timestamps.
     * @notice This modifier is used to check if the current round is ended and start the next round.
     * @notice If the timestamps run so far ahead that the current round after MAX_ROUND_REWIND doesn't reach the actual current round,
     * the function will emit MaxRoundRewindReached event and stop the function immediately (doesn't reach the _;).
     * This allow to call any functions that has this modifier several times to reach the actual current round,
     * and only after that function will reach the _; and continue the execution.
     */
    modifier updateRoundTimestamps() {
        (, uint32 end) = getRoundPeriod(getCurrentRoundId());

        uint8 rewindCount = 0;

        while (block.timestamp >= end) {
            _startNextRound();

            (, end) = getRoundPeriod(getCurrentRoundId());

            if (++rewindCount == MAX_ROUND_REWIND) {
                emit MaxRoundRewindReached();
                return;
            }
        }

        _;
    }
}
