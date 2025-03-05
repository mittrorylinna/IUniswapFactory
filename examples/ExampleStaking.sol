// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../contracts/ApollumiaStaking.sol";

/**
 * @title ExampleStaking
 * @dev This contract demonstrates how to interact with the ApollumiaStaking contract.
 *      Users can stake tokens, withdraw staked amounts, and claim rewards through this example.
 */
contract ExampleStaking {
    // Instance of the ApollumiaStaking contract
    ApollumiaStaking public stakingContract;

    /**
     * @dev Event emitted when a user stakes tokens using this contract.
     * @param user The address of the user staking tokens.
     * @param amount The amount of tokens staked.
     */
    event ExampleStaked(address indexed user, uint256 amount);

    /**
     * @dev Event emitted when a user withdraws staked tokens using this contract.
     * @param user The address of the user withdrawing tokens.
     * @param amount The amount of tokens withdrawn.
     */
    event ExampleWithdrawn(address indexed user, uint256 amount);

    /**
     * @dev Event emitted when a user claims staking rewards using this contract.
     * @param user The address of the user claiming rewards.
     * @param amount The amount of rewards claimed.
     */
    event ExampleRewardClaimed(address indexed user, uint256 amount);

    /**
     * @dev Constructor to initialize the ExampleStaking contract.
     * @param _stakingContract Address of the deployed ApollumiaStaking contract.
     */
    constructor(address _stakingContract) {
        require(_stakingContract != address(0), "Invalid staking contract address");
        stakingContract = ApollumiaStaking(_stakingContract);
    }

    /**
     * @dev Stakes APOLLUMIA tokens in the ApollumiaStaking contract.
     * @param amount The amount of tokens to stake.
     */
    function stake(uint256 amount) external {
        require(amount > 0, "Cannot stake zero tokens");

        // Call the stake function of the ApollumiaStaking contract
        stakingContract.stake(amount);

        // Emit event to track staking activity
        emit ExampleStaked(msg.sender, amount);
    }

    /**
     * @dev Withdraws staked tokens from the ApollumiaStaking contract.
     * @param amount The amount of tokens to withdraw.
     */
    function withdraw(uint256 amount) external {
        require(amount > 0, "Cannot withdraw zero tokens");

        // Call the withdraw function of the ApollumiaStaking contract
        stakingContract.withdraw(amount);

        // Emit event to track withdrawal activity
        emit ExampleWithdrawn(msg.sender, amount);
    }

    /**
     * @dev Claims staking rewards from the ApollumiaStaking contract.
     */
    function claimRewards() external {
        // Call the claimRewards function of the ApollumiaStaking contract
        stakingContract.claimRewards();

        // Since rewards are transferred directly, fetching the reward balance is not necessary
        emit ExampleRewardClaimed(msg.sender, 0); // The exact reward amount is not retrieved here
    }
}
