// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Conditionals {

    // the 'foo' function takes an argument 'x'and returns a uint value. It uses if/else statement to determine the appropriate return value based on the value of 'x'. If 'x' is less than 10, it returns 0. If 'x' is between 10 and 20, it returns 1. Otherwise, it returns 2.
    function foo(uint x) public pure returns (uint) {
        if(x < 10) {
            return 0;
        } else if( x < 20) {
            return 1;
        } else {
            return 2;
        }
    }


    // the 'ternary' function also takes an argument 'x' and returns a uint value. It demonstrates an alternative way to write if/else statements using the ternary operators. The ternary operator, represeneted by the "?" symbol, allows us to write concise if/else statements in a single line.
    function ternary(uint x) public pure returns (uint) {
        return x < 10 ? 1 : 2;
    }
}