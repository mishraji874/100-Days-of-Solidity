// Variables

/*
1. Local Variables: Local variables are declared within functions and are not stored on the blockchain. They have a temporary lifespan and are accessible only within the scope of the function in which they are declared. Local variables are useful for storing intermediate results or data required for computation within a specific function.

2. State Variables: State variables are decalred outisde of functions and are stored on the blockchain. These variables persist between functions calls and are associated with the contracts instance. State variables are suitable for storing contract specific data that needs to be accessed and modified by multiple functions within the contract.

3. Global Variables: Global variables in Solidity provide essential information about the blockchain and the current transaction. These variables are available to all functionss within a contract and offer crucial context for contract execution.
Two most commonly used global variables are:
- 'block.timestamp': This variable returns the current timestamp(in seconds) of the block in which the contract is being executed. It enables contracts to incorporate time-based logic or record the occurence of specific events.
- 'msg.sender': This variable represents the address of account that called the current function. It can be used to verify the identity of the caller or perform access control checks.
*/


//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Variables {
    
    // In the below function, the variable 'i' is local variable. It is assigned the value 456 within the function 'doSomething()'. Once the execution of the function is complete, the variable 'i' is destroyed, and its value is no longer accessible.
    function doSomething() public {
        uint i = 456;
        // Rest of the function code
    }

    // The variables 'text' and 'num' are state variables. The 'public' visibility modifier generates automatic getter functions, enabling access to their values from outside the contract. These variables are stored on the blockchain and can be read or modified by other contracts or extrnal entities.
    string public text = "Hello";
    uint public num = 123;

    // In the below function, we are retrieving the current timrstamp using 'block.timestamp' and store it in the 'timestamp' variable. Similarly, we obtain the caller's address using 'msg.sender' and assign it to the 'sender' variable.
    function func() public {
        uint timestamp = block.timestamp;
        address sender = msg.sender;
        //Rest of the function code
    }
}