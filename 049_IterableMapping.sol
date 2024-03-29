/*
Mappings serve as key-value data structures, enabling efficient data lookup and storage.
They are fundamental in storing and retrieving data within smart contracts.
However, one limitation is their inability to facilitate easy iteration through their elements.
*/

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IterableMappingExample {
    mapping(address => uint256) private myMapping;
    address[] private keys;

    function setValue(address key, uint256 value) public {
        myMapping[key] = value;
        keys.push(key);
    }

    function getValue(address key) public view returns (uint256) {
        return myMapping[key];
    }

    function getAllKeys() public view returns (address[] memory) {
        return keys;
    }
}

/*
Explanation: In the above code, we define the `myMapping` mapping that associates addresses with corresponding uint256 values. Additionally, we maintain an array called `keys` to preserve the order of key additions. The `setValue` function allows adding or updating key-value pairs in the mapping, while `getValue` retrieves the value associated with a given key. Finally, the `getAllKeys` function returns an array containing all the keys in the mapping. 
*/


/*
Iterating Over an Iterable Mapping:
Now that we have an iterable mapping in place, let’s explore how we can effectively iterate over its elements using a loop. 🔄

function iterateMapping() public view {
    for (uint256 i = 0; i < keys.length; i++) {
        address key = keys[i];
        uint256 value = myMapping[key];
        // Perform desired operations with key-value pairs
    }
}
The `iterateMapping` function loops through the `keys` array, retrieving the corresponding value from the `myMapping` mapping, and allowing you to perform desired operations with each key-value pair. This way, you can seamlessly iterate over the elements of your iterable mapping, expanding the possibilities of your Solidity projects!
*/


/*
Analyzing a smart contract:

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
library IterableMapping {
 // Iterable mapping from address to uint;
 struct Map {
 address[] keys;
 mapping(address => uint) values;
 mapping(address => uint) indexOf;
 mapping(address => bool) inserted;
 }
function get(Map storage map, address key) public view returns (uint) {
 return map.values[key];
 }
function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
 return map.keys[index];
 }
function size(Map storage map) public view returns (uint) {
 return map.keys.length;
 }
function set(Map storage map, address key, uint val) public {
 if (map.inserted[key]) {
 map.values[key] = val;
 } else {
 map.inserted[key] = true;
 map.values[key] = val;
 map.indexOf[key] = map.keys.length;
 map.keys.push(key);
 }
 }
function remove(Map storage map, address key) public {
 if (!map.inserted[key]) {
 return;
 }
delete map.inserted[key];
 delete map.values[key];
uint index = map.indexOf[key];
 address lastKey = map.keys[map.keys.length - 1];
map.indexOf[lastKey] = index;
 delete map.indexOf[key];
map.keys[index] = lastKey;
 map.keys.pop();
 }
}
contract TestIterableMap {
 using IterableMapping for IterableMapping.Map;
IterableMapping.Map private map;
function testIterableMap() public {
 map.set(address(0), 0);
 map.set(address(1), 100);
 map.set(address(2), 200); // insert
 map.set(address(2), 200); // update
 map.set(address(3), 300);
for (uint i = 0; i < map.size(); i++) {
 address key = map.getKeyAtIndex(i);
assert(map.get(key) == i * 100);
 }
map.remove(address(1));
// keys = [address(0), address(3), address(2)]
 assert(map.size() == 3);
 assert(map.getKeyAtIndex(0) == address(0));
 assert(map.getKeyAtIndex(1) == address(3));
 assert(map.getKeyAtIndex(2) == address(2));
 }
}




Explanation:

This smart contract showcases the implementation of an iterable mapping using a library called `IterableMapping`. Let’s go through the different parts of the code to understand its functionality.

1. The `IterableMapping` library defines a `Map` struct that consists of four components:
— `keys`: An array of addresses that serves as the keys for the mapping.
— `values`: A mapping that associates each address key with a corresponding uint value.
— `indexOf`: A mapping that stores the index of each address key in the `keys` array.
— `inserted`: A mapping that tracks whether an address has been inserted into the mapping.

2. The library provides several functions to interact with the `Map` struct:
— `get`: Retrieves the value associated with a given address key.
— `getKeyAtIndex`: Returns the address key at a specified index in the `keys` array.
— `size`: Returns the number of elements in the `keys` array.
— `set`: Adds or updates a key-value pair in the mapping. If the key already exists, the value is updated.
— `remove`: Removes a key-value pair from the mapping.

3. The `TestIterableMap` contract demonstrates the usage of the `IterableMapping` library. It declares an instance of the `IterableMapping.Map` struct called `map`.

4. The `testIterableMap` function showcases the functionality of the iterable mapping. It sets various key-value pairs in the `map` and performs different operations on them.

5. Inside the `for` loop, the function iterates through the `map` using the `getKeyAtIndex` function and asserts that the retrieved values are equal to `i * 100`, where `i` represents the index.

6. After the loop, the function removes the key-value pair associated with `address(1)` using the `remove` function.

7. Finally, the function asserts the expected size and order of keys in the `map`.

This smart contract demonstrates how the `IterableMapping` library enables the creation and manipulation of iterable mappings, allowing for efficient iteration and management of key-value pairs.
*/