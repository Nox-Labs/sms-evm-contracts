# RUSDDataHubKeeper
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/extensions/RUSDDataHubKeeper.sol)

**Inherits:**
Initializable, [Base](/src/extensions/Base.sol/abstract.Base.md)


## State Variables
### RUSDDataHubKeeperStorageLocation

```solidity
bytes32 private constant RUSDDataHubKeeperStorageLocation =
    0xf6c75126fb149fdabc8197aad315689d01deaa3ab6f9a0ac6e9d265d1ad6fe00;
```


## Functions
### __RUSDDataHubKeeper_init


```solidity
function __RUSDDataHubKeeper_init(address _rusdDataHub)
    internal
    noZeroAddress(_rusdDataHub)
    onlyInitializing;
```

### _getRUSDDataHubKeeperStorage


```solidity
function _getRUSDDataHubKeeperStorage() private pure returns (RUSDDataHubKeeperStorage storage $);
```

### getRUSDDataHub


```solidity
function getRUSDDataHub() public view returns (IRUSDDataHub);
```

### _getRusd


```solidity
function _getRusd() internal view returns (IRUSD rusd);
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
### RUSDDataHubKeeperStorage
**Note:**
storage-location: erc7201:rusd.storage.RUSDDataHubKeeper


```solidity
struct RUSDDataHubKeeperStorage {
    IRUSDDataHub rusdDataHub;
}
```

