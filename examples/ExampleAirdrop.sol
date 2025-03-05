// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "../contracts/ApollumiaAirdrop.sol"; // Importing the ApollumiaAirdrop contract

/**
 * @title ExampleAirdrop
 * @dev This contract demonstrates how to interact with the ApollumiaAirdrop contract.
 *      It allows users to initiate an airdrop by calling the distributeAirdrop function
 *      from the ApollumiaAirdrop contract.
 */
contract ExampleAirdrop {
    // Instance of the ApollumiaAirdrop contract
    ApollumiaAirdrop public airdropContract;

    /**
     * @dev Event emitted when an airdrop is executed through this contract.
     * @param sender The address that initiated the airdrop.
     * @param recipient The recipient address that received the airdrop.
     * @param amount The amount of tokens distributed to the recipient.
     */
    event ExampleAirdropExecuted(address indexed sender, address indexed recipient, uint256 amount);

    /**
     * @dev Constructor to initialize the ExampleAirdrop contract.
     * @param _airdropContract Address of the deployed ApollumiaAirdrop contract.
     */
    constructor(address _airdropContract) {
        require(_airdropContract != address(0), "Invalid airdrop contract address");
        airdropContract = ApollumiaAirdrop(_airdropContract);
    }

    /**
     * @dev Executes an airdrop using the ApollumiaAirdrop contract.
     * @param recipients Array of addresses that will receive the airdrop.
     * @param amounts Array of token amounts corresponding to each recipient.
     * @notice The length of recipients and amounts arrays must be the same.
     */
    function executeAirdrop(address[] calldata recipients, uint256[] calldata amounts) external {
        require(recipients.length == amounts.length, "Array length mismatch");
        require(recipients.length > 0, "No recipients provided");

        // Calls the distributeAirdrop function of the ApollumiaAirdrop contract
        airdropContract.distributeAirdrop(recipients, amounts);

        // Emit an event for each recipient in the airdrop
        for (uint256 i = 0; i < recipients.length; i++) {
            emit ExampleAirdropExecuted(msg.sender, recipients[i], amounts[i]);
        }
    }
}
