async function main() {

  var MiPrimerNft = await hre.ethers.getContractFactory(
    "MiPrimerNft"
  );

  var miPrimerNft = await hre.upgrades.deployProxy(MiPrimerNft, {
    kind: "uups",
  });

  await miPrimerNft.deployed();


  var implmntAddress = await upgrades.erc1967.getImplementationAddress(
    miPrimerNft.address // address del prozy
  );

  console.log("El Proxy address es (V1):", miPrimerNft.address);
  console.log("El Implementation address es (V1):", implmntAddress);

  await hre.run("verify:verify", {
    address: implmntAddress,
    constructorArguments: [],
  });
}

async function upgrade() {
  var MiPrimerNftProxyAddress =
    "0x87C54456D3c50600ECC3cC6888d197180af4Dc0b";

  const MiPrimerNft2 = await hre.ethers.getContractFactory(
    "MiPrimerNft2"
  );

  // Le decimos al contrato proxi que apunte al nuevo contrato de implementacion
  var miPrimerNft2 = await upgrades.upgradeProxy(
    MiPrimerNftProxyAddress,
    MiPrimerNft2
  );

  await miPrimerNft2.deployTransaction.wait(5);

  var implmntAddress = await upgrades.erc1967.getImplementationAddress(
    miPrimerNft2.address
  );

  console.log("El Proxy address es (V2):", miPrimerNft2.address);
  console.log("El Implementation address es (V2):", implmntAddress);

  await hre.run("verify:verify", {
    address: implmntAddress,
    constructorArguments: [],
  });
}

/main()/
upgrade()
  
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });