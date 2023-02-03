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

function _setURI(string memory newuri) internal virtual override  onlyOwner{
    _setURI(newuri);
}

    
}