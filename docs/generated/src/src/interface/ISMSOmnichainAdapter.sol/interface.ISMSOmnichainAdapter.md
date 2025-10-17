# ISMSOmnichainAdapter

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/interface/ISMSOmnichainAdapter.sol)

## Functions

### bridgePing

```solidity
function bridgePing(Message memory _payload, LzMessageMetadata memory _metadata) external payable;
```

### quoteSend

```solidity
function quoteSend(
    uint32 _dstEid,
    Message memory _message,
    bytes memory _options,
    bool _payInLzToken
) external view returns (MessagingFee memory);
```

## Events

### BridgePing

```solidity
event BridgePing(
    bytes32 indexed guid, address indexed from, Message payload, LzMessageMetadata metadata
);
```

### BridgePong

```solidity
event BridgePong(bytes32 indexed guid, Message payload);
```
