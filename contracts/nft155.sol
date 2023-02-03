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
function _setURI(string memory newuri) internal virtual override  onlyOwner{
    _setURI(newuri);
}

function MintNfts(uint256 tokenId,uint256 _amount) public {
    _mint(msg.sender, tokenId, _amount, "");
    _tokenIds.increment();

}


    
}