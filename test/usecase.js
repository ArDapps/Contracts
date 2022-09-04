const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

const { groth16} = require("snarkjs");

const wasm_tester = require("circom_tester").wasm;


const snarkjs = require('snarkjs')
const fs = require('fs')

const wc = require('/home/ben/ethwarsaw/Contracts/contracts/circuits/circuit_js/witness_calculator.js')
const wasm = '/home/ben/ethwarsaw/Contracts/contracts/circuits/circuit_js/circuit.wasm'
const zkey = '/home/ben/ethwarsaw/Contracts/contracts/circuits/circuit_final.zkey'
const INPUTS_FILE = '/tmp/inputs'
const WITNESS_FILE = '/tmp/witness'


const inputSignals = { "incomeRequirement": [100], "income": [200] }
// const inputSignals = { "in" : 500}


const generateWitness = async (inputs) => {
  const buffer = fs.readFileSync(wasm);
  const witnessCalculator = await wc(buffer)
  const buff = await witnessCalculator.calculateWTNSBin(inputs, 0);
  fs.writeFileSync(WITNESS_FILE, buff)
}



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
      escrowFactory = await EscrowFactory.deploy(offerFactory.address);
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
      

      // const circuit = await wasm_tester("contracts/circuits/circuit.circom");
      // await circuit.loadConstraints();
      // const witness = await circuit.calculateWitness(inputSignals, true);


      // ###PROOF####
      
      

       // replace with your signals
      await generateWitness(inputSignals)
      const { proof, publicSignals } = await snarkjs.groth16.prove(zkey, WITNESS_FILE);
      // console.log(proof)
      
      // const { proof, publicSignals } = await groth16.fullProve({"incomeRequirement":5000,"income":10000}, "contracts/circuits/circuit_js/circuit.wasm","contracts/circuits/circuit_final.zkey");
        
      // We retrieve the parameterized calldata from the proof and signals to be able to call the smart contract verifier with the correct data.
      const calldata = await groth16.exportSolidityCallData(proof, publicSignals);
      // console.log(calldata)
      // Doing some formatting to get an array of strings from the array of arrays of bigNumbers that we have in calldata
      const argv = calldata.replace(/["[\]\s]/g, "").split(',').map(x => BigInt(x).toString());
      console.log(argv)
      //The next lines are the creation of the correct parameters for the contract call
      const a = [argv[0], argv[1]];
      const b = [[argv[2], argv[3]], [argv[4], argv[5]]];
      const c = [argv[6], argv[7]];
      const Input = argv.slice(8);

      // Contract call to verify the proof
      expect(await offerInstance.verifyProof(a, b, c, Input)).to.be.true;
      

      //Now I apply to an offer via the Escrow
      tx = await escrow.applyToOffer(0,a,b,c,Input);
      // tx = await escrow.applyToOffer(0,[1,1],[[2,2],[2,2]],[2,2],[1]);
      await tx.wait();
      

      // Now the landlord accept the applicant
      tx = await offerInstance.chooseApplicant(0);
      await tx.wait();

      // appliedOffer = await offerFactory.getAddressOfOffer(0);
      chosenApplicant = await offerInstance.chosenApplicant();
      console.log("Chosen Applicant is ", chosenApplicant)



    });
  });
});
