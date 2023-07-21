// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract PublicSale is Initializable, PausableUpgradeable, AccessControlUpgradeable, UUPSUpgradeable {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    // Mi Primer Token
    IERC20Upgradeable miPrimerToken; // Setter in Constructor

    // 17 de Junio del 2023 GMT
    uint256 constant startDate = 1686960000;

    // Maximo price NFT
    uint256 constant MAX_PRICE_NFT = 50000;

    // Gnosis Safe
    address gnosisSafeWallet; // Setter in Constructor

    event DeliverNft(address winnerAccount, uint256 nftId);

    mapping(uint256 => bool) internal tokensSold;
    mapping(uint256 => uint256) public tmpTokensSoldbyPrice;
    mapping(uint256 => address) public tmpTokensSoldbyAddress;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _miPrimerTokenAddress, address _gnosisSafeWallet) public initializer {
        __Pausable_init();
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(UPGRADER_ROLE, msg.sender);
        gnosisSafeWallet = payable(msg.sender);
        miPrimerToken = IERC20Upgradeable(_miPrimerTokenAddress);
        gnosisSafeWallet = _gnosisSafeWallet;
    }

    receive() external payable {}
    fallback() external payable {}

    function purchaseNftById(uint256 _id) external {
        // Realizar 3 validaciones:
        // 1 - el id no se haya vendido. Sugerencia: llevar la cuenta de ids vendidos
        //         * Mensaje de error: "Public Sale: id not available"
        // 2 - el msg.sender haya dado allowance a este contrato en suficiente de MPRTKN
        //         * Mensaje de error: "Public Sale: Not enough allowance"
        // 3 - el msg.sender tenga el balance suficiente de MPRTKN
        //         * Mensaje de error: "Public Sale: Not enough token balance"
        // 4 - el _id se encuentre entre 1 y 30
        //         * Mensaje de error: "NFT: Token id out of range"

        require(!tokensSold[_id], "Public Sale: id not available");
        require(_id >= 1 && _id <= 30, "NFT: Token id out of range");

        uint256 priceNft = _getPriceById(_id) * 10**18;
        require(miPrimerToken.allowance(msg.sender, address(this)) >= priceNft, "Public Sale: Not enough allowance");
        require(miPrimerToken.balanceOf(msg.sender) >= priceNft, "Public Sale: Not enough token balance");

        uint256 fee = (priceNft * 10) / 100;
        uint256 net = priceNft - fee;
        miPrimerToken.transferFrom(msg.sender, gnosisSafeWallet, fee);
        miPrimerToken.transferFrom(msg.sender, address(this), net);

        emit DeliverNft(msg.sender, _id);
        tokensSold[_id] = true;
        tmpTokensSoldbyPrice[_id] = priceNft;
        tmpTokensSoldbyAddress[_id] = msg.sender;
    }

    function depositEthForARandomNft() public payable {
        uint256 nftId = _getRandomNftId();

        if (nftId == 0) {
            if (msg.value != 0) payable(msg.sender).transfer(msg.value);
            revert("Sorry, no Tokens available");
        }

        if (msg.value < 0.01e18) {
            payable(msg.sender).transfer(msg.value);
            revert("You have less than 0.01 ether");
        }

        (bool success,) = payable(gnosisSafeWallet).call{
            value: 0.01e18,
            gas: 5000000
        }("");
        require(success, "Failed transfer");

        if (msg.value > 0.01e18) {
            payable(msg.sender).transfer(msg.value - 0.01e18);
        }

        emit DeliverNft(msg.sender, nftId);
        tokensSold[nftId] = true;
        tmpTokensSoldbyPrice[nftId] = 0.01e18;
        tmpTokensSoldbyAddress[nftId] = msg.sender;
    }

    function transferTokensToOwner() public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(miPrimerToken.balanceOf(address(this)) > 0, "Public Sale: Balance of MiPrimerToken is zero");
        miPrimerToken.transfer(msg.sender, miPrimerToken.balanceOf(address(this)));
    }

    ////////////////////////////////////////////////////////////////////////
    /////////                    Helper Methods                    /////////
    ////////////////////////////////////////////////////////////////////////

    function _getRandomNftId() internal view returns (uint256) {
        uint256 random = 0;

        uint256 i;
        for (i = 1; i <= 30; i++) {
            if (!tokensSold[i]) random++;
        }
        if (random == 0) return 0;

        do {
            random = (uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 30) + 1;
        } while (tokensSold[random]);

        return random;
    }

    function _getPriceById(uint256 _id) internal view returns (uint256) {
        uint256 priceGroupOne = 500;
        if (_id >= 1 && _id <= 10) return priceGroupOne;

        uint256 priceGroupTwo = 1000 * _id;
        if (_id >= 11 && _id <= 20) return priceGroupTwo;

        uint256 priceGroupThree = 10000 + 150 * (block.timestamp - startDate) / 3600;

        if (priceGroupThree > MAX_PRICE_NFT) priceGroupThree = MAX_PRICE_NFT;
        return priceGroupThree;
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyRole(UPGRADER_ROLE) {}
}
