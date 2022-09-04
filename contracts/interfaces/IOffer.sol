// SPDX-License-Identifier: GPL-3.0 license
pragma solidity ^0.8.16;


interface IOffer {
    function owner() external view returns(address);
    function incomeRequirement() external view returns(uint);
    function description() external view returns(string memory);
    function registerApplicant(string memory _name, string memory _description,  uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[1] memory input) external;
}

interface IOfferFactory {
    struct OfferData {
        address offerContractAddress;
        string description;
        uint incomeRequirement;
        address owner;
    }

    function offers(uint index) external returns(OfferData memory);
}