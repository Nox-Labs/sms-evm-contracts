# TWAB

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/extensions/TWAB.sol)

**Inherits:**
Initializable, IERC20, [Base](/src/extensions/Base.sol/abstract.Base.md)

## State Variables

### TWABStorageLocation

```solidity
bytes32 private constant TWABStorageLocation =
    0xd5efd9e6f6b587af2e2d822068ce7fcce37c6c1290968041377a1bfb7c5a0900;
```

## Functions

### \_getTWABStorage

```solidity
function _getTWABStorage() private pure returns (TWABStorage storage $);
```

### \_\_TWAB_init

Construct a new TwabController.

_Reverts if the period offset is in the future._

```solidity
function __TWAB_init(uint32 _periodLength, uint32 _periodOffset) internal onlyInitializing;
```

**Parameters**

| Name            | Type     | Description                                                                                                                                              |
| --------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `_periodLength` | `uint32` | Sets the minimum period length for Observations. When a period elapses, a new Observation is recorded, otherwise the most recent Observation is updated. |
| `_periodOffset` | `uint32` | Sets the beginning timestamp for the first period. This allows us to maximize storage as well as line up periods with a chosen timestamp.                |

### totalSupply

```solidity
function totalSupply() external view returns (uint256);
```

### balanceOf

```solidity
function balanceOf(address user) external view returns (uint256);
```

### transfer

```solidity
function transfer(address _to, uint256 _amount) public noZeroAddress(_to) returns (bool);
```

### allowance

```solidity
function allowance(address owner, address spender) public view virtual returns (uint256);
```

### approve

```solidity
function approve(address spender, uint256 amount) external returns (bool);
```

### transferFrom

```solidity
function transferFrom(address _from, address _to, uint256 _amount)
    public
    noZeroAddress(_from)
    noZeroAddress(_to)
    returns (bool);
```

### \_transfer

============ Internal Functions ============

```solidity
function _transfer(address _from, address _to, uint96 _amount) internal;
```

### \_approve

```solidity
function _approve(address owner, address spender, uint256 value, bool emitEvent)
    internal
    virtual
    noZeroAddress(owner)
    noZeroAddress(spender);
```

### \_spendAllowance

```solidity
function _spendAllowance(address owner, address spender, uint256 value) internal virtual;
```

### \_increaseBalances

Increases a user's balance and delegateBalance for a specific vault.

```solidity
function _increaseBalances(address _user, uint96 _amount) internal;
```

**Parameters**

| Name      | Type      | Description                                              |
| --------- | --------- | -------------------------------------------------------- |
| `_user`   | `address` | the address of the user whose balance is being increased |
| `_amount` | `uint96`  | the amount of balance being increased                    |

### \_decreaseBalances

Decreases the a user's balance and delegateBalance for a specific vault.

```solidity
function _decreaseBalances(address _user, uint96 _amount) internal;
```

**Parameters**

| Name      | Type      | Description                           |
| --------- | --------- | ------------------------------------- |
| `_user`   | `address` |                                       |
| `_amount` | `uint96`  | the amount of balance being decreased |

### \_decreaseTotalSupply

Decreases the totalSupply balance and delegateBalance for a specific vault.

```solidity
function _decreaseTotalSupply(uint96 _amount) internal;
```

**Parameters**

| Name      | Type     | Description                           |
| --------- | -------- | ------------------------------------- |
| `_amount` | `uint96` | the amount of balance being decreased |

### \_increaseTotalSupply

Increases the totalSupply balance and delegateBalance for a specific vault.

```solidity
function _increaseTotalSupply(uint96 _amount) internal;
```

**Parameters**

| Name      | Type     | Description                           |
| --------- | -------- | ------------------------------------- |
| `_amount` | `uint96` | the amount of balance being increased |

### lastObservationAt

Computes the timestamp after which no more observations will be made.

```solidity
function lastObservationAt() external view returns (uint256);
```

**Returns**

| Name     | Type      | Description                                                                     |
| -------- | --------- | ------------------------------------------------------------------------------- |
| `<none>` | `uint256` | The largest timestamp at which the TwabController can record a new observation. |

### getTwabBetween

Looks up the average balance of a user between two timestamps.

_Timestamps are Unix timestamps denominated in seconds_

```solidity
function getTwabBetween(address user, uint256 startTime, uint256 endTime)
    public
    view
    returns (uint256);
```

**Parameters**

| Name        | Type      | Description                                                                                                                                          |
| ----------- | --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| `user`      | `address` | the user whose average balance is being queried                                                                                                      |
| `startTime` | `uint256` | the start of the time range for which the average balance is being queried. The time will be snapped to a period end time on or after the timestamp. |
| `endTime`   | `uint256` | the end of the time range for which the average balance is being queried. The time will be snapped to a period end time on or after the timestamp.   |

**Returns**

| Name     | Type      | Description                                                |
| -------- | --------- | ---------------------------------------------------------- |
| `<none>` | `uint256` | The average balance of the user between the two timestamps |

### getTotalSupplyTwabBetween

Looks up the average total supply between two timestamps.

_Timestamps are Unix timestamps denominated in seconds_

```solidity
function getTotalSupplyTwabBetween(uint256 startTime, uint256 endTime)
    public
    view
    returns (uint256);
```

**Parameters**

| Name        | Type      | Description                                                                     |
| ----------- | --------- | ------------------------------------------------------------------------------- |
| `startTime` | `uint256` | the start of the time range for which the average total supply is being queried |
| `endTime`   | `uint256` | the end of the time range for which the average total supply is being queried   |

**Returns**

| Name     | Type      | Description                                         |
| -------- | --------- | --------------------------------------------------- |
| `<none>` | `uint256` | The average total supply between the two timestamps |

### periodEndOnOrAfter

Computes the period end timestamp on or after the given timestamp.

```solidity
function periodEndOnOrAfter(uint256 _timestamp) external view returns (uint256);
```

**Parameters**

| Name         | Type      | Description            |
| ------------ | --------- | ---------------------- |
| `_timestamp` | `uint256` | The timestamp to check |

**Returns**

| Name     | Type      | Description                                                                           |
| -------- | --------- | ------------------------------------------------------------------------------------- |
| `<none>` | `uint256` | The end timestamp of the period that ends on or immediately after the given timestamp |

### \_periodEndOnOrAfter

Computes the period end timestamp on or after the given timestamp.

```solidity
function _periodEndOnOrAfter(uint256 _timestamp) internal view returns (uint256);
```

**Parameters**

| Name         | Type      | Description                                      |
| ------------ | --------- | ------------------------------------------------ |
| `_timestamp` | `uint256` | The timestamp to compute the period end time for |

**Returns**

| Name     | Type      | Description        |
| -------- | --------- | ------------------ |
| `<none>` | `uint256` | A period end time. |

### hasFinalized

Checks if the given timestamp is before the current overwrite period.

```solidity
function hasFinalized(uint256 time) public view returns (bool);
```

**Parameters**

| Name   | Type      | Description            |
| ------ | --------- | ---------------------- |
| `time` | `uint256` | The timestamp to check |

**Returns**

| Name     | Type   | Description                                                                             |
| -------- | ------ | --------------------------------------------------------------------------------------- |
| `<none>` | `bool` | True if the given time is finalized, false if it's during the current overwrite period. |

### currentOverwritePeriodStartedAt

Computes the timestamp at which the current overwrite period started.

_The overwrite period is the period during which observations are collated._

```solidity
function currentOverwritePeriodStartedAt() public view returns (uint256);
```

**Returns**

| Name     | Type      | Description                                                         |
| -------- | --------- | ------------------------------------------------------------------- |
| `<none>` | `uint256` | period The timestamp at which the current overwrite period started. |

### getPeriodOffset

```solidity
function getPeriodOffset() public view returns (uint256);
```

### getPeriodLength

```solidity
function getPeriodLength() public view returns (uint256);
```

## Events

### TotalSupplyObservationRecorded

Emitted when a Total Supply Observation is recorded to the Ring Buffer.

```solidity
event TotalSupplyObservationRecorded(
    uint96 totalSupply, bool isNew, ObservationLib.Observation observation
);
```

**Parameters**

| Name          | Type                         | Description                                 |
| ------------- | ---------------------------- | ------------------------------------------- |
| `totalSupply` | `uint96`                     | the resulting total supply                  |
| `isNew`       | `bool`                       | whether the observation is new or not       |
| `observation` | `ObservationLib.Observation` | the observation that was created or updated |

### ObservationRecorded

Emitted when an Observation is recorded to the Ring Buffer.

```solidity
event ObservationRecorded(
    address indexed user, uint96 balance, bool isNew, ObservationLib.Observation observation
);
```

**Parameters**

| Name          | Type                         | Description                                 |
| ------------- | ---------------------------- | ------------------------------------------- |
| `user`        | `address`                    | the users whose Observation was recorded    |
| `balance`     | `uint96`                     | the resulting balance                       |
| `isNew`       | `bool`                       | whether the observation is new or not       |
| `observation` | `ObservationLib.Observation` | the observation that was created or updated |

## Errors

### PeriodOffsetInFuture

Emitted when the period offset is not in the past.

```solidity
error PeriodOffsetInFuture(uint32 periodOffset);
```

**Parameters**

| Name           | Type     | Description                          |
| -------------- | -------- | ------------------------------------ |
| `periodOffset` | `uint32` | The period offset that was passed in |

### ERC20InsufficientAllowance

```solidity
error ERC20InsufficientAllowance(address spender, uint256 currentAllowance, uint256 requested);
```

## Structs

### TWABStorage

**Note:**
storage-location: erc7201:twab.storage.TWAB

```solidity
struct TWABStorage {
    uint32 periodLength;
    uint32 periodOffset;
    mapping(address => TwabLib.Account) userObservations;
    mapping(address account => mapping(address spender => uint256)) allowances;
    TwabLib.Account totalSupplyObservations;
}
```
