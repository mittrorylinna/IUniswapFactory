const { ethers } = require("hardhat");

async function main() {
    // Replace with the actual deployed contract address
    const contractAddress = "YOUR_DEPLOYED_CONTRACT_ADDRESS";

    // Get the contract factory instance for APOLLUMIA
    const APOLLUMIA = await ethers.getContractFactory("APOLLUMIA");

    // Attach to the deployed contract using the provided address
    const apollumia = APOLLUMIA.attach(contractAddress);

    // Fetch the total supply of the token (in smallest unit)
    const totalSupply = await apollumia.totalSupply();

    // Convert total supply to readable format (assuming 9 decimal places)
    console.log(`Total Supply: ${ethers.utils.formatUnits(totalSupply, 9)} APOLLUMIA`);

    // Check if trading is open
    const tradingOpen = await apollumia.tradingOpen();
    console.log(`Trading Open: ${tradingOpen}`);

    // If trading is not open, attempt to enable it
    if (!tradingOpen) {
        console.log("Trading is not open. Attempting to enable it...");

        // Send transaction to open trading
        const tx = await apollumia.openTrading();

        // Wait for the transaction to be confirmed
        await tx.wait();

        console.log("Trading has been successfully enabled.");
    } else {
        console.log("Trading is already enabled.");
    }
}

// Execute the main function and handle errors
main().catch((error) => {
    console.error("Error interacting with the contract:", error);
    process.exitCode = 1; // Exit with a non-zero status code on failure
});
