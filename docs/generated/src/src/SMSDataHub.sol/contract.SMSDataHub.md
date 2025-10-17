# SMSDataHub

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/SMSDataHub.sol)

**Inherits:**
[ISMSDataHub](/src/interface/ISMSDataHub.sol/interface.ISMSDataHub.md), UUPSUpgradeable, [Base](/src/extensions/Base.sol/abstract.Base.md)

The central registry and access control contract for the SMS ecosystem.
This contract stores and manages the addresses of all critical system components, including the SMS, MMS, omnichain adapter, administrator, and minter.
It simplifies contract interactions and centralizes configuration. It also provides a central point for pausing and unpausing the system.
All contracts communicate with this contract through the `SMSDataHubKeeper` extension.
Admin of this contracts its also the admin of all other contracts.

## State Variables

### omnichainAdapter

```solidity
address private omnichainAdapter;
```

### admin

```solidity
address private admin;
```

### minter

```solidity
address private minter;
```

### sms

```solidity
address private sms;
```

### mms

```solidity
address internal mms;
```

### pauseLevel

```solidity
PauseLevel private pauseLevel;
```

## Functions

### initialize

Initializes the contract.

```solidity
function initialize(address _admin, address _minter)
    external
    initializer
    noZeroAddress(_admin)
    noZeroAddress(_minter);
```

**Parameters**

| Name      | Type      | Description         |
| --------- | --------- | ------------------- |
| `_admin`  | `address` | The admin address.  |
| `_minter` | `address` | The minter address. |

### getAdmin

Returns the admin address.

```solidity
function getAdmin() public view returns (address);
```

### getMinter

Returns the minter address.

```solidity
function getMinter() public view returns (address);
```

### getSMS

Returns the SMS address.

```solidity
function getSMS() public view returns (address);
```

### getOmnichainAdapter

Returns the omnichain adapter address.

```solidity
function getOmnichainAdapter() public view returns (address);
```

### getPauseLevel

Returns the pause level.

```solidity
function getPauseLevel() public view returns (PauseLevel);
```

### setSMS

Sets the SMS address.

Does not emit events because it's happened only once.

_Address can be set only once._

```solidity
function setSMS(address _sms) public noZeroAddress(_sms) onlyAdmin onlyUnset(sms);
```

### setOmnichainAdapter

Sets the omnichain adapter address.

Does not emit events because it's happened only once.

_Address can be set only once._

```solidity
function setOmnichainAdapter(address _omnichainAdapter)
    public
    noZeroAddress(_omnichainAdapter)
    onlyAdmin
    onlyUnset(omnichainAdapter);
```

### setAdmin

Sets the admin address.

Emits AdminChanged event.

_Address can be changed._

```solidity
function setAdmin(address _admin) public onlyAdmin;
```

### setMinter

Sets the minter address.

Emits MinterChanged event.

_Address can be changed._

```solidity
function setMinter(address _minter) public onlyAdmin;
```

### setPauseLevel

Sets the pause level.

Emits PauseLevelChanged event.

_Pause level can be changed._

```solidity
function setPauseLevel(PauseLevel _pauseLevel) public onlyAdmin;
```

### \_authorizeUpgrade

Authorizes the upgrade of the contract.

_Inherits from UUPSUpgradeable._

_Only the admin can authorize the upgrade._

```solidity
function _authorizeUpgrade(address) internal override onlyAdmin;
```

### onlyAdmin

```solidity
modifier onlyAdmin();
```

### onlyUnset

```solidity
modifier onlyUnset(address _address);
```
