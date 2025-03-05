// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "../contracts/AdvancedTrade.sol";

/**
 * @title ExampleTrade
 * @dev This contract demonstrates how to interact with the AdvancedTrade contract.
 *      It allows users to execute trades and allows the contract owner to withdraw
 *      the accumulated fees from the AdvancedTrade contract.
 */
contract ExampleTrade {
    // Instance of the AdvancedTrade contract
    AdvancedTrade public tradeContract;

    /**
     * @dev Event emitted when a trade is executed using this contract.
     * @param trader The address that initiated the trade.
     * @param amount The amount of tokens traded.
     * @param fee The transaction fee deducted.
     */
    event ExampleTradeExecuted(address indexed trader, uint256 amount, uint256 fee);

    /**
     * @dev Event emitted when fees are withdrawn from the AdvancedTrade contract.
     * @param receiver The address receiving the withdrawn fees.
     * @param amount The amount of fees withdrawn.
     */
    event ExampleFeeWithdrawn(address indexed receiver, uint256 amount);

    /**
     * @dev Constructor to initialize the ExampleTrade contract.
     * @param _tradeContract Address of the deployed AdvancedTrade contract.
     */
    constructor(address _tradeContract) {
        require(_tradeContract != address(0), "Invalid trade contract address");
        tradeContract = AdvancedTrade(_tradeContract);
    }

    /**
     * @dev Executes a trade using the AdvancedTrade contract.
     * @param amount The amount of tokens the user wants to trade.
     */
    function executeTrade(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        // Call the executeTrade function of the AdvancedTrade contract
        tradeContract.executeTrade(amount);

        // Calculate the transaction fee based on the current tax rate
        uint256 fee = (amount * tradeContract.taxRate()) / 100;
        uint256 netAmount = amount - fee;

        // Emit event to track the trade execution
        emit ExampleTradeExecuted(msg.sender, netAmount, fee);
    }

    /**
     * @dev Withdraws accumulated fees from the AdvancedTrade contract.
     * @param to The address to receive the withdrawn fees.
     * @param amount The amount of fees to withdraw.
     * @notice Only the owner of this contract can call this function.
     */
    function withdrawFees(address to, uint256 amount) external {
        require(to != address(0), "Invalid recipient address");
        require(amount > 0, "Amount must be greater than zero");

        // Call the withdrawFees function of the AdvancedTrade contract
        tradeContract.withdrawFees(to, amount);

        // Emit event to track the fee withdrawal
        emit ExampleFeeWithdrawn(to, amount);
    }
}
