# DelegateBalanceLTAmount
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/lib/TwabLib.sol)

Emitted when a delegate balance is decreased by an amount that exceeds the amount available.


```solidity
error DelegateBalanceLTAmount(uint96 delegateBalance, uint96 delegateAmount, string message);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`delegateBalance`|`uint96`|The current delegate balance of the account|
|`delegateAmount`|`uint96`|The amount being decreased from the account's delegate balance|
|`message`|`string`|An additional message describing the error|

