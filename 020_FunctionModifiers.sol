// Restricting Access with Modifiers

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract FunctionModifiers {
    address public owner;
    uint public x = 10;
    bool public locked;
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    // Rest of the contract
}

// Explanation: Here the 'onlyOwner' modifier checks whether the caller of a function is the owner of the contract. If the condition fails, the function call will revert with the error message "Not owwner". The undersocre symbol within the modifier indicates where the remaining function code should execute.


/*
To apply the 'onlyOwner' modifier to the function, simply place it before the function definition

Ex:- function changeOwner(address _newOwner) public onlyOwner {
    owner = _newOwner;
}

Now, only the contract owwwner can call the 'changeOwner' function and update the 'owner' variable.
*/


/*
Validating Inputs with Modifiers

Modifiers in Solidity can also accept inputs and perform validations on them. Consider the `validAddress` modifier within the `FunctionModifier` contract: 


modifier validAddress(address _addr) {
require(_addr != address(0), “Not valid address”);
_;
}

This modifier ensures that the provided address is not the zero address. If the condition fails, the function call will revert with the error message “Not valid address.” Once again, the `_` symbol indicates where the remaining function code should execute.

To utilize the `validAddress` modifier, include it as a parameter in the function definition:


function changeOwner(address _newOwner) public onlyOwner validAddress(_newOwner) {
owner = _newOwner;
}


Hence, before executing the `changeOwner` function, the `validAddress` modifier will validate the `_newOwner` address to ensure it is not the zero address. This enhances the reliability and integrity of our smart contracts by preventing unintended operations. 
*/


/*
Guarding Against Reentrancy Attacks

Reentrancy attacks represent a serious vulnerability, wherein a malicious contract repeatedly calls back into a vulnerable contract before the previous call completes. Solidity modifiers come to our aid in guarding against such attacks by preventing reentrant function calls.

Within the `FunctionModifier` contract, the `noReentrancy` modifier achieves this protection: 


modifier noReentrancy() {
require(!locked, “

No reentrancy”);

locked = true;
_;
locked = false;
}


The `locked` variable keeps track of the reentrancy state. When a function with the `noReentrancy` modifier is called, it checks whether `locked` is `false`. If `true`, the function call will revert with the error message “No reentrancy.” Otherwise, the `locked` state is set to `true`, the remaining function code executes (`_`), and finally, the `locked` state is reset to `false`.

Let’s examine the `decrement` function in the `FunctionModifier` contract to illustrate the practical usage of the `noReentrancy` modifier: 


function decrement(uint i) public noReentrancy {
x -= i;

if (i > 1) {
decrement(i — 1);
}
}


The `decrement` function subtracts `i` from the `x` variable. If `i` is greater than 1, the function recursively calls itself with `i — 1` as the argument. The `noReentrancy` modifier ensures that no reentrant calls can occur during the execution of the `decrement` function, thus mitigating any potential reentrancy vulnerabilities. 
*/


// Analyzing and Comparing Smart Contracts
/*
The `FunctionModifier` contract exemplifies the use of modifiers for access control (`onlyOwner`), input validation (`validAddress`), and guarding against reentrancy attacks (`noReentrancy`). These modifiers introduce an additional layer of security and control to the contract’s functions.

By employing the `onlyOwner` modifier, the contract effectively restricts certain operations to the contract owner exclusively. This prevents unauthorized access and ensures that critical functions can only be executed by the owner.

The `validAddress` modifier helps prevent the usage of invalid addresses, which could lead to unexpected behavior or even loss of funds. This validation ensures that operations involving addresses are executed with valid inputs, thereby safeguarding the integrity of the contract.

The `noReentrancy` modifier serves as a protective shield against reentrancy attacks by locking the function during execution. This preventive measure halts any potential recursive calls that could exploit vulnerable state changes.

Overall, the `FunctionModifier` contract demonstrates exemplary practices for access control, input validation, and protection against reentrancy attacks. It provides a robust foundation for building secure and reliable smart contracts.
*/