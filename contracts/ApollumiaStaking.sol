pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ApollumiaStaking
 * @dev This contract allows users to stake APOLLUMIA tokens and earn rewards.
 */
contract ApollumiaStaking is Ownable {
    IERC20 public apollumiaToken; // APOLLUMIA Token contract instance
    uint256 public rewardRate; // Reward rate per block
    mapping(address => uint256) public stakedBalance; // User staking balance
    mapping(address => uint256) public rewardBalance; // User rewards balance
    mapping(address => uint256) public lastUpdateBlock; // Last updated block for rewards

    /**
     * @dev Emitted when a user stakes tokens.
     * @param user The address of the user who staked
     * @param amount The amount of tokens staked
     */
    event Staked(address indexed user, uint256 amount);

    /**
     * @dev Emitted when a user withdraws staked tokens.
     * @param user The address of the user withdrawing
     * @param amount The amount of tokens withdrawn
     */
    event Withdrawn(address indexed user, uint256 amount);

    /**
     * @dev Emitted when a user claims their rewards.
     * @param user The address of the user claiming rewards
     * @param amount The amount of rewards claimed
     */
    event RewardClaimed(address indexed user, uint256 amount);

    /**
     * @notice Initializes the staking contract with APOLLUMIA token and reward rate.
     * @param _token Address of the APOLLUMIA token contract
     * @param _rewardRate The initial reward rate
     */
    constructor(IERC20 _token, uint256 _rewardRate) {
        apollumiaToken = _token;
        rewardRate = _rewardRate;
    }

    /**
     * @notice Allows users to stake their APOLLUMIA tokens.
     * @param _amount The amount of tokens to stake
     */
    function stake(uint256 _amount) external {
        require(_amount > 0, "Cannot stake zero tokens");

        // Update rewards before modifying balance
        updateRewards(msg.sender);

        apollumiaToken.transferFrom(msg.sender, address(this), _amount);
        stakedBalance[msg.sender] += _amount;

        emit Staked(msg.sender, _amount);
    }

    /**
     * @notice Allows users to withdraw their staked tokens.
     * @param _amount The amount of tokens to withdraw
     */
    function withdraw(uint256 _amount) external {
        require(_amount > 0, "Cannot withdraw zero tokens");
        require(stakedBalance[msg.sender] >= _amount, "Insufficient staked balance");

        updateRewards(msg.sender);

        stakedBalance[msg.sender] -= _amount;
        apollumiaToken.transfer(msg.sender, _amount);

        emit Withdrawn(msg.sender, _amount);
    }

    /**
     * @notice Allows users to claim their accumulated staking rewards.
     */
    function claimRewards() external {
        updateRewards(msg.sender);
        uint256 rewards = rewardBalance[msg.sender];
        require(rewards > 0, "No rewards available");

        rewardBalance[msg.sender] = 0;
        apollumiaToken.transfer(msg.sender, rewards);

        emit RewardClaimed(msg.sender, rewards);
    }

    /**
     * @dev Internal function to update user rewards based on staked balance.
     * @param _user Address of the user to update rewards for
     */
    function updateRewards(address _user) internal {
        if (lastUpdateBlock[_user] > 0) {
            uint256 blocksElapsed = block.number - lastUpdateBlock[_user];
            rewardBalance[_user] += (stakedBalance[_user] * rewardRate * blocksElapsed) / 1e18;
        }
        lastUpdateBlock[_user] = block.number;
    }

    /**
     * @notice Allows the owner to update the reward rate.
     * @param _newRate The new reward rate per block
     */
    function setRewardRate(uint256 _newRate) external onlyOwner {
        rewardRate = _newRate;
    }
}
