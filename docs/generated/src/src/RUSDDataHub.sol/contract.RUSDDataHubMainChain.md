# RUSDDataHubMainChain
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/RUSDDataHub.sol)

**Inherits:**
[IRUSDDataHubMainChain](/src/interface/IRUSDDataHub.sol/interface.IRUSDDataHubMainChain.md), [RUSDDataHub](/src/RUSDDataHub.sol/contract.RUSDDataHub.md)

The main chain implementation of the RUSDDataHub contract. Only one instance of this contract is deployed on the main chain.

*Inherits from RUSDDataHub.*

*Adding YUSD address.*


## Functions
### getYUSD

Returns the YUSD address.


```solidity
function getYUSD() public view returns (address);
```

### setYUSD

Sets the YUSD address.

Does not emit events because it's happened only once.

*Address can be set only once.*


```solidity
function setYUSD(address _yusd) public noZeroAddress(_yusd) onlyAdmin onlyUnset(yusd);
```

