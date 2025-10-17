# LzMessageMetadata

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/interface/IDataTypes.sol)

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

| Name       | Type           | Description                                          |
| ---------- | -------------- | ---------------------------------------------------- |
| `dstEid`   | `uint32`       | The destination chain eid.                           |
| `options`  | `bytes`        | The options for the lz message.                      |
| `refundTo` | `address`      | The address to refund the message to.                |
| `fee`      | `MessagingFee` | The MessagingFee struct from the LayerZero protocol. |
