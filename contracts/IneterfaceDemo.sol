// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./ILogger.sol";

contract Payment {
    ILogger logger;

    constructor(address _logger) {
        logger = ILogger(_logger);
    }

    receive() external payable {
        logger.log(msg.sender, msg.value);
    }

    function payment(address _from, uint _index) public view returns (uint) {
        return logger.getEntry(_from, _index);
    }
}
