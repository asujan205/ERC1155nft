// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract MyMarketPlace is ERC1155,Ownable{
constructor ()ERC1155("") {}
using Counters for Counters.Counter;
Counters.Counter private _tokenIds;
Counters.Counter private _isSold;
ERC1155 private _nft;
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
        if (currentItem.isSold == false && currentItem.seller == msg.sender) {
            uint256 currentId = currentIndex;
            items[currentId] = currentItem;
            currentIndex += 1;
        }
    }
    return items;
}


    
}