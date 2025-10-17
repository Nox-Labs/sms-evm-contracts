# BalanceLTAmount

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/lib/TwabLib.sol)

Emitted when a balance is decreased by an amount that exceeds the amount available.

```solidity
error BalanceLTAmount(uint96 balance, uint96 amount, string message);
```

**Parameters**

| Name      | Type     | Description                                           |
| --------- | -------- | ----------------------------------------------------- |
| `balance` | `uint96` | The current balance of the account                    |
| `amount`  | `uint96` | The amount being decreased from the account's balance |
| `message` | `string` | An additional message describing the error            |
