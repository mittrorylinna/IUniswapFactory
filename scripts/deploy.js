const hre = require("hardhat");

async function main() {
    // Get the contract factory
    const APOLLUMIA = await hre.ethers.getContractFactory("APOLLUMIA");
    
    // Deploy the contract
    console.log("Deploying APOLLUMIA token...");
    const apollumia = await APOLLUMIA.deploy();

    // Wait for deployment to finish
    await apollumia.deployed();
    
    console.log(`APOLLUMIA deployed to: ${apollumia.address}`);
}

// Run the script and handle errors
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
