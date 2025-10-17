# DelegateBalanceLTAmount

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/lib/TwabLib.sol)

Emitted when a delegate balance is decreased by an amount that exceeds the amount available.

```solidity
error DelegateBalanceLTAmount(uint96 delegateBalance, uint96 delegateAmount, string message);
```

**Parameters**

| Name              | Type     | Description                                                    |
| ----------------- | -------- | -------------------------------------------------------------- |
| `delegateBalance` | `uint96` | The current delegate balance of the account                    |
| `delegateAmount`  | `uint96` | The amount being decreased from the account's delegate balance |
| `message`         | `string` | An additional message describing the error                     |
