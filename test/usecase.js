const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("UseCase", function () {
  function parseEvent(txReceipt, contract, eventName) {
    const unparsedEv = txReceipt.logs.find(
      (evInfo) => evInfo.topics[0] == contract.filters[eventName]().topics[0]
    );
  
    const parsedEv = contract.interface.parseLog(unparsedEv);
  
    return parsedEv;
  }
  describe("UseCase1", function () {
    it("Should go through the use case without problems", async function () {
      const OfferFactory = await hre.ethers.getContractFactory("OfferFactory");
      offerFactory = await OfferFactory.deploy();
      await offerFactory.deployed();

      //Deploy new offer contract via the offer Factory
      tx = await offerFactory.newOffer("BLablablabla",3000,0);
      rc = await tx.wait();
      // Retrieve the address of the new contract in the event
      offerInstanceAddress = parseEvent(rc,offerFactory,"NewOffer").args[0];

      console.log(offerInstanceAddress);


      OfferInstance = await hre.ethers.getContractFactory("Offer");
      offerInstance = await OfferInstance.attach(offerInstanceAddress);

      // Now deploy new escrow contract via the Escrow Factory
      const EscrowFactory = await hre.ethers.getContractFactory("EscrowFactory");
      escrowFactory = await EscrowFactory.deploy();
      await escrowFactory.deployed();

      //Deploy new offer contract via the offer Factory
      tx = await escrowFactory.createNewEscrow("Benjamin","I am blablabla");
      rc = await tx.wait();

      // Retrieve the address of the new contract in the event
      escrowInstanceAddress = parseEvent(rc,escrowFactory,"NewEscrow").args[0];

      console.log(escrowInstanceAddress);

      EscrowContract = await hre.ethers.getContractFactory("Escrow");
      escrow = await EscrowContract.attach(escrowInstanceAddress);

      // NEED TO COMPILE PROOF BEFORE NEXT STEPS
      // a = require()
      

      // Now I apply to an offer via the Escrow
      // tx = await escrow.applyToOffer(0,a,b,c,input);
      // await tx.wait();


    });
  });
});
