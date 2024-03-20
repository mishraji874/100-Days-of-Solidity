/*
Sending Ether: 📤🚀
When it comes to sending Ether, there are three primary methods at our disposal: `transfer`, `send`, and `call`. Each method has its own gas requirements and return values. Let’s delve into the details of each method:

1. Transfer: 🔄

The `transfer` method serves as the simplest way to send Ether. It transfers a fixed amount of gas (2300 gas) and automatically throws an error if the transfer fails. Here’s an example of using the `transfer` method in Solidity:


function sendEtherUsingTransfer(address payable _to) public payable {
_to.transfer(msg.value);
}


Although the `transfer` method is easy to use, it’s important to note that it may encounter issues if the receiving contract performs complex operations during the transaction. In such cases, the transfer could fail, resulting in a loss of funds.

2. Send: 📩

The `send` method closely resembles `transfer`, but it provides a boolean return value to indicate the success or failure of the transfer. Similar to `transfer`, it also sends a fixed amount of gas (2300 gas) and reverts if the transfer fails. Here’s an example of using the `send` method:


function sendEtherUsingSend(address payable _to) public payable {
bool sent = _to.send(msg.value);
require(sent, “Failed to send Ether”);
}


Despite the `send` method providing a return value, it is no longer recommended for sending Ether due to potential re-entrancy attacks and the limited gas provided. It is advisable to use the `call` method instead.

3. Call: 📞

The `call` method stands as the most versatile way to send Ether and interact with other contracts. It allows for forwarding all available gas or specifying a gas limit, and provides a boolean return value indicating the success or failure of the transfer. Here’s an example of using the `call` method:


function sendEtherUsingCall(address payable _to) public payable {
(bool sent, bytes memory data) = _to.call{value: msg.value}(“”);
require(sent, “Failed to send Ether”);
}


After December 2019, the `call` method became the recommended approach for sending Ether. It grants more control over gas usage and facilitates complex interactions between contracts. However, it’s crucial to implement appropriate security measures to guard against re-entrancy attacks.
*/



/*
Receiving Ether: 📥💰
When it comes to receiving Ether in a contract, two functions need to be implemented: `receive()` and `fallback()`. Let’s understand when each function is called:

1. Receive(): 📥

The `receive()` function gets invoked when the transaction’s `msg.data` is empty. It is an `external payable` function commonly used to receive Ether. Here’s an example of the `receive()` function:


receive() external payable {}


By implementing the `receive()` function, your contract becomes capable of accepting Ether transfers when no specific function is called.

2. Fallback(): 🔄❓

The `fallback()` function gets called when the transaction’s `msg.data` is not empty or when no other function matches the function signature. It is an `external payable` function that can also be used to receive Ether. Here’s an example of the `fallback()` function:


fallback() external payable {}


The `fallback()` function serves as a catch-all function when no other functions match the transaction’s data. It can be useful for implementing custom logic when receiving Ether.
*/


/*
Choosing the Right Method: 🛠️⚖️
Given the multiple options available for sending and receiving Ether, it’s essential to select the appropriate method based on your requirements. Here’s a summary to assist you in making the right choice:

- Sending Ether: Utilize the `call` method in conjunction with a re-entrancy guard to ensure secure transactions. Make all state changes before calling other contracts and employ a re-entrancy guard modifier to prevent malicious behavior.

- Receiving Ether: Implement both the `receive()` and `fallback()` functions in your contract to cover all possible scenarios. The `receive()` function should handle transfers when `msg.data` is empty, while the `fallback()` function can handle other cases.
*/


// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract ReceiveEther {
    receive() external payable {}
    fallback() external payable {}
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}


contract SendEther {
    function sendViaTransfer(address payable _to) public payable {
        _to.transfer(msg.value);
    }
    function sendViaSend(address payable _to) public payable {
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }
    function sendViaCall(address payable _to) public payable {
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}

//Explanation: In the `ReceiveEther` contract, the `receive()` function gets called when Ether is transferred, and the `fallback()` function is invoked when other functions are not matched. The `SendEther` contract exemplifies the three different methods for sending Ether.