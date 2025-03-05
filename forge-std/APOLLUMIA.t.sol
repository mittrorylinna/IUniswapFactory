// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./Test.sol";
import "../contracts/IUniswapFactory.sol";

/**
 * This test is placed in the 'forge-std' directory for demonstration.
 * Typically, you would keep your tests in a dedicated 'test' or 'mock' directory,
 * and only import 'forge-std/Test.sol'.
 */
contract APOLLUMIATest is Test {
    APOLLUMIA private apollumia;
    address private owner;
    address private user1;
    address private user2;

    function setUp() public {
        owner = address(this);
        user1 = makeAddr("USER1");
        user2 = makeAddr("USER2");

        // Deploy the APOLLUMIA contract
        apollumia = new APOLLUMIA();
    }

    function testInitialState() public {
        // Verify basic contract metadata
        assertEq(apollumia.name(), "APOLLUMIA", "Wrong name");
        assertEq(apollumia.symbol(), "APOLLUMIA", "Wrong symbol");
        assertEq(apollumia.decimals(), 9, "Wrong decimals");

        // Check total supply => 100,000,000 * 10^9
        uint256 expectedSupply = 100_000_000 * 10**9;
        assertEq(apollumia.totalSupply(), expectedSupply, "Mismatch in total supply");

        // Confirm all tokens allocated to deployer
        assertEq(apollumia.balanceOf(owner), expectedSupply, "Owner should hold entire supply");
    }

    function testTransferBasics() public {
        // Transfer 500 tokens to user1
        uint256 amount = 500 * 10**9; // since decimals = 9
        apollumia.transfer(user1, amount);

        assertEq(apollumia.balanceOf(user1), amount, "user1 balance should match");
        assertEq(
            apollumia.balanceOf(owner),
            (100_000_000 * 10**9) - amount,
            "Owner balance should decrease"
        );
    }

    function testMaxTxAndMaxWalletLimits() public {
        // Retrieve current maxTxAmount
        uint256 maxTx = apollumia._maxTxAmount();

        // Attempt transferring more than maxTx => expect revert
        vm.expectRevert(bytes("Exceeds the maxTxAmount"));
        apollumia.transfer(user1, maxTx + 1);

        // Transfer exactly maxTx => should succeed
        apollumia.transfer(user1, maxTx);
        assertEq(apollumia.balanceOf(user1), maxTx, "user1 should have exactly maxTx");

        // Next transfer that would exceed _maxWalletSize => expect revert
        vm.expectRevert(bytes("Exceeds the maxWalletSize"));
        apollumia.transfer(user1, 1);
    }

    function testRemoveLimits() public {
        // removeLimits is owner-only
        apollumia.removeLimits();

        // Now we can send any amount without revert
        uint256 totalSupply = apollumia.totalSupply();
        apollumia.transfer(user1, totalSupply);

        assertEq(apollumia.balanceOf(user1), totalSupply, "user1 should receive entire supply");
        assertEq(apollumia.balanceOf(owner), 0, "owner should have zero after transfer");
    }

    function testOpenTrading() public {
        // By default, trading is not open
        // Opening trading should not revert
        apollumia.openTrading();

        // If you want to verify any side effects of openTrading,
        // do so here (e.g., checking if certain states changed).
    }

    function testManualSwapOnlyByTaxWallet() public {
        // The constructor sets the tax wallet to the deployer (which is owner here).
        // Attempting to call manualSwap from another address should fail
        vm.prank(user1);
        vm.expectRevert(bytes("Not authorized"));
        apollumia.manualSwap();

        // From owner => should succeed (though might do nothing if no tokens in contract)
        apollumia.manualSwap();
    }
}
