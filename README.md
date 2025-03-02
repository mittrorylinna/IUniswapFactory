## Overview
APOLLUMIA is an ERC-20 token implemented on the Ethereum blockchain. It incorporates transaction tax mechanisms, anti-bot protections, and integrates with Uniswap for decentralized trading. 

## Features
- **ERC-20 Standard Compliance**: Implements standard token functions such as `transfer`, `approve`, and `transferFrom`.
- **Tax Mechanism**: Initial and final buy/sell tax rates apply to transactions, adjusting dynamically over time.
- **Ownership & Access Control**: The contract includes an `Ownable` module, allowing only the owner to perform administrative actions.
- **Liquidity Integration**: Supports Uniswap V2 for token swapping and liquidity provisioning.
- **Anti-Bot Measures**: Implements a transfer delay mechanism to mitigate front-running and bot activities.

## Contract Details
- **Token Name**: APOLLUMIA
- **Symbol**: APOLLUMIA
- **Decimals**: 9
- **Total Supply**: 100,000,000 APOLLUMIA
- **Max Transaction Amount**: 20,000,000 APOLLUMIA
- **Max Wallet Size**: 20,000,000 APOLLUMIA

## Tax System
| Stage          | Buy Tax (%) | Sell Tax (%) |
|---------------|------------|-------------|
| Initial       | 20%        | 24%         |
| Final        | 0%         | 0%          |
| Reduction Points | 22 buys   | 25 buys    |

## Uniswap Integration
- **Liquidity Management**: The contract allows adding liquidity through Uniswap V2.
- **Swapping Mechanism**: Uses Uniswap's `swapExactTokensForETHSupportingFeeOnTransferTokens` for token swaps.

## Deployment & Configuration
1. **Contract Deployment**: Deploy on Ethereum mainnet.
2. **Trading Activation**: The owner must call `openTrading()` to enable trading.
3. **Remove Limits**: The owner can remove transaction limits using `removeLimits()`.

## Security Considerations
- **SafeMath Library**: Ensures secure arithmetic operations, preventing overflows and underflows.
- **Transfer Delay**: Prevents bots from executing multiple transactions within the same block.
- **Fee Collection**: The collected tax is swapped for ETH and sent to the designated tax wallet.

## License
This project is released under the MIT License.

