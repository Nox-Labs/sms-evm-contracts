# BalanceLTAmount
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/lib/TwabLib.sol)

Emitted when a balance is decreased by an amount that exceeds the amount available.


```solidity
error BalanceLTAmount(uint96 balance, uint96 amount, string message);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`balance`|`uint96`|The current balance of the account|
|`amount`|`uint96`|The amount being decreased from the account's balance|
|`message`|`string`|An additional message describing the error|

