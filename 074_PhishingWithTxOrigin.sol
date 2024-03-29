/*

1. Introduction to `tx.origin` 🔄
In Solidity, `tx.origin` is a global variable that provides the sender’s address of the original external transaction. It might sound harmless at first, but it’s important to distinguish between the sender of the transaction and the caller of the contract function.

- `msg.sender`: Refers to the address that is directly calling the current function.
- `tx.origin`: Represents the origin of the external transaction that triggered the contract’s function call.

2. The Deceptive Charm of `tx.origin` ✨
While `tx.origin` was initially introduced to cater to certain use cases, it has become a notorious tool in the hands of malicious actors. The apparent charm of `tx.origin` lies in its potential to deceive the contract by pretending to be the original sender of the transaction. This deception forms the basis of the vulnerability we are discussing.

3. Exploiting with Phishing Attacks 🎣
Phishing attacks involve tricking users into believing they are interacting with a legitimate entity while, in reality, they are handing over sensitive information or control to an attacker. With the help of `tx.origin`, attackers can craft contracts that exploit this deceptive behavior to impersonate legitimate users and execute actions on their behalf.

How the Attack Unfolds
1. User Interaction: The attacker deploys a malicious contract that contains a function vulnerable to the `tx.origin` exploit.
2. User Interaction: A legitimate user, let’s call them Alice, interacts with the malicious contract.
3. Deceptive Execution: When Alice interacts with the malicious contract, the function within the contract uses `tx.origin` to determine Alice’s original address.
4. False Legitimacy: The malicious contract now appears to have been called directly by Alice, thanks to the deceptive nature of `tx.origin`.
5. Unauthorized Actions: The contract can now execute actions on Alice’s behalf, potentially causing financial loss or compromising sensitive data.

*/

//4. A real-world example

pragma solidity ^0.8.0;
contract PhishableContract {
    address public owner;
    constructor() {
        owner = msg.sender;
    }
    function withdrawFunds(address payable recipient, uint256 amount) public {
        require(tx.origin == owner, "Unauthorized access");
        recipient.transfer(amount);
    }
}

/*
5. Mitigating the Risk: Best Practices 🛡️
Preventing `tx.origin` vulnerabilities requires a combination of secure coding practices and understanding the implications of each function’s usage. Here are some best practices to consider:

Avoid `tx.origin`: In most cases, you should use `msg.sender` instead of `tx.origin` to determine the immediate caller’s address.
Use Function Modifiers: Utilize function modifiers to restrict access to sensitive functions and validate the caller’s identity.
Context-Based Permissions: Implement context-based permission systems that rely on contract-specific roles and access control.
White-Listed Addresses: Maintain a white-list of trusted addresses that are allowed to interact with critical contract functions.
Third-party Libraries: When using external libraries, ensure they follow secure practices and don’t rely solely on `tx.origin`.
*/


//Analysis Report: Difference between 'msg.sender' and 'tx.origin'

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
Wallet is a simple contract where only the owner should be able to transfer
Ether to another address. Wallet.transfer() uses tx.origin to check that the
caller is the owner. Let's see how we can hack this contract
*/

/*
1. Alice deploys Wallet with 10 Ether
2. Eve deploys Attack with the address of Alice's Wallet contract.
3. Eve tricks Alice to call Attack.attack()
4. Eve successfully stole Ether from Alice's wallet

What happened?
Alice was tricked into calling Attack.attack(). Inside Attack.attack(), it
requested a transfer of all funds in Alice's wallet to Eve's address.
Since tx.origin in Wallet.transfer() is equal to Alice's address,
it authorized the transfer. The wallet transferred all Ether to Eve.
*/

contract Wallet {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function transfer(address payable _to, uint _amount) public {
        require(tx.origin == owner, "Not owner");

        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }
}

contract Attack {
    address payable public owner;
    Wallet wallet;

    constructor(Wallet _wallet) {
        wallet = Wallet(_wallet);
        owner = payable(msg.sender);
    }

    function attack() public {
        wallet.transfer(owner, address(wallet).balance);
    }
}


/*
In the realm of Solidity programming, understanding the distinctions between `msg.sender` and `tx.origin` is crucial for building secure and robust smart contracts. These two global variables might appear similar on the surface, but they hold distinct meanings and implications.

🌐 `msg.sender`: This variable represents the address of the entity that directly called the current function within the contract. It denotes the immediate caller’s identity, allowing the contract to recognize and attribute actions accordingly. `msg.sender` is the recommended method for identifying the actor interacting with the contract, as it accurately reflects the source of the function invocation.

🚀 `tx.origin`: In contrast, `tx.origin` refers to the original sender’s address of the external transaction that initiated the chain of contract calls. It traces back to the root source of the transaction, even if there are intermediate contracts involved. However, relying solely on `tx.origin` can open doors to vulnerabilities, as it doesn’t necessarily indicate the immediate caller of the current contract function.

🔐 Vulnerability Scenario: Exploiting `tx.origin`
Let’s delve into an example to comprehend how a malicious actor can exploit the difference between `msg.sender` and `tx.origin` to compromise a contract’s security.

Consider a scenario where we have three contracts: A (owner), B, and C. Contract A calls contract B, and then contract B calls contract C. In contract C, `msg.sender` would point to contract B, whereas `tx.origin` would point to contract A. This distinction can be leveraged by malicious contracts to deceive the owner of a contract.
*/

/*
🛑 The Vulnerable Contract: Wallet
Below is a contract named `Wallet` that demonstrates this vulnerability. It utilizes `tx.origin` to verify the owner’s identity before transferring Ether to another address.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract Wallet {
    address public owner;
    constructor() payable {
        owner = msg.sender;
    }
    function transfer(address payable _to, uint _amount) public {
        require(tx.origin == owner, "Not owner");
        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }
}


/*
🔒 Preventing the Vulnerability: Best Practices
function transfer(address payable _to, uint256 _amount) public {
    require(msg.sender == owner, "Not owner");

    (bool sent, ) = _to.call{ value: _amount }("");
    require(sent, "Failed to send Ether");
}
To mitigate the risks associated with `tx.origin` vulnerabilities, it’s recommended to use `msg.sender` instead. By doing so, you ensure that the immediate caller’s address is accurately identified, reducing the chances of deception.

Here’s the updated `transfer` function using `msg.sender`:

function transfer(address payable _to, uint256 _amount) public {
    require(msg.sender == owner, "Not owner");
    (bool sent, ) = _to.call{value: _amount}("");
    require(sent, "Failed to send Ether");
}
By substituting `tx.origin` with `msg.sender`, you enforce a tighter security mechanism that focuses on the direct caller, thus thwarting potential exploitation.
*/