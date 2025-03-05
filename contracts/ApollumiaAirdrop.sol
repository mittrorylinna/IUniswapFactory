// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IApollumiaToken is IERC20 {
    function isExcludedFromFee(address account) external view returns (bool);
    function maxTxAmount() external view returns (uint256);
    function maxWalletSize() external view returns (uint256);
}

contract ApollumiaAirdrop is Ownable {
    IApollumiaToken public immutable token;

    event AirdropDistributed(address indexed recipient, uint256 amount);
    event TokensRecovered(address indexed recipient, uint256 amount);

    constructor(address _token) {
        require(_token != address(0), "Invalid token address");
        token = IApollumiaToken(_token);
    }

    function distributeAirdrop(address[] calldata recipients, uint256[] calldata amounts) external onlyOwner {
        require(recipients.length == amounts.length, "Array length mismatch");

        uint256 maxTx = token.maxTxAmount();
        uint256 maxWallet = token.maxWalletSize();

        for (uint256 i = 0; i < recipients.length; i++) {
            address recipient = recipients[i];
            uint256 amount = amounts[i];

            require(recipient != address(0), "Invalid recipient");
            require(amount > 0, "Amount must be greater than zero");
            require(amount <= maxTx, "Exceeds max transaction amount");

            uint256 recipientBalance = token.balanceOf(recipient);
            require(recipientBalance + amount <= maxWallet, "Exceeds max wallet size");

            require(token.transfer(recipient, amount), "Token transfer failed");
            emit AirdropDistributed(recipient, amount);
        }
    }

    function recoverTokens(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Invalid address");
        require(amount > 0, "Amount must be greater than zero");
        require(token.transfer(to, amount), "Token recovery failed");

        emit TokensRecovered(to, amount);
    }
}
