// State Variables
// Variables which are declared within a contract that retains their value across function calls. They represent the contract's storage and enable the persistent storage of data

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract StateVariables {
    
    //declaration of the variable which stores the value
    uint public num;

    //you need to send a transaction to write to a state variable
    function set(uint _num) public {
        num = _num;
    }

    //you can read from state variable without sending a transaction.
    function get() public view returns (uint) {
        return num;
    }
}

/*
Detailed Analysis of the Smart Contract
The provided `SimpleStorage` contract showcases the reading and writing of a state variable. Let’s take a closer look at its components:

1. State Variable:
— The contract includes a state variable named `num`, which is declared as a public unsigned integer (`uint public`).
— The `public` visibility modifier automatically generates a getter function for `num`.
— By default, the initial value of `num` is set to 0.

2. `set` Function:
— The `set` function allows us to update the value of `num` by accepting a parameter `_num` of type `uint`.
— The `public` visibility modifier enables both internal and external access to the function.
— Inside the function, the value of `_num` is assigned to `num`, thereby updating its value.

3. `get` Function:
— The `get` function enables us to read the current value of `num`.
— The function is declared as `public` and `view`.
— By calling the `get` function, we can retrieve the value of `num`.

By utilizing the `set` function, you can update the value of `num`, while the `get` function allows you to retrieve the stored value without incurring any transaction fees.
*/