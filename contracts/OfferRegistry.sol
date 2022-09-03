// SPDX-License-Identifier: GPL-3.0 license
pragma solidity ^0.8.16;

import "./interfaces/IOffer.sol";

contract OfferRegistry {
    struct Offer {
        address offerContractAddress;
        string description;
        uint incomeRequirement;
        address owner;
    }

    Offer[] offers;

    // mapping(address => bool) isOfferRunning; NOT HERE -> Considering that an offer is running while 
    // it is in the registry

    /// Add an existing offer verifier contract to the registry
    function addOffer(address offerContractAddress) external {
        // Fetch the infos from the verifier contract
        address ownerAddress = IOffer(offerContractAddress).owner();
        string memory description = IOffer(offerContractAddress).description();
        uint incomeRequirement = IOffer(offerContractAddress).incomeRequirement();

        // Create the offer
        Offer memory newOffer;
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