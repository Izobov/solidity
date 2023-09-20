// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;


contract Enum {
    //Struct
    struct Payment {
        uint amount;
        uint timestamp;
        address from;
    }

    struct Balance {
        uint totalBalance;
        mapping (uint => Payment) payments;
    }

    mapping(address => Balance) public balances;

    function pay2() public payable {
        uint paymentIndex = balances[msg.sender].totalBalance;
        Payment memory newPayment = Payment(
            msg.value,
            block.timestamp,
            msg.sender
        );
        balances[msg.sender].payments[paymentIndex] = newPayment;
        balances[msg.sender].totalBalance++;
    }

    function getPayment(address _addr, uint _index) public view returns(Payment memory) {
        return balances[_addr].payments[_index];
    }


    //Byte
    bytes public  b1; //dynamic bytes
    bytes1 public  b2; //fixed bytes
    // 1 --> 32
    // 32*8 = 256


    //Array 
    uint[] public dynamicArr;
    uint[10] public items; // only 10 items
    uint[3][2] public matrix; // [[1,2,3],[4,5,6]]
    
    
    //Enum

    enum Status {Paid, Delivered, Received} // can itarate by index

    Status public currentStatus;

    function pay() public {
        currentStatus = Status.Paid;
    }
    function delivered() public {
        currentStatus = Status.Delivered;
    }
}