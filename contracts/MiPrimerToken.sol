pragma solidity 0.8.18;


import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";


contract MyTokenMiPrimerToken is
Initializable,
ERC20Upgradeable,
OwnableUpgradeable,
UUPSUpgradeable
{


    function initialize() public initializer {
        __ERC20_init("MyTokenMiPrimerToken", "MPRTKN");
        __Ownable_init();
        __UUPSUpgradeable_init();
        _mint(msg.sender, 100000000 * 10 ** decimals());
    }
      /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
   
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to,amount);
    }
}



contract MyTokenMiPrimerToken2 is
    Initializable,
    ERC20Upgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    function initialize() public initializer {
        __ERC20_init("MyTokenMiPrimerToken", "MPRTKN");
        __Ownable_init();
        __UUPSUpgradeable_init();
        _mint(msg.sender, 100000000 * 10 ** decimals());
    }
  /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to , amount * 10 ** decimals());
    }

    function burn(address to, uint256 amount) public onlyOwner {
        _burn(to , amount * 10 ** decimals());
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}