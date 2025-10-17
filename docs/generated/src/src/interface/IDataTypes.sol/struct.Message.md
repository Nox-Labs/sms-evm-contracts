# Message

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/interface/IDataTypes.sol)

Message struct to send to the destination chain.

```solidity
struct Message {
    bytes32 to;
    uint64 amount;
}
```

**Properties**

| Name     | Type      | Description                           |
| -------- | --------- | ------------------------------------- |
| `to`     | `bytes32` | The address of the destination chain. |
| `amount` | `uint64`  | The amount of tokens to send.         |
