// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IERC721.sol";
import "./ERC721URIStorage.sol";

contract MyToken is ERC721URIStorage {
    address public owner;
    uint currentToken;

    constructor() ERC721("MyToken", "MTK") {
        owner = msg.sender;
    }

    function safeMint(address to, string calldata tokenId) public {
        require(msg.sender == owner, "only owner can mint");
        _safeMint(to, currentToken);
        _setTokenURI(currentToken, tokenId);
        currentToken++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://my-json-server.typicode.com/andresaaap/demo/tokens/";
    }
}
