pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/bitify.circom";
include "../../node_modules/circomlib/circuits/poseidon.circom";

template IncomeVerification() {
    // Public inputs
    signal input incomeRequirement;
    signal input income;

    component greaterThan = GreaterThan(32);
    greaterThan.in[0] <== income;
    greaterThan.in[1] <== incomeRequirement;
    greaterThan.out === 1;
 }

 component main {public [incomeRequirement]} = IncomeVerification();