// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title FeeManager
 * @dev Manages the collection and distribution of transaction fees 
 *      for the APOLLUMIA token contract.
 */
contract FeeManager {
    
    /// @notice Address of the contract owner (typically the APOLLUMIA deployer)
    address public owner;

    /// @notice Address that will receive collected fees
    address public feeRecipient;

    /// @notice Total amount of fees collected by the contract
    uint256 public totalFeesCollected;

    /// @dev Event emitted when fees are collected.
    event FeesCollected(address indexed sender, uint256 amount);

    /// @dev Event emitted when fees are distributed.
    event FeesDistributed(address indexed recipient, uint256 amount);

    /// @dev Restricts function access to the contract owner.
    modifier onlyOwner() {
        require(msg.sender == owner, "FeeManager: caller is not the owner");
        _;
    }

    /**
     * @dev Initializes the contract with the fee recipient address.
     * @param _feeRecipient Address that will receive collected fees.
     */
    constructor(address _feeRecipient) {
        require(_feeRecipient != address(0), "FeeManager: invalid recipient address");
        owner = msg.sender;
        feeRecipient = _feeRecipient;
    }

    /**
     * @dev Allows external sources to send fees to the contract.
     *      The sent amount is added to `totalFeesCollected`.
     */
    function collectFees() external payable {
        require(msg.value > 0, "FeeManager: no fees sent");
        
        totalFeesCollected += msg.value;
        emit FeesCollected(msg.sender, msg.value);
    }

    /**
     * @dev Distributes all collected fees to the designated recipient.
     *      Can only be called by the contract owner.
     */
    function distributeFees() external onlyOwner {
        require(totalFeesCollected > 0, "FeeManager: no fees to distribute");

        uint256 amount = totalFeesCollected;
        totalFeesCollected = 0;

        payable(feeRecipient).transfer(amount);
        emit FeesDistributed(feeRecipient, amount);
    }

    /**
     * @dev Updates the fee recipient address.
     *      Can only be called by the contract owner.
     * @param _newRecipient The new address to receive collected fees.
     */
    function updateFeeRecipient(address _newRecipient) external onlyOwner {
        require(_newRecipient != address(0), "FeeManager: invalid recipient address");
        
        feeRecipient = _newRecipient;
    }
}
