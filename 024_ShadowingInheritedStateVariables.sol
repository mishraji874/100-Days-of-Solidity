// Shadowing
// When a contract inherits another contract, it inherits both its functions and state variables. However, if the child contract declares a state variable with the same name as the parent variable, it does not actually override the original variable.


// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract A {
    string public name = "Contract A";
    function getName() public view returns (string memory) {
        return name;
    }
}

contract C is A {
    constructor() {
        name = "Contract C";
    }

    // C.getName(); returns "Contract C"
}

//Explanation: In this example, Contract C overrides the inherited `name` state variable correctly. Inside the constructor of Contract C, we simply assign a new value to `name` using the statement `name = “Contract C”;`. Consequently, when we create an instance of Contract C, the value of `name` will be “Contract C”. By following this approach, we can successfully override inherited state variables and achieve the desired behavior in our smart contracts.


// Sample Code to Solidify the Concept
/*
1. Shadowing with Different Variable Type:

contract A {
    uint256 public number = 42;
    function getNumber() public view returns (uint256) {
        return number;
    }
}
contract D is A {
    constructor() {
    number = 24;
    }
    // D.getNumber returns 24
}

Explanation: In this example, contract D inherits the `number` state variable from contract A and shadows it with a new value. Although the variable type has changed to `uint256`, the concept of shadowing remains the same. Contract D assigns the value 24 to `number` inside its constructor. Consequently, when we call `D.getNumber()`, it returns the overridden value 24.


2. Shadowing with Modifier:

contract E is A {
    constructor() {
    name = "Contract E";
    }
    modifier overrideName() {
        name = "Modified Name";
    _  ;
    }
    function getName() public view overrideName returns (string memory) {
        return name;
    }
}
In this example, contract E overrides the `getName()` function inherited from contract A. The `overrideName` modifier is used to modify the behavior of the function. Inside the modifier, we assign a new value “Modified Name” to `name`. When we call `E.getName()`, it returns the overridden value “Modified Name”.
*/