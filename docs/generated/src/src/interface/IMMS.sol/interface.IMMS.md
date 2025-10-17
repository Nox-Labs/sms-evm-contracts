# IMMS

[Git Source](https://github.com/Nox-Labs/sms-evm-contracts/blob/15a987dcda55f8dfabcf220505750bc01f9d6f51/src/interface/IMMS.sol)

**Inherits:**
IERC20Metadata

## Functions

### stake

```solidity
function stake(address user, uint96 amount, bytes calldata data) external;
```

### redeem

```solidity
function redeem(address user, uint96 amount, bytes calldata data) external;
```

### claimRewards

```solidity
function claimRewards(uint32 roundId, address user, address to, uint256 amount) external;
```

### claimRewards

```solidity
function claimRewards(uint32 roundId, address user, address to) external returns (uint256 amount);
```

### compoundRewards

```solidity
function compoundRewards(uint32 roundId, address user) external;
```

### finalizeRound

```solidity
function finalizeRound(uint32 roundId) external;
```

### changeNextRoundDuration

```solidity
function changeNextRoundDuration(uint32 duration) external;
```

### changeNextRoundBp

```solidity
function changeNextRoundBp(uint32 bp) external;
```

### getCurrentRoundId

```solidity
function getCurrentRoundId() external view returns (uint32);
```

### getRoundPeriod

```solidity
function getRoundPeriod(uint32 roundId) external view returns (uint32 start, uint32 end);
```

### calculateRewardsRound

```solidity
function calculateRewardsRound(uint32 roundId, address user) external view returns (uint256);
```

### calculateTotalRewardsRound

```solidity
function calculateTotalRewardsRound(uint32 roundId) external view returns (uint256);
```

### calculateClaimableRewards

```solidity
function calculateClaimableRewards(uint32 roundId, address user) external view returns (uint256);
```

## Events

### NewRound

```solidity
event NewRound(uint32 roundId, uint32 start, uint32 end);
```

### RewardsClaimed

```solidity
event RewardsClaimed(uint32 roundId, address user, address to, uint256 amount);
```

### RewardsCompounded

```solidity
event RewardsCompounded(uint32 roundId, address user, uint256 amount);
```

### RoundFinalized

```solidity
event RoundFinalized(uint32 roundId, uint256 amount);
```

### RoundDurationChanged

```solidity
event RoundDurationChanged(uint32 roundId, uint32 duration);
```

### RoundBpChanged

```solidity
event RoundBpChanged(uint32 roundId, uint32 bp);
```

### Stake

```solidity
event Stake(address indexed user, uint256 amount, bytes data);
```

### Redeem

```solidity
event Redeem(address indexed user, uint256 amount, bytes data);
```

## Errors

### RoundIdUnavailable

```solidity
error RoundIdUnavailable();
```

### RoundNotEnded

```solidity
error RoundNotEnded();
```

### RoundAlreadyFinalized

```solidity
error RoundAlreadyFinalized();
```

### InsufficientRewards

```solidity
error InsufficientRewards(uint256 amount, uint256 claimableRewards);
```

### InvalidBp

```solidity
error InvalidBp();
```

### TwabNotFinalized

```solidity
error TwabNotFinalized();
```
