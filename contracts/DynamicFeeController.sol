// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IToken {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract DynamicFeeController {
    address public token;
    address public treasury;
    address public admin;

    uint256 public baseFee; // in basis points, e.g., 250 = 2.5%
    uint256 public maxFee;
    uint256 public volumeThreshold;
    uint256 public rollingVolume;
    uint256 public lastReset;

    mapping(address => bool) public feeExempt;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor(address _token, address _treasury, uint256 _baseFee, uint256 _maxFee, uint256 _volumeThreshold) {
        token = _token;
        treasury = _treasury;
        admin = msg.sender;
        baseFee = _baseFee;
        maxFee = _maxFee;
        volumeThreshold = _volumeThreshold;
        lastReset = block.timestamp;
    }

    function setExempt(address user, bool exempt) external onlyAdmin {
        feeExempt[user] = exempt;
    }

    function setParameters(uint256 _baseFee, uint256 _maxFee, uint256 _volumeThreshold) external onlyAdmin {
        baseFee = _baseFee;
        maxFee = _maxFee;
        volumeThreshold = _volumeThreshold;
    }

    function executeTransfer(address from, address to, uint256 amount) external {
        uint256 currentFee = calculateFee(amount);
        uint256 feeAmount = feeExempt[from] ? 0 : (amount * currentFee) / 10000;
        uint256 netAmount = amount - feeAmount;

        if (feeAmount > 0) {
            require(IToken(token).transferFrom(from, treasury, feeAmount), "Fee transfer failed");
        }
        require(IToken(token).transferFrom(from, to, netAmount), "Main transfer failed");

        updateVolume(amount);
    }

    function calculateFee(uint256 amount) public view returns (uint256) {
        if (rollingVolume >= volumeThreshold) {
            return maxFee;
        }
        return baseFee + ((maxFee - baseFee) * rollingVolume) / volumeThreshold;
    }

    function updateVolume(uint256 amount) internal {
        if (block.timestamp > lastReset + 1 days) {
            rollingVolume = 0;
            lastReset = block.timestamp;
        }
        rollingVolume += amount;
    }
}
