// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../examples/ExampleStaking.sol";
import "../contracts/ApollumiaStaking.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * A simple ERC20 token used for testing purposes.
 */
contract MockToken is ERC20 {
    constructor() ERC20("MockToken", "MKT") {
        _mint(msg.sender, 1_000_000 * 10**18); // Mint 1 million tokens for testing
    }
}

/**
 * This contract tests the ExampleStaking contract using Foundry's Forge.
 */
contract ExampleStakingTest is Test {
    MockToken private token;
    ApollumiaStaking private stakingContract;
    ExampleStaking private exampleStaking;
    address private user1;
    address private owner;
    uint256 private initialStakeAmount = 100 * 10**18; // 100 tokens

    function setUp() public {
        owner = address(this);
        user1 = address(1);

        // Deploy mock token
        token = new MockToken();

        // Deploy staking contract with reward rate of 1 token per block
        stakingContract = new ApollumiaStaking(IERC20(address(token)), 1 * 10**18);

        // Deploy example staking contract
        exampleStaking = new ExampleStaking(address(stakingContract));

        // Allocate tokens to user1
        token.transfer(user1, initialStakeAmount);

        // Approve staking contract to spend user1's tokens
        vm.prank(user1);
        token.approve(address(stakingContract), initialStakeAmount);
    }

    function testStakeTokens() public {
        vm.startPrank(user1); // Simulate user1 calling the contract

        // Stake tokens via the ExampleStaking contract
        exampleStaking.stake(initialStakeAmount);

        // Verify that the staking balance is updated
        uint256 stakedBalance = stakingContract.stakedBalance(user1);
        assertEq(stakedBalance, initialStakeAmount, "Stake balance should match initial stake amount");

        vm.stopPrank();
    }

    function testWithdrawTokens() public {
        vm.startPrank(user1);

        // Stake first
        exampleStaking.stake(initialStakeAmount);

        // Withdraw tokens
        exampleStaking.withdraw(initialStakeAmount);

        // Verify that staking balance is zero
        uint256 stakedBalance = stakingContract.stakedBalance(user1);
        assertEq(stakedBalance, 0, "Stake balance should be zero after withdrawal");

        vm.stopPrank();
    }

    function testClaimRewards() public {
        vm.startPrank(user1);
        // Stake first
        exampleStaking.stake(initialStakeAmount);

        // Advance a few blocks to accumulate rewards
        vm.roll(block.number + 10);

        // Claim rewards
        exampleStaking.claimRewards();

        // Verify rewards balance (since rewards are transferred, only checking if the function executes)
        uint256 rewards = stakingContract.rewardBalance(user1);
        assertEq(rewards, 0, "Rewards should be zero after claiming");

        vm.stopPrank();
    }
}
