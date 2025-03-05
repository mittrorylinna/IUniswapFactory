# Overview

APOLLUMIA is an ERC-20 token implemented on the Ethereum blockchain. It incorporates transaction tax mechanisms, anti-bot protections, and integrates with Uniswap for decentralized trading. The staking contract enhances the utility of APOLLUMIA, encouraging long-term holding and engagement. 🚀

## Features

- **ERC-20 Standard Compliance**: Implements standard token functions such as `transfer`, `approve`, and `transferFrom`.
- **Tax Mechanism**: Initial and final buy/sell tax rates apply to transactions, adjusting dynamically over time.
- **Ownership & Access Control**: The contract includes an `Ownable` module, allowing only the owner to perform administrative actions.
- **Liquidity Integration**: Supports Uniswap V2 for token swapping and liquidity provisioning.
- **Anti-Bot Measures**: Implements a transfer delay mechanism to mitigate front-running and bot activities.
- **Airdrop System**: Allows the owner to distribute tokens to multiple addresses efficiently.

## Contract Details

- **Token Name**: APOLLUMIA  
- **Symbol**: APOLLUMIA  
- **Decimals**: 9  
- **Total Supply**: 100,000,000 APOLLUMIA  
- **Max Transaction Amount**: 20,000,000 APOLLUMIA  
- **Max Wallet Size**: 20,000,000 APOLLUMIA  

## Tax System

| Stage   | Buy Tax (%) | Sell Tax (%) |
|---------|------------|-------------|
| Initial | 20%        | 24%         |
| Final   | 0%         | 0%          |

- **Reduction Points**: Buy tax reduces after 22 buys, and sell tax reduces after 25 buys.

## Uniswap Integration

- **Liquidity Management**: The contract allows adding liquidity through Uniswap V2.
- **Swapping Mechanism**: Uses Uniswap's `swapExactTokensForETHSupportingFeeOnTransferTokens` for token swaps.

## Airdrop System

- **Batch Distribution**: The owner can distribute tokens to multiple addresses at once.
- **Security Measures**: Ensures recipients' addresses are valid before transferring tokens.
- **Token Recovery**: The owner can recover unused airdrop tokens if needed.

## Deployment & Configuration

- **Contract Deployment**: Deploy on Ethereum mainnet.
- **Trading Activation**: The owner must call `openTrading()` to enable trading.
- **Remove Limits**: The owner can remove transaction limits using `removeLimits()`.
- **Airdrop Execution**: The owner can call `distributeAirdrop()` to distribute tokens.

## Security Considerations

- **SafeMath Library**: Ensures secure arithmetic operations, preventing overflows and underflows.
- **Transfer Delay**: Prevents bots from executing multiple transactions within the same block.
- **Fee Collection**: The collected tax is swapped for ETH and sent to the designated tax wallet.
- **Airdrop Safety**: Only the owner can execute the airdrop, ensuring controlled distribution.

## Additional Improvements

- **Dynamic Tax Adjustment**: The buy and sell tax rates automatically decrease after a specific number of transactions.
- **Max Transaction and Wallet Size Limits**: Limits prevent excessive token concentration and promote fair trading.
- **Exemption System**: Certain addresses (e.g., the owner and contract) are exempt from tax and trading restrictions.
- **Trading Safety**: Trading can only begin once the owner explicitly enables it, ensuring security before deployment is finalized.
