// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MyLibrary
/// @notice A simple demonstration library for Foundry projects.
/// @dev Use these internal functions within your contracts as needed.
library MyLibrary {
    /// @dev Returns the sum of two numbers.
    /// @param a The first number.
    /// @param b The second number.
    /// @return The result of a + b.
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /// @dev Returns the product of two numbers.
    /// @param a The first number.
    /// @param b The second number.
    /// @return The result of a * b.
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }
}
