# LzMessageMetadata
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/interface/IDataTypes.sol)

LzMessageMetadata to provide metadata for the lz message.


```solidity
struct LzMessageMetadata {
    uint32 dstEid;
    bytes options;
    address refundTo;
    MessagingFee fee;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`dstEid`|`uint32`|The destination chain eid.|
|`options`|`bytes`|The options for the lz message.|
|`refundTo`|`address`|The address to refund the message to.|
|`fee`|`MessagingFee`|The MessagingFee struct from the LayerZero protocol.|

