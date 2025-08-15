# IRUSDOmnichainAdapter
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/interface/IRUSDOmnichainAdapter.sol)


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

