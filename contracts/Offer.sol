// SPDX-License-Identifier: GPL-3.0 license
pragma solidity ^0.8.16;

import "./Verifier.sol";

import "./Offer.sol";
import "./Escrow.sol";
import "./OfferFactory.sol";
import "./EscrowFactory.sol";


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Offer is Verifier {

    //Info displayed on the frontend
    address public owner;
    uint public incomeRequirement;
    string public description;
    uint public depositRequirement;

    // Time for approval
    uint constant TIME_FOR_ACCEPTANCE = 3 days;

    //Applicants structure
    struct Applicant {
        address escrowAddress;
        string name;
        string description;
        bool chosen;
    }

    //List of the applicants that applied successfully
    Applicant[] public applicants;

    // One applicant is chosen at some point OR WE CAN PUT THAT IN THE APPLICANT STRUCT
    Applicant public chosenApplicant;
    bool public isApplicantChosen = false;
    uint deadlineForAcceptance;

    //TOKEN NEED TO REMOVE HARDCODED VALUE I GUESS
    IERC20 TOKEN = IERC20(0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83);

    constructor(string memory _description, uint _incomeRequirement, uint _depositRequirement) {
        description = _description;
        incomeRequirement = _incomeRequirement;
        depositRequirement = _depositRequirement;
    }

    // We choose the applicant via the index in the array
    function chooseApplicant(uint index) public {
        require(!isApplicantChosen, "Applicant already choosen");
        isApplicantChosen = true;
        applicants[index].chosen = true;
        chosenApplicant = applicants[index];
        
        // deadlineForAcceptance = block.timestamp + TIME_FOR_ACCEPTANCE;

        // We need to tell the applicant we are good
        address escrowAddress = chosenApplicant.escrowAddress;
        Escrow(escrowAddress).isAcceptedBy(address(this));

    }

    function registerApplicant(string memory _name, string memory _description,  uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[1] memory input) external {
        // First check the proof
        bool isProofValid = verifyProof(a, b, c, input);
        require(isProofValid, "Invalid proof");
        // Then 
        // require(TOKEN.balanceOf(msg.sender) > depositRequirement, "Deposit not sufficient"); // Maybe not the best way to do it
        Applicant memory applicant;
        applicant.escrowAddress = msg.sender;
        applicant.name = _name;
        applicant.description = _description;
        applicant.chosen = false;
        applicants.push(applicant);
    }

}