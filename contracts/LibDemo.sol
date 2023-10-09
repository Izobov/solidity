// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

library StrExt {
    function eq(
        string memory str1,
        string memory str2
    ) internal pure returns (bool) {
        return keccak256(abi.encode(str1)) == keccak256(abi.encode(str2));
    }
}

library ArrayExt {
    function inArray(uint[] memory arr, uint el) internal pure returns (bool) {
        for (uint i = 0; i < arr.length; i++) {
            if (arr[i] == el) return true;
        }
        return false;
    }
}

contract LibDemo {
    using StrExt for string;
    using ArrayExt for uint[];

    function runnerStr(
        string memory str1,
        string memory str2
    ) public pure returns (bool) {
        return str1.eq(str2);
    }

    function runnerArr(uint[] memory arr1, uint el) public pure returns (bool) {
        return arr1.inArray(el);
    }
}
