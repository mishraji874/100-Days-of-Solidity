/*
What is Multi Call? 🤔
In Ethereum and other blockchain networks, interacting with smart contracts can be a resource-intensive and costly process. Each transaction or contract call incurs a gas fee, and executing multiple calls individually can quickly become expensive. This is where the concept of “Multi Call” comes in to save the day! 😎

Multi Call is a design pattern that allows us to batch multiple contract calls into a single transaction, significantly reducing gas costs and enhancing the overall efficiency of our dApps. By aggregating multiple calls, we minimize the overhead associated with executing each call separately, and thus, users can save valuable funds when using our smart contracts.

How does Multi Call work? 🛠️
To implement Multi Call, we use a smart contract acting as a proxy that aggregates and dispatches multiple read-only function calls to other contracts. These read-only functions don’t modify the blockchain state; therefore, they do not require a separate transaction.

The Multi Call contract gathers all the required function signatures and parameters, then executes them together as a single transaction, processing all the calls in one go. This not only saves gas costs but also reduces the number of interactions with the blockchain, which is beneficial for scalability.
*/

//The Multi Call Smart Contract in Solidity

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Multicall {
    function getBalances(address[] calldata addresses) external view returns (uint256[]) {
        uint256[] memory balances = new uint256[](addresses.length);
        for(uint256 i = 0; i < addresses.length; i++) {
            balances[i] = addresses[i].balance;
        }
        return balances;
    }

    function executeCalls(
        address[] calldata contractAddresses,
        bytes[] calldata calldata
    ) external view returns (bytes[] memory) {
        bytes[] memory results = new bytes[](contractAddresses.length);
        for (uint256 i = 0; i < contractAddresses.length; i++) {
            (bool success, bytes memory result) = contractAddresses[i].staticcall(callData[i]);
            if (success) {
                results[i] = result;
            }
        }
        return results;
    }
}

/*
Explanation: In this example, the `getBalances` function takes an array of addresses as input and returns an array of their respective account balances. The contract allows us to efficiently retrieve multiple balances in a single function call, making it an excellent use case for the Multi Call pattern.

In this unique implementation, we have a more flexible `executeCalls` function that can handle multiple contract addresses and their corresponding function call data. The function uses the `staticcall` to execute each function and collect the results in an array. This opens up endless possibilities for developers to interact with various smart contracts efficiently in a single transaction.
*/


/*
Benefits of Multi Call 🌟
1. Gas Cost Reduction: By aggregating calls into a single transaction, users can save significant amounts of gas, especially when dealing with a large number of contract calls.

2. Improved Efficiency: Multi Call minimizes the number of interactions with the blockchain, leading to better scalability and faster response times for dApps.

3. Enhanced User Experience: Lower gas costs mean users are more likely to interact with your dApp, resulting in a better overall user experience.

4. Simplified Code: Implementing Multi Call can simplify the codebase, as it reduces the need for multiple function calls.

5. Economic Scalability: With reduced gas fees, your dApp becomes more economically scalable, attracting more users and transactions.
*/

//Multi Call: Aggregating Multiple Queries Efficiently

//1, The Multicall Contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract MultiCall {
 function multiCall(
 address[] calldata targets,
 bytes[] calldata data
 ) external view returns (bytes[] memory) {
 require(targets.length == data.length, "target length != data length");
bytes[] memory results = new bytes[](data.length);
for (uint i; i < targets.length; i++) {
 (bool success, bytes memory result) = targets[i].staticcall(data[i]);
 require(success, "call failed");
 results[i] = result;
 }
return results;
 }
}

/*
Analysis

- The `multiCall` function takes two dynamic arrays as input parameters: `targets` and `data`.
- The `targets` array contains the addresses of the contracts that need to be queried.
- The `data` array contains the function call data for each contract’s query, encoded as bytes.
- The function ensures that both arrays have the same length using a `require` statement.
- It initializes a `results` array to store the responses from the contract queries.
- Inside a for loop, each contract is queried using the `staticcall` function.
- If the call is successful, the response is stored in the `results` array.
- If any call fails, the entire batch fails, and an exception is raised.
*/

// 2. The TestMulticall Contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract TestMultiCall {
 function test(uint _i) external pure returns (uint) {
 return _i;
 }
function getData(uint _i) external pure returns (bytes memory) {
 return abi.encodeWithSelector(this.test.selector, _i);
 }
}

/*
Analysis

- The `test` function takes an unsigned integer `_i` as input and returns the same value.
- The `getData` function takes an unsigned integer `_i` and returns the encoded function call data of the `test` function with `_i` as the parameter.
*/

/*
3. How Multi Call Works
The “MultiCall” contract allows us to batch multiple queries from different contracts into a single transaction. To demonstrate its functionality, let’s consider the following example:

function testMultiCall() external view returns (bytes[] memory) {
 TestMultiCall contract1 = new TestMultiCall();
 TestMultiCall contract2 = new TestMultiCall();
 
 bytes[] memory data = new bytes[](2);
 data[0] = contract1.getData(42);
 data[1] = contract2.getData(100);
 
 address[] memory targets = new address[](2);
 targets[0] = address(contract1);
 targets[1] = address(contract2);
return MultiCall.multiCall(targets, data);
}
In this example, we have created two instances of the “TestMultiCall” contract and prepared the data and target arrays for the “MultiCall” contract. The result of calling the `testMultiCall` function would be an array containing the responses of the two contract queries.

4. Benefits of Multi Call
The Multi Call technique offers several benefits for smart contract developers:

- Gas Cost Reduction: By aggregating multiple queries into a single transaction, gas costs are significantly reduced compared to making individual calls for each query.

- Efficiency: The batching of contract queries reduces the number of interactions with the blockchain, leading to enhanced efficiency and faster response times.

- Economical Scalability: Lower gas costs make the dApp more economically scalable, attracting more users and transactions.

In conclusion, Multi Call is a powerful technique for optimizing contract interactions on the Ethereum blockchain. By batching multiple queries into a single transaction, developers can achieve significant gas cost savings and improve the overall efficiency of their dApps. The “MultiCall” contract provided in the report demonstrates how this technique can be implemented in Solidity.
*/