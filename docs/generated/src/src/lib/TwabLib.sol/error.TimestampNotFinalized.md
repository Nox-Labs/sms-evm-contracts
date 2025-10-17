# TimestampNotFinalized

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/lib/TwabLib.sol)

Emitted when a request is made for a twab that is not yet finalized.

```solidity
error TimestampNotFinalized(uint256 timestamp, uint256 currentOverwritePeriodStartedAt);
```

**Parameters**

| Name                              | Type      | Description                             |
| --------------------------------- | --------- | --------------------------------------- |
| `timestamp`                       | `uint256` | The requested timestamp                 |
| `currentOverwritePeriodStartedAt` | `uint256` | The current overwrite period start time |
