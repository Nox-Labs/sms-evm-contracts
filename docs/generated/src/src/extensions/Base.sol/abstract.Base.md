# Base
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/extensions/Base.sol)

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

