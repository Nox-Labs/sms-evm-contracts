# TwabLib

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/lib/TwabLib.sol)

## Functions

### increaseBalances

Increase a user's balance and delegate balance by a given amount.

_This function mutates the provided account._

```solidity
function increaseBalances(
    uint32 periodLength,
    uint32 periodOffset,
    Account storage _account,
    uint96 _amount
)
    internal
    returns (
        ObservationLib.Observation memory observation,
        bool isNew,
        bool isObservationRecorded,
        AccountDetails memory accountDetails
    );
```

**Parameters**

| Name           | Type      | Description                           |
| -------------- | --------- | ------------------------------------- |
| `periodLength` | `uint32`  | The length of an overwrite period     |
| `periodOffset` | `uint32`  | The offset of the first period        |
| `_account`     | `Account` | The account to update                 |
| `_amount`      | `uint96`  | The amount to increase the balance by |

**Returns**

| Name                    | Type                         | Description                                                       |
| ----------------------- | ---------------------------- | ----------------------------------------------------------------- |
| `observation`           | `ObservationLib.Observation` | The new/updated observation                                       |
| `isNew`                 | `bool`                       | Whether or not the observation is new or overwrote a previous one |
| `isObservationRecorded` | `bool`                       | Whether or not an observation was recorded to storage             |
| `accountDetails`        | `AccountDetails`             |                                                                   |

### decreaseBalances

Decrease a user's balance and delegate balance by a given amount.

_This function mutates the provided account._

```solidity
function decreaseBalances(
    uint32 periodLength,
    uint32 periodOffset,
    Account storage _account,
    uint96 _amount,
    string memory _revertMessage
)
    internal
    returns (
        ObservationLib.Observation memory observation,
        bool isNew,
        bool isObservationRecorded,
        AccountDetails memory accountDetails
    );
```

**Parameters**

| Name             | Type      | Description                                              |
| ---------------- | --------- | -------------------------------------------------------- |
| `periodLength`   | `uint32`  | The length of an overwrite period                        |
| `periodOffset`   | `uint32`  | The offset of the first period                           |
| `_account`       | `Account` | The account to update                                    |
| `_amount`        | `uint96`  | The amount to decrease the balance by                    |
| `_revertMessage` | `string`  | The revert message to use if the balance is insufficient |

**Returns**

| Name                    | Type                         | Description                                                       |
| ----------------------- | ---------------------------- | ----------------------------------------------------------------- |
| `observation`           | `ObservationLib.Observation` | The new/updated observation                                       |
| `isNew`                 | `bool`                       | Whether or not the observation is new or overwrote a previous one |
| `isObservationRecorded` | `bool`                       | Whether or not the observation was recorded to storage            |
| `accountDetails`        | `AccountDetails`             |                                                                   |

### getOldestObservation

Looks up the oldest observation in the circular buffer.

```solidity
function getOldestObservation(
    ObservationLib.Observation[MAX_CARDINALITY] storage _observations,
    AccountDetails memory _accountDetails
) internal view returns (uint16 index, ObservationLib.Observation memory observation);
```

**Parameters**

| Name              | Type                                          | Description                         |
| ----------------- | --------------------------------------------- | ----------------------------------- |
| `_observations`   | `ObservationLib.Observation[MAX_CARDINALITY]` | The circular buffer of observations |
| `_accountDetails` | `AccountDetails`                              | The account details to query with   |

**Returns**

| Name          | Type                         | Description                                   |
| ------------- | ---------------------------- | --------------------------------------------- |
| `index`       | `uint16`                     | The index of the oldest observation           |
| `observation` | `ObservationLib.Observation` | The oldest observation in the circular buffer |

### getNewestObservation

Looks up the newest observation in the circular buffer.

```solidity
function getNewestObservation(
    ObservationLib.Observation[MAX_CARDINALITY] storage _observations,
    AccountDetails memory _accountDetails
) internal view returns (uint16 index, ObservationLib.Observation memory observation);
```

**Parameters**

