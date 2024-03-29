/*
Understanding Solidity Storage 🗃️

Before we delve into the world of assembly, let’s first understand Solidity storage and how it operates. Solidity storage can be thought of as an array with an incredibly large length of 2²⁵⁶, where each slot in the array can store 32 bytes of data. State variables in Solidity are automatically stored in this storage array, with the order of declaration and variable types determining which slots will be used.

For example, consider the following Solidity code snippet:

contract StorageExample {
    uint256 public data1;
    uint256 public data2;
    uint256 public data3;
}
In this contract, `data1`, `data2`, and `data3` will occupy consecutive slots in the storage array. The first slot will store `data1`, the second slot will store `data2`, and the third slot will store `data3`.

Introduction to Assembly in Solidity 🛠️

Solidity supports inline assembly, allowing you to write low-level code that directly interacts with the Ethereum Virtual Machine (EVM). This provides developers with more control and flexibility over the contract’s behavior. Although inline assembly is powerful, it comes with increased risks and should be used with caution. When used properly, assembly can optimize gas costs and enable advanced functionality not achievable with pure Solidity code.

Let’s take a quick look at the basic structure of Solidity inline assembly:

assembly {
 // Assembly code goes here
}
Inside the assembly block, we can write EVM instructions using a syntax similar to other assembly languages. But don’t worry, we won’t dive into the intricate details of EVM opcodes in this article; instead, we’ll focus on using assembly to write to any slot in Solidity storage. 😎
*/

/*
Step 1: Calculating the Slot Number 🔢

slotNumber = keccak256(abi.encodePacked(key)) >> 5
Where `key` is a unique identifier for the state variable (e.g., its name as a string). The `keccak256` function calculates the 256-bit (32-byte) Keccak-256 hash of the `abi.encodePacked` value, and then we shift right by 5 bits (dividing by 32) to get the slot number.
*/

/*
Step 2: Writing to the Slot using Assembly ✍️


contract WriteToAnySlotExample {
    uint256 public data;
    function writeToSlot(uint256 slot, uint256 value) public {
        assembly {
            // Calculate the storage position
            let storagePosition := add(slot, 1)
            // Write the value to the specified slot
            sstore(storagePosition, value)
        }
    }
}
In this example, we have a state variable `data`, and the `writeToSlot` function takes two parameters: `slot` and `value`. The `slot` parameter represents the slot number where we want to write the data, and the `value` parameter is the data we want to store.
*/

/*
Step 3: Putting It All Together 🔄

contract WriteToAnySlotExample {
    uint256 public data;
    function writeToSlot(uint256 slot, uint256 value) public {
        assembly {
            // Calculate the storage position
            let storagePosition := add(slot, 1)
            // Write the value to the specified slot
            sstore(storagePosition, value)
        }
    }
    function readData() public view returns (uint256) {
        return data;
    }
}
In this example, we have a state variable `data`, and the `writeToSlot` function allows us to write data to any slot. The `readData` function simply returns the value of `data`, allowing us to verify that the writing process was successful.
*/

/*
Security Considerations and Best Practices 🔒
While writing to any slot in Solidity storage can be a powerful tool, it also comes with significant security risks. Using assembly incorrectly can lead to unintended behavior, contract vulnerabilities, and loss of user funds. Therefore, it’s essential to follow best practices and exercise caution when using assembly:

1. Double-Check Slot Numbers: Ensure that you calculate the correct slot numbers for your state variables. Mistakenly writing data to the wrong slot can lead to unexpected results.

2. Gas Usage: Writing to any slot directly in assembly might result in higher gas costs compared to the Solidity compiler’s optimized storage allocation. Be mindful of the gas implications.

3. Avoid Overwriting Critical Data: Make sure you are not overwriting any critical data or contract state, as this can lead to irrecoverable consequences.

4. Extensive Testing: Thoroughly test your contract, especially when using assembly. Ensure it behaves as expected and doesn’t introduce vulnerabilities.
*/


//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

library StorageSlot {
    struct AddressSlot {
        address value;
    }

    function getAddressSlot(
        bytes32 slot
    ) internal pure returns (AddressSlot storage pointer) {
        assembly {
            //get the pointer to AddressSlot stored at slot
            pointer.slot := slot
        }
    }
}

contract TestSlot {
    bytes32 public constant TEST_SLOT = keccak256("TEST_SLOT");

    function write(address _addr) external {
        StorageSlot.AddressSlot storage data = StorageSlot.getAddressSlot(TEST_SLOT);
        data.value = _addr;
    }

    function get() external view returns (addreess) {
        StorageSlot.AddressSlot storage data = StorageSlot.getAddressSlot(TEST_SLOT);
        return data.value;
    }
}


/*
Explanation:
1. The code starts with SPDX-License-Identifier and pragma statements to specify the license and version of Solidity.

2. The `StorageSlot` library is defined to provide utility functions related to storage slots. It includes a struct `AddressSlot` that wraps an address, allowing it to be passed around as a storage pointer.

3. The `getAddressSlot` function in the `StorageSlot` library is internal and pure, meaning it can only be used within the contract and does not modify the contract’s state. It takes a `bytes32` slot as input and returns a storage pointer to the `AddressSlot` struct stored at that slot. The function uses assembly to read the storage pointer.

4. The `TestSlot` contract defines a public constant `TEST_SLOT` of type `bytes32`, which is initialized with the Keccak-256 hash of the string “TEST_SLOT”. This constant represents the slot where the address will be stored.

5. The `write` function in the `TestSlot` contract is external, meaning it can be called from outside the contract. It takes an address `_addr` as input and writes it to the storage slot represented by `TEST_SLOT`. To do this, it first obtains a storage pointer to the `AddressSlot` struct using the `getAddressSlot` function from the `StorageSlot` library and then sets the `value` field of the struct to the input address `_addr`.

6. The `get` function in the `TestSlot` contract is also external and returns an address. It reads the address stored in the storage slot represented by `TEST_SLOT` and returns it. Similar to the `write` function, it obtains a storage pointer to the `AddressSlot` struct using the `getAddressSlot` function and then retrieves the `value` field to return the address stored in the slot.

How it Works:
The `StorageSlot` library allows the `TestSlot` contract to write and read data to and from specific storage slots without directly using assembly. The library provides a clean abstraction to handle storage pointers and ensures that the pointer returned by `getAddressSlot` points to the correct storage location.

When the `write` function is called with an address `_addr`, it gets a storage pointer to the `AddressSlot` struct at the `TEST_SLOT` and sets the `value` field of the struct to `_addr`, effectively writing the address to the specified storage slot.

Conversely, when the `get` function is called, it retrieves the address stored in the `TEST_SLOT` by getting a storage pointer to the `AddressSlot` struct and accessing the `value` field.
*/