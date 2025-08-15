# TimestampNotFinalized
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/lib/TwabLib.sol)

Emitted when a request is made for a twab that is not yet finalized.


```solidity
error TimestampNotFinalized(uint256 timestamp, uint256 currentOverwritePeriodStartedAt);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`timestamp`|`uint256`|The requested timestamp|
|`currentOverwritePeriodStartedAt`|`uint256`|The current overwrite period start time|

