# SMSDataHubMainChain

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/SMSDataHub.sol)

**Inherits:**
[ISMSDataHubMainChain](/src/interface/ISMSDataHub.sol/interface.ISMSDataHubMainChain.md), [SMSDataHub](/src/SMSDataHub.sol/contract.SMSDataHub.md)

The main chain implementation of the SMSDataHub contract. Only one instance of this contract is deployed on the main chain.

_Inherits from SMSDataHub._

_Adding MMS address._

## Functions

### getMMS

Returns the MMS address.

```solidity
function getMMS() public view returns (address);
```

### setMMS

Sets the MMS address.

Does not emit events because it's happened only once.

_Address can be set only once._

```solidity
function setMMS(address _mms) public noZeroAddress(_mms) onlyAdmin onlyUnset(mms);
```
