# SMSDataHubKeeper

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/extensions/SMSDataHubKeeper.sol)

**Inherits:**
Initializable, [Base](/src/extensions/Base.sol/abstract.Base.md)

## State Variables

### SMSDataHubKeeperStorageLocation

```solidity
bytes32 private constant SMSDataHubKeeperStorageLocation =
    0xf6c75126fb149fdabc8197aad315689d01deaa3ab6f9a0ac6e9d265d1ad6fe00;
```

## Functions

### \_\_SMSDataHubKeeper_init

```solidity
function __SMSDataHubKeeper_init(address _smsDataHub)
    internal
    noZeroAddress(_smsDataHub)
    onlyInitializing;
```

### \_getSMSDataHubKeeperStorage

```solidity
function _getSMSDataHubKeeperStorage() private pure returns (SMSDataHubKeeperStorage storage $);
```

### getSMSDataHub

```solidity
function getSMSDataHub() public view returns (ISMSDataHub);
```

### \_getSMS

```solidity
function _getSMS() internal view returns (ISMS sms);
```

### onlyMinter

```solidity
modifier onlyMinter();
```

### onlyAdmin

```solidity
modifier onlyAdmin();
```

### onlyAdapter

```solidity
modifier onlyAdapter();
```

### noPauseLevel

```solidity
modifier noPauseLevel(PauseLevel _pauseLevel);
```

## Structs

### SMSDataHubKeeperStorage

**Note:**
storage-location: erc7201:sms.storage.SMSDataHubKeeper

```solidity
struct SMSDataHubKeeperStorage {
    ISMSDataHub smsDataHub;
}
```
