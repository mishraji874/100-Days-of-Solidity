// Imports
//In the realm of software development, the principle of “Don’t Repeat Yourself” (DRY) is highly valued. It helps us avoid code duplication, reduce bugs, and improve code maintenance. Solidity’s import statement allows us to achieve these goals by seamlessly integrating external files into our smart contracts.


/*
Import syntax

1. Importing from llocal files: Tosimport solidity files that exist within our project directory, we can use either a relative or an absoulte path.

Ex:- import "./utils/StringUtils.sol"
     import "../contracts/Token.sol"

2.  Importing external packages: Solidity also allows us to import code from external packages or libraries, typically installed via package managers like npm or imported from popular Solidity package repositories. The import path in such cases usually includes the package name, followed by the file path. 

Ex:- import “openzeppelin/contracts/token/ERC20/ERC20.sol”;
*/


// Sample code snippets

//1. Importing local files

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "./Token.sol";

contract MyContract {
    Token private myToken;

    constructor() {
        myToken = new Token();
    }

    // Rest of the contract code…
}


//2. Importing externall libraries

import "openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyContract is ERC20 {
    constructor() ERC20("MyToken", "MTK") {
        // Additional initialization logic…
    }

 // Rest of the contract code…
}