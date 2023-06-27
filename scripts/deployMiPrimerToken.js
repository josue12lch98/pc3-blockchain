async function main() {

  var MiPrimerToken = await hre.ethers.getContractFactory(
    "MyTokenMiPrimerToken"
  );

  var miPrimerToken = await hre.upgrades.deployProxy(MiPrimerToken, {
    kind: "uups",
  });

  await miPrimerToken.deployed();


  var implmntAddress = await upgrades.erc1967.getImplementationAddress(
    miPrimerToken.address // address del prozy
  );

  console.log("El Proxy address es (V1):", miPrimerToken.address);
  console.log("El Implementation address es (V1):", implmntAddress);

  await hre.run("verify:verify", {
    address: implmntAddress,
    constructorArguments: [],
  });
}

async function upgrade() {
  var MiPrimerTokenProxyAddress =
    "0xDa8230e110E1d1FB95e7E46D1cA16e1fBE2088bb";

  const MyTokenMiPrimerToken2 = await hre.ethers.getContractFactory(
    "MyTokenMiPrimerToken2"
  );

  // Le decimos al contrato proxi que apunte al nuevo contrato de implementacion
  var myTokenMiPrimerToken2 = await upgrades.upgradeProxy(
    MiPrimerTokenProxyAddress,
    MyTokenMiPrimerToken2
  );

  await myTokenMiPrimerToken2.deployTransaction.wait(5);

  var implmntAddress = await upgrades.erc1967.getImplementationAddress(
    myTokenMiPrimerToken2.address
  );

  console.log("El Proxy address es (V2):", myTokenMiPrimerToken2.address);
  console.log("El Implementation address es (V2):", implmntAddress);

  await hre.run("verify:verify", {
    address: implmntAddress,
    constructorArguments: [],
  });
}

//main()
upgrade()
  //
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });