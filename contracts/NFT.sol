// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;


import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract MiPrimerNft is
Initializable,
ERC721Upgradeable,
PausableUpgradeable,
AccessControlUpgradeable,
ERC721BurnableUpgradeable,
OwnableUpgradeable,
UUPSUpgradeable{

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    function initialize() public initializer {
        __ERC721_init("MiPrimerNft", "MPRNFT");
        __Pausable_init();
        __AccessControl_init();
        __UUPSUpgradeable_init();
        __Ownable_init();        
        __ERC721Burnable_init();
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

   /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
   

   function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmNUn3p5niXFjHSMsBLKuQxGH6TQsMnPoo5DaK6P1E7L6X/";
    }
 
    function safeMint(address to, uint256 id) public onlyRole(MINTER_ROLE) {
        // Se hacen dos validaciones
        // 1 - Dicho id no haya sido acuñado antes
        // 2 - Id se encuentre en el rando inclusivo de 1 a 30
        //      * Mensaje de error: "Public Sale: id must be between 1 and 30"
        require(!_exists(id), "Ya tiene duenio");
        require(id <= 30 && id >= 1,"Public Sale: id must be between 1 and 30"); // El id inicia en 0 hasta 29. si coloco de 1 a 30, tendria que restar 1 posteriormente.

        _safeMint(to, id);      

    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(
        bytes4 interfaceId
     ) public view override(ERC721Upgradeable, AccessControlUpgradeable) returns (bool) {
         return super.supportsInterface(interfaceId);
     }



}




contract MiPrimerNft2 is
Initializable,
ERC721Upgradeable,
PausableUpgradeable,
AccessControlUpgradeable,
ERC721BurnableUpgradeable,
OwnableUpgradeable,
UUPSUpgradeable{

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    function initialize() public initializer {
        __ERC721_init("MiPrimerNft", "MPRNFT");
        __Pausable_init();
        __AccessControl_init();
        __UUPSUpgradeable_init();
        __ERC721Burnable_init();
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }
   /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
   

   function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmbMqEvSKpnZ12d22dc2tFyVweBG3G455cweg9pxTYtjg5/";
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }



    function safeMint(address to, uint256 id) public onlyRole(MINTER_ROLE) {
        // Se hacen dos validaciones
        // 1 - Dicho id no haya sido acuñado antes
        // 2 - Id se encuentre en el rando inclusivo de 1 a 30
        //      * Mensaje de error: "Public Sale: id must be between 1 and 30"
        require(_exists(id), "Ya tiene duenio");
        require(id <= 30 && id >= 1,"Public Sale: id must be between 1 and 30"); // El id inicia en 0 hasta 29. si coloco de 1 a 30, tendria que restar 1 posteriormente.

        _safeMint(to, id);      

    }



    // The following functions are overrides required by Solidity.

   
        function supportsInterface(
            bytes4 interfaceId
        ) public view virtual override(ERC721Upgradeable, AccessControlUpgradeable) returns (bool) {
            return super.supportsInterface(interfaceId);
        }
   
     



}