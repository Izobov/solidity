// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "./IERC165.sol";

contract ERC165 is IERC165 {
    function supportsInterface(
        bytes4 interfaceId
    ) public pure virtual returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}
