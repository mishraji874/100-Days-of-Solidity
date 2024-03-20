// Fallback
// The fallback function serves as a safety net for handling unexpected situations within a smart contract. It prevents transactions from failing and ensures a graceful recovery when undefined functions are invoked. Additionally, the fallback function facilitates the reception of Ether without requiring a specific function call, making it an essential tool for implementing payment systems within contracts.


// Fallback contract

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Fallback {

    event Log(string func, uint gas);
    fallback() external payable {
        emit Log("fallback", gasleft());
    }
    receive() external payable {
        emit Log("receive", gasleft());
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

//Explanantion: In this contract, we have the fallback function defined with the `fallback` keyword. It emits a log event indicating that the fallback function was triggered and displays the amount of gas remaining (`gasleft()`). Additionally, the contract includes a `receive` function, which acts as a variant of the fallback function triggered when `msg.data` is empty. The `getBalance()` function allows us to check the balance of the contract.


//Sending ether to the fallback function

contract SendToFallback {
    function transferToFallback(address payable _to) public payable {
        _to.transfer(msg.value);
    }
    function callFallback(address payable _to) public payable {
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "failed to send ether");
    }
}

//Explanation: The `transferToFallback` function utilizes the `transfer` function to send Ether to the specified address `_to`. It automatically forwards the value sent with the function call to the fallback function. On the other hand, the `callFallback` function employs the `call` function to send Ether to the designated address `_to`. It also forwards the value sent with the function call but allows for more control over the low-level details of the call. It includes error handling with a `require` statement to revert the transaction if the call fails. 


//The Power of Fallback with Input and Output

contract FallbackInputOutput {
    address immutable target;
    constructor(address _target) {
    target = _target;
    }
    fallback(bytes calldata data) external payable returns (bytes memory) {
        (bool ok, bytes memory res) = target.call{value: msg.value}(data);
        require(ok, "call failed");
        return res;
    }
}

contract Counter {
    uint public count;
    function get() external view returns (uint) {
        return count;
    }
    function inc() external returns (uint) {
        count += 1;
        return count;
    }
}

contract TestFallbackInputOutput {
    event Log(bytes res);
    function test(address _fallback, bytes calldata data) external {
        (bool ok, bytes memory res) = _fallback.call(data);
        require(ok, "call failed");
        emit Log(res);
    }
    function getTestData() external pure returns (bytes memory, bytes memory) {
        return (abi.encodeWithSignature("get()"), abi.encodeWithSignature("inc()"));
    }
}


/*
Explanation: In this code snippet, we have three contracts: `FallbackInputOutput`, `Counter`, and `TestFallbackInputOutput`.

The `FallbackInputOutput` contract takes an address as a constructor argument and stores it in the `target` variable. Its fallback function accepts bytes calldata as input and returns bytes memory as output. Within the fallback function, it invokes the specified function of the target contract using the provided input data and forwards the provided value.

The `Counter` contract represents a simple counter with two functions: `get`, which returns the current value of the counter, and `inc`, which increments the counter and returns the updated value.

The `TestFallbackInputOutput` contract includes a `test` function that allows us to test the fallback function of a contract. It accepts the address of the fallback contract and the desired input data as arguments. It calls the fallback function of the specified contract with the provided data and emits the result as a log.

The `getTestData` function provides sample data to test the fallback function. It uses the `abi.encodeWithSignature` function to encode the function calls for `get` and `inc`.
*/