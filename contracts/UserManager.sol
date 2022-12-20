// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract UserManager {
    mapping(string => address) private users;

    function takeNickname(string memory nickname) external {
        require(users[nickname] == address(0), "Nickname has already taken");
        users[nickname] = msg.sender;
    }

    function getUserByName(string memory nickname) external view returns(address) {
        return users[nickname];
    }


}