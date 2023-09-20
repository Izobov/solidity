// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Functions {
    string message = "Hello";

    //public   visible anyware
    //external visible outside contract but not in contract
    //internal visible in contract + childs
    //private visible only in contract

    //view read blockchain vars
    //pure 

    function getBalance() public view returns(uint) {
        return  address(this).balance;
    }

    function getBalance2() public view returns(uint balance) {
        balance = address(this).balance;
        return  balance;
    }

    function setMessage(string memory newMsg) external {
        message = newMsg;
    }

    function getMessage() external view returns(string memory) {
       return  message;
    }

    function pay() external payable {}

}