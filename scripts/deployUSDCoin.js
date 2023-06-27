var { ethers } = require("hardhat");

async function main() {
  const USDCoin = await ethers.getContractFactory("USDCoin");
  const uSDCoin = await USDCoin.deploy();
console.log("Deploying USDCoin...");
  var tx = await uSDCoin.deployed();
  console.log("Deploying after...");
  await tx.deployTransaction.wait(5);

  console.log("Contrato :", uSDCoin.address);
  
  await hre.run("verify:verify", {
    address: uSDCoin.address,
    constructor: [],
  });

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1; // exitcode quiere decir fallor por error, terminacion fatal
});