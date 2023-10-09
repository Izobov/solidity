// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Timelock {
    uint public constant MIN_DELAY = 10;
    uint public constant MAX_DELAY = 1 days;
    address[] public owners;
    mapping(address => bool) public isOwner;
    mapping(bytes32 => bool) public queue;
    event AddToQueue(bytes32 indexed txId);
    event Discarted(bytes32 indexed txId);
    event Executed(bytes32 indexed txId, bytes res);
    string public message;
    uint public amount;
    uint public constant CONFIRMATIONS_REQUIRED = 3;

    struct Transaction {
        bytes32 uid;
        address to;
        uint value;
        bytes data;
        bool executed;
        uint confirmations;
    }

    mapping(bytes32 => Transaction) public txs;

    mapping(bytes32 => mapping(address => bool)) public confirmations;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "only owners");
        _;
    }

    modifier inQueue(bytes32 _txId) {
        require(queue[_txId], "not in queue");
        _;
    }

    constructor(address[] memory _owners) {
        require(_owners.length >= CONFIRMATIONS_REQUIRED, "not enough owners!");
        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Address can't be zero");
            require(!isOwner[owner], "Address's should be unique");
            owners.push(owner);
            isOwner[owner] = true;
        }
    }

    function addToQueue(
        address _to,
        string calldata _func,
        bytes calldata _data,
        uint _value,
        uint _timestamp
    ) external onlyOwner returns (bytes32) {
        require(
            _timestamp > block.timestamp + MIN_DELAY && // 10 seconds minimum lock
                _timestamp < block.timestamp + MAX_DELAY, // 10000 seconds maximum lock
            "invalid timestamp"
        );
        bytes32 txId = keccak256(
            abi.encode(_to, _func, _data, _value, _timestamp)
        );
        require(!queue[txId], " already in queue");
        queue[txId] = true;
        txs[txId] = Transaction({
            uid: txId,
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            confirmations: 0
        });
        emit AddToQueue(txId);
        return txId;
    }

    function cancelConfirmation(
        bytes32 _txId
    ) external onlyOwner inQueue(_txId) {
        require(
            confirmations[_txId][msg.sender],
            "You didn't confirmed this tx"
        );
        Transaction storage transaction = txs[_txId];
        transaction.confirmations--;
        confirmations[_txId][msg.sender] = false;
    }

    function confirm(bytes32 _txId) external onlyOwner inQueue(_txId) {
        require(!confirmations[_txId][msg.sender], "You've already confirmed");
        Transaction storage transaction = txs[_txId];
        transaction.confirmations++;
        confirmations[_txId][msg.sender] = true;
    }

    function discard(bytes32 _txId) external onlyOwner inQueue(_txId) {
        delete queue[_txId];
        emit Discarted(_txId);
    }

    function exec(
        address _to,
        string calldata _func,
        bytes calldata _data,
        uint _value,
        uint _timestamp
    ) external payable onlyOwner returns (bytes memory) {
        bytes32 txId = keccak256(
            abi.encode(_to, _func, _data, _value, _timestamp)
        );
        require(queue[txId], "not in queue");

        Transaction storage transaction = txs[txId];
        require(
            transaction.confirmations >= CONFIRMATIONS_REQUIRED,
            "Not enough confirmations"
        );
        require(!transaction.executed, "Already executed");
        require(block.timestamp >= _timestamp, "too early");
        require(block.timestamp <= _timestamp + MAX_DELAY, "too late");

        bytes memory data;
        if (bytes(_func).length > 0) {
            data = abi.encodePacked(bytes4(keccak256(bytes(_func))), _data);
        } else {
            data = _data;
        }

        transaction.executed = true;
        delete queue[txId];
        (bool success, bytes memory res) = _to.call{value: _value}(data);
        require(success);
        emit Executed(txId, res);
        return res;
    }

    function demo(string calldata _msg) external payable {
        message = _msg;
        amount = msg.value;
    }

    function getTime() external view returns (uint) {
        return block.timestamp + 60;
    }

    function prepareData(
        string calldata _msg
    ) external pure returns (bytes memory) {
        return abi.encode(_msg);
    }
}
