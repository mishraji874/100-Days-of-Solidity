/*
Understanding Visibility: Unlocking the Different Levels 🔍
In Solidity, visibility acts as a gateway, governing who can interact with specific functions and state variables within a contract. There are four primary visibility levels to explore: public, private, internal, and external. Each level serves a unique purpose and offers distinct access permissions. Let’s unlock the secrets of these visibility levels one by one! 🔐

1️⃣ Private Visibility: Securing the Inner Sanctum 🤫

Private functions and state variables are like hidden treasures, accessible only within the contract that defines them. Their restricted access ensures that they remain confined within the boundaries of the contract, shielded from external interference. Contracts that inherit from the base contract containing private members cannot directly access them. Privacy is the name of the game when it comes to private visibility. 🙈

2️⃣ Internal Visibility: Sharing Secrets with the Inheritors 👥

The internal visibility level allows functions and state variables to be shared with the contract that defines them and any derived contracts. It forms a bridge of knowledge, granting access to the inner workings of a contract’s logic to its inheritors. This visibility level facilitates collaboration and seamless integration between contracts, enabling derived contracts to leverage and build upon the internal functionality. 🤝

3️⃣ Public Visibility: Opening the Gates to the World 🌍

Public functions and state variables are the global citizens of the Solidity world. They are accessible not only within the defining contract and derived contracts but also by external contracts and accounts. Public visibility breaks down barriers, promoting interoperability and enabling seamless interaction between contracts and external entities. It’s like throwing open the gates and inviting the world to engage with your contract’s functionalities. 🌐

4️⃣ External Visibility: Engaging in Secure Handshakes 🤝

The external visibility level is similar to public visibility in terms of accessibility to external contracts and accounts. However, it comes with an intriguing twist — external functions can only be called by external contracts and accounts. This level of visibility restricts internal access, ensuring a controlled and secure environment for contract interactions. External visibility is often used when contracts need to expose specific functionalities to other contracts or external accounts securely. 🔒
*/


// Base contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract Base {
    // Private function can only be called
    // - inside this contract
    // Contracts that inherit this contract cannot call this function.
    function privateFunc() private pure returns (string memory) {
        return "private function called";
    }
    function testPrivateFunc() public pure returns (string memory) {
        return privateFunc();
    }
    // Internal function can be called
    // - inside this contract
    // - inside contracts that inherit this contract
    function internalFunc() internal pure returns (string memory) {
        return "internal function called";
    }
    function testInternalFunc() public pure virtual returns (string memory) {
        return internalFunc();
    }
    // Public functions can be called
    // - inside this contract
    // - inside contracts that inherit this contract
    // - by other contracts and accounts
    function publicFunc() public pure returns (string memory) {
        return "public function called";
    }
    // External functions can only be called
    // - by other contracts and accounts
    function externalFunc() external pure returns (string memory) {
        return "external function called";
    }
    // This function will not compile since we're trying to call
    // an external function here.
    // function testExternalFunc() public pure returns (string memory) {
    // return externalFunc();
    // }
    // State variables
    string private privateVar = "my private variable";
    string internal internalVar = "my internal variable";
    string public publicVar = "my public variable";
    // State variables cannot be external so this code won't compile.
    // string external externalVar = "my external variable";
}

// Explanation: The `Base` contract demonstrates private, internal, public, and external functions and state variables. It also highlights the compilation errors that arise when trying to access external functions internally or declaring state variables as external.


// Child contract

contract Child is Base {
    // Inherited contracts do not have access to private functions
    // and state variables.
    // function testPrivateFunc() public pure returns (string memory) {
    // return privateFunc();
    // }
    // Internal function call be called inside child contracts.
    function testInternalFunc() public pure override returns (string memory) {
    return internalFunc();
    }
}

// Explanation: The `Child` contract extends the `Base` contract, inheriting its visibility-restricted functions. It showcases how internal functions can be accessed and overridden in derived contracts, while private functions and state variables remain inaccessible.