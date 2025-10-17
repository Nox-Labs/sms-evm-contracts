# Constants

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/lib/ObservationLib.sol)

### MAX_CARDINALITY

_Sets max ring buffer length in the Account.observations Observation list.
As users transfer/mint/burn tickets new Observation checkpoints are recorded.
The current `MAX_CARDINALITY` guarantees a one year minimum, of accurate historical lookups._

_The user Account.Account.cardinality parameter can NOT exceed the max cardinality variable.
Preventing "corrupted" ring buffer lookup pointers and new observation checkpoints._

```solidity
uint16 constant MAX_CARDINALITY = 17520;
```
