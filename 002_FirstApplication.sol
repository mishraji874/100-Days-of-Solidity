//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Counter {
    // First we will declare the count variable and initalize its value to 0
    // Here, uint means unsigned integer
    uint public count = 0;

    // get(): A view function that returns the current value of the 'count' variable.
    function get() public view returns (uint) {
        return count;
    }

    // increment(): A function that increment the value of 'count' variable by 1.
    function increment() public {
        count += 1;
    }

    //decrement(): A function that decrements the value of 'count' by 1. If the value of the 'count' variable will be 0 then this function will fail.
    function decrement() public {
        count -= 1;
    }
}