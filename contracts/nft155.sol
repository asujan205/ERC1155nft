// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract MyMarketPlace is ERC1155,Ownable{
    IERC1155 private _nft;

  constructor(address _nftContract) ERC1155("") {
        _nft = IERC1155(_nftContract);
    }
using Counters for Counters.Counter;
Counters.Counter private _tokenIds;
Counters.Counter private _isSold;

address private _owner;
 uint256 private platformFee = 25;
uint256 private deno = 1000;


struct  NftMarketItem{

    uint256 id;
    uint256 nftId;
    uint256 amount;
    uint256 price;
    uint256 royalty;
    address payable seller;
    address payable owner;
    bool isSold;
}
mapping(uint256 => NftMarketItem) private marketItem;
// the uri should be in the from of www.uri.com/{id}.json`
function _setURI(string memory newuri) internal virtual override  onlyOwner{
    _setURI(newuri);
}
//miniting the nfts
function MintNfts(uint256 tokenId,uint256 _amount) public {
    _mint(msg.sender, tokenId, _amount, "");
    

}
//Listing the nfts
function CreateMarketItem ( uint256 nftId, uint256 amount, uint256 price, uint256 royalty) public {
    require(price > 0, "Price must be at least 1 wei");
    require(royalty > 0, "Royalty must be at least 1 wei");
    _tokenIds.increment();
    uint256 itemId = _tokenIds.current();
    marketItem[itemId] = NftMarketItem(itemId, nftId, amount, price, royalty, 
    payable(msg.sender), payable(address(0)), false);
    
    _safeTransferFrom(msg.sender, address(this), nftId, amount, "");
}
//Fetching the nfts
function FetchMarketItem() public view returns (NftMarketItem[] memory){
    uint256 itemCount = _tokenIds.current();
    uint256 unsoldItemCount = itemCount - _isSold.current();
    uint256 currentIndex = 0;
    NftMarketItem[] memory items = new NftMarketItem[](unsoldItemCount);
    for (uint256 i = 0; i < itemCount; i++) {
        if (marketItem[i + 1].id == 0) {
            continue;
        }
        NftMarketItem storage currentItem = marketItem[i + 1];
        if (currentItem.isSold == false) {
            uint256 currentId = currentIndex;
            items[currentId] = currentItem;
            currentIndex += 1;
        }
    }
    return items;


}
//fetch the nfts you buyed
function FetchMyItem() public view returns (NftMarketItem[] memory){
    uint256 itemCount = _tokenIds.current();
    uint256 unsoldItemCount = itemCount - _isSold.current();
    uint256 currentIndex = 0;
    NftMarketItem[] memory items = new NftMarketItem[](unsoldItemCount);
    for (uint256 i = 0; i < itemCount; i++) {
        if (marketItem[i + 1].id == 0) {
            continue;
        }
        NftMarketItem storage currentItem = marketItem[i + 1];
        if (currentItem.owner == msg.sender) {
            uint256 currentId = currentIndex;
            items[currentId] = currentItem;
            currentIndex += 1;
        }
    }
    return items;
}
//fetchNfts you listed

 function fetchItemListed() public view returns (NftMarketItem[] memory){
    uint256 itemCount = _tokenIds.current();
    uint256 unsoldItemCount = itemCount - _isSold.current();
    uint256 currentIndex = 0;
    NftMarketItem[] memory items = new NftMarketItem[](unsoldItemCount);
    for (uint256 i = 0; i < itemCount; i++) {
        if (marketItem[i + 1].id == 0) {
            continue;
        }
        NftMarketItem storage currentItem = marketItem[i + 1];
        if (currentItem.seller == msg.sender) {
            uint256 currentId = currentIndex;
            items[currentId] = currentItem;
            currentIndex += 1;
        }
    }
    return items;


 }
//buying the nfts
function BuyNfts(uint256 TokenId,uint256 _amounts)public payable{
    require(TokenId > 0 && TokenId <= _tokenIds.current(), "Token ID does not exist");
    NftMarketItem storage item = marketItem[TokenId];
    require(item.isSold == false, "Item is already sold");
    require(item.amount == _amounts, "Item is not available");
    require(msg.value >= item.price, "Not enough Ether");
    uint256 royalty = (item.price * item.royalty) / deno;
    uint256 marketfee= (item.price * platformFee) / deno;
    uint256 sellerProceeds = item.price - (royalty + platformFee);
    item.seller.transfer(sellerProceeds);
    payable(owner()).transfer(marketfee);
    item.owner = payable(msg.sender);
    item.isSold = true;
    _isSold.increment();
    _safeTransferFrom(address(this), msg.sender, item.nftId, item.amount, "");

}


    
}