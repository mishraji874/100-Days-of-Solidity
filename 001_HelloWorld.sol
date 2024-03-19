// Code Structure

/* 
1. License identifier declaration: On the first line we have to declare about the license on which we are allowwed to write the code.
The most used one is - SPDX-License-Identifier: MIT


2.. Pragma directive: It is the starting point of the contract. It specifies the compiler versions to be used. Like 0.8.17, ^0.8.17, >= 0.8.17, etc.

3. Contract Declaration: Next we declare the contract using the keyword 'contract' followed by the copntract name. Contracts serve as the building blocks of smart contracts, encapsulating functinaliy and data into reusable units.

4. State Variable: Inside the contract, we will define a state variable which maybe of any name. State variables hold data that persists throughout the contract's lifetime. So, now here a new keyword 'public' is used to use that state variable everywhere in the code and also outside of the contractr, allowing us to read its value.

4. Initialization: Next, we will initialize that variable to some value and start reading and writing and viewing the value.
*/

// Techincal Deep Dive

/*
1. Solidity Versioning:
Solidity is a rapidly evolving language, and maintaining compatibility with different compiler versions is crucial. By specifying the pragma directive, we ensure that our contract is compiled using a specific version of the Solidity compiler. This helps avoid potential issues caused by breaking changes in newer compiler versions.

2. Data Types:
Solidity provides various data types to accommodate different needs. In our example, we used the “string” data type to store the greeting message. Solidity also supports other primitive types such as integers, booleans, addresses, and more. Understanding these data types is essential for building robust and efficient smart contracts.

3. Visibility Modifiers:
By using the “public” visibility modifier, we expose the state variable “greet” to the outside world. Solidity provides several visibility modifiers, including public, private, internal, and external, which control the accessibility of variables and functions. Properly defining visibility is crucial for security and encapsulation.

4. Contract Deployment and Interaction:
Once we’ve written our Solidity contract, we need to deploy it to a blockchain network. This allows users to interact with the contract’s functions and access its data. Deploying a contract involves compiling the Solidity code, generating a bytecode representation, and deploying it to the desired blockchain network using tools like Remix or Truffle.

*/

// Our Hello World contract

//SPDX-LIcense-Identifier: MIT

pragma solidity ^0.8.0;

contract HelloWorld {
    string public greeting;

    constructor() {
        greeting = "Hello World";
    }

    function setGreeting(string memory _greeting) public {
        greeting = _greeting;
    }

    function getGreeting() public view returns (string memory) {
        return greeting;
    }
}