// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CreateNFT is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    address contractAddress;

    uint256 public constant mintRate = 0.001 ether;
    uint256 public constant MAX_SUPPLY = 100;

    string public baseTokenURI;

    constructor(string memory baseURI, address marketplaceAddress) ERC721("CreateNFT", "CNFT") {
        setBaseURI(baseURI);
        contractAddress = marketplaceAddress;
    }

    function _baseURI() internal override view returns (string memory) {
        return baseTokenURI;
    }

    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    } 

    function mintNFT(uint _count) public payable returns (uint256) {
        uint totalMinted = _tokenIdCounter.current();
        require(msg.value >= mintRate, "Not enough ether");

        _tokenIdCounter.increment();
        uint256 newItemId = _tokenIdCounter.current();

        _mint(msg.sender, newItemId);
        
        return newItemId;
    }

    function _mintNFT() private {
      uint newTokenID = _tokenIdCounter.current();
      _safeMint(msg.sender, newTokenID);
      _tokenIdCounter.increment();
    } 

    function withdraw() public payable onlyOwner {
        require(address(this).balance > 0, "Address has 0 balance");
        payable(owner()).transfer(address(this).balance);
    }
}
