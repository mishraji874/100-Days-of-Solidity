// Constructor
// A constructor is a special function that shares the same name as the contract itself. When a contract is deployed, the constructor is executed only once to initialize the contract's state variables.

/*
Initializing Parent Contracts

In Solidity, contracts can inherit from other contracts, creating a parent-child relationship. When a derived contract is created, the constructors of both the derived contract and its parent contracts are executed. There are two primary methods to initialize parent contracts with parameters: using the inheritance list and the derived contract’s constructor.

1️⃣ Initializing Parent Contracts in the Inheritance List

One way to initialize parent contracts is by specifying the constructor arguments in the inheritance list. Let’s consider the contract `B` as an example. By using `X(“Input to X”)` and `Y(“Input to Y”)` in the inheritance list, we pass the required arguments to the constructors of the parent contracts `X` and `Y` respectively.


contract B is X(“Input to X”), Y(“Input to Y”) {
// …
}


2️⃣ Initializing Parent Contracts in the Derived Contract’s Constructor

Another method involves initializing parent contracts directly within the derived contract’s constructor. In contract `C`, we initialize the parent contracts `X` and `Y` by passing the arguments directly in the constructor using the syntax `X(_name)` and `Y(_text)`.


contract C is X, Y {
constructor(string memory _name, string memory _text) X(_name) Y(_text) {
// …
}
}

*/


/*
Analyzing the Order of Constructors
When a derived contract initializes parent contracts, the order of constructor execution follows the order of inheritance, regardless of the order of parent contracts listed in the constructor of the child contract. Let’s examine contracts `D` and `E` to understand this concept better.

In contract `D`, the constructors are called in the following order: `X` constructor, `Y` constructor, and finally, the `D` constructor itself.


contract D is X, Y {
constructor() X(“X was called”) Y(“Y was called”) {
// …
}
}


In contrast, in contract `E`, the order of constructor calls is reversed compared to the order in the contract definition. The `Y` constructor is called before the `X` constructor.


contract E is X, Y {
constructor() Y(“Y was called”) X(“X was called”) {
// …
}
}


*/


/*
More Content:

1️⃣ Constructor Overloading:

Similar to function overloading, Solidity allows constructors to be overloaded, providing different initialization options for contracts.

2️⃣ Modifiers and Constructor Visibility:

Constructors can have visibility modifiers such as `public`, `private`, `internal`, and `external`. Properly specifying the visibility ensures that the constrsuctor is accessible as intended.

3️⃣ Constructor Arguments and Security Considerations:

When passing arguments to constructors, it is vital to validate and sanitize inputs to prevent potential security vulnerabilities, such as reentrancy attacks or integer overflows.
*/