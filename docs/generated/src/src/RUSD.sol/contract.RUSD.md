# RUSD
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/RUSD.sol)

**Inherits:**
[IRUSD](/src/interface/IRUSD.sol/interface.IRUSD.md), [Blacklistable](/src/extensions/Blacklistable.sol/abstract.Blacklistable.md), [RUSDDataHubKeeper](/src/extensions/RUSDDataHubKeeper.sol/abstract.RUSDDataHubKeeper.md), UUPSUpgradeable, ERC20PermitUpgradeable

Has 6 decimals.


## State Variables
### CROSS_CHAIN
The constant to identify the cross-chain mint/burn.


```solidity
bytes32 public constant CROSS_CHAIN = keccak256("CROSS_CHAIN");
```


## Functions
### initialize

Initializes the contract.


```solidity
function initialize(address _rusdDataHub) public initializer;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_rusdDataHub`|`address`|The address of the RUSDDataHub contract.|


### mint

Mints RUSD to the specified address.

Emits Mint event.


```solidity
function mint(address to, uint256 amount, bytes calldata data)
    public
    onlyMinter
    noZeroAmount(amount)
    noZeroBytes(data)
    noCrossChain(data)
    noPauseLevel(PauseLevel.High);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`to`|`address`|The address to mint RUSD to.|
|`amount`|`uint256`|The amount of RUSD to mint.|
|`data`|`bytes`|The data to be passed to the event. Only for off-chain use.|


### burn

Burns RUSD from the caller.

Emits Burn event.


```solidity
function burn(uint256 amount, bytes calldata data)
    public
    onlyMinter
    noZeroAmount(amount)
    noZeroBytes(data)
    noPauseLevel(PauseLevel.High)
    noCrossChain(data);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`amount`|`uint256`|The amount of RUSD to burn.|
|`data`|`bytes`|The data to be passed to the event. Only for off-chain use.|


### mint

Mints RUSD to the specified address.

Emits Mint event.


```solidity
function mint(address to, uint256 amount)
    public
    onlyAdapter
    noZeroAmount(amount)
    noPauseLevel(PauseLevel.High);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`to`|`address`|The address to mint RUSD to.|
|`amount`|`uint256`|The amount of RUSD to mint.|


### burn

Burns RUSD from the caller.

Emits Burn event.


```solidity
function burn(uint256 amount)
    public
    onlyAdapter
    noZeroAmount(amount)
    noPauseLevel(PauseLevel.High);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`amount`|`uint256`|The amount of RUSD to burn.|


### approve


```solidity
function approve(address spender, uint256 amount)
    public
    override(ERC20Upgradeable, IERC20)
    noPauseLevel(PauseLevel.High)
    returns (bool);
```

### transferFrom


```solidity
function transferFrom(address from, address to, uint256 amount)
    public
    override(ERC20Upgradeable, IERC20)
    noPauseLevel(PauseLevel.High)
    returns (bool);
```

### transfer


```solidity
function transfer(address to, uint256 amount)
    public
    override(ERC20Upgradeable, IERC20)
    noPauseLevel(PauseLevel.Critical)
    returns (bool);
```

### decimals

Returns the number of decimals used to get its user representation.

*Inherited from ERC20Upgradeable.*


```solidity
function decimals() public pure override(ERC20Upgradeable, IERC20Metadata) returns (uint8);
```

### permit


```solidity
function permit(
    address owner,
    address spender,
    uint256 value,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
) public override;
```

### _update

Updates the balance of the specified address.

*Inherited from Blacklistable.*


```solidity
function _update(address from, address to, uint256 amount)
    internal
    override
    notBlacklisted(from)
    notBlacklisted(to);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`from`|`address`|The address to update the balance from.|
|`to`|`address`|The address to update the balance to.|
|`amount`|`uint256`|The amount of RUSD to update.|


### _authorizeUpgrade

Authorizes the upgrade of the contract.

*Inherited from UUPSUpgradeable.*


```solidity
function _authorizeUpgrade(address) internal view override onlyAdmin;
```

### _authorizeBlacklist

Authorizes the blacklist of the contract.

*Inherited from Blacklistable.*


```solidity
function _authorizeBlacklist() internal view override onlyAdmin;
```

### noCrossChain

Validates the data.

Revert if data is empty or contains the CROSS_CHAIN constant.


```solidity
modifier noCrossChain(bytes calldata data);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`data`|`bytes`|The data to validate.|


