# IRUSDDataHub
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/interface/IRUSDDataHub.sol)


## Functions
### getAdmin


```solidity
function getAdmin() external view returns (address);
```

### getMinter


```solidity
function getMinter() external view returns (address);
```

### getRUSD


```solidity
function getRUSD() external view returns (address);
```

### getOmnichainAdapter


```solidity
function getOmnichainAdapter() external view returns (address);
```

### setAdmin


```solidity
function setAdmin(address _admin) external;
```

### setMinter


```solidity
function setMinter(address _minter) external;
```

### setRUSD


```solidity
function setRUSD(address _rusd) external;
```

### setOmnichainAdapter


```solidity
function setOmnichainAdapter(address _omnichainAdapter) external;
```

### getPauseLevel


```solidity
function getPauseLevel() external view returns (PauseLevel);
```

### setPauseLevel


```solidity
function setPauseLevel(PauseLevel _pauseLevel) external;
```

## Events
### PauseLevelChanged

```solidity
event PauseLevelChanged(PauseLevel pauseLevel);
```

### AdminChanged

```solidity
event AdminChanged(address admin);
```

### MinterChanged

```solidity
event MinterChanged(address minter);
```

## Errors
### AlreadySet

```solidity
error AlreadySet();
```

