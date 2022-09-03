// SPDX-License-Identifier: GPL-3.0 license
pragma solidity ^0.8.16;


interface IOffer {
    function owner() external view returns(address);
    function incomeRequirement() external view returns(uint);
    function description() external view returns(string memory);

}