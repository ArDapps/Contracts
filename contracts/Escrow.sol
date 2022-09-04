// SPDX-License-Identifier: GPL-3.0 license
pragma solidity ^0.8.16;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./Offer.sol";
import "./Escrow.sol";
import "./OfferFactory.sol";
import "./EscrowFactory.sol";

contract Escrow {

    // Public Personnal details
    string name;
    string selfDescription;

    // Ownership via address:
    address owner;
    
    address escrowFactory;

    IERC20 TOKEN = IERC20(0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83);

    address offerAcceptedBy;
    bool acceptedByAnOffer;

    constructor(string memory _name, string memory _selfDescription, address _owner, address _escrowFactory) {
        escrowFactory = _escrowFactory;
        name = _name;
        selfDescription = _selfDescription;
        owner = _owner;
    }

    function applyToOffer(uint256 _offerID, uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[1] memory input) public {
        address offerAddress = OfferFactory(EscrowFactory(escrowFactory).offerFactoryAddress()).getAddressOfOffer(_offerID);
        
        // registration on the offer, the verification is done on the offer side.
        Offer(offerAddress).registerApplicant(name,selfDescription, a,b,c,input);
    }

    // TODO The locking of the funds on the escrow

    function addFundsToEscrow(uint amount) public {
        TOKEN.transferFrom(msg.sender, address(this), amount);
    }

    function isAcceptedBy(address _offerAddress) public {
        acceptedByAnOffer = true;
        offerAcceptedBy = _offerAddress;
    }


    

}