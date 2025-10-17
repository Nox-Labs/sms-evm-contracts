# ObservationLib

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/lib/ObservationLib.sol)

## Functions

### binarySearch

Fetches Observations `beforeOrAt` and `afterOrAt` a `_target`, eg: where [`beforeOrAt`, `afterOrAt`] is satisfied.
The result may be the same Observation, or adjacent Observations.

_The \_target must fall within the boundaries of the provided \_observations.
Meaning the \_target must be: older than the most recent Observation and younger, or the same age as, the oldest Observation._

_If `_newestObservationIndex` is less than `_oldestObservationIndex`, it means that we've wrapped around the circular buffer.
So the most recent observation will be at `_oldestObservationIndex + _cardinality - 1`, at the beginning of the circular buffer._

```solidity
function binarySearch(
    Observation[MAX_CARDINALITY] storage _observations,
    uint24 _newestObservationIndex,
    uint24 _oldestObservationIndex,
    uint32 _target,
    uint16 _cardinality
)
    internal
    view
    returns (
        Observation memory beforeOrAt,
        uint16 beforeOrAtIndex,
        Observation memory afterOrAt,
        uint16 afterOrAtIndex
    );
```

**Parameters**

| Name                      | Type                           | Description                                                         |
| ------------------------- | ------------------------------ | ------------------------------------------------------------------- |
| `_observations`           | `Observation[MAX_CARDINALITY]` | List of Observations to search through.                             |
| `_newestObservationIndex` | `uint24`                       | Index of the newest Observation. Right side of the circular buffer. |
| `_oldestObservationIndex` | `uint24`                       | Index of the oldest Observation. Left side of the circular buffer.  |
| `_target`                 | `uint32`                       | Timestamp at which we are searching the Observation.                |
| `_cardinality`            | `uint16`                       | Cardinality of the circular buffer we are searching through.        |

**Returns**

| Name              | Type          | Description                                              |
| ----------------- | ------------- | -------------------------------------------------------- |
| `beforeOrAt`      | `Observation` | Observation recorded before, or at, the target.          |
| `beforeOrAtIndex` | `uint16`      | Index of observation recorded before, or at, the target. |
| `afterOrAt`       | `Observation` | Observation recorded at, or after, the target.           |
| `afterOrAtIndex`  | `uint16`      | Index of observation recorded at, or after, the target.  |

## Structs

### Observation

Observation, which includes an amount and timestamp.

```solidity
struct Observation {
    uint128 cumulativeBalance;
    uint96 balance;
    uint32 timestamp;
}
```

**Properties**

| Name                | Type      | Description                                          |
| ------------------- | --------- | ---------------------------------------------------- |
| `cumulativeBalance` | `uint128` | the cumulative time-weighted balance at `timestamp`. |
| `balance`           | `uint96`  | `balance` at `timestamp`.                            |
| `timestamp`         | `uint32`  | Recorded `timestamp`.                                |
