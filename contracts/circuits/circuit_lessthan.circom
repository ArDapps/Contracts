pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";

template LessThan10() {
    signal input in;
    // signal output out;

    component lt = LessThan(4); 

    lt.in[0] <== in;
    lt.in[1] <== 10;

    lt.out === 1;
}

component main{public [in]} = LessThan10();