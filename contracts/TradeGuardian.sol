// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IApollumia {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TradeGuardian {
    address public token;
    address public admin;
    uint256 public cooldownPeriod;

    mapping(address => uint256) public lastTradeTimestamp;
    mapping(address => bool) public whitelisted;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor(address _token, uint256 _cooldownPeriod) {
        token = _token;
        admin = msg.sender;
        cooldownPeriod = _cooldownPeriod;
    }

    function setWhitelist(address user, bool status) external onlyAdmin {
        whitelisted[user] = status;
    }

    function setCooldown(uint256 period) external onlyAdmin {
        cooldownPeriod = period;
    }

    function protectedTransfer(address to, uint256 amount) external {
        require(whitelisted[msg.sender], "Not whitelisted");
        require(
            block.timestamp >= lastTradeTimestamp[msg.sender] + cooldownPeriod,
            "Cooldown active"
        );

        lastTradeTimestamp[msg.sender] = block.timestamp;
        require(IApollumia(token).transfer(to, amount), "Transfer failed");
    }
}
