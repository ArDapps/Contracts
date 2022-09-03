// SPDX-License-Identifier: GPL-3.0 license
pragma solidity ^0.8.16;

import "./Verifier.sol";
import "./interfaces/IOffer.sol";
import "./interfaces/IEscrow.sol";

contract Offer is IOffer, Verifier {

    //Info displayed on the frontend
    address public owner;
    uint public incomeRequirement;
    string public description;

    // Time for approval
    uint constant TIME_FOR_ACCEPTANCE = 3 days;

    //Applicants structure
    struct Applicant {
        address escrowAddress;
        string name;
        string description;
    }

    //List of the applicants that applied successfully
    Applicant[] public applicants;

    // One applicant is chosen at some point OR WE CAN PUT THAT IN THE APPLICANT STRUCT
    Applicant public chosenApplicant;
    bool public isApplicantChosen = false;
    uint deadlineForAcceptance;

    // We choose the applicant via the index in the array
    function chooseApplicant(uint index) public {
        require(!isApplicantChosen, "Applicant already choosen");
        isApplicantChosen = true;
        chosenApplicant = applicants[index];
        deadlineForAcceptance = block.timestamp + TIME_FOR_ACCEPTANCE;
    }

    function registerApplicant(string memory _name, string memory _description,  uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[10] memory input) external {
        bool isProofValid = verifyProof(a, b, c, input);
        require(isProofValid, "Invalid proof");
        Applicant memory applicant;
        applicant.escrowAddress = msg.sender;
        applicant.name = _name;
        applicant.description = _description;
        applicants.push(applicant);
    }

}