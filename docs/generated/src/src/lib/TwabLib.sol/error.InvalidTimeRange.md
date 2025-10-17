# InvalidTimeRange

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/lib/TwabLib.sol)

Emitted when a TWAB time range start is after the end.

```solidity
error InvalidTimeRange(uint256 start, uint256 end);
```

**Parameters**

| Name    | Type      | Description    |
| ------- | --------- | -------------- |
| `start` | `uint256` | The start time |
| `end`   | `uint256` | The end time   |
