// Error Handling
/*
1. `require`: Validate Inputs and Conditions
The `require` function acts as a guard, validating inputs and conditions before executing specific parts of the code. It ensures that the specified conditions are met, and if not, it throws an error and reverts all changes made to the contract’s state. This function is commonly used to validate inputs, check conditions before execution, and validate return values from other functions.


require(_i > 10, “Input must be greater than 10”);


In the above example, we use `require` to validate that the input `_i` is greater than 10. If the condition is not satisfied, the contract execution is reverted, and an error message is displayed.

2. `revert`: Complex Conditions and Custom Errors
The `revert` function is similar to `require` in terms of reverting state changes and throwing an error. However, `revert` is particularly useful when the conditions to check are more complex or when you want to provide more detailed error messages.


if (_i <= 10) {
revert(“Input must be greater than 10”);
}


In the above example, we use `revert` to check if `_i` is less than or equal to 10. If the condition is true, the contract execution is reverted, and the error message “Input must be greater than 10” is displayed.

3. `assert`: Testing Invariants and Internal Errors
The `assert` function is used to check for conditions that should never be false. It is primarily used to test for internal errors and verify invariants within the contract. If an `assert` statement fails, it indicates the presence of a bug in the code.


assert(num == 0);


In the above example, we use `assert` to verify that the variable `num` is always equal to 0. Since `num` cannot be updated within the contract, this assert statement ensures that the invariant is maintained.
*/

// Custom Error: Gas Optimization and Detailed Error Messages
/*
Solidity allows you to define custom errors using the `error` keyword. Custom errors help optimize gas costs by avoiding unnecessary storage operations and provide more informative error messages.

error InsufficientBalance(uint balance, uint withdrawAmount);
function testCustomError(uint _withdrawAmount) public view {
    uint bal = address(this).balance;
    if (bal < _withdrawAmount) {
        revert InsufficientBalance({balance: bal, withdrawAmount: _withdrawAmount});
    }
}
In the above example, we define a custom error called `InsufficientBalance` that takes two parameters: `balance` and `withdrawAmount`. If the contract’s balance is less than the requested withdrawal amount, the function reverts and throws the `InsufficientBalance` error, including the actual balance and the requested withdrawal amount.
*/


// Preventing Integer Overflows and Underflows
/*
In addition to error handling, preventing integer overflows and underflows is crucial for the integrity of financial transactions in smart contracts. Solidity provides techniques to avoid such issues.

function deposit(uint _amount) public {
    uint oldBalance = balance;
    uint newBalance = balance + _amount;
    require(newBalance >= oldBalance, "Overflow");
    balance = newBalance;
    assert(balance >= oldBalance);
}
function withdraw(uint _amount) public {
    uint oldBalance = balance;
    require(balance >= _amount, "Underflow");
    if (balance < _amount) {
        revert("Underflow");
    }
    balance -= _amount;
    assert(balance <= oldBalance);
}
In the above example, the `deposit` function ensures that the new balance after the deposit is greater than or equal to the old balance to prevent overflow. The `withdraw` function checks if the contract has enough balance before deducting the requested amount to avoid underflows.
*/