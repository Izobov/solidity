// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract MyContract {
    address otherContract;

    event Response(string);

    constructor(address _other) {
        otherContract = _other;
    }

    function callReceive() external  payable {
        (bool success, ) = otherContract.call{value: msg.value}(""); // low-level call receive of AnotherContract
        require(success, "cant send funds!"); // low-level call dosent throw an err, so we need to check by ower own

        //transfer - has gas limit 2300. Low -level dosent have gas limit;
    }

    function callSetName(string calldata _name) external  {
        // (bool success ,bytes memory res ) = otherContract.call(abi.encodeWithSignature("setName(string)", _name)); // calling specific function
        //  same but in case we have AnotherContract sources
        (bool success ,bytes memory res ) = otherContract.call(abi.encodeWithSelector(AnotherContract.setName.selector, _name)); // calling specific function
         require(success, "cant set name!");

        emit Response(abi.decode(res, (string)));
    }
}


contract AnotherContract {
    string public name;
    mapping (address => uint) public  balances;

    function setName(string calldata _name) external  returns(string memory) {
        name = _name;
        return  name;
    }

    receive() external payable {
        balances[msg.sender] += msg.value;
    }
}