# SMS EVM Contracts

## Overview

This repository contains the Solidity smart contracts for the SMS ecosystem. The core of the system revolves around two primary tokens:

- **SMS**: A omnichain stablecoin designed for consistent value.
- **MMS**: A yield-bearing token that allows holders to earn rewards.

The system is built with omnichain capabilities using the LayerZero protocol, enabling seamless transfer of SMS tokens across various blockchain networks. All core contracts are implemented using an upgradeable proxy pattern (UUPS) to allow for future improvements.

## Core Components

- `SMS.sol`: The implementation of the SMS stablecoin, an ERC20 token with 6 decimals. Its supply is managed through restricted minting and burning operations. The contract also includes features for security and convenience, such as address blacklisting and EIP-2612 permit functionality.

- `MMS.sol`: The implementation of the MMS yield-bearing token. Holders earn rewards in SMS based on their Time-Weighted Average Balance (TWAB). The reward system is structured into "rounds" with configurable APR and duration.

- `SMSDataHub.sol`: A central registry and access control contract. It stores and manages the addresses of all critical system components, including the `SMS` and `MMS` contracts, the omnichain adapter, the administrator, and the minter. This simplifies contract interactions and centralizes configuration.

- `SMSOmnichainAdapter.sol`: A LayerZero OApp (Omnichain Application) that facilitates the cross-chain transfer of SMS tokens. It handles the burning of tokens on a source chain and coordinates the minting of an equivalent amount on the destination chain.

## Documentation

For a more in-depth understanding of the architecture, data flows, and core concepts, please refer to the detailed documentation and diagrams located in the [docs](./docs/) directory.

## Getting Started

### Prerequisites

- [Foundry](https://getfoundry.sh/)
- [Node.js](https://nodejs.org/en/) and [npm](https://www.npmjs.com/)

### Installation

1.  Clone the repository:

    ```bash
    git clone <repository-url>
    cd sms-evm-contracts
    ```

2.  Install the dependencies:
    ```bash
    npm install
    ```

## Development Workflow

### Testing

To run the full test suite:

```bash
npm run test
```

To generate a test coverage report:

```bash
npm run coverage
```

### Linting and Static Analysis

To check the code for style violations and best practices using Solhint:

```bash
npm run lint
```

To run the Slither static analyzer for vulnerability detection:

```bash
npm run slither
```

_Note: This command executes the `slither.sh` script._

## Deployment

The contracts are deployed using Foundry scripts. The process is divided into several steps:

#### 1. Deploy Contracts

Deploy the main contracts (SMS, MMS, etc.) to the desired network. Scripts are pre-configured for the following networks:

- **Sepolia (Testnet)**
  ```bash
  npm run deploy:sepolia
  ```
- **Arbitrum**
  ```bash
  npm run deploy:arbitrum
  ```
- **BNB Smart Chain**
  ```bash
  npm run deploy:bsc
  ```

#### 2. Configure Omnichain Communication

After deploying the contracts to multiple chains, you must "wire" them to enable cross-chain functionality. This process sets the trusted peer addresses for the `SMSOmnichainAdapter` on each chain.

- **Wire EVM Chains**

  ```bash
  npm run wire-oapps
  ```

  _This script configures communication between the specified EVM-based chains._

- **Wire with Solana**
  ```bash
  npm run wire-solana
  ```
  _This script connects the EVM deployment with a corresponding deployment on the Solana network._
