// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./ERC721.sol";

abstract contract ERC721URIStorage is ERC721 {
    mapping(uint => string) _tokensURIs;

    function tokenURI(
        uint tokenId
    )
        public
        view
        virtual
        override
        _requireMinted(tokenId)
        returns (string memory)
    {
        string memory _tokenURI = _tokensURIs[tokenId];
        string memory _base = _baseURI();
        if (bytes(_base).length == 0) {
            return _tokenURI;
        }
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(_base, _tokenURI));
        }

        return super.tokenURI(tokenId);
    }

    function _setTokenURI(
        uint tokenId,
        string memory _tokenURI
    ) internal virtual _requireMinted(tokenId) {
        _tokensURIs[tokenId] = _tokenURI;
    }

    function burn(uint tokenId) public override {
        super.burn(tokenId);
        if (bytes(_tokensURIs[tokenId]).length != 0) {
            delete _tokensURIs[tokenId];
        }
    }
}
