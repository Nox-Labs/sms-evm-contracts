# ISMSDataHub

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/interface/ISMSDataHub.sol)

## Functions

### getAdmin

```solidity
function getAdmin() external view returns (address);
```

### getMinter

```solidity
function getMinter() external view returns (address);
```

### getSMS

```solidity
function getSMS() external view returns (address);
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

### setSMS

```solidity
function setSMS(address _sms) external;
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
