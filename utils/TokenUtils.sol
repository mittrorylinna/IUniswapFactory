// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TokenUtils
 * @dev A utility contract providing helper functions for ERC-20 token interactions.
 */
library TokenUtils {
    /**
     * @dev Safely transfers ERC-20 tokens from the caller to a specified recipient.
     * @param token The address of the ERC-20 token contract.
     * @param recipient The recipient address.
     * @param amount The amount of tokens to transfer.
     */
    function safeTransfer(address token, address recipient, uint256 amount) internal {
        require(token != address(0), "TokenUtils: Invalid token address");
        require(recipient != address(0), "TokenUtils: Invalid recipient address");
        require(amount > 0, "TokenUtils: Transfer amount must be greater than zero");

        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("transfer(address,uint256)", recipient, amount));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "TokenUtils: Transfer failed");
    }

    /**
     * @dev Returns the balance of a given ERC-20 token for a specified account.
     * @param token The address of the ERC-20 token contract.
     * @param account The address to query the balance of.
     * @return The token balance of the specified account.
     */
    function getBalance(address token, address account) internal view returns (uint256) {
        require(token != address(0), "TokenUtils: Invalid token address");
        require(account != address(0), "TokenUtils: Invalid account address");

        (bool success, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        require(success, "TokenUtils: Failed to get balance");

        return abi.decode(data, (uint256));
    }
}
