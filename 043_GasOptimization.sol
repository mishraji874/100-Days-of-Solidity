/*
Gas Saving Technique 1: Replacing Memory with Calldata 📥
When it comes to passing arguments to external functions, Solidity provides two options: `memory` and `calldata`. By utilizing the `calldata` keyword, you can directly read the argument from the transaction’s input data instead of storing it in memory. This technique eliminates the gas cost associated with copying the array’s contents to memory. Let’s see how this optimization works in practice by examining a code sample:

```solidity
function sumIfEvenAndLessThan99(uint[] calldata nums) external {
// … function body
}
```

By using `calldata` instead of `memory` for the `nums` array parameter, we significantly reduce the gas cost. This simple substitution can make a noticeable impact on the efficiency of your contract. 💡💰

Gas Saving Technique 2: Loading State Variables to Memory 📦
To minimize gas consumption, it’s advantageous to load frequently accessed state variables into memory. By doing so, you reduce the number of expensive SSTORE operations and achieve substantial gas savings. Consider the following code snippet:

```solidity
uint public total;

function sumIfEvenAndLessThan99(uint[] calldata nums) external {
uint _total = total;
// … rest of the function
}
```

In this example, we create a local variable `_total` and initialize it with the value of the `total` state variable. By performing computations on `_total` instead of directly modifying `total`, we avoid redundant SSTORE operations and optimize gas usage. This small adjustment can lead to significant efficiency improvements. ⚡️🔋

Gas Saving Technique 3: Short Circuiting ⚡️
Leveraging short circuiting in conditional statements can greatly optimize gas consumption. The short circuiting behavior in Solidity allows us to avoid evaluating unnecessary conditions if the first condition already evaluates to false. Let’s examine a code snippet to demonstrate the power of short circuiting:

function sumIfEvenAndLessThan99(uint[] calldata nums) external {
 uint _total = total;
 uint len = nums.length;
for (uint i = 0; i < len; ) {
 uint num = nums[i];
 if (num % 2 == 0 && num < 99) {
 _total += num;
 }
 unchecked {
 ++i;
 }
 }
total = _total;
}
By combining the conditions `num % 2 == 0` and `num < 99` into a single `if` statement, we enable short circuiting. Solidity will only evaluate the second condition if the first condition evaluates to true, thereby saving gas by avoiding unnecessary computations. This technique can significantly optimize the execution of conditional logic in your smart contracts. ⚡️💡

Gas Saving Technique 4: Pre-increment Operator in Loops 🔄
In Solidity, using the pre-increment operator `++i` instead of the post-increment operator `i++` can yield gas savings, albeit relatively small. The pre-increment operator increments the value of `i` before returning it, eliminating the need for an additional operation. While the gas difference may be minimal in individual iterations, applying this technique consistently in larger loops can result in cumulative gas savings. Let’s take a look at an example:

function iterateAndIncrement(uint[] calldata nums) external {
 for (uint i = 0; i < nums.length; ) {
 // … loop logic
 unchecked {
 ++i;
 }
 }
}
By using the pre-increment operator `++i`, we optimize gas usage within the loop construct. This seemingly small adjustment can add up to substantial savings when dealing with extensive iterations. 🔄💰

Gas Saving Technique 5: Caching Array Length 📏
Caching the length of an array before entering a loop can help reduce gas consumption. By storing the array length in a local variable outside the loop, we avoid redundant SLOAD operations and improve efficiency. Consider the following code snippet:

```solidity
function processArray(uint[] calldata arr) external {
uint len = arr.length;
for (uint i = 0; i < len; i++) {
// … loop logic
}
}
```

In this optimized version, we assign the length of the `arr` array to a local variable `len` before entering the loop. By accessing `len` in the loop condition instead of repeatedly accessing `arr.length`, we eliminate unnecessary gas costs associated with loading the array length on each iteration. This technique is particularly beneficial for contracts handling large arrays. 📏💡

Gas Saving Technique 6: Loading Array Elements to Memory 📄
Optimizing gas usage involves minimizing redundant storage operations. To achieve this, loading array elements to memory using local variables can be highly effective. Let’s examine an example:

```solidity
function sumArray(uint[] calldata arr) external returns (uint) {
uint sum = 0;
for (uint i = 0; i < arr.length; i++) {
uint element = arr[i];
sum += element;
}
return sum;
}
```

In this optimized code, we load the current array element `arr[i]` into a local variable `element` before performing any computations. By accessing `element` instead of `arr[i]` multiple times within the loop, we reduce the number of costly SLOAD operations, resulting in gas savings. This technique is particularly beneficial for scenarios where array elements are accessed multiple times or undergo complex calculations. 📄💰

Gas Saving Technique 7: Unchecked Overflow/Underflow ✅
In situations where we are confident that certain operations will not cause overflow or underflow, using the `unchecked` keyword can provide additional gas optimization. By indicating that the compiler should not throw an exception on overflow or underflow, we can save gas in scenarios where the bounds are already guaranteed. Here’s an example:

```solidity
function increment(uint value) external {
unchecked {
value++;
}
}
```

In this code snippet, we use `unchecked` to suppress potential exceptions related to overflow or underflow during the increment operation. By assuring the compiler that the bounds of `value` are already guaranteed, we save gas that would otherwise be consumed by the exception handling mechanism. This technique should be used with caution and only in situations where the absence of exceptions is guaranteed. ✅⛽️
*/