// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Ownable {
    address public owner;

    constructor(address ownerOverride) {
        owner = ownerOverride == address(0) ? msg.sender : ownerOverride;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "not an owner!");
        _;
    }

    function withdraw(address payable _to) public virtual onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}

abstract contract Balances is Ownable {
    function getBalance() public view onlyOwner returns (uint) {
        return address(this).balance;
    }

    function withdraw(address payable _to) public virtual override onlyOwner {
        _to.transfer(getBalance());
    }
}

contract MyContract is Ownable, Balances {
    constructor(address _owner) Ownable(_owner) {}

    // constructor(address _owner) {
    //     owner = _owner;
    // }
    function withdraw(address payable _to) public override(Ownable, Balances) {
        // Balances.withdraw(_to);
        super.withdraw(_to);
    }
}
