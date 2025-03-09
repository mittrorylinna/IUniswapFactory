// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../contracts/IUniswapFactory.sol"; // Adjust path if necessary
import "../lib/api.sol";

contract APOLLUMIATest is Test {
    APOLLUMIA private apollumia;
    address private owner;
    address private addr1;
    address private addr2;

    // Helper: Convert "human-readable" tokens to internal decimals
    // For example, "100" means 100 APOLLUMIA with 9 decimals
    function toWei(uint256 amount) internal pure returns (uint256) {
        return amount * 10**9; // since APOLLUMIA has 9 decimals
    }

    function setUp() public {
        // Each Foundry test runs in its own EVM instance.
        // By default, the test contract itself is "msg.sender" here,
        // so we treat this contract as `owner`.
        owner = address(this);
        addr1 = makeAddr("ADDR1");
        addr2 = makeAddr("ADDR2");

        // Deploy the APOLLUMIA contract
        apollumia = new APOLLUMIA();
    }

    function testInitialValues() public {
        // Check name, symbol, decimals
        assertEq(apollumia.name(), "APOLLUMIA", "Name mismatch");
        assertEq(apollumia.symbol(), "APOLLUMIA", "Symbol mismatch");
        assertEq(apollumia.decimals(), 9, "Decimals mismatch");

        // Check total supply => 100,000,000 * 10^9
        uint256 expectedSupply = 100_000_000 * 10**9;
        assertEq(apollumia.totalSupply(), expectedSupply, "Total supply mismatch");

        // Owner should have entire supply
        assertEq(apollumia.balanceOf(owner), expectedSupply, "Owner balance mismatch");
    }

    function testTransfer() public {
        // Transfer 1,000 APOLLUMIA from owner to addr1
        uint256 transferAmount = toWei(1000);
        apollumia.transfer(addr1, transferAmount);

        // Check balances
        assertEq(apollumia.balanceOf(owner), (100_000_000 * 10**9) - transferAmount, "Owner balance after transfer");
        assertEq(apollumia.balanceOf(addr1), transferAmount, "addr1 balance mismatch");
    }

    function testMaxTxAndMaxWalletBeforeRemoveLimits() public {
        // The contract sets _maxTxAmount to 20,000,000 * 10^9
        uint256 maxTx = apollumia._maxTxAmount();

        // Try a transfer > maxTx => should revert
        vm.expectRevert(bytes("Exceeds the maxTxAmount"));
        apollumia.transfer(addr1, maxTx + 1);

        // Transfer exactly maxTx => should succeed
        apollumia.transfer(addr1, maxTx);
        assertEq(apollumia.balanceOf(addr1), maxTx, "addr1 should have maxTx tokens");

        // Next transfer could push over maxWalletSize => should revert
        vm.expectRevert(bytes("Exceeds the maxWalletSize"));
        apollumia.transfer(addr1, 1);
    }

    function testRemoveLimits() public {
        // removeLimits can only be called by owner
        apollumia.removeLimits();
        
        // Now we can transfer as many as we want
        uint256 totalSupply = apollumia.totalSupply();
        // Transfer tokens from owner to addr1
        apollumia.transfer(addr1, totalSupply);

        assertEq(apollumia.balanceOf(addr1), totalSupply, "addr1 should have entire supply after removeLimits");
    }

    function testOwnerOnlyRemoveLimits() public {
        // A non-owner address should fail
        vm.prank(addr1); 
        vm.expectRevert(bytes("caller is not the owner"));
        apollumia.removeLimits();
    }

    function testOpenTrading() public {
        // By default, tradingOpen is false
        // We call openTrading as owner
        apollumia.openTrading();
        // There's no direct public bool to read, but no revert => success
        // Additional checks could be done if logic in openTrading() changes storage
    }

    function testManualSwapOwnerOnly() public {
        // manualSwap can be called only by _taxWallet, which by default is the owner in constructor
        vm.prank(addr1);
        vm.expectRevert(bytes("Not authorized"));
        apollumia.manualSwap();

        // Called by owner => should pass (though might do nothing if there's no tax to swap)
        apollumia.manualSwap();
    }
}
