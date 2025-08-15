# InsufficientHistory
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/lib/TwabLib.sol)

Emitted when there is insufficient history to lookup a twab time range


```solidity
error InsufficientHistory(
    PeriodOffsetRelativeTimestamp requestedTimestamp, PeriodOffsetRelativeTimestamp oldestTimestamp
);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`requestedTimestamp`|`PeriodOffsetRelativeTimestamp`|The timestamp requested|
|`oldestTimestamp`|`PeriodOffsetRelativeTimestamp`|The oldest timestamp that can be read|

