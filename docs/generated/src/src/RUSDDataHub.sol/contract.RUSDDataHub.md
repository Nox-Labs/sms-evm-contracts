# RUSDDataHub
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/RUSDDataHub.sol)

**Inherits:**
[IRUSDDataHub](/src/interface/IRUSDDataHub.sol/interface.IRUSDDataHub.md), UUPSUpgradeable, [Base](/src/extensions/Base.sol/abstract.Base.md)

The central registry and access control contract for the RUSD ecosystem.
This contract stores and manages the addresses of all critical system components, including the RUSD, YUSD, omnichain adapter, administrator, and minter.
It simplifies contract interactions and centralizes configuration. It also provides a central point for pausing and unpausing the system.
All contracts communicate with this contract through the `RUSDDataHubKeeper` extension.
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


### rusd

```solidity
address private rusd;
```


### yusd

```solidity
address internal yusd;
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

|Name|Type|Description|
|----|----|-----------|
|`_admin`|`address`|The admin address.|
|`_minter`|`address`|The minter address.|


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

### getRUSD

Returns the RUSD address.


```solidity
function getRUSD() public view returns (address);
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

### setRUSD

Sets the RUSD address.

Does not emit events because it's happened only once.

*Address can be set only once.*


```solidity
function setRUSD(address _rusd) public noZeroAddress(_rusd) onlyAdmin onlyUnset(rusd);
```

### setOmnichainAdapter

Sets the omnichain adapter address.

Does not emit events because it's happened only once.

*Address can be set only once.*


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

*Address can be changed.*


```solidity
function setAdmin(address _admin) public onlyAdmin;
```

### setMinter

Sets the minter address.

Emits MinterChanged event.

*Address can be changed.*


```solidity
function setMinter(address _minter) public onlyAdmin;
```

### setPauseLevel

Sets the pause level.

Emits PauseLevelChanged event.

*Pause level can be changed.*


```solidity
function setPauseLevel(PauseLevel _pauseLevel) public onlyAdmin;
```

### _authorizeUpgrade

Authorizes the upgrade of the contract.

*Inherits from UUPSUpgradeable.*

*Only the admin can authorize the upgrade.*


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

