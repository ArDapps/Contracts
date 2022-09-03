// SPDX-License-Identifier: GPL-3.0 license
pragma solidity ^0.8.16;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/IOffer.sol";

contract ZKRent_Escrow {

    // Public Personnal details
    string name;
    string selfDescription;


    struct Offer {
        string title;
        uint256 id;
        uint256 timestampListed;
        uint256 timestampApplied;
        address beneficiary;
        uint256 amountForEscrow;
        address offerAddress;
    }

    IERC20 DAI;

    uint256[] ids;
    mapping (uint256 => Offer) offerIDtoOffer;

    constructor(address _DAIAddress, string memory _name, string memory _selfDescription) {
        DAI = IERC20(_DAIAddress);
        name = _name;
        selfDescription = _selfDescription;
    }

    function applyToOffer(uint256 _offerID, uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[10] memory input) public {
        Offer memory offerToApply = offerIDtoOffer[_offerID];
        
        // registration on the offer, the verification is done on the offer side.
        IOffer(offerToApply.offerAddress).registerApplicant(name,selfDescription, a,b,c,input);
    }

    // TODO The locking of the funds on the escrow



}