# ISMS

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/interface/ISMS.sol)

**Inherits:**
IERC20Metadata

## Functions

### mint

```solidity
function mint(address to, uint256 amount) external;
```

### burn

```solidity
function burn(uint256 amount) external;
```

### mint

```solidity
function mint(address to, uint256 amount, bytes calldata data) external;
```

### burn

```solidity
function burn(uint256 amount, bytes calldata data) external;
```

## Events

### Mint

```solidity
event Mint(address indexed to, uint256 amount, bytes data);
```

### Burn

```solidity
event Burn(address indexed from, uint256 amount, bytes data);
```

## Errors

### CrossChainActionNotAllowed

```solidity
error CrossChainActionNotAllowed();
```
