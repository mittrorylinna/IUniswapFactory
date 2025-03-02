// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title FeeManager
 * @dev This contract manages the collection and distribution of transaction fees
 *      collected by the APOLLUMIA token contract.
 */
contract FeeManager {
    
    // Address of the contract owner (typically the APOLLUMIA deployer)
    address public owner;
    
    // Address where collected fees will be sent
    address public feeRecipient;
    
    // Total fees collected in the contract
    uint256 public totalFeesCollected;
    
    /**
     * @dev Event emitted when fees are collected.
     * @param sender Address that sent the fees.
     * @param amount Amount of fees collected.
     */
    event FeesCollected(address indexed sender, uint256 amount);
    
    /**
     * @dev Event emitted when fees are distributed.
     * @param recipient Address receiving the fees.
     * @param amount Amount of fees sent.
     */
    event FeesDistributed(address indexed recipient, uint256 amount);
    
    /**
     * @dev Modifier to restrict function calls to the contract owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }
    
    /**
     * @dev Constructor to initialize the contract with the owner and fee recipient.
     * @param _feeRecipient Address to receive collected fees.
     */
    constructor(address _feeRecipient) {
        require(_feeRecipient != address(0), "Invalid recipient address");
        owner = msg.sender;
        feeRecipient = _feeRecipient;
    }
    
    /**
     * @dev Function to collect fees from external sources.
     */
    function collectFees() external payable {
        require(msg.value > 0, "No fees sent");
        totalFeesCollected += msg.value;
        emit FeesCollected(msg.sender, msg.value);
    }
    
    /**
     * @dev Function to distribute collected fees to the designated recipient.
     */
    function distributeFees() external onlyOwner {
        require(totalFeesCollected > 0, "No fees to distribute");
        uint256 amount = totalFeesCollected;
        totalFeesCollected = 0;
        payable(feeRecipient).transfer(amount);
        emit FeesDistributed(feeRecipient, amount);
    }
    
    /**
     * @dev Function to update the fee recipient address.
     * @param _newRecipient The new address to receive collected fees.
     */
    function updateFeeRecipient(address _newRecipient) external onlyOwner {
        require(_newRecipient != address(0), "Invalid recipient address");
        feeRecipient = _newRecipient;
    }
}
