// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CreateNFT is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    address contractAddress;

    uint256 public mintRate = 0.001 ether;
    uint256 public MAX_SUPPLY = 100;

    constructor(address marketplaceAddress) ERC721("CreateNFT", "CNFT") {
        contractAddress = marketplaceAddress;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://jsonkeeper.com/b/U5UD";
    }

    function mintNFT() public payable returns (uint256) {
        require( MAX_SUPPLY > 100, "No more mints available");
        require(msg.value >= mintRate, "Not enough ether");
        _tokenIdCounter.increment();
        uint256 newItemId = _tokenIdCounter.current();

        _mint(msg.sender, newItemId);
        
        return newItemId;
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "Address has 0 balance");
        payable(owner()).transfer(address(this).balance);
    }
}
