// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract MyContract {
    function selector() external pure returns (bytes4) {
        return bytes4(keccak256(bytes("work(string)")));
        // its first 4 bytes
    }

    function work(string memory _str) external pure returns (bytes32 data) {
        assembly {
            let ptr := mload(64)
            data := mload(sub(ptr, 32))
        }
    }

    function callData(
        uint[3] calldata _arr
    ) external pure returns (bytes32 _el1) {
        assembly {
            _el1 := calldataload(4)
            // 0x0000000000000000000000000000000000000000000000000000000000000001
        }
    }
}
