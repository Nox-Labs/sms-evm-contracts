# PauseLevel
[Git Source](https://dapp-devs.com/ssh://git@git.2222/lumos-labs/rusd/rusd-contracts/rusd-evm-contracts/blob/c89eeb1e740ab933cc296c4ed9d03110b942680f/src/interface/IRUSDDataHub.sol)

Each pause level is a subset of the previous one.

*None: Operations paused: `None`*

*Low: Operations paused: RUSD.permit (excluding minter)*

*Medium: Operations paused: YUSD.claim, YUSD.stake, YUSD.redeem*

*High: Operations paused: RUSD.approve, RUSD.transferFrom, Adapter.bridgePing*

*Critical: Operations paused: RUSD.transfer, RUSD.mint (Adapter.bridgePong), RUSD.burn*


```solidity
enum PauseLevel {
    None,
    Low,
    Medium,
    High,
    Critical
}
```

