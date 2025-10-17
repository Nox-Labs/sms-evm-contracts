# SMS

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/SMS.sol)

**Inherits:**
[ISMS](/src/interface/ISMS.sol/interface.ISMS.md), [Blacklistable](/src/extensions/Blacklistable.sol/abstract.Blacklistable.md), [SMSDataHubKeeper](/src/extensions/SMSDataHubKeeper.sol/abstract.SMSDataHubKeeper.md), UUPSUpgradeable, ERC20PermitUpgradeable

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
function initialize(address _smsDataHub) public initializer;
```

**Parameters**

| Name          | Type      | Description                             |
| ------------- | --------- | --------------------------------------- |
| `_smsDataHub` | `address` | The address of the SMSDataHub contract. |

### mint

Mints SMS to the specified address.

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

| Name     | Type      | Description                                                 |
| -------- | --------- | ----------------------------------------------------------- |
| `to`     | `address` | The address to mint SMS to.                                 |
| `amount` | `uint256` | The amount of SMS to mint.                                  |
| `data`   | `bytes`   | The data to be passed to the event. Only for off-chain use. |

### burn

Burns SMS from the caller.

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

| Name     | Type      | Description                                                 |
| -------- | --------- | ----------------------------------------------------------- |
| `amount` | `uint256` | The amount of SMS to burn.                                  |
| `data`   | `bytes`   | The data to be passed to the event. Only for off-chain use. |

### mint

Mints SMS to the specified address.

Emits Mint event.

```solidity
function mint(address to, uint256 amount)
    public
    onlyAdapter
    noZeroAmount(amount)
    noPauseLevel(PauseLevel.High);
```

**Parameters**

| Name     | Type      | Description                 |
| -------- | --------- | --------------------------- |
| `to`     | `address` | The address to mint SMS to. |
| `amount` | `uint256` | The amount of SMS to mint.  |

### burn

Burns SMS from the caller.

Emits Burn event.

```solidity
function burn(uint256 amount)
    public
    onlyAdapter
    noZeroAmount(amount)
    noPauseLevel(PauseLevel.High);
```

**Parameters**

| Name     | Type      | Description                |
| -------- | --------- | -------------------------- |
| `amount` | `uint256` | The amount of SMS to burn. |

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

_Inherited from ERC20Upgradeable._

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

### \_update

Updates the balance of the specified address.

_Inherited from Blacklistable._

```solidity
function _update(address from, address to, uint256 amount)
    internal
    override
    notBlacklisted(from)
    notBlacklisted(to);
```

**Parameters**

| Name     | Type      | Description                             |
| -------- | --------- | --------------------------------------- |
| `from`   | `address` | The address to update the balance from. |
| `to`     | `address` | The address to update the balance to.   |
| `amount` | `uint256` | The amount of SMS to update.            |

### \_authorizeUpgrade

Authorizes the upgrade of the contract.

_Inherited from UUPSUpgradeable._

```solidity
function _authorizeUpgrade(address) internal view override onlyAdmin;
```

### \_authorizeBlacklist

Authorizes the blacklist of the contract.

_Inherited from Blacklistable._

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

| Name   | Type    | Description           |
| ------ | ------- | --------------------- |
| `data` | `bytes` | The data to validate. |
