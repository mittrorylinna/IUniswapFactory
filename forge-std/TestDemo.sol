// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * Minimal demonstration of a Test contract.
 * For complete functionality, see:
 * https://github.com/foundry-rs/forge-std/blob/master/src/Test.sol
 */

abstract contract Test {
    // A basic assertion function
    function assertEq(uint256 a, uint256 b, string memory message) internal {
        if (a != b) {
            revert(message);
        }
    }

    // Overload with no custom message
    function assertEq(uint256 a, uint256 b) internal {
        assertEq(a, b, "Assertion Failure: uint256 mismatch");
    }

    // Another basic assertion
    function assertTrue(bool condition, string memory message) internal {
        if (!condition) {
            revert(message);
        }
    }

    // Overload with no custom message
    function assertTrue(bool condition) internal {
        assertTrue(condition, "Assertion Failure: condition is false");
    }

    // Example function for expecting a revert
    // In the official Foundry library, you would use `vm.expectRevert(...)`.
    // Here we demonstrate a no-op for illustration only.
    function expectRevert(bytes memory) internal pure {
        // No-op in this minimal example
        // The real foundry Test.sol uses cheat codes from 'Vm' to handle reverts
    }

    // Example function for "pranking" transactions
    // In the official foundry library, you would use `vm.prank(...)`.
    function prank(address) internal pure {
        // No-op in this minimal example
    }

    // Additional utilities, cheat codes, console logs, etc.
    // would normally be included in a full Test.sol from foundry.
}
