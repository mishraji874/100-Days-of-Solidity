// Understanding mappings
// In solidity, mapping are created using the syntax 'mapping(keyType => valueType)'. Mapping provides an efficient wway to associate values with unique keys and retrieve them later with ease.

// Creating a simple mapping

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Mapping {

    //mapping from address to uint
    mapping(address => uint) public myMap;

    function get(address _addr) public view returns (uint) {
        // mapping always returns a value.
        // if the value was not never set, it will return the default value.
        return myMap[_addr];
    }

    function set(address _addr, uint _i) public {
        // update the value at this address
        myMap[_addr] = _i;
    }

    function remove(address _addr) public {
        // reset the value to tthe default value
        delete myMap[_addr];
    }
}

//Explanation: In this `Mapping` contract, we have defined a mapping named `myMap` that maps addresses (`address`) to unsigned integers (`uint`). The `get` function allows us to retrieve the value associated with a specific address. If the value was never set for that address, it will return the default value of `uint`, which is 0. The `set` function updates the value at a given address, and the `remove` function resets the value to the default value.



// Creating a Nested Mappings

contract NestedMapping {
    //nested mapping (mapping from address to another mapping)
    mapping(address => mapping(uint => bool)) public nested;

    function get(address _addr1, uint _i) public view returns (bool) {
        return nested[_addr1][_i];
    }

    function set(address _addr1, uint _i, bool _boo) public {
        nested[_addr1][_i] = _boo;
    }

    function remove(address _addr1, uint _i) public {
        delete nested[_addr1][_i];
    }
}

//Explanation: In the `NestedMapping` contract, we have introduced a nested mapping named `nested`. It maps addresses (`address`) to another mapping, which, in turn, maps unsigned integers (`uint`) to booleans (`bool`). This allows for a two-dimensional storage structure, enabling efficient access to values based on both the address and the integer index.



/*
Analyzing the Smart Contracts:

The `Mapping` contract:
The `Mapping` contract demonstrates a basic mapping usage scenario. It includes three functions:

1. `get`: This function takes an address `_addr` as a parameter and returns the associated unsigned integer value stored in the `myMap` mapping. If no value is set for the given address, it will return the default value of `uint`, which is 0.

2. `set`: The `set` function allows users to update the value at a specific address `_addr` in the `myMap` mapping. It takes a uint `_i` as the new value and assigns it to the corresponding address.

3. `remove`: With the `remove` function, users can reset the value at a given address `_addr` in the `myMap` mapping. It deletes the value, setting it back to the default value of `uint`, which is 0.

The `NestedMapping` contract:
The `NestedMapping` contract demonstrates the usage of nested mappings. It includes three functions:

1. `get`: This function takes an address `_addr1` and an unsigned integer `_i` as parameters and returns the boolean value associated with the nested mapping `nested`. Even if the nested mapping is not initialized, Solidity will return the default value of `bool`, which is `false`.

2. `set`: The `set` function allows users to update the boolean value in the nested mapping `nested`. It takes an address `_addr1`, an unsigned integer `_i`, and a boolean `_boo` as parameters, and assigns the boolean value to the corresponding address and integer index.

3. `remove`: The `remove` function deletes the boolean value at a specific address `_addr1` and unsigned integer `_i` in the nested mapping `nested`. The deleted value will revert to the default value of `bool`, which is `false`.
*/