| Name              | Type                                          | Description                         |
| ----------------- | --------------------------------------------- | ----------------------------------- |
| `_observations`   | `ObservationLib.Observation[MAX_CARDINALITY]` | The circular buffer of observations |
| `_accountDetails` | `AccountDetails`                              | The account details to query with   |

**Returns**

| Name          | Type                         | Description                                   |
| ------------- | ---------------------------- | --------------------------------------------- |
| `index`       | `uint16`                     | The index of the newest observation           |
| `observation` | `ObservationLib.Observation` | The newest observation in the circular buffer |

### getBalanceAt

Looks up a users balance at a specific time in the past. The time must be before the current overwrite period.

_Ensure timestamps are safe using requireFinalized_

```solidity
function getBalanceAt(
    uint32 periodLength,
    uint32 periodOffset,
    ObservationLib.Observation[MAX_CARDINALITY] storage _observations,
    AccountDetails memory _accountDetails,
    uint256 _targetTime
) internal view requireFinalized(periodLength, periodOffset, _targetTime) returns (uint256);
```

**Parameters**

| Name              | Type                                          | Description                         |
| ----------------- | --------------------------------------------- | ----------------------------------- |
| `periodLength`    | `uint32`                                      | The length of an overwrite period   |
| `periodOffset`    | `uint32`                                      | The offset of the first period      |
| `_observations`   | `ObservationLib.Observation[MAX_CARDINALITY]` | The circular buffer of observations |
| `_accountDetails` | `AccountDetails`                              | The account details to query with   |
| `_targetTime`     | `uint256`                                     | The time to look up the balance at  |

**Returns**

| Name     | Type      | Description                            |
| -------- | --------- | -------------------------------------- |
| `<none>` | `uint256` | balance The balance at the target time |

### isShutdownAt

Returns whether the TwabController has been shutdown at the given timestamp
If the twab is queried at or after this time, whether an absolute timestamp or time range, it will return 0.

```solidity
function isShutdownAt(uint256 timestamp, uint32 periodLength, uint32 periodOffset)
    internal
    pure
    returns (bool);
```

**Parameters**

| Name           | Type      | Description                    |
| -------------- | --------- | ------------------------------ |
| `timestamp`    | `uint256` | The timestamp to check         |
| `periodLength` | `uint32`  |                                |
| `periodOffset` | `uint32`  | The offset of the first period |

**Returns**

| Name     | Type   | Description                                                                     |
| -------- | ------ | ------------------------------------------------------------------------------- |
| `<none>` | `bool` | True if the TwabController is shutdown at the given timestamp, false otherwise. |

### lastObservationAt

Computes the largest timestamp at which the TwabController can record a new observation.

```solidity
function lastObservationAt(uint32 periodLength, uint32 periodOffset)
    internal
    pure
    returns (uint256);
```

**Parameters**

| Name           | Type     | Description                    |
| -------------- | -------- | ------------------------------ |
| `periodLength` | `uint32` |                                |
| `periodOffset` | `uint32` | The offset of the first period |

**Returns**

| Name     | Type      | Description                                                                     |
| -------- | --------- | ------------------------------------------------------------------------------- |
| `<none>` | `uint256` | The largest timestamp at which the TwabController can record a new observation. |

### getTwabBetween

Looks up a users TWAB for a time range. The time must be before the current overwrite period.

_If the timestamps in the range are not exact matches of observations, the balance is extrapolated using the previous observation._

```solidity
function getTwabBetween(
    uint32 periodLength,
    uint32 periodOffset,
    ObservationLib.Observation[MAX_CARDINALITY] storage _observations,
    AccountDetails memory _accountDetails,
    uint256 _startTime,
    uint256 _endTime
) internal view requireFinalized(periodLength, periodOffset, _endTime) returns (uint256);
```

**Parameters**

| Name              | Type                                          | Description                         |
| ----------------- | --------------------------------------------- | ----------------------------------- |
| `periodLength`    | `uint32`                                      | The length of an overwrite period   |
| `periodOffset`    | `uint32`                                      | The offset of the first period      |
| `_observations`   | `ObservationLib.Observation[MAX_CARDINALITY]` | The circular buffer of observations |
| `_accountDetails` | `AccountDetails`                              | The account details to query with   |
| `_startTime`      | `uint256`                                     | The start of the time range         |
| `_endTime`        | `uint256`                                     | The end of the time range           |

**Returns**

| Name     | Type      | Description                      |
| -------- | --------- | -------------------------------- |
| `<none>` | `uint256` | twab The TWAB for the time range |

### \_recordObservation

Given an AccountDetails with updated balances, either updates the latest Observation or records a new one

```solidity
function _recordObservation(
    uint32 periodLength,
    uint32 periodOffset,
    AccountDetails memory _accountDetails,
    Account storage _account
)
    internal
    returns (
        ObservationLib.Observation memory observation,
        bool isNew,
        AccountDetails memory newAccountDetails
    );
```

**Parameters**

| Name              | Type             | Description                 |
| ----------------- | ---------------- | --------------------------- |
| `periodLength`    | `uint32`         | The overwrite period length |
| `periodOffset`    | `uint32`         | The overwrite period offset |
| `_accountDetails` | `AccountDetails` | The updated account details |
| `_account`        | `Account`        | The account to update       |

**Returns**

| Name                | Type                         | Description                                                       |
| ------------------- | ---------------------------- | ----------------------------------------------------------------- |
| `observation`       | `ObservationLib.Observation` | The new/updated observation                                       |
| `isNew`             | `bool`                       | Whether or not the observation is new or overwrote a previous one |
| `newAccountDetails` | `AccountDetails`             | The new account details                                           |

### \_calculateTemporaryObservation

Calculates a temporary observation for a given time using the previous observation.

_This is used to extrapolate a balance for any given time._

```solidity
function _calculateTemporaryObservation(
    ObservationLib.Observation memory _observation,
    PeriodOffsetRelativeTimestamp _time
) private pure returns (ObservationLib.Observation memory);
```

**Parameters**

| Name           | Type                            | Description                |
| -------------- | ------------------------------- | -------------------------- |
| `_observation` | `ObservationLib.Observation`    | The previous observation   |
| `_time`        | `PeriodOffsetRelativeTimestamp` | The time to extrapolate to |

### \_getNextObservationIndex

Looks up the next observation index to write to in the circular buffer.

_If the current time is in the same period as the newest observation, we overwrite it._

_If the current time is in a new period, we increment the index and write a new observation._

```solidity
function _getNextObservationIndex(
    uint32 periodLength,
    uint32 periodOffset,
    ObservationLib.Observation[MAX_CARDINALITY] storage _observations,
    AccountDetails memory _accountDetails
)
    private
    view
    returns (uint16 index, ObservationLib.Observation memory newestObservation, bool isNew);
```

**Parameters**

| Name              | Type                                          | Description                         |
| ----------------- | --------------------------------------------- | ----------------------------------- |
| `periodLength`    | `uint32`                                      | The length of an overwrite period   |
| `periodOffset`    | `uint32`                                      | The offset of the first period      |
| `_observations`   | `ObservationLib.Observation[MAX_CARDINALITY]` | The circular buffer of observations |
| `_accountDetails` | `AccountDetails`                              | The account details to query with   |

**Returns**

| Name                | Type                         | Description                                                     |
| ------------------- | ---------------------------- | --------------------------------------------------------------- |
| `index`             | `uint16`                     | The index of the next observation slot to overwrite             |
| `newestObservation` | `ObservationLib.Observation` | The newest observation in the circular buffer                   |
| `isNew`             | `bool`                       | True if the observation slot is new, false if we're overwriting |

### \_currentOverwritePeriodStartedAt

Computes the start time of the current overwrite period

```solidity
function _currentOverwritePeriodStartedAt(uint32 periodLength, uint32 periodOffset)
    private
    view
    returns (uint256);
```

**Parameters**

| Name           | Type     | Description                       |
| -------------- | -------- | --------------------------------- |
| `periodLength` | `uint32` | The length of an overwrite period |
| `periodOffset` | `uint32` | The offset of the first period    |

**Returns**

| Name     | Type      | Description                                    |
| -------- | --------- | ---------------------------------------------- |
| `<none>` | `uint256` | The start time of the current overwrite period |

### \_extrapolateFromBalance

Calculates the next cumulative balance using a provided Observation and timestamp.

```solidity
function _extrapolateFromBalance(
    ObservationLib.Observation memory _observation,
    PeriodOffsetRelativeTimestamp _offsetTimestamp
) private pure returns (uint128);
```

**Parameters**

| Name               | Type                            | Description                         |
| ------------------ | ------------------------------- | ----------------------------------- |
| `_observation`     | `ObservationLib.Observation`    | The observation to extrapolate from |
| `_offsetTimestamp` | `PeriodOffsetRelativeTimestamp` | The timestamp to extrapolate to     |

**Returns**

| Name     | Type      | Description                                               |
| -------- | --------- | --------------------------------------------------------- |
| `<none>` | `uint128` | cumulativeBalance The cumulative balance at the timestamp |

### currentOverwritePeriodStartedAt

Computes the overwrite period start time given the current time

```solidity
function currentOverwritePeriodStartedAt(uint32 periodLength, uint32 periodOffset)
    internal
    view
    returns (uint256);
```

**Parameters**

| Name           | Type     | Description                       |
| -------------- | -------- | --------------------------------- |
| `periodLength` | `uint32` | The length of an overwrite period |
| `periodOffset` | `uint32` | The offset of the first period    |

**Returns**

| Name     | Type      | Description                                      |
| -------- | --------- | ------------------------------------------------ |
| `<none>` | `uint256` | The start time for the current overwrite period. |

### getTimestampPeriod

Calculates the period a timestamp falls within.

_Timestamp prior to the periodOffset are considered to be in period 0._

```solidity
function getTimestampPeriod(uint32 periodLength, uint32 periodOffset, uint256 _timestamp)
    internal
    pure
    returns (uint256);
```

**Parameters**

| Name           | Type      | Description                               |
| -------------- | --------- | ----------------------------------------- |
| `periodLength` | `uint32`  | The length of an overwrite period         |
| `periodOffset` | `uint32`  | The offset of the first period            |
| `_timestamp`   | `uint256` | The timestamp to calculate the period for |

**Returns**

| Name     | Type      | Description       |
| -------- | --------- | ----------------- |
| `<none>` | `uint256` | period The period |

### getPeriodStartTime

Calculates the start timestamp for a period

```solidity
function getPeriodStartTime(uint32 periodLength, uint32 periodOffset, uint256 _period)
    internal
    pure
    returns (uint256);
```

**Parameters**

| Name           | Type      | Description                                      |
| -------------- | --------- | ------------------------------------------------ |
| `periodLength` | `uint32`  | The period length to use to calculate the period |
| `periodOffset` | `uint32`  | The period offset to use to calculate the period |
| `_period`      | `uint256` | The period to check                              |

**Returns**

| Name     | Type      | Description                                          |
| -------- | --------- | ---------------------------------------------------- |
| `<none>` | `uint256` | \_timestamp The timestamp at which the period starts |

### getPeriodEndTime

Calculates the last timestamp for a period

```solidity
function getPeriodEndTime(uint32 periodLength, uint32 periodOffset, uint256 _period)
    internal
    pure
    returns (uint256);
```

**Parameters**

| Name           | Type      | Description                                      |
| -------------- | --------- | ------------------------------------------------ |
| `periodLength` | `uint32`  | The period length to use to calculate the period |
| `periodOffset` | `uint32`  | The period offset to use to calculate the period |
| `_period`      | `uint256` | The period to check                              |

**Returns**

| Name     | Type      | Description                                        |
| -------- | --------- | -------------------------------------------------- |
| `<none>` | `uint256` | \_timestamp The timestamp at which the period ends |

### \_getPreviousOrAtObservation

Looks up the newest observation before or at a given timestamp.

_If an observation is available at the target time, it is returned. Otherwise, the newest observation before the target time is returned._

```solidity
function _getPreviousOrAtObservation(
    ObservationLib.Observation[MAX_CARDINALITY] storage _observations,
    AccountDetails memory _accountDetails,
    PeriodOffsetRelativeTimestamp _offsetTargetTime
) private view returns (ObservationLib.Observation memory prevOrAtObservation);
```

**Parameters**

| Name                | Type                                          | Description                                            |
| ------------------- | --------------------------------------------- | ------------------------------------------------------ |
| `_observations`     | `ObservationLib.Observation[MAX_CARDINALITY]` | The circular buffer of observations                    |
| `_accountDetails`   | `AccountDetails`                              | The account details to query with                      |
| `_offsetTargetTime` | `PeriodOffsetRelativeTimestamp`               | The timestamp to look up (offset by the period offset) |

**Returns**

| Name                  | Type                         | Description     |
| --------------------- | ---------------------------- | --------------- |
| `prevOrAtObservation` | `ObservationLib.Observation` | The observation |

### hasFinalized

Checks if the given timestamp is safe to perform a historic balance lookup on.

_A timestamp is safe if it is before the current overwrite period_

```solidity
function hasFinalized(uint32 periodLength, uint32 periodOffset, uint256 _time)
    internal
    view
    returns (bool);
```

**Parameters**

| Name           | Type      | Description                                      |
| -------------- | --------- | ------------------------------------------------ |
| `periodLength` | `uint32`  | The period length to use to calculate the period |
| `periodOffset` | `uint32`  | The period offset to use to calculate the period |
| `_time`        | `uint256` | The timestamp to check                           |

**Returns**

| Name     | Type   | Description                                 |
| -------- | ------ | ------------------------------------------- |
| `<none>` | `bool` | isSafe Whether or not the timestamp is safe |

### \_hasFinalized

Checks if the given timestamp is safe to perform a historic balance lookup on.

_A timestamp is safe if it is on or before the current overwrite period start time_

```solidity
function _hasFinalized(uint32 periodLength, uint32 periodOffset, uint256 _time)
    private
    view
    returns (bool);
```

**Parameters**

| Name           | Type      | Description                                      |
| -------------- | --------- | ------------------------------------------------ |
| `periodLength` | `uint32`  | The period length to use to calculate the period |
| `periodOffset` | `uint32`  | The period offset to use to calculate the period |
| `_time`        | `uint256` | The timestamp to check                           |

**Returns**

| Name     | Type   | Description                                 |
| -------- | ------ | ------------------------------------------- |
| `<none>` | `bool` | isSafe Whether or not the timestamp is safe |

### requireFinalized

Checks if the given timestamp is safe to perform a historic balance lookup on.

```solidity
modifier requireFinalized(uint32 periodLength, uint32 periodOffset, uint256 _timestamp);
```

**Parameters**

| Name           | Type      | Description                                      |
| -------------- | --------- | ------------------------------------------------ |
| `periodLength` | `uint32`  | The period length to use to calculate the period |
| `periodOffset` | `uint32`  | The period offset to use to calculate the period |
| `_timestamp`   | `uint256` | The timestamp to check                           |

## Structs

### AccountDetails

Struct ring buffer parameters for single user Account.

```solidity
struct AccountDetails {
    uint96 balance;
    uint16 nextObservationIndex;
    uint16 cardinality;
}
```

**Properties**

| Name                   | Type     | Description                                                                                                                                          |
| ---------------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| `balance`              | `uint96` | Current token balance for an Account                                                                                                                 |
| `nextObservationIndex` | `uint16` | Next uninitialized or updatable ring buffer checkpoint storage slot                                                                                  |
| `cardinality`          | `uint16` | Current total "initialized" ring buffer checkpoints for single user Account. Used to set initial boundary conditions for an efficient binary search. |

### Account

Account details and historical twabs.

_The size of observations is MAX_CARDINALITY from the ObservationLib._

```solidity
struct Account {
    AccountDetails details;
    ObservationLib.Observation[17520] observations;
}
```

**Properties**

| Name           | Type                                | Description                                  |
| -------------- | ----------------------------------- | -------------------------------------------- |
| `details`      | `AccountDetails`                    | The account details                          |
| `observations` | `ObservationLib.Observation[17520]` | The history of observations for this account |
