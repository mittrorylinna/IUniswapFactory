// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DeployHelper
 * @dev A utility contract to assist in contract deployment and verification.
 */
contract DeployHelper {
    address public deployer;

    /**
     * @dev Sets the deployer address when the contract is deployed.
     */
    constructor() {
        deployer = msg.sender;
    }

    /**
     * @dev Returns the address of the deployer.
     * @return Address of the deployer.
     */
    function getDeployer() external view returns (address) {
        return deployer;
    }

    /**
     * @dev Checks whether a contract exists at a given address.
     * @param _addr The address to check.
     * @return True if a contract exists at the given address, false otherwise.
     */
    function isContract(address _addr) external view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(_addr)
        }
        return size > 0;
    }
}
