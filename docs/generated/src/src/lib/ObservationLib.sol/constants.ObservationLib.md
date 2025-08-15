# Constants
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/lib/ObservationLib.sol)

### MAX_CARDINALITY
*Sets max ring buffer length in the Account.observations Observation list.
As users transfer/mint/burn tickets new Observation checkpoints are recorded.
The current `MAX_CARDINALITY` guarantees a one year minimum, of accurate historical lookups.*

*The user Account.Account.cardinality parameter can NOT exceed the max cardinality variable.
Preventing "corrupted" ring buffer lookup pointers and new observation checkpoints.*


```solidity
uint16 constant MAX_CARDINALITY = 17520;
```

