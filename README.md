# OpenMark Cairo Smart Contracts

## Requirements

Before you begin, ensure you have the following tools installed:

- [Node (>= v18.17)](https://nodejs.org/en/download/)
- Yarn ([v1](https://classic.yarnpkg.com/en/docs/install/) or [v2+](https://yarnpkg.com/getting-started/install))
- [Git](https://git-scm.com/downloads)

### Scarb Version

To ensure the proper functioning of openmark contracts, your local `Scarb` version must be `2.5.4`. First, check your local Scarb version:

```sh
scarb --version
```

If your local Scarb version is not `2.5.4`, you need to install it.

1. Add the Scarb plugin:

    ```bash
    asdf plugin add scarb
    ```

2. Install the specific version (e.g., 2.5.4):

    ```bash
    asdf install scarb 2.5.4
    ```

3. Set the global version:

    ```bash
    asdf global scarb 2.5.4
    ```

Alternatively, you can install Scarb using the following command:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh -s -- -v 2.5.4
```

### Starknet Foundry Version

To ensure the proper functioning of the tests on openmark contracts, your Starknet Foundry version must be 0.25.0. First, check your Starknet Foundry version:

```sh
snforge --version
```

If your Starknet Foundry version is not `0.25.0`, you need to install it.

- [Starknet Foundry](https://foundry-rs.github.io/starknet-foundry/getting-started/installation.html)

## Compatible Versions

- Scarb - v2.5.4
- Snforge - v0.23
- Cairo - v2.5.4
- Rpc - v0.5.1

## Quickstart

1. Clone this repository and install dependencies:

    ```bash
    git clone https://github.com/grindytech/openmark-cairo-contract --recurse-submodules
    cd openmark-cairo-contract
    yarn install
    ```

2. Run a local network in the first terminal:

    **Note:** You can skip this step if you want to use Sepolia Testnet.

    ```bash
    yarn chain
    ```

    This command starts a local Starknet network using Devnet. The network runs on your local machine and can be used for testing and development. You can customize the network configuration in `scaffold.config.ts` for your Next.js app.

    **Note:** If you are on Sepolia or mainnet, for a better user experience on your app, you can get a dedicated RPC from [Infura dashboard](https://www.infura.io/). A default is provided [here](https://github.com/grindytech/openmark-cairo-contract/tree/main/packages/nextjs/.env.example). To use this, run:

    ```bash
    cp packages/nextjs/.env.example packages/nextjs/.env.local
    ```

3. On a second terminal, deploy the sample contract:

    ```bash
    yarn deploy --network {NETWORK_NAME} // when NETWORK_NAME is not specified, it defaults to "devnet"
    ```

    **Note:** To use Sepolia testnet, set `{NETWORK_NAME}` to `sepolia`.

    This command deploys a sample smart contract to the local network. The contract is located in `packages/snfoundry/contracts/src` and can be modified to suit your needs. The `yarn deploy` command uses the deploy script located in `packages/snfoundry/scripts-ts/deploy.ts` to deploy the contract to the network. You can also customize the deploy script.

4. On a third terminal, start your Next.js app:

    ```bash
    yarn start
    ```

    Visit your app at: `http://localhost:3000`. You can interact with your smart contract using the `Debug Contracts` page. You can tweak the app config in `packages/nextjs/scaffold.config.ts`.

## Acknowledgements
This project is forked from [Scaffold-Stark](https://scaffoldstark.com). We extend our gratitude to them for their excellent work and contributions to the community.

Visit [Scaffold Docs](https://www.docs.scaffoldstark.com/) to learn how to start building with Scaffold.