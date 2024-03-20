// Inheritance
// Contracts can inherit from one or more parent contracts, thereby acquiring their state variables and functions. The keyword "is" is used to specify inheritance relationships between contracts.


/* Graph of inheritance
 A
 / \
 B C
 / \ /
F D,E
*/

// SPDX_license-Identifier: MIT

pragma solidity ^0.8.17;

contract A {
    function foo() public pure virtual returns (string memory) {
        return "A";
    }
}

contract B is A {
    function foo() public pure virtual override returns (string memory) {
        return "B";
    }
}

contract C is A {
    function foo() public pure virtual override returns (string memory) {
        return "C";
    }
}

contract D is B, C {
    function foo() public pure virtual override(B, C) returns (string memory) {
        return super.foo();
    }
}

contract E is C, B {
    function foo() public pure virtual override(C, B) returns (string memory) {
        return "B";
    }
}

contract F is A, B {
    function foo() public pure virtual override(A, B) returns (string memory) {
        return super.foo();
    }
}

// Explanation: In the above example, contract A is the base contract, while contracts B and C inherit from A. Contract D inherits from both B and C, and contract E inherits from C and B. Finally, contract F inherits from A and B. Order of inheritance is important because it determines the order in which function implementations are searched when a function is called. The search starts from the rightmost parent contract and proceeds in a depth-first manner.

/*
Function Overriding and Virtual Functions
Inheritance allows child contracts to override functions inherited from parent contracts. To enable function overriding, the parent function must be declared as virtual, and the child function must use the “override” keyword. This mechanism ensures that the child contract provides its implementation of the function.

In the example above, contracts B and C both override the foo() function inherited from contract A. The “override” keyword explicitly indicates that these functions are intended to override their parent implementations.

Additionally, the “virtual” keyword in contract A’s foo() function signifies that it is designed to be overridden by child contracts. It allows the function to be defined in a parent contract and overridden in derived contracts.
*/

/*
Analyzing and Comparing the Smart Contracts
Now, let’s analyze, compare, and comment on the smart contracts provided in the example. We’ll go contract by contract to understand their behavior and the output of the foo() function.

Contract A:

Contract A defines a virtual function foo(), which returns the string “A”. Being the base contract, it serves as the starting point for inheritance in the contract hierarchy.

Contract B:

Contract B inherits from contract A using the “is” keyword. It overrides the foo() function and returns the string “B”. Thus, calling foo() on contract B will result in the output “B”.

Contract C:

Contract C also inherits from contract A and overrides the foo() function. It returns the string “C” when foo() is called on contract C.

Contract D:

Contract D inherits from both contracts B and C. It overrides the foo() function, explicitly specifying the order of the parent contracts using the “override” keyword. In this case, foo() returns the result of calling super.foo(), which resolves to contract C’s implementation. Therefore, calling foo() on contract D will output “C”.

Contract E:

Contract E has a similar inheritance structure as contract D but with the order of parent contracts reversed. When foo() is called on contract E, it returns the output of super.foo(), which refers to contract B’s implementation. Hence, the output will be “B”.

Contract F:

Contract F inherits from contracts A and B. When foo() is called on contract F, it returns the output of super.foo(), which points to contract B’s implementation. Consequently, calling foo() on contract F will produce the output “B”.
*/