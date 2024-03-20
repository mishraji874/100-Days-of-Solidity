//Delegatecall
//In the realm of Solidity, `delegatecall` is often likened to the `call` function, but it possesses a crucial distinction. While `call` executes the code of the called contract within its own context, 🤝 `delegatecall` executes the code of the called contract within the context of the calling contract. This means that when contract A performs a `delegatecall` to contract B, B’s code is executed using contract A’s storage, message sender, and value. This unique capability paves the way for powerful composability and code reuse patterns in Ethereum smart contracts.


//Contract B

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

//NOTE: Deploy this contract first

contract B {
    //NOTE: storage layout must be the same as contract A
    uint public num;
    address public sender;
    uint public value;
    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

//Contract A

contract A {
    uint public num;
    address public sender;
    uint public value;
    function setVars(address _contract, uint _num) public payable {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
        abi.encodeWithSignature("setVars(uint256)", _num));
    }
}

//Explanation: Contract A serves as the calling contract, utilizing `delegatecall` to execute the `setVars` function in Contract B. The function accepts the address of contract B and a new value for `num` as parameters. Notice that the storage variables in contract A have the same layout as in contract B, facilitating seamless data sharing between the contracts.


/*
Deep Dive into Delegatecall Usage

When `delegatecall` is invoked, the following series of steps takes place:

1️⃣ The `abi.encodeWithSignature` function is employed to generate the function signature and encode the parameters. In this case, it encodes the function signature `”setVars(uint256)”` and the `_num` parameter.

2️⃣ The encoded data is passed as an argument to the `delegatecall` function, along with the address of contract B.

3️⃣ The `delegatecall` function is executed, leading to the invocation of contract B’s code within the context of contract A. Consequently, contract B’s execution utilizes contract A’s storage, message sender, and value.

4️⃣ The return value of the `delegatecall` operation is captured in the `success` boolean variable and the `data` bytes variable. This enables contract A to determine the success of the `delegatecall` and access any returned data.

Notably, when using `delegatecall`, the code execution occurs in the context of the calling contract, but the called contract’s storage remains unmodified. Consequently, any changes made to storage variables within the called contract will be reflected in the calling contract.
*/


/*
Use Cases and Benefits 📚
Now that we have grasped the inner workings of `delegatecall`, let’s explore some practical use cases and the benefits it brings to the table:

1️⃣ Upgradable Contracts: 🔄 `delegatecall` empowers the implementation of upgradable contracts. By separating the storage and logic into distinct contracts, the logic contract can be updated while preserving the data stored in the storage contract.

2️⃣ Code Reusability: 🔄 `delegatecall` enables contracts to reuse existing code without the need for redeployment. Contracts can delegate the execution of specific functions to other contracts, harnessing pre-audited and battle-tested code.

3️⃣ Composability: 🔄 Contracts can leverage `delegatecall` to interact with other contracts and extend their functionality. This paves the way for the creation of intricate systems where different contracts seamlessly collaborate.

4️⃣ Efficient Function Calls: 🔄 `delegatecall` is more gas-efficient compared to `call`. By executing the code within the calling contract’s context, `delegatecall` circumvents expensive state changes, providing a cost-effective approach to execute external contract code.
*/



//Example 1: Upgradable Storage

contract Storage {
    uint public data;
}

contract Logic {
    address public storageContract;
    function setData(uint _data) public {
    (bool success, ) = storageContract.delegatecall(abi.encodeWithSignature("setData(uint256)", _data));
    }
}

//Explanation: In this example, the `Logic` contract delegates the execution of the `setData` function to the `Storage` contract. By changing the address of the `storageContract`, the logic contract can upgrade the storage contract while preserving the data stored in it.


// Example 2: Library Function Delegation

library Math {
    function add(uint a, uint b) external pure returns (uint) {
        return a + b;
    }
}
contract Calculator {
    using Math for uint;
    function addNumbers(uint _a, uint _b) public pure returns (uint) {
        return Math.add(_a, _b);
    }
}

//Explanation: In this example, the `Calculator` contract utilizes the `delegatecall` feature of libraries. The `Math` library provides an `add` function, which is delegated to by the `Calculator` contract. This approach allows the contract to leverage the functionality of the library without requiring separate deployment.