# InvalidTimeRange
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/lib/TwabLib.sol)

Emitted when a TWAB time range start is after the end.


```solidity
error InvalidTimeRange(uint256 start, uint256 end);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`start`|`uint256`|The start time|
|`end`|`uint256`|The end time|

