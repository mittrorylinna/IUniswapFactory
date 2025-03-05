// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "../contracts/IUniswapFactory.sol";

/**
 * @title ExampleUniswapFactory
 * @dev This contract demonstrates interactions with the APOLLUMIA token and Uniswap.
 *      Users can retrieve token details, check allowances, and perform token swaps.
 */
contract ExampleUniswapFactory {
    using SafeMath for uint256;

    // Instance of the APOLLUMIA token contract
    APOLLUMIA public apollumiaToken;
    
    // Instance of the Uniswap V2 Router
    IUniswapV2Router02 public uniswapRouter;

    /**
     * @dev Event emitted when a token swap is executed.
     * @param user The address of the user performing the swap.
     * @param tokenAmount The amount of APOLLUMIA tokens swapped.
     * @param ethReceived The amount of ETH received.
     */
    event SwapExecuted(address indexed user, uint256 tokenAmount, uint256 ethReceived);

    /**
     * @dev Constructor to initialize the ExampleUniswapFactory contract.
     * @param _token Address of the deployed APOLLUMIA token contract.
     * @param _uniswapRouter Address of the Uniswap V2 Router contract.
     */
    constructor(address _token, address _uniswapRouter) {
        require(_token != address(0), "Invalid token address");
        require(_uniswapRouter != address(0), "Invalid router address");

        apollumiaToken = APOLLUMIA(_token);
        uniswapRouter = IUniswapV2Router02(_uniswapRouter);
    }

    /**
     * @dev Retrieves the total supply of APOLLUMIA tokens.
     * @return The total supply of the token.
     */
    function getTotalSupply() external view returns (uint256) {
        return apollumiaToken.totalSupply();
    }

    /**
     * @dev Retrieves the balance of APOLLUMIA tokens for a specific address.
     * @param account The address to check the balance for.
     * @return The token balance of the specified address.
     */
    function getBalance(address account) external view returns (uint256) {
        return apollumiaToken.balanceOf(account);
    }

    /**
     * @dev Retrieves the allowance set by an owner for a spender.
     * @param owner The address that granted the allowance.
     * @param spender The address allowed to spend tokens.
     * @return The remaining allowance.
     */
    function getAllowance(address owner, address spender) external view returns (uint256) {
        return apollumiaToken.allowance(owner, spender);
    }

    /**
     * @dev Approves the Uniswap router to spend APOLLUMIA tokens on behalf of the user.
     * @param amount The amount of tokens to approve.
     */
    function approveUniswap(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        apollumiaToken.approve(address(uniswapRouter), amount);
    }

    /**
     * @dev Swaps APOLLUMIA tokens for ETH using Uniswap.
     * @param tokenAmount The amount of tokens to swap.
     * @notice The contract must be approved to spend the tokens before calling this function.
     */
    function swapTokensForETH(uint256 tokenAmount) external {
        require(tokenAmount > 0, "Token amount must be greater than zero");
        require(apollumiaToken.balanceOf(msg.sender) >= tokenAmount, "Insufficient token balance");

        // Transfer tokens from the user to this contract
        require(apollumiaToken.transferFrom(msg.sender, address(this), tokenAmount), "Token transfer failed");

        // Approve the Uniswap router to spend the tokens
        apollumiaToken.approve(address(uniswapRouter), tokenAmount);

        // Define the token swap path (APOLLUMIA -> WETH)
        address;
        path[0] = address(apollumiaToken);
        path[1] = uniswapRouter.WETH();

        // Execute the swap
        uint256 initialETHBalance = address(this).balance;
        uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // Accept any amount of ETH
            path,
            msg.sender, // Send ETH directly to the user
            block.timestamp
        );

        // Calculate the amount of ETH received
        uint256 ethReceived = address(this).balance.sub(initialETHBalance);

        // Emit event to track the swap
        emit SwapExecuted(msg.sender, tokenAmount, ethReceived);
    }

    /**
     * @dev Fallback function to receive ETH from Uniswap swaps.
     */
    receive() external payable {}
}
