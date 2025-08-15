# Message
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/interface/IDataTypes.sol)

Message struct to send to the destination chain.


```solidity
struct Message {
    bytes32 to;
    uint64 amount;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`to`|`bytes32`|The address of the destination chain.|
|`amount`|`uint64`|The amount of tokens to send.|

