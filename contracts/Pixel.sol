// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

// For remix
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Counters.sol";

// For truffle
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Pixel is ERC721("NFTs Homepage Pixel", "PIXEL") {
    using Counters for Counters.Counter;
    
    event Minted(address owner, uint256 tokenId, uint256 pixelIndex);
    event IpfsHashUpdated(uint256 pixelIndex, string ipfsHash);
    
    address public masterAdminAddress;
    address payable public dev1Address;
    address payable public dev2Address;
    
    modifier onlyMasterAdmin {
        require(msg.sender == masterAdminAddress, "Only master admin");
        _;
    }
    
    Counters.Counter public _tokenIds;
    
    struct PixelMetadata {
        uint256 tokenId;
        string ipfsHash;
    }
    
    mapping(uint256 => PixelMetadata) public pixelMetadata;
    mapping(uint256 => uint256) public tokenIdToPixelIndex;
    
    function getPixelOwner(uint256 _index) public view returns (address) {
        return ownerOf(pixelMetadata[_index].tokenId);
    }
    
    modifier onlyPixelOwner(uint256 _index) {
        require(getPixelOwner(_index) == msg.sender, "Only pixel owner");
        _;
    }
    
    constructor() {
        masterAdminAddress = msg.sender;
        dev1Address = payable(msg.sender);
        dev2Address = payable(msg.sender);
    }
    
    function mint(uint256 row, uint256 col, address _to) public payable returns (uint256) {

        require(msg.value >= 100000000000000000, "Too cheap");
        require(row >= 0 && row < 100 && col >= 0 && col < 100, "Out of bound");
        require(pixelMetadata[row*100 + col].tokenId == 0, "Out of stock");
        
        _tokenIds.increment();

        // tokenId start at 1
        uint256 newTokenId = _tokenIds.current();
        _safeMint(_to, newTokenId);
        
        uint256 pixelIndex = row*100 + col;
        
        tokenIdToPixelIndex[newTokenId] = pixelIndex;
        pixelMetadata[pixelIndex].tokenId = newTokenId;
        
        // Transfer money to dev address
        uint256 halfValue = msg.value / 2;
        dev1Address.transfer(halfValue);
        dev2Address.transfer(halfValue);
        
        emit Minted(msg.sender, newTokenId, pixelIndex);
        
        return newTokenId;
    }
    
    function updateIpfsHash(uint256 _index, string memory _ipfsHash) public onlyPixelOwner(_index) {
        pixelMetadata[_index].ipfsHash = _ipfsHash;
        emit IpfsHashUpdated(_index, _ipfsHash);
    }
    
    function updateMasterAdmin(address _newAddress) public onlyMasterAdmin {
        masterAdminAddress = _newAddress;
    }
    
    function updateDev(uint256 _i, address payable _devAddress) public onlyMasterAdmin {
        if (_i == 1) {
            dev1Address = _devAddress;
        } else if (_i == 2) {
            dev2Address = _devAddress;
        }
    }
}
