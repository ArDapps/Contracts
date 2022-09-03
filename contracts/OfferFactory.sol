// SPDX-License-Identifier: GPL-3.0 license
pragma solidity ^0.8.16;

import "./interfaces/IOffer.sol";
import "./Offer.sol";
import "./Verifier.sol";

contract OfferFactory {
    struct OfferData {
        address offerContractAddress;
        string description;
        uint incomeRequirement;
        address owner;
    }

    OfferData[] offers;

    event NewOffer(address offerAddress);

    // mapping(address => bool) isOfferRunning; NOT HERE -> Considering that an offer is running while 
    // it is in the registry

    // Deploy a new offer verifier contract 
    function newOffer(string memory description, uint incomeRequirement, uint depositRequirement) external {
        // Deploy the contract
        Offer offerContract = new Offer(description,incomeRequirement,depositRequirement);

        // Create the offer
        OfferData memory newOffer;
        newOffer.offerContractAddress = address(offerContract);
        newOffer.description = description;
        newOffer.incomeRequirement = incomeRequirement;
        newOffer.owner = msg.sender;

        // Push the new offer on the array
        offers.push(newOffer);

        emit NewOffer(address(offerContract));
    }

    /// Add an existing offer verifier contract to the registry
    function addOffer(address offerContractAddress) external {
        // Fetch the infos from the verifier contract
        address ownerAddress = IOffer(offerContractAddress).owner();
        string memory description = IOffer(offerContractAddress).description();
        uint incomeRequirement = IOffer(offerContractAddress).incomeRequirement();

        // Create the offer
        OfferData memory newOffer;
        newOffer.offerContractAddress = offerContractAddress;
        newOffer.description = description;
        newOffer.incomeRequirement = incomeRequirement;
        newOffer.owner = ownerAddress;

        // Push the new offer on the array
        offers.push(newOffer);
    }

    // NEED TO HAVE A WAY OF REMOVING THE OFFERS
    function removeOffer(address offerContractAddress) external {

    }
}