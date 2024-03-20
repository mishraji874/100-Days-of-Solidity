// Bitwise Operators
/*
Bitwise operators are operators that perform operations on individual bits of binary data. They enable you to manipulate and extract specific bits, set or clear bits, and perform logical operations at the bit level. Solidity provides a set of bitwise operators that empower developers to work with binary data in a more granular way.

Solidity supports the following bitwise operators:

- Bitwise AND (`&`) ✖️
- Bitwise OR (`|`) ➕
- Bitwise XOR (`^`) ➖
- Bitwise NOT (`~`) ⌛
- Bitwise Left Shift (`<<`) ⬅️
- Bitwise Right Shift (`>>`) ➡️

## Bitwise AND (`&`) ✖️
The bitwise AND operator (`&`) compares the corresponding bits of two operands and returns a new value where each bit is set to `1` if both bits are `1`, and `0` otherwise.

Example:- function and(uint x, uint y) external pure returns (uint) {
return x & y;
}

In this example, the `and` function takes two unsigned integer parameters, `x` and `y`, and returns the result of performing a bitwise AND operation on them. For instance, if `x` is `14` (binary `1110`) and `y` is `11` (binary `1011`), the result of `x & y` would be `10` (binary `1010`).


## Bitwise OR (`|`) ➕
The bitwise OR operator (`|`) compares the corresponding bits of two operands and returns a new value where each bit is set to `1` if at least one of the bits is `1`, and `0` otherwise.


Example:- function or(uint x, uint y) external pure returns (uint) {
return x | y;
}


In this example, the `or` function takes two unsigned integer parameters, `x` and `y`, and returns the result of performing a bitwise OR operation on them. For example, if `x` is `12` (binary `1100`) and `y` is `9` (binary `1001`), the result of `x | y` would be `13` (binary `1101`).


## Bitwise XOR (`^`) ➖
The bitwise XOR operator (`^`) compares the corresponding bits of two operands and returns a new value where each bit is set to `1` if the bits are different, and `0` if the bits are the same. 

Example:- function xor(uint x, uint y) external pure returns (uint) {
return x ^ y;
}


In this example, the `xor` function takes two unsigned integer parameters, `x` and `y`, and returns the result of performing a bitwise XOR operation on them. For instance, if `x` is `12` (binary `1100`) and `y` is `5` (binary `0101`), the result of `x ^ y` would be `9` (binary `1001`).


## Bitwise NOT (`~`) ⌛
The bitwise NOT operator (`~`) is a unary operator that negates each bit of its operand. It returns a new value where each `0` is replaced by `1`, and each `1` is replaced by `0`. 

Example:- function not(uint8 x) external pure returns (uint8) {
return ~x;
}


In this example, the `not` function takes an unsigned 8-bit integer parameter `x` and returns the result of performing a bitwise NOT operation on it. For example, if `x` is `12` (binary `00001100`), the result of `~x` would be `243` (binary `11110011`).


## Bitwise Left Shift (`<<`) ⬅️
The bitwise left shift operator (`<<`) shifts the bits of its left-hand operand to the left by a specified number of positions. It effectively multiplies the operand by `2` raised to the power of the shift amount.

Example: function shiftLeft(uint x, uint bits) external pure returns (uint) {
return x << bits;
}

In this example, the `shiftLeft` function takes an unsigned integer `x` and a `bits` parameter, which represents the number of positions to shift the bits. The function returns the result of shifting the bits of `x` to the left by `bits` positions. For instance, if `x` is `1` and `bits` is `3`, the result of `x << bits` would be `8`.


## Bitwise Right Shift (`>>`) ➡️
The bitwise right shift operator (`>>`) shifts the bits of its left-hand operand to the right by a specified number of positions. It effectively divides the operand by `2` raised to the power of the shift amount. 

Example:- function shiftRight(uint x, uint bits) external pure returns (uint) {
return x >> bits;
}


In this example, the `shiftRight` function takes an unsigned integer `x` and a `bits` parameter, which represents the number of positions to shift the bits. The function returns the result of shifting the bits of `x` to the right by `bits` positions. For example, if `x` is `8` and `bits` is `2`, the result of `x >> bits` would be `2`.




*/

