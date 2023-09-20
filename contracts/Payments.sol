// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Payments {
    //Struct
    struct Payment {
        uint amount;
        uint timestamp;
        address from;
    }

    struct Balance {
        uint totalBalance;
        mapping(uint => Payment) payments;
    }

    mapping(address => Balance) public balances;

    function pay() public payable {
        uint paymentIndex = balances[msg.sender].totalBalance;
        Payment memory newPayment = Payment(
            msg.value,
            block.timestamp,
            msg.sender
        );
        balances[msg.sender].payments[paymentIndex] = newPayment;
        balances[msg.sender].totalBalance++;
    }

    function getPayment(
        address _addr,
        uint _index
    ) public view returns (Payment memory) {
        return balances[_addr].payments[_index];
    }

    function currentBalance() public view returns (uint) {
        return address(this).balance;
    }
}
