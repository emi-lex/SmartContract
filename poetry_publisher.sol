// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract PoetryPublisher is ERC721 {
    uint256 public nextTokenId;
    address public admin;

    constructor() ERC721("PoetryNFT", "PNFT") {
        admin = msg.sender;
    }

    struct Poetry {
        address author;
        string content;
        uint256 tokenId;
    }

    mapping(uint256 => Poetry) public poems;

    event PoetryPublished(address indexed author, uint256 indexed tokenId);

    function publishPoetry(string memory _content) external {
        uint256 tokenId = nextTokenId;
        _safeMint(msg.sender, tokenId);
        poems[tokenId] = Poetry(msg.sender, _content, tokenId);
        nextTokenId++;
        emit PoetryPublished(msg.sender, tokenId);
    }

    function returnNFT(uint256 _tokenId) external {
        require(msg.sender == poems[_tokenId].author, "Only author can return NFT");
        require(_exists(_tokenId), "Query for nonexistent token"
        );
        _burn(_tokenId);
        delete poems[_tokenId];
    }
}