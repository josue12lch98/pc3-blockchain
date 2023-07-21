const { expect } = require("chai");
const { ethers } = require("hardhat");
const { time } = require("@nomicfoundation/hardhat-network-helpers");

const { getRole, deploySC, deploySCNoUp, ex, pEth } = require("../utils");

const MINTER_ROLE = getRole("MINTER_ROLE");
const BURNER_ROLE = getRole("BURNER_ROLE");

// 21 de diciembre del 2022 GMT
var startDate = 1671580800;

var makeBN = (num) => ethers.BigNumber.from(String(num));

describe("MI PRIMER TOKEN TESTING", function () {
  var nftContract, publicSale, miPrimerToken, usdc;
  var owner, gnosis, alice, bob, carl, deysi;
  var name = "Mi Primer NFT";
  var symbol = "MPRNFT";

  beforeEach(async function () {
 
    [owner, gnosis, alice, bob, carl, deysi] = await ethers.getSigners();
      // Mock miPrimerToken contract
      const MyTokenMiPrimerToken = await ethers.getContractFactory("MyTokenMiPrimerToken");
  
      miPrimerToken = await hre.upgrades.deployProxy(MyTokenMiPrimerToken, {
      kind: "uups",
    });
    
     implementationAddress = await upgrades.erc1967.
    getImplementationAddress(miPrimerToken.address);
  
      const NFT = await ethers.getContractFactory("NFT");
  
      miPrimerNft = await upgrades.deployProxy(NFT, ["MyNFT", "MNFT"], {
        initializer: "initialize",
        kind: "uups",
      });
    
     implementationAddress = await upgrades.erc1967.
    getImplementationAddress(nft.address);
  
      
  
      // Initialize DarkRallySale contract
      const PublicSale = await ethers.getContractFactory("PublicSale");
    
    
   
      publicSale = await upgrades.deployProxy(PublicSale,  {
        kind: "uups",
      });
      
       implementationAddressDarkRallySale = await upgrades.erc1967.
      getImplementationAddress(publicSale.address);
  
      const USDCoin = await ethers.getContractFactory("USDCoin");
      usdCoin = await USDCoin.deploy();
   
    
    });

  // Estos dos métodos a continuación publican los contratos en cada red
  // Se usan en distintos tests de manera independiente
  // Ver ejemplo de como instanciar los contratos en deploy.js
  async function deployNftSC() {}

  async function deployPublicSaleSC() {}

  describe("Mi Primer Nft Smart Contract", () => {
    // Se publica el contrato antes de cada test
  
    
    describe("MiPrimerNft", function () {
      let owner, gnosis, alice, bob, carl, deysi;
      let MiPrimerNft;
      let miPrimerNft;
    
      beforeEach(async function () {
        [owner, gnosis, alice, bob, carl, deysi] = await ethers.getSigners();
    
        MiPrimerNft = await ethers.getContractFactory("MiPrimerNft");
        miPrimerNft = await upgrades.deployProxy(NFT, ["MyNFT", "MNFT"], {
          initializer: "initialize",
          kind: "uups",
        });
           });
    
      it.only("should deploy the contract", async function () {
        expect(await miPrimerNft.name()).to.equal("MiPrimerNft");
      });
    
      it.only("should mint NFTs", async function () {
        await miPrimerNft.safeMint(alice.address, 1);
        expect(await miPrimerNft.ownerOf(1)).to.equal(alice.address);
    
        await miPrimerNft.safeMint(bob.address, 30);
        expect(await miPrimerNft.ownerOf(30)).to.equal(bob.address);
    
        await expect(miPrimerNft.safeMint(carl.address, 0)).to.be.revertedWith(
          "Public Sale: id must be between 1 and 30"
        );
    
        await expect(miPrimerNft.safeMint(deysi.address, 31)).to.be.revertedWith(
          "Public Sale: id must be between 1 and 30"
        );
      });
    });
    
    describe("MiPrimerNft2", function () {
      let owner, gnosis, alice, bob, carl, deysi;
      let MiPrimerNft2;
      let miPrimerNft2;
    
      beforeEach(async function () {
        [owner, gnosis, alice, bob, carl, deysi] = await ethers.getSigners();
    
        MiPrimerNft2 = await ethers.getContractFactory("MiPrimerNft2");
        miPrimerNft2 = await upgrades.deployProxy(MiPrimerNft2);
      });
    
      it.only("should deploy the contract", async function () {
        expect(await miPrimerNft2.name()).to.equal("MiPrimerNft");
      });
    
      it.only("should mint NFTs", async function () {
        await miPrimerNft2.safeMint(alice.address, 1);
        expect(await miPrimerNft2.ownerOf(1)).to.equal(alice.address);
    
        await miPrimerNft2.safeMint(bob.address, 30);
        expect(await miPrimerNft2.ownerOf(30)).to.equal(bob.address);
    
        await expect(miPrimerNft2.safeMint(carl.address, 0)).to.be.revertedWith(
          "Public Sale: id must be between 1 and 30"
        );
    
        await expect(miPrimerNft2.safeMint(deysi.address, 31)).to.be.revertedWith(
          "Public Sale: id must be between 1 and 30"
        );
      });
    
      it.only("should pause and unpause the contract", async function () {
        expect(await miPrimerNft2.paused()).to.equal(false);
    
        await miPrimerNft2.pause();
        expect(await miPrimerNft2.paused()).to.equal(true);
    
        await miPrimerNft2.unpause();
        expect(await miPrimerNft2.paused()).to.equal(false);
      });
    });
    

    it("Verifica nombre colección", async () => {});

    it("Verifica símbolo de colección", async () => {});

    it("No permite acuñar sin privilegio", async () => {});

    it("No permite acuñar doble id de Nft", async () => {});

    it("Verifica rango de Nft: [1, 30]", async () => {
      // Mensaje error: "NFT: Token id out of range"
    });

    it("Se pueden acuñar todos (30) los Nfts", async () => {});
  });

  describe("Public Sale Smart Contract", () => {
    // Se publica el contrato antes de cada test
    beforeEach(async () => {
      await deployPublicSaleSC();
    });

    it("No se puede comprar otra vez el mismo ID", async () => {});

    it("IDs aceptables: [1, 30]", async () => {});

    it("Usuario no dio permiso de MiPrimerToken a Public Sale", async () => {});

    it("Usuario no tiene suficientes MiPrimerToken para comprar", async () => {});

    describe("Compra grupo 1 de NFT: 1 - 10", () => {
      it("Emite evento luego de comprar", async () => {
        // modelo para validar si evento se disparo con correctos argumentos
        // var tx = await publicSale.purchaseNftById(id);
        // await expect(tx)
        //   .to.emit(publicSale, "DeliverNft")
        //   .withArgs(owner.address, counter);
      });

      it("Disminuye balance de MiPrimerToken luego de compra", async () => {
        // Usar changeTokenBalance
        // source: https://ethereum-waffle.readthedocs.io/en/latest/matchers.html#change-token-balance
      });

      it("Gnosis safe recibe comisión del 10% luego de compra", async () => {});

      it("Smart contract recibe neto (90%) luego de compra", async () => {});
    });

    describe("Compra grupo 2 de NFT: 11 - 20", () => {
      it("Emite evento luego de comprar", async () => {});

      it("Disminuye balance de MiPrimerToken luego de compra", async () => {});

      it("Gnosis safe recibe comisión del 10% luego de compra", async () => {});

      it("Smart contract recibe neto (90%) luego de compra", async () => {});
    });

    describe("Compra grupo 3 de NFT: 21 - 30", () => {
      it("Disminuye balance de MiPrimerToken luego de compra", async () => {});

      it("Gnosis safe recibe comisión del 10% luego de compra", async () => {});

      it("Smart contract recibe neto (90%) luego de compra", async () => {});
    });

    describe("Depositando Ether para Random NFT", () => {
      it("Método emite evento (30 veces) ", async () => {});

      it("Método falla la vez 31", async () => {});

      it("Envío de Ether y emite Evento (30 veces)", async () => {});

      it("Envío de Ether falla la vez 31", async () => {});

      it("Da vuelto cuando y gnosis recibe Ether", async () => {
        // Usar el método changeEtherBalances
        // Source: https://ethereum-waffle.readthedocs.io/en/latest/matchers.html#change-ether-balance-multiple-accounts
        // Ejemplo:
        // await expect(
        //   await owner.sendTransaction({
        //     to: publicSale.address,
        //     value: pEth("0.02"),
        //   })
        // ).to.changeEtherBalances(
        //   [owner.address, gnosis.address],
        //   [pEth("-0.01"), pEth("0.01")]
        // );
      });
    });
  });
});
