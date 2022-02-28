// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyNFT is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint public mintRate = 0.01 ether;
    uint public MAX_SUPPLY = 1000;

    constructor() ERC721("MyNFT", "NFT") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://miro.medium.com/max/1120/1*k_EY7dcLYB5Z5k8zhMcv6g.png";
    }

    function mintNFT(address to) public payable {
        require(totalSupply() < MAX_SUPPLY, "Can't mint more");
        require(msg.value == mintRate, "Not enough matic");
        _tokenIdCounter.increment();
        _safeMint(to, _tokenIdCounter.current());
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function withDraw() public onlyOwner {
        require(address(this).balance > 0, "Not enough balance to withdraw");
        payable(owner()).transfer(address(this).balance);
    }
}