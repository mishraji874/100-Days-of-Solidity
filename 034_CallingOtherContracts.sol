// Direct Function Call

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Callee {
    uint public x;
    uint public value;
    function setX(uint _x) public returns (uint) {
        x = _x;
        return x;
    }
// Additional functions for illustration purposes
 // …
}

contract Caller {
    function setX(Callee _callee, uint _x) public {
        uint x = _callee.setX(_x);
    }
// Additional functions for illustration purposes
 // …
}

/*
Explanation: - The `Callee` contract defines a function `setX` that sets the value of `x` and returns it.
- The `Caller` contract includes a function `setX` which receives an instance of the `Callee` contract and a new value `_x`. It then invokes the `setX` function of the `Callee` contract, passing `_x` as an argument.

By calling functions directly between contracts, we establish a straightforward communication mechanism. However, please note that this approach is limited to contracts residing on the same blockchain. For scenarios involving contracts on different blockchains or networks, we need a different method. Let’s explore another approach to contract interaction that accommodates such situations.
*/


//Low-level Call: Bridging contracts across networks

contract Caller {
    function setXFromAddress(address _addr, uint _x) public {
        Callee callee = Callee(_addr);
        callee.setX(_x);
    }
    function setXandSendEther(Callee _callee, uint _x) public payable {
        (uint x, uint value) = _callee.setXandSendEther{value: msg.value}(_x);
    }
}

/*
Explanation: - The `Caller` contract contains two functions: `setXFromAddress` and `setXandSendEther`.
- The `setXFromAddress` function receives the address of the `Callee` contract `_addr` and a new value `_x`. It then creates an instance of the `Callee` contract using the address `_addr` and invokes its `setX` function, passing `_x` as an argument.
- The `setXandSendEther` function takes an instance of the `Callee` contract `_callee` and a new value `_x`. It also accepts Ether by using the `payable` modifier. The function invokes the `setXandSendEther` function of the `Callee` contract, transferring the received Ether along with the `_x` value. The returned values `x` and `value` are captured in variables for further processing.

Utilizing the low-level call allows us to interact with contracts deployed on different networks or blockchains. However, it’s crucial to exercise caution when employing this approach, as it involves additional complexities and potential security risks. Always perform a thorough analysis of the contracts you intend to interact with and ensure their trustworthiness before making cross-chain calls.
*/