# RUSDOmnichainAdapter
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/RUSDOmnichainAdapter.sol)

**Inherits:**
[IRUSDOmnichainAdapter](/src/interface/IRUSDOmnichainAdapter.sol/interface.IRUSDOmnichainAdapter.md), [RUSDDataHubKeeper](/src/extensions/RUSDDataHubKeeper.sol/abstract.RUSDDataHubKeeper.md), UUPSUpgradeable, OAppUpgradeable

The omnichain mint/burn adapter contract.

This is separate contract, to allow RUSD to be bridged to other chains through LayerZero.


## Functions
### constructor

Initializes the contract.

*Set the endpoint address in the immutable endpoint variable.*

*This will work properly with proxy contract because the immutable variable works like a constant.*


```solidity
constructor(address _lzEndpoint) OAppUpgradeable(_lzEndpoint);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_lzEndpoint`|`address`|The address of the LayerZero endpoint.|


### initialize

Initializes the contract.


```solidity
function initialize(address _rusdDataHub) public initializer;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_rusdDataHub`|`address`|The address of the RUSDDataHub contract.|


### bridgePing

Burns RUSD from the caller and sends it to the destination chain.

Emits BridgePing event.


```solidity
function bridgePing(Message calldata _msg, LzMessageMetadata memory _md)
    public
    payable
    noPauseLevel(PauseLevel.High);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_msg`|`Message`|The message to send.|
|`_md`|`LzMessageMetadata`|The metadata of the message.|


### _bridgePong

Mints RUSD to the specified address.

Emits BridgePong event.


```solidity
function _bridgePong(bytes32 _guid, bytes calldata _encodedMessage) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_guid`|`bytes32`|The guid of the message.|
|`_encodedMessage`|`bytes`|The encoded message.|


### _sendLzMessage

Sends a message to the destination chain with lzSend.


```solidity
function _sendLzMessage(Message calldata _message, LzMessageMetadata memory _md)
    internal
    returns (MessagingReceipt memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_message`|`Message`|The message to send.|
|`_md`|`LzMessageMetadata`|The metadata of the message.|


### _lzReceive

Receives a message from the source chain with lzReceive.


```solidity
function _lzReceive(
    Origin calldata,
    bytes32 _guid,
    bytes calldata _encodedMessage,
    address,
    bytes calldata
) internal override;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`Origin`||
|`_guid`|`bytes32`|The guid of the message.|
|`_encodedMessage`|`bytes`|The encoded message.|
|`<none>`|`address`||
|`<none>`|`bytes`||


### quoteSend

Quotes the fee for sending a message to the destination chain.


```solidity
function quoteSend(
    uint32 _dstEid,
    Message calldata _message,
    bytes memory _options,
    bool _payInLzToken
) public view returns (MessagingFee memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_dstEid`|`uint32`|The destination chain id.|
|`_message`|`Message`|The message to send.|
|`_options`|`bytes`|The options of the message.|
|`_payInLzToken`|`bool`|Whether to pay in LZ token.|


### defaultLzOptions

Returns the default LZ options.

Contains executorLzReceiveOption with 200k gas and 0 value.


```solidity
function defaultLzOptions() public pure returns (bytes memory);
```

### _authorizeUpgrade

Authorizes the upgrade of the contract.

*Inherited from UUPSUpgradeable.*


```solidity
function _authorizeUpgrade(address) internal override onlyAdmin;
```

### setPeer

Sets the peer of the contract.

*Inherited from OAppUpgradeable.*


```solidity
function setPeer(uint32 _eid, bytes32 _peer) public override onlyAdmin;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_eid`|`uint32`|The destination chain eid.|
|`_peer`|`bytes32`|The peer of the contract.|


