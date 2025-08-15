# IRUSD
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/interface/IRUSD.sol)

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

