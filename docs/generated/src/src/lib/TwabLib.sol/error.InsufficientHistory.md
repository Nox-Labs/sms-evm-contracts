# InsufficientHistory

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/lib/TwabLib.sol)

Emitted when there is insufficient history to lookup a twab time range

```solidity
error InsufficientHistory(
    PeriodOffsetRelativeTimestamp requestedTimestamp, PeriodOffsetRelativeTimestamp oldestTimestamp
);
```

**Parameters**

| Name                 | Type                            | Description                           |
| -------------------- | ------------------------------- | ------------------------------------- |
| `requestedTimestamp` | `PeriodOffsetRelativeTimestamp` | The timestamp requested               |
| `oldestTimestamp`    | `PeriodOffsetRelativeTimestamp` | The oldest timestamp that can be read |
