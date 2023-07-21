var { ethers } = require("hardhat");
var {verify, deploySCNoUp, deploySC,printAddress} = require("../utils/index.js");
async function main() {

  var usdcCoin  =await deploySCNoUp("USDCoin");
  await verify(usdcCoin.address,'USDCoin')
  
  var miPrimerTokenProxy = await deploySC('MyTokenMiPrimerToken');
  var impl = await printAddress('miPrimerToken' , miPrimerTokenProxy.address);
  verify(impl,'MyTokenMiPrimerToken');
  
  var publicSaleProxy = await deploySC('PublicSale', [miPrimerTokenProxy.address, "0x655252000B5aC35239C9B7F112d3F252874763f4"]);
  var impl = await printAddress('PublicSale' , publicSaleProxy.address);
  verify(impl,'MyTokenMiPrimerToken');
  
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1; // exitcode quiere decir fallor por error, terminacion fatal
});

