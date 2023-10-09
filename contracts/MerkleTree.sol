// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract MerkleTree {
    //    H5      H6
    //   /  \    /  \
    //  H1  H2  H3  H4
    //  /   /   /   /
    // TX1 TX2 TX3 TX4
    bytes32[] public hashes;
    string[4] transactions = [
        "TX1: Scherlock => John",
        "TX1: John => Scherlock",
        "TX1: John => Marry",
        "TX1: Marry => Scherlock"
    ];

    constructor() {
        for (uint i = 0; i < transactions.length; i++) {
            hashes.push(makeHash(transactions[i]));
        }
        uint count = transactions.length;
        uint offset = 0;
        while (count > 0) {
            for (uint i = 0; i < count - 1; i += 2) {
                hashes.push(
                    keccak256(
                        abi.encodePacked(
                            hashes[offset + i],
                            hashes[offset + i + 1]
                        )
                    )
                );
            }
            offset += count;
            count = count / 2;
        }
    }

    function veryfy(
        string memory transaction,
        uint index,
        bytes32 root,
        bytes32[] memory proof
    ) public pure returns (bool) {
        bytes32 hash = makeHash(transaction);
        for (uint i = 0; i < proof.length; i++) {
            bytes32 el = proof[i];
            if (index % 2 == 0) {
                hash = keccak256(abi.encodePacked(hash, el));
            } else {
                hash = keccak256(abi.encodePacked(el, hash));
            }
            index = index / 2;
        }

        return hash == root;
    }

    function makeHash(string memory input) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(input));
    }
}
