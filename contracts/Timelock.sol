// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Timelock {
    uint public constant MIN_DELAY = 10;
    uint public constant MAX_DELAY = 1 days;
    address public owner;
    mapping(bytes32 => bool) public queue;
    event AddToQueue(bytes32 indexed txId);
    event Discarted(bytes32 indexed txId);
    event Executed(bytes32 indexed txId, bytes res);
    string public message;
    uint public amount;

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
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
        emit AddToQueue(txId);
    }

    function discard(bytes32 _txId) external onlyOwner {
        require(queue[_txId], "not in queue");
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
        bytes memory data;
        if (bytes(_func).length > 0) {
            data = abi.encodePacked(bytes4(keccak256(bytes(_func))), _data);
        } else {
            data = _data;
        }
        require(queue[txId], "not in queue");
        require(block.timestamp >= _timestamp, "too early");
        require(block.timestamp <= _timestamp + MAX_DELAY, "too late");
        delete queue[txId];
        (bool success, bytes memory res) = _to.call{value: _value}(_data);
        require(success, "tx failed");
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
