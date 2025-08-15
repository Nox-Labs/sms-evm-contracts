# Blacklistable
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/extensions/Blacklistable.sol)

**Inherits:**
Initializable


## State Variables
### BlacklistableStorageLocation

```solidity
bytes32 private constant BlacklistableStorageLocation =
    0x8a2131119662f7e94b7ab89e3d23f8f5cb94fee44e6233ad76f409857f71e400;
```


## Functions
### _getBlacklistableStorage


```solidity
function _getBlacklistableStorage() private pure returns (BlacklistableStorage storage $);
```

### __Blacklistable_init


```solidity
function __Blacklistable_init() internal onlyInitializing;
```

### isBlacklisted


```solidity
function isBlacklisted(address account) external view returns (bool);
```

### blacklist


```solidity
function blacklist(address account) external onlyBlacklister;
```

### unBlacklist


```solidity
function unBlacklist(address account) external onlyBlacklister;
```

### _isBlacklisted


```solidity
function _isBlacklisted(address account) internal view virtual returns (bool);
```

### _blacklist


```solidity
function _blacklist(address account) internal virtual;
```

### _unBlacklist


```solidity
function _unBlacklist(address account) internal virtual;
```

### _authorizeBlacklist


```solidity
function _authorizeBlacklist() internal view virtual;
```

### onlyBlacklister


```solidity
modifier onlyBlacklister();
```

### notBlacklisted


```solidity
modifier notBlacklisted(address account);
```

## Events
### Blacklisted

```solidity
event Blacklisted(address indexed account);
```

### UnBlacklisted

```solidity
event UnBlacklisted(address indexed account);
```

## Errors
### Blacklist

```solidity
error Blacklist(address account);
```

## Structs
### BlacklistableStorage
**Note:**
storage-location: erc7201:rusd.storage.blacklistable


```solidity
struct BlacklistableStorage {
    mapping(address => bool) list;
}
```

