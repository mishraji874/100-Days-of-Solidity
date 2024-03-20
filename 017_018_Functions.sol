// Functions
/*
Two types:
1. View functions: These functions are used to retireve and return data from the function without modifying the state of the contract. These functions are used to provide read-only access to the contract's state variables.

2. Pure functions: These functions not only do not modify the state, but they also do not read or access any state variables. Pure functions are entirely self-contained and rely only on the input parameters provided to them.
*/


// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Functions {
    uint public x = 1;
    
    //In the above contract, the function `addToX` is declared as a view function. It takes a parameter `y` and returns the sum of `x` and `y`. Since the function is marked as “view,” it does not modify the state of the contract and can be safely called from other contracts or read by external applications.
    function addToX(uint y) public view returns (uint) {
        return x + y;
    }


    //In the above contract, the function `add` is declared as a pure function. It takes two parameters `i` and `j` and returns their sum. Since the function is marked as “pure,” it doesn’t read or modify any state variables. Pure functions are deterministic, meaning that given the same input, they will always produce the same output. They can be executed locally without interacting with the blockchain, making them more efficient than view functions.
    function add(uint i, uint j) public pure returns (uint) {
        return i + j;
    }
}


/*
Benefits of Using View and Pure Functions 💡
1️⃣ Security: By explicitly declaring functions as view or pure, you provide clarity to other developers and auditors regarding the intended behavior of the function. This helps prevent unintentional modifications to the state and minimizes the risk of introducing vulnerabilities.

2️⃣ Gas Efficiency: View and pure functions do not require transactions to be executed on the blockchain. As a result, they do not consume any gas, making them more cost-effective when retrieving data or performing computations.

3️⃣ Code Reusability: View and pure functions can be called by other functions within the same contract or by external contracts. This promotes code reusability and modular design, as these functions can be used in multiple contexts without concerns about state modifications.

4️⃣ Optimization: Since pure functions are entirely self-contained and do not rely on external variables, they can be optimized by the compiler more aggressively. This can lead to improved performance and reduced gas costs.
*/