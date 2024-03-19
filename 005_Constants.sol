// Constants
// Constants plays a vital role in making your code more robust, secure and cost-efficient. They are defined using the 'contract' keyword, which ensures that their value remains unchanged once assigned. By convention, constant variables are writtem in uppercase to distinguish them from regular variables. Constants provide immutability to variables, ensuring that their values cannot be changed accidently or intentionally.

/*
Utilizing Constants in Your Smart Contracts

1. Immutability: Constants provide an additional layer of security by ensuring that specific values remain constant throughout contract execution. This prevents accidental or malicious modifications that could compromise the integrity of your code.

2. Gas Optimization: By using constants, you can significantly optimize the gas cost of your smart contracts. Since their values are hard-coded and do not change, the Solidity compiler can optimize the bytecode accordingly. This optimization results in reduced gas consumption, making your contracts more efficient and cost-effective.

3. Code Readability: Constants enhance the readability of your code by clearly defining and separating values that are meant to remain constant. Following the convention of using uppercase letters makes constants easily identifiable, even in large codebases. This improves code maintainability and reduces the chances of errors due to accidental value modifications.

4. Reusability: Constants can be reused throughout your smart contract or even across multiple contracts. By defining constants for commonly used values, you promote code reusability, standardization, and consistency. It simplifies maintenance and updates, as modifying a constant value at a single location automatically reflects the change wherever it is used.

*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Constants {
    // 'MY_ADDRESS' constant is an 'address' type variable that holds a fixed ethereum address
    address public constant MY_ADDRESS = 0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;

    //'MY_UINT' is a 'uint' type variable with a fixed value.
    uint public constant MY_UINT = 123;

    function getMyAddress() public view returns (address) {
        return MY_ADDRESS;
    }

    function getMyUint() public view returns (uint) {
        return MY_UINT;
    }
}