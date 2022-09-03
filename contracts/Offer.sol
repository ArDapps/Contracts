// SPDX-License-Identifier: GPL-3.0 license
pragma solidity ^0.8.16;

import "./Verifier.sol";
import "./interfaces/IOffer.sol";

contract Offer is IOffer, Verifier {

    //Info displayed on the frontend
    address public owner;
    uint public incomeRequirement;
    string public description;

    //Applicants structure
    struct Applicant {
        address escrowAddress;
        string name;
        string description;
    }

    //List of the applicants that applied successfully
    Applicant[] public applicants;

    // One applicant is chosen at some point
    Applicant public chosenApplicant;
    bool public isApplicantChosen = false;

    // We choose the applicant via the index in the array
    function chooseApplicant(uint index) public {
        require(!isApplicantChosen, "Applicant already choosen");
        isApplicantChosen = true;
        chosenApplicant = applicants[index];
    }

    // WARNING TIME WINDOW NOT IMPLEMENTED

}