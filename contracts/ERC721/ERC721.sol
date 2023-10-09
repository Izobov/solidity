//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "./IERC721Metadata.sol";
import "./IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./ERC165.sol";

contract ERC721 is ERC165, IERC721Metadata {
    using Strings for uint;
    string public name;
    string public symbol;

    mapping(address => uint) balances;
    mapping(uint => address) owners;
    mapping(uint => address) tokenApprovals;
    mapping(address => mapping(address => bool)) operatorApprovals;

    modifier _requireMinted(uint _tokenId) {
        require(_exists(_tokenId), "not minted");
        _;
    }

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function balanceOf(address owner) public view returns (uint) {
        return balances[owner];
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public pure override returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function approve(address to, uint tokenId) public {
        address owner = ownerOf(tokenId);
        require(to != owner, "already owner");
        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "not approved"
        );
        tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function setApprovalForAll(address operator, bool _approved) public {
        require(msg.sender != operator, "owner is operator");
        require(
            operatorApprovals[msg.sender][operator] != _approved,
            "already approved"
        );
        operatorApprovals[msg.sender][operator] = _approved;
        emit ApprovalForAll(msg.sender, operator, _approved);
    }

    function transferFrom(address from, address to, uint tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "not approved");
        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "not approved");
        _safeTransfer(from, to, tokenId);
    }

    function ownerOf(
        uint tokenId
    ) public view _requireMinted(tokenId) returns (address) {
        return owners[tokenId];
    }

    function isApprovedForAll(
        address owner,
        address operator
    ) public view returns (bool) {
        return operatorApprovals[owner][operator];
    }

    function getApproved(
        uint tokenId
    ) public view _requireMinted(tokenId) returns (address) {
        return tokenApprovals[tokenId];
    }

    function tokenURI(
        uint tokenId
    ) public view virtual _requireMinted(tokenId) returns (string memory) {
        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
                : "";
    }

    function burn(uint tokenId) public virtual {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "not approved or owner"
        );
        address owner = ownerOf(tokenId);
        delete tokenApprovals[tokenId];
        balances[owner]--;
        delete owners[tokenId];
    }

    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    function _safeMint(address to, uint tokenId) internal {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(msg.sender, to, tokenId),
            "not received"
        );
    }

    function _mint(address to, uint tokenId) internal {
        require(to != address(0), "to zero address");
        require(!_exists(tokenId), "already minted");
        _beforeMintToken(to, tokenId);
        balances[to]++;
        owners[tokenId] = to;
        emit Transfer(address(0), to, tokenId);
        _afterMintToken(to, tokenId);
    }

    function _safeTransfer(address from, address to, uint tokenId) internal {
        require(
            _checkOnERC721Received(from, to, tokenId),
            "transfer to non ERC721Receiver implementer"
        );
        _transfer(from, to, tokenId);
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint tokenId
    ) private returns (bool) {
        if (to.code.length > 0) {
            try
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    tokenId,
                    bytes("")
                )
            returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function _transfer(address from, address to, uint tokenId) internal {
        require(ownerOf(tokenId) == from, "not owner");
        require(to != address(0), "to zero address");
        _beforeTransferToken(from, to, tokenId);
        balances[from]--;
        balances[to]++;
        owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
        _afterTransferToken(from, to, tokenId);
    }

    function _exists(uint _tokenId) internal view returns (bool) {
        return owners[_tokenId] != address(0);
    }

    function _isApprovedOrOwner(
        address spender,
        uint tokenId
    ) internal view returns (bool) {
        address owner = ownerOf(tokenId);
        require(
            spender == owner ||
                isApprovedForAll(owner, spender) ||
                getApproved(tokenId) == spender,
            "not approved"
        );
        return true;
    }

    function _beforeTransferToken(
        address from,
        address to,
        uint tokenId
    ) internal virtual {}

    function _afterTransferToken(
        address from,
        address to,
        uint tokenId
    ) internal virtual {}

    function _beforeMintToken(address to, uint tokenId) internal virtual {}

    function _afterMintToken(address to, uint tokenId) internal virtual {}
}
