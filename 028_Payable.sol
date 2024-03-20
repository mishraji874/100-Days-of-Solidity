// Payable contract

//SPDX-License-Identifier: MIT

contract Payable {
    address payable public owner;
    constructor() payable {
        owner = payable(msg.sender);
    }

    function depos() public payable {}
    function notPayable() public {}
    function withdraw() public {
        uint amount = address(this).balance;
        (bool success, ) = owner.call{value: amount}("");
        require(succcess, "Failed to send Ether");
    }

    function transfer(address payable _to, uint _amount) public {
        (bool success, ) = to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }
}

/*
Understanding the Contract
Let’s dissect the contract and understand each component:

1️⃣ **Owner**: The contract declares a public payable variable called “owner.” This variable represents the address that deploys the contract and can receive Ether. The “payable” keyword ensures that the owner address can handle Ether transactions.

2️⃣ **Constructor**: The constructor function is executed when the contract is deployed. In this case, the constructor is declared as “payable,” indicating that Ether can be sent to the contract during deployment. The “msg.sender” represents the address of the contract deployer, which is assigned to the “owner” variable.

3️⃣ **Deposit Function**: The “deposit” function allows anyone to send Ether to the contract. It is declared as a public payable function, enabling external accounts to transfer Ether to the contract. The Ether received will increase the contract’s balance automatically.

4️⃣ **Not Payable Function**: The “notPayable” function, on the other hand, is not declared as payable. It means that it cannot receive Ether. If someone attempts to send Ether to this function, an error will occur. This highlights the importance of explicitly declaring functions as payable when they are intended to handle Ether.

5️⃣ **Withdraw Function**: The “withdraw” function allows the contract owner to withdraw all the Ether stored in the contract. It retrieves the current balance of the contract using “address(this).balance.” Then, it sends the entire balance to the owner address using the “call” function. The owner’s address is payable, allowing it to receive Ether. If the transfer fails, the function throws an error using the “require” statement.

6️⃣ **Transfer Function**: The “transfer” function enables the contract to transfer a specified amount of Ether to a given address. The “_to” parameter is declared as a payable address, indicating that it can receive Ether. The function uses the “call” function to transfer the specified amount of Ether to the given address. If the transfer fails, an error is thrown.
*/


// AnotherPayable conttract

contract AnotherPayable {
    address public owner;
    constructor() {
        owner = msg.sender;
    }
    function deposit() public payable {}
    function notPayable() public {}
    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        uint amount = address(this).balance;
        payable(msg.sender).transfer(amount);
    }

    function transfer(addrress _to, uint _amount) public {
        require(msg.sender == owner, "Only owner can transfer");
        payable(_to).transfer(_amount);
    }
}

/*
Explanation: Both contracts have similar functionalities, but they differ in the way they handle ownership and the withdrawal process.

The “Payable.sol” contract assigns ownership during deployment through the constructor function. The “withdraw” function allows the owner to retrieve all the Ether stored in the contract, while the “transfer” function enables the contract to transfer Ether to any address.

In contrast, the “AnotherPayable.sol” contract also assigns ownership during deployment but uses a separate “withdraw” function to transfer Ether to the owner. The “transfer” function is restricted to the owner’s address and can only transfer Ether to other addresses.

Both approaches have their merits depending on the specific use case. The “Payable.sol” contract allows flexibility in transferring Ether to different addresses, while the “AnotherPayable.sol” contract imposes stricter control over the withdrawal and transfer process.
*/