// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";

contract Market is ReentrancyGuard {
    using Counters for Counters.Counter;

    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold;

    // defining struct for items
    struct Item {
       uint itemId;
       address nftContract;
       uint256 tokenId;
       address payable seller;
       address payable owner;
       uint256 price;
    }

    mapping (uint256 => Item) private idToMarketItem;

    event ItemCreated (
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price
    );

   //Listing nft for sale
    function sellItem(address nftContract, uint256 tokenId, uint256 price) public payable nonReentrant {
        require(price > 0, "Price is very low");

        _itemIds.increment();
        uint256 itemId = _itemIds.current();

       idToMarketItem[itemId] =  Item(
      itemId,
      nftContract,
      tokenId,
      payable(msg.sender),
      payable(address(0)),
      price
    );

    IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

    //emitng event for created nft
    emit ItemCreated(itemId, nftContract, tokenId, msg.sender, address(0), price);
    }

    function createSale(address nftContract, uint256 itemId) public payable nonReentrant {
        uint price = idToMarketItem[itemId].price;
        uint tokenId = idToMarketItem[itemId].tokenId;

        require(msg.value == price, "Enter the offered price to complete purchase");

        idToMarketItem[itemId].seller.transfer(msg.value); //tranferring amount to seller
        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId); //transferring ownership of nft
        idToMarketItem[itemId].owner = payable(msg.sender); 
        _itemsSold.increment();
    }

    function fetchItems() public view returns(Item[] memory) {
        uint itemCount = _itemIds.current();
        uint itemsUnsold = _itemIds.current() - _itemsSold.current();
        uint currentIndex = 0;

        Item[] memory items = new Item[](itemsUnsold);
        for (uint256 i = 0; i < itemCount; i++) {
            if (idToMarketItem[i + 1].owner == address(0)) {
                uint currentId = idToMarketItem[i + 1].itemId;
                Item storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            } else {
                
            }
        }
    }
}