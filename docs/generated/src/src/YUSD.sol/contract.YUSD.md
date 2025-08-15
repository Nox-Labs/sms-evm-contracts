# YUSD
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/YUSD.sol)

**Inherits:**
[IYUSD](/src/interface/IYUSD.sol/interface.IYUSD.md), [TWAB](/src/extensions/TWAB.sol/contract.TWAB.md), [RUSDDataHubKeeper](/src/extensions/RUSDDataHubKeeper.sol/abstract.RUSDDataHubKeeper.md), UUPSUpgradeable

Has 6 decimals.

This is yield-bearing stablecoin pegged to RUSD 1:1.
Yielding is done by converting RUSD to YUSD and claiming rewards in RUSD.
Each round has a different reward rate and duration specified by admin,
if admin didn't specify this data then the next round starts with previous conditions.

During the rounds, staker's balance is tracked by TWAB
and rewards are calculated based on the average balance of the staker in the round.
After the round is finalized, the RUSD rewards are transferred to the YUSD contract from the admin.
Also stakers can claim rewards during the round, but this creates a debt on the YUSD contract,
so it's impossible to redeem all YUSD and claim all rewards while admin didn't finalize the current round.

All actions are allowed only for minter except for admin functionalities.


## State Variables
### BP_PRECISION
The precision of the basis points.

1% = 100bp.

BP stands for Basis Points.


```solidity
uint16 public constant BP_PRECISION = 1e4;
```


### INTERNAL_MATH_PRECISION
The precision of the internal math.


```solidity
uint128 constant INTERNAL_MATH_PRECISION = 1e30;
```


### totalDebt
The total debt of the YUSD contract in RUSD to all users (not including the current round)

If totalDebt is positive, it means surplus of RUSD on YUSD contract. (All users can redeem and claim `totalDebt` as rewards) (If all users redeem and claim rewards, the debt will be zero)

If totalDebt is negative, it means shortfall of RUSD on YUSD contract. (All users can't redeem and claim whole rewards)


```solidity
int256 public totalDebt;
```


### roundTimestamps
The timestamps of the rounds.

*The length of the array - 2 is the number of rounds.*

*The first element is the start timestamp of the first round.*

*The second element is the end timestamp of the first round and the start timestamp of the second round.*

*[startTimestampOfRound0, startTimestampOfRound1, startTimestampOfRound2, ...]*


```solidity
uint32[] public roundTimestamps;
```


### _roundInfo
The information of the rounds.

roundInfo is the information of the round.


```solidity
mapping(uint32 roundId => RoundInfo roundInfo) private _roundInfo;
```


## Functions
### initialize

Initializes the YUSD contract.


```solidity
function initialize(
    address _rusdDataHub,
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
    noZeroAmount(_firstRoundStartTimestamp);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_rusdDataHub`|`address`|The address of the RUSDDataHub contract.|
|`_periodLength`|`uint32`|The length of the period. (How often the TWAB is updated?)|
|`_firstRoundStartTimestamp`|`uint32`|The start timestamp of the first round. (When the first round starts?)|
|`_roundBp`|`uint32`|The basis points of the reward rate of the first round. (How much rewards are given per round in bp?)|
|`_roundDuration`|`uint32`|The duration of the first round. (How long the first round lasts?)|


### name


```solidity
function name() public pure returns (string memory);
```

### symbol


```solidity
function symbol() public pure returns (string memory);
```

### decimals


```solidity
function decimals() public pure returns (uint8);
```

### stake

Stake RUSD to YUSD.

Emits Stake event.


```solidity
function stake(address user, uint96 amount, bytes calldata data)
    external
    updateRoundTimestamps
    onlyMinter
    noPauseLevel(PauseLevel.High)
    noZeroAmount(amount)
    noZeroAddress(user)
    noZeroBytes(data);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`user`|`address`|The address of the user.|
|`amount`|`uint96`|The amount of RUSD to stake.|
|`data`|`bytes`|The data to stake.|


### redeem

Redeem YUSD to RUSD.

Emits Redeem event.


```solidity
function redeem(address user, uint96 amount, bytes calldata data)
    external
    updateRoundTimestamps
    onlyMinter
    noPauseLevel(PauseLevel.High)
    noZeroAmount(amount)
    noZeroAddress(user)
    noZeroBytes(data);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`user`|`address`|The address of the user.|
|`amount`|`uint96`|The amount of YUSD to redeem.|
|`data`|`bytes`|The data to redeem.|


### claimRewards

Claim rewards from the round.

Emits RewardsClaimed event.


```solidity
function claimRewards(uint32 roundId, address user, address to, uint256 amount)
    external
    updateRoundTimestamps
    onlyMinter
    noZeroAmount(amount);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`roundId`|`uint32`|The id of the round.|
|`user`|`address`|The address of the user.|
|`to`|`address`|The address to transfer the rewards to.|
|`amount`|`uint256`|The amount of rewards to claim.|


### claimRewards

Claim rewards from the round.

Emits RewardsClaimed event.


```solidity
function claimRewards(uint32 roundId, address user, address to)
    external
    updateRoundTimestamps
    onlyMinter
    returns (uint256 rusdAmount);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`roundId`|`uint32`|The id of the round.|
|`user`|`address`|The address of the user.|
|`to`|`address`|The address to transfer the rewards to.|


### compoundRewards

Compound rewards from the round.

This function is used to claim rewards and stake them back.

Emits RewardsCompounded event.


```solidity
function compoundRewards(uint32 roundId, address user) external updateRoundTimestamps onlyMinter;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`roundId`|`uint32`|The id of the round.|
|`user`|`address`|The address of the user.|


### getCurrentRoundId

Get the current round id.

The current round id is the length of the roundTimestamps array minus 2.

The first round is the round with id 0.

In initialize function first two elements of roundTimestamps array are set.


```solidity
function getCurrentRoundId() public view returns (uint32);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint32`|The current round id.|


### getRoundPeriod

Get the period of the round.


```solidity
function getRoundPeriod(uint32 roundId) public view returns (uint32 start, uint32 end);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`roundId`|`uint32`|The id of the round.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`start`|`uint32`|The start timestamp of the round.|
|`end`|`uint32`|The end timestamp of the round.|


### calculateClaimableRewards

Calculate the claimable rewards for the user in the round.

The claimable rewards is the rewards that have been calculated for the user in the round
minus the rewards that have been claimed by the user.


```solidity
function calculateClaimableRewards(uint32 roundId, address user) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`roundId`|`uint32`|The id of the round.|
|`user`|`address`|The address of the user.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The claimable rewards for the user in the round.|


### calculateRewardsRound

Calculate the rewards for the user in the round.

The rewards are calculated based on the average balance of the user in the round.


```solidity
function calculateRewardsRound(uint32 roundId, address user) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`roundId`|`uint32`|The id of the round.|
|`user`|`address`|The address of the user.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The rewards for the user in the round.|


### calculateTotalRewardsRound

Calculate the total rewards for the round.

The total rewards are calculated based on the average balance of the total supply in the round.


```solidity
function calculateTotalRewardsRound(uint32 roundId) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`roundId`|`uint32`|The id of the round.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The total rewards for the round.|


### getRoundInfo

Get the information of the round.


```solidity
function getRoundInfo(uint32 roundId)
    public
    view
    returns (uint32 bp, uint32 duration, bool isFinalized);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`roundId`|`uint32`|The id of the round.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`bp`|`uint32`|The basis points of the reward rate of the round.|
|`duration`|`uint32`|The duration of the round.|
|`isFinalized`|`bool`|The flag to check if the round is finalized.|


### _claimRewards

Claim rewards from the round.

Decreases the total debt of the YUSD contract.


```solidity
function _claimRewards(uint32 roundId, address user, uint256 amount, address to)
    private
    noPauseLevel(PauseLevel.High)
    noZeroAddress(to)
    noZeroAmount(amount);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`roundId`|`uint32`|The id of the round.|
|`user`|`address`|The address of the user.|
|`amount`|`uint256`|The amount of rewards to claim.|
|`to`|`address`|The address to transfer the rewards to.|


### _getBoundedEnd

Get the bounded end timestamp of the round.

The bounded end timestamp is the end timestamp of the round or the current timestamp, whichever is smaller.


```solidity
function _getBoundedEnd(uint32 end) private view returns (uint32);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`end`|`uint32`|The end timestamp of the round.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint32`|The bounded end timestamp of the round.|


### _calculateRewardsForTwab

Calculate the rewards for the TWAB.


```solidity
function _calculateRewardsForTwab(
    uint32 roundId,
    uint32 start,
    uint32 end,
    uint256 boundedEnd,
    uint256 twabBalance
) private view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`roundId`|`uint32`|The id of the round.|
|`start`|`uint32`|The start timestamp of the round.|
|`end`|`uint32`|The end timestamp of the round.|
|`boundedEnd`|`uint256`|The bounded end timestamp of the round.|
|`twabBalance`|`uint256`|The balance of the TWAB.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The rewards for the TWAB.|


### _startNextRound

Start the next round.

Emits NewRound event.

*This function is called when the current round is ended and the transaction triggered with `updateRoundTimestamps` modifier.*

*This function will create next round info base on previous round if admin didn't override it.*

*This function will update the roundTimestamps array.*


```solidity
function _startNextRound() private;
```

### changeNextRoundDuration

Change the duration of the next round.

Emits RoundDurationChanged event.


```solidity
function changeNextRoundDuration(uint32 duration) external noZeroAmount(duration) onlyAdmin;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`duration`|`uint32`|The duration of the next round.|


### changeNextRoundBp

Change the basis points of the next round.

Emits RoundBpChanged event.


```solidity
function changeNextRoundBp(uint32 bp) external onlyAdmin;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`bp`|`uint32`|The basis points of the next round.|


### finalizeRound

Finalize the round.

Emits RoundFinalized event.

*This function is called by admin to finalize the round.*

*This function will transfer the rewards to the YUSD contract from caller.*

*This function will increase the total debt of the YUSD contract.*


```solidity
function finalizeRound(uint32 roundId) external onlyAdmin;
```

### _authorizeUpgrade

Authorize the upgrade of the contract.

Emits Upgrade event.


```solidity
function _authorizeUpgrade(address newImplementation) internal override onlyAdmin;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newImplementation`|`address`|The address of the new implementation.|


### updateRoundTimestamps

Update the round timestamps.

This modifier is used to check if the current round is ended and start the next round.


```solidity
modifier updateRoundTimestamps();
```

## Structs
### RoundInfo
The information of the round.

bp is the basis points of the reward rate.

duration is the duration of the round.

isBpSet is a flag to check if the bp is changed by admin.

isDurationSet is a flag to check if the duration is changed by admin.

isFinalized is a flag to check if the round is finalized.

claimedRewards is the rewards that have been claimed by the user. Allow users to claim rewards during current round.


```solidity
struct RoundInfo {
    uint32 bp;
    uint32 duration;
    bool isBpSet;
    bool isDurationSet;
    bool isFinalized;
    mapping(address user => uint256 claimedRewards) claimedRewards;
}
```

