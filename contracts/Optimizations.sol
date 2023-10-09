// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Op {
    // uint demo;

    // uint128 a = 1;
    // uint128 b = 1;
    // uint128 c = 1;

    // bytes32 public hash = 0x4dbfb35453b00919b15a140af1ae2463a7d07c677443724682a5ab04c2b20389;

    // mapping(address => uint) payments;

    // function pay() external payable {
    //     require(msg.sender != address(0), "zero address");
    //     payments[msg.sender] = msg.value;
    // }

    uint public result = 1;

    function doWork(uint[] memory data) public {
        uint temp = result;
        for (uint i = 0; i < data.length; i++) {
            temp *= data[i];
        }
        result = temp;
    }
}

contract Un {
    // uint demo = 0;

    // uint128 a = 1;
    // uint128 c = 1;
    // uint128 b = 1;

    // bytes32 public hash = keccak256(abi.encodePacked("test"));

    //   mapping(address => uint) payments;

    // function pay() external payable {
    //     address _from = msg.sender;
    //     require(_from != address(0), "zero address");
    //     payments[_from] = msg.value;
    // }

    uint public result = 1;

    function doWork(uint[] memory data) public {
        for (uint i = 0; i < data.length; i++) {
            result *= data[i];
        }
    }
}
