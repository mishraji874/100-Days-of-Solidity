// Events
/*
Events play a crucial role in Solidity, enabling the emission and recording of important information from a smart contract to the Ethereum blockchain. They act as a form of log that captures significant occurrences or actions within the contract. To define an event, the `event` keyword is used, followed by a name and optional parameters. It’s worth noting that up to three parameters can be indexed, allowing for efficient filtering and searching based on these indexed parameters.

Let’s take a closer look at the syntax for declaring an event:

```solidity
event Log(address indexed sender, string message);
event AnotherLog();
```

In the example above, we have two events: `Log` and `AnotherLog`. The `Log` event includes two parameters: an indexed `address` parameter called `sender` and a non-indexed `string` parameter named `message`. On the other hand, the `AnotherLog` event does not have any parameters.
*/


// Application of Events
/*
Elevating User Interface Updates:
One of the key applications of events is facilitating real-time updates in user interfaces (UIs) for decentralized applications (dApps). By emitting events, the backend of a dApp can inform the frontend about specific occurrences. For instance, when a user makes a purchase on an e-commerce dApp, an event can be emitted to log the purchase details. The frontend can listen for this event and dynamically update the UI, providing the user with order confirmations or transaction receipts.

Events establish an efficient and decentralized communication channel between smart contracts and frontends. Rather than constantly polling the blockchain for changes, the frontend can simply listen for specific events and trigger UI updates whenever they occur. This approach reduces unnecessary network traffic and significantly improves the overall user experience.

Cost-Effective Storage:
Another remarkable advantage of using events is their cost-effectiveness when it comes to storing information on the Ethereum blockchain. Emitting and storing events are considerably cheaper compared to writing data to the contract’s state variables. The economical nature of events stems from their storage mechanism. Unlike state variables, events are not stored on the blockchain directly. Instead, they are stored in the transaction logs, which form part of the blockchain’s historical record.

By leveraging events for logging and storing relevant information, smart contracts can optimize gas costs and enhance overall efficiency. Events are particularly valuable in scenarios where the historical record of events holds more significance than the current state of the contract. For instance, in a decentralized voting system, the events representing each vote might carry greater importance than the current vote tally.
*/


//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Events {
    // Event declaration
    // Upto 3 parameters can be indexed
    // Indexed parameters help you filter the logs by the indexed parameter

    event Log(address indexed sender, string message);
    event AnotherLog();

    function test() public {
        emit Log(msg.sender, "Hello World!");
        emit Log(msg.sender, "Hello EVM!");
        emit AnotherLog();
    }
}

//Explanation: The `Event` contract provided above demonstrates the application of events. It declares two events: `Log` and `AnotherLog`. The `Log` event takes an indexed `address` parameter named `sender` and a non-indexed `string` parameter named `message`. Within the `test` function, three events are emitted. The first two are instances of the `Log` event with different `message` parameters, while the third event is an instance of the `AnotherLog` event. By emitting these events, relevant information can be captured and stored on the blockchain. When the `test` function is called, two instances of the `Log` event are emitted, each with a unique `message` parameter. Additionally, an instance of the `AnotherLog` event is emitted.


//Analyzing the contract
/*
The `Event` contract effectively demonstrates the utilization of events. It declares two events: `Log` and `AnotherLog`. The `Log` event includes an indexed `address` parameter named `sender` and a non-indexed `string` parameter named `message`. The `test` function emits three events, two of which are instances of the `Log` event with different `message` parameters, while the third event is an instance of the `AnotherLog` event.

The provided smart contract serves as an exemplary showcase of the fundamental usage of events in Solidity. By emitting events with relevant information, developers can capture and process that information through external entities.

In conclusion, events are a vital aspect of Solidity and Ethereum development. They empower developers to create dynamic and responsive applications on the blockchain. The ability to update user interfaces and store valuable information in a cost-effective manner makes events a powerful tool in the Ethereum ecosystem.
*/