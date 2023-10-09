// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract ComRev {
    address[] public candidates = [
        0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
        0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db,
        0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
    ];

    mapping(address => bytes32) public commits;
    mapping(address => uint) public votes;
    bool votingStopped;

    modifier isActive() {
        require(!votingStopped, "Voting stoped!");
        _;
    }

    function commitVote(bytes32 _hashedVote) external isActive {
        require(commits[msg.sender] == bytes32(0));

        commits[msg.sender] = _hashedVote;
    }

    function stopVoting() external isActive {
        votingStopped = true;
    }

    function revealVote(address _candidate, bytes32 _secret) external {
        require(votingStopped, "Voting is in progress!");

        bytes32 commit = keccak256(
            abi.encodePacked(_candidate, _secret, msg.sender)
        );
        require((commit == commits[msg.sender]));
        delete commits[msg.sender];
        votes[_candidate]++;
    }
}
