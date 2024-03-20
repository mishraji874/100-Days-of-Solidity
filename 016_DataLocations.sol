// Data Locations
/*
1. Storage: It refers to variables stored permanently on the blockchain. These variables, typically state variables declared at the contract level, persist across multiple functions calls. They are accessible or modifying storage variables incurs higher gas costs compared to memory variables.

2. Memory: It is used to temporarily store variables during the execution of a function. These variables are dynamically allocated and deallocated within the function's scope. They are not persistent between function calls and are primarily used for local variables or function parameters. Memory variables offer lower gas costs compared to storage variables.

3. Calldata: It is a special read-only space that contains function arguments. It is particularly useful for passing large amounts of data to a function incurring excessive gas costs. It is mainly used for external function calls.
*/


// Example: Using Storage Variables
function f() public {
    _f(arr, map, myStructs[1]);
    MyStruct storage myStruct = myStructs[1];
    MyStruct memory myMemStruct = MyStruct(0);
}
function _f(
    uint[] storage _arr,
    mapping(uint => address) storage _map,
    MyStruct storage _myStruct
) internal {
 // Perform operations with storage variables
}

//Explanation: In the `f` function, we call the internal `_f` function, passing storage variables such as `arr`, `map`, and `myStructs[1]`. As storage variables, any modifications made within `_f` will persist outside the function call. Additionally, we demonstrate the creation of a struct variable `myMemStruct` in memory, which exists only within the function’s execution.


//  Example: Utilizing Memory Variables
function g(uint[] memory _arr) public returns (uint[] memory) {
 // Perform operations with memory array
}

// Explanation: The `g` function accepts a memory array `_arr` as a parameter. It performs operations on the memory array and returns a memory array as well. Memory arrays are allocated and deallocated within the function’s scope, making them suitable for temporary data storage.


//Example: Leveraging Calldata
function h(uint[] calldata _arr) external {
 // Perform operations with calldata array
}

// Explanation: The `h` function accepts a calldata array `_arr` as an argument. Calldata arrays are read-only and are useful for accessing function arguments without incurring gas costs. The function can perform operations on the calldata array but cannot modify it.