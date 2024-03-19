/*
Array Initalization

In Solidity, arrays can have a compile-time fixed size or a dynamic size.

1️⃣ Dynamic-sized Array:

uint[] public arr;
uint[] public arr2 = [1, 2, 3];

In the first example, we declare a dynamic-sized array named `arr` without specifying an initial size. The `public` keyword makes the array accessible from outside the contract. In the second example, `arr2` is initialized with three elements: 1, 2, and 3.


2️⃣ Fixed-sized Array:

uint[10] public myFixedsizeArr;

we declare a fixed-sized array named `myFixedSizeArr` with a size of 10. Fixed-sized arrays have a predetermined length that cannot be changed during runtime.
*/


/*
Array Access and Modification

1️⃣ Accessing Elements:

function get(uint i) public view returns (uint) {
    return arr[i];
}
The `get` function allows us to retrieve the value at a specific index `i` from the `arr` array.


2️⃣ Returning the Entire Array:

function getArr() public view returns (uint[] memory) {
    return arr;
}
The `getArr` function returns the entire `arr` array. However, be cautious when using this approach with arrays that can grow indefinitely, as it can consume a significant amount of gas.


3️⃣ Appending Elements:

function push(uint i) public {
    arr.push(i);
}
The `push` function appends a new element `i` to the end of the `arr` array, increasing its length by one.


4️⃣ Removing Elements:

function pop() public {
    arr.pop();
}
The `pop` function removes the last element from the `arr` array, decreasing its length by one.


5️⃣ Array Length:

function getLength() public view returns (uint) {
    return arr.length;
}
The `getLength` function returns the current length of the `arr` array.


6️⃣ Deleting Elements:

function remove(uint index) public {
    delete arr[index];
}
The `remove` function deletes the element at the specified index `index` in the `arr` array. The `delete` keyword resets the value at that index to its default value (0 in this case) without changing the array length.


7️⃣ Working with Memory Arrays:

function examples() external {
    uint[] memory a = new uint[](5);
}
In the `examples` function, we demonstrate how to create a memory array with a fixed size of 5. Memory arrays are useful when you need to create temporary arrays within a function.
*/


// Array removal techniques

// SPDX-License-Identifier: MIT

// 1️⃣ Remove by Shifting Elements:


pragma solidity ^0.8.17;

contract ArrayRemoveByShifting {
    uint[] public arr;
    function remove(uint index) public {
        require(index < arr.length, "index out of bound");
        for(uint i = index; i < arr.length; i++) {
            arr[i] = arr[i + 1];
        }
        arr.pop();
    }

    function test() external {
        arr = [1,2,3,4,5];
        remove(2);
        // [1,2,4,5]
        assert(arr[0] == 1);
        assert(arr[1] == 2);
        assert(arr[2] == 4);
        assert(arr[3] == 5);
        assert(arr.length == 4);
        arr = [1];
        remove(0);
        // []
        assert(arr.length == 0);
    }
}

// Explanantion: In this example, the `remove` function shifts elements from right to left starting from the specified index `_index`. It then uses the `pop` function to remove the duplicated last element.


// 2️⃣ Remove by Replacing with Last Element:

contract ArrayReplaceFromEnd {
    uint[] public arr;
    function remove(uint index) public {
        arr[index] = arr[arr.length - 1];
        arr.pop();
    }

    function test() external {
        arr = [1,2,3,4,5];
        remove(1);
        // [1,4,3]
        assert(arr.length == 3);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
        assert(arr[2] == 3);
        remove(2);
        // [1,4]
        assert(arr.length == 2);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
    }
}

//Explanation: In this example, the `remove` function replaces the element at the specified index `index` with the last element in the array. It then uses the `pop` function to remove the duplicated last element, effectively deleting the desired element.