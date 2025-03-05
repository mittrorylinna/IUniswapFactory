// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AdvancedTrade is Ownable {
    IERC20 public immutable token;
    uint256 public taxRate = 5; // tax rate that changes based on transactions
    uint256 public feeBalance; // Accumulated fees collected from transactions

    event TradeExecuted(address indexed trader, uint256 amount, uint256 fee);
    event FeeWithdrawn(address indexed owner, uint256 amount);

    constructor(address _token) {
        require(_token != address(0), "Invalid token address");
        token = IERC20(_token);
    }

    function executeTrade(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(token.balanceOf(msg.sender) >= amount, "Insufficient balance");
        
        uint256 fee = (amount * taxRate) / 100;
        uint256 netAmount = amount - fee;

        require(token.transferFrom(msg.sender, address(this), amount), "Token transfer failed");
        feeBalance += fee; // Update accumulated fees

        emit TradeExecuted(msg.sender, netAmount, fee);
    }

    function withdrawFees(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Invalid address");
        require(amount <= feeBalance, "Not enough fees accumulated");
        
        feeBalance -= amount;
        require(token.transfer(to, amount), "Fee withdrawal failed");
        emit FeeWithdrawn(to, amount);
    }
}
