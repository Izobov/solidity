// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface ILogger {
    function log(address _from, uint _amount) external;

    function getEntry(address _from, uint _index) external view returns (uint);
}
