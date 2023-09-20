// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Instructions {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function pay() external payable {}

    function withdraw(address payable _to) external {
        //Panci error
        // assert(msg.sender == owner);
        
        require(msg.sender == owner, "You are not owner!");
        
        // same thing
        // if (msg.sender != owner) {
        // revert("you are not owner");
        // }
        _to.transfer(address(this).balance);
    }
}