# PauseLevel

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/interface/ISMSDataHub.sol)

Each pause level is a subset of the previous one.

_None: Operations paused: `None`_

_Low: Operations paused: SMS.permit (excluding minter)_

_Medium: Operations paused: MMS.claim, MMS.stake, MMS.redeem_

_High: Operations paused: SMS.approve, SMS.transferFrom, Adapter.bridgePing_

_Critical: Operations paused: SMS.transfer, SMS.mint (Adapter.bridgePong), SMS.burn_

```solidity
enum PauseLevel {
    None,
    Low,
    Medium,
    High,
    Critical
}
```
