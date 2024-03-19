// Primitive Data Types

/*
1. Boolena Type: In solidity, the boolean type can have only two possible values: 'true' or 'false'. It is mostly used to represent logical values and is particulary useful in conditional statements and decision-making inside contracts.

2. Unsigned Integer Types: Solidity provides several unsigned integer types, which are used to representnon-negative whwole numbers. These typee include 'uint8', 'uint16', 'uint256', and more.
The number following 'uint' represents the number of bits each type can  hold.

The formula for finding the range of the values stored by the unsigned integer is:- "0 to 2^n - 1"

For example, 'uint8' can stoe value ranging from 0 to 2^8-1(255), while 'uint256' can store the values ranges from 0 to 2^256-1, providing a vast range of possible values.

3. Signed Integer Types: These types can represent both positive and negative whole numbers. Similar to unsigned integers, signed integers have different sizes ranging from 'int8' to 'int256'.

The formula for finding the range of the signed integer type is:- "-2^n-1 to 2^n-1 - 1"

For instance, 'int8' can hold values from -2^7 to 2^7-1 (-128 to 127), while 'int256' can hold values from -2^255 to 2^255-1.

4. Address Type: The 'address' type is used to store the addresses. It represents the a 20-byte value and is typically used to store addresses of user accounts or smart contracts. Addresses are hexadecimal values and are commonly expressed as 40 characters.
For example:- 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c

5. Bytes Type: It repersents the dynamic array of bytes. It is a shorthand for 'byte[]'. Bytes are used to store sequences of bytes and are often utilized for handling raw data or performing cryptographic operations. Solidity also provides fixed-sized byte arrays, but for brevity, we will focus on the dyanmic bytes arrays.

For example, 'bytes1' represents a single byte, and you can initialize it with a hexadecimal value like '0xb5'.Similarly, 'bytes1' with a value of '0x56'.

6. Default Values: When you declare variables in Solidity whthout explicity assigning them a value, they are initialized with default balues.
For example, a 'bool' variable will be initialzed to 'false', a 'uint' variable to '0', an 'int' variable to '0', and an address variable to '0x0000000000000000000000000000000000000000'.
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract PrimitiveDataTypes {
    bool public boo = true;

    uint8 public u8 = 1;
    uint public u256 = 456;
    uint public u = 123;

    int8 public i8 = -1;
    int public i256 = 456;
    int public i = -123;

    address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;

    bytes1 a = 0xb5;
    bytes1 b = 0x56;

    bool public defaultBoo;
    uint public defaultUint;
    int public defaultInt;
    address public defaultAddr;
}