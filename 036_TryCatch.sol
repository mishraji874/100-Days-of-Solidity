// Try-Catch Construct in Solidity 
// The try-catch construct in Solidity allows developers to catch errors that occur during external function calls or contract creations. It acts as a safety net, providing a fallback mechanism to mitigate any potential issues. The try-catch block consists of a “try” statement, followed by one or more “catch” statements. Now, let’s explore the different use cases of try-catch in Solidity.


//Handling Errors in External Function Calls

function tryCatchExternalCall(uint _i) public {
    try foo.myFunc(_i) returns (string memory result) {
        emit Log(result);
    } catch {
        emit Log("external call failed");
    }
}

//Explanation: In the `tryCatchExternalCall` function, we attempt to call the `myFunc` function of the `foo` contract instance. If the call succeeds, the returned result is emitted via the `Log` event. However, if an error occurs, such as a failed `require` statement, the catch block is executed, and the “external call failed” message is emitted. This way, you can handle errors and provide appropriate feedback to users or other contracts interacting with your smart contract. 



// Handling Errors in Contract Creations

function tryCatchNewContract(address _owner) public {
    try new Foo(_owner) returns (Foo Foo) {
        //you can use variable foo here
        emit Log("foo created");
    } catch Error(string memory reason) {
        // catch failing revert() and require()
        emit LogBytes(reason);
    }
}

//Explanation: In the `tryCatchNewContract` function, we attempt to create a new instance of the `Foo` contract with the provided `_owner` address. If the contract creation is successful, the `Foo created` message is emitted via the `Log` event. However, if an error occurs during the contract creation, such as an invalid address or a failed `assert` statement, the appropriate catch block is executed. It emits an error message via the `Log` event or provides additional information through the `LogBytes` event. This way, you can handle errors during contract creations and take appropriate actions accordingly