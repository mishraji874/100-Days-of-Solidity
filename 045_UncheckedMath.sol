// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract UncheckedMath {
    function add(uint x, uint y) external pure returns (uint) {
        // 22291 gas
        // return x + y;
        // 22103 gas
        unchecked {
            return x + y;
        }
    }
    function sub(uint x, uint y) external pure returns (uint) {
        // 22329 gas
        // return x - y;
        // 22147 gas
        unchecked {
            return x - y;
        }
    }
    function sumOfCubes(uint x, uint y) external pure returns (uint) {
        // Wrap complex math logic inside unchecked
        unchecked {
            uint x3 = x * x * x;
            uint y3 = y * y * y;
            return x3 + y3;
        }
    }
}


/*
## Benefits of Unchecked Math 🌟
Utilizing Unchecked Math in Solidity 0.8 offers several advantages:

1. **Gas Savings**: Disabling overflow and underflow checks with Unchecked Math eliminates the need for additional computational steps. This results in substantial gas savings, reducing the overall cost of executing your smart contracts.

2. **Improved Efficiency**: With fewer computational steps, Unchecked Math enhances the efficiency of arithmetic operations within Solidity contracts. This optimization is particularly beneficial when dealing with large-scale arithmetic calculations.
*/


/*
### Addition without Check ➕
The `add` function performs an addition operation between two input parameters, `x` and `y`. The version without Unchecked Math (commented out) consumes 22,291 gas, while the version utilizing Unchecked Math consumes only 22,103 gas. By disabling the check, we achieve a gas saving of 188 gas, resulting in more efficient contract execution. 📉

### Subtraction without Check ➖
The `sub` function subtracts the value of `y` from `x`. Similar to the `add` function, the version without Unchecked Math (commented out) consumes 22,329 gas, whereas the version using Unchecked Math consumes only 22,147 gas. Here again, by disabling the check, we achieve a gas saving of 182 gas.

### Complex Math Logic 🔄
The `sumOfCubes` function demonstrates a scenario where complex math logic is involved. Inside the `unchecked` block, the function calculates the cube of `x` and `y` separately and then returns their sum. By wrapping the entire complex logic inside the `unchecked` block, we ensure that the overflow and underflow checks are disabled throughout the calculation. This not only saves gas but also improves the efficiency of the contract.
*/