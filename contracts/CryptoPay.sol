// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./UserManager.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CryptoPay {
    UserManager public userManager;

    constructor() {
        userManager = new UserManager();
    }

    function checkUser(string memory nickname) private view returns (address) {
        address user = userManager.getUserByName(nickname);
        require(user != address(0), "User not found");
        return user;
    }

    function sendEth(string memory nickname) external payable {
        address user = checkUser(nickname);
        (bool isSent, ) = user.call{value: msg.value}("");
        require(isSent, "Error");
    }

    function sendERC20(
        string memory nickname,
        address tokenAddress,
        uint amount
    ) external payable {
        address user = checkUser(nickname);
        ERC20 token = ERC20(tokenAddress);
        bool isSent = token.transferFrom(msg.sender, user, amount);
        require(isSent, "Unable to sent tokens");
    }
}
