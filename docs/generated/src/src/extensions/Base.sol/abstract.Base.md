# Base

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/extensions/Base.sol)

**Inherits:**
Initializable

## Functions

### constructor

```solidity
constructor();
```

### noZeroAddress

```solidity
modifier noZeroAddress(address _address);
```

### noZeroAmount

```solidity
modifier noZeroAmount(uint256 _amount);
```

### noZeroBytes

```solidity
modifier noZeroBytes(bytes calldata _bytes);
```

## Errors

### ZeroAddress

```solidity
error ZeroAddress();
```

### ZeroAmount

```solidity
error ZeroAmount();
```

### Unauthorized

```solidity
error Unauthorized();
```

### ZeroBytes

```solidity
error ZeroBytes();
```

### Paused

```solidity
error Paused();
```
