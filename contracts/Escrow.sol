// SPDX-License-Identifier: GPL-3.0 license
pragma solidity ^0.8.16;

contract ZKRent_Escrow {
    struct Offer {
        string title;
        uint256 id;
        uint256 timestampListed;
        uint256 timestampApplied;
        address beneficiary;
        uint256 amountForEscrow;
    }

    mapping (uint256 => Offer) offerIDtoOffer;

    function applyToOffer(uint256 _offerID) public {
        fund(_offerID);
    }

    function fund(uint256 _offerID) public {
        
    }
}