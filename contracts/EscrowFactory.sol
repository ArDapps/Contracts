// SPDX-License-Identifier: GPL-3.0 license
pragma solidity ^0.8.16;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/IOffer.sol";
import "./Escrow.sol";


contract EscrowFactory {
    address[] escrows;
    mapping(address => address) escrowToOwner;

    event NewEscrow(address newEscrowAddress);

    // function to create a new escrow contract for one applicant. Needs to be called by the applicant
    function createNewEscrow(string memory name, string memory description) external {
        Escrow newEscrow = new Escrow(name, description,msg.sender);
        escrows.push(address(newEscrow));
        escrowToOwner[address(newEscrow)] = msg.sender;

        emit NewEscrow(address(newEscrow));
    }
}