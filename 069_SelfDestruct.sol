/*
Demystifying the Self-Destruct Opcode 🕵️‍♂️
In the Solidity ecosystem, the “Self-Destruct” opcode (also known as “SELFDESTRUCT”) might sound ominous, but fear not! It’s a critical and often misunderstood component that allows for the removal of a contract from the Ethereum blockchain. However, its name can be quite deceiving, as it doesn’t actually destroy the contract in the sense of obliterating it from existence. Instead, it renders the contract inoperable and reclaims its remaining funds, making them accessible to the designated recipient.

The Self-Destruct opcode serves as a powerful tool for managing smart contract resources efficiently. Contracts on the Ethereum blockchain are like autonomous entities, and like any well-structured system, they sometimes need to be decommissioned. This could be due to a variety of reasons, such as upgrading to a new contract version, a contract that has outlived its purpose, or even security concerns.

When and How to Use Self-Destruct 🛠️
Before we dive into the technical nitty-gritty, let’s establish some guidelines on when and how to use Self-Destruct responsibly:

1. Contract Upgrades: One common scenario for employing Self-Destruct is when you’re introducing a new and improved version of a contract. By Self-Destructing the old contract, you can free up resources while ensuring that any remaining funds are safely transferred to the new version.

2. Resource Management: Contracts might be deployed for specific time-limited functionalities. After the contract’s intended usage period is over, Self-Destruct can help you tidy up, preventing unnecessary clutter on the blockchain.

3. Emergency Situations: In cases where a contract has been compromised or a critical vulnerability is detected, Self-Destruct can be used to quarantine the contract and prevent further exploitation.

4. Gas Efficiency: Self-Destructing a contract can release storage and memory, making your contract more gas-efficient.
*/


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract SelfDestructDemo {
 address public owner;
 uint256 public funds;
constructor() {
 owner = msg.sender;
 funds = msg.value;
 }
modifier onlyOwner() {
 require(msg.sender == owner, "Only the owner can call this");
 _;
 }
function destroy() external onlyOwner {
 selfdestruct(payable(owner));
 }
}

/*
Testing the Waters: Ensuring Safe Self-Destruct 🛡️🧪
While Self-Destruct offers tremendous benefits, using it recklessly can lead to unintended consequences. Therefore, it’s crucial to conduct thorough testing before incorporating Self-Destruct into your production contracts. Here’s a checklist of tests you should consider:

1. Unit Testing: Write unit tests to ensure that the Self-Destruct functionality behaves as expected. Test scenarios such as fund transfers, contract state changes, and edge cases.

2. Integration Testing: Test the interaction between the Self-Destruct feature and other parts of your contract. Verify that the funds are correctly transferred and that the contract state is updated accordingly.

3. Gas Usage Analysis: Measure the gas consumption of Self-Destruct operations to ensure that your contract remains efficient. Gas cost can impact the overall usability of your contract.

4. Edge Cases: Test scenarios like Self-Destructing a contract with zero funds or attempting to Self-Destruct a non-existent contract. Ensure that your contract handles these cases gracefully.

Best Practices and Security Considerations 🔒🔑
As with any powerful tool, Self-Destruct should be used judiciously and with careful consideration. Here are some best practices and security tips to keep in mind:

1. Access Control: Implement proper access control mechanisms to restrict who can trigger the Self-Destruct function. Unauthorized access could lead to fund loss or contract manipulation.

2. Emergency Stop Mechanism: Consider implementing an emergency stop mechanism that allows authorized parties to pause or disable the Self-Destruct feature in critical situations.

3. Reentrancy Protection: Guard against reentrancy attacks by ensuring that the Self-Destruct operation is the last step in your contract’s logic, preventing external calls after destruction.

4. Funds Recovery: Ensure that the funds are sent to the intended recipient after Self-Destruct. Avoid hardcoded addresses and use a well-tested withdrawal pattern.
*/


//Security Analysis of Smart Contract: “Self Destruct”


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// The goal of this game is to be the 7th player to deposit 1 Ether.
// Players can deposit only 1 Ether at a time.
// Winner will be able to withdraw all Ether.

/*
1. Deploy EtherGame
2. Players (say Alice and Bob) decides to play, deposits 1 Ether each.
2. Deploy Attack with address of EtherGame
3. Call Attack.attack sending 5 ether. This will break the game
   No one can become the winner.

What happened?
Attack forced the balance of EtherGame to equal 7 ether.
Now no one can deposit and the winner cannot be set.
*/

contract EtherGame {
    uint public targetAmount = 7 ether;
    address public winner;

    function deposit() public payable {
        require(msg.value == 1 ether, "You can only send 1 Ether");

        uint balance = address(this).balance;
        require(balance <= targetAmount, "Game is over");

        if (balance == targetAmount) {
            winner = msg.sender;
        }
    }

    function claimReward() public {
        require(msg.sender == winner, "Not winner");

        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }
}

contract Attack {
    EtherGame etherGame;

    constructor(EtherGame _etherGame) {
        etherGame = EtherGame(_etherGame);
    }

    function attack() public payable {
        // You can simply break the game by sending ether so that
        // the game balance >= 7 ether

        // cast address to payable
        address payable addr = payable(address(etherGame));
        selfdestruct(addr);
    }
}


/*
Vulnerability Analysis 🕵️‍♂️🔍
The smart contracts “EtherGame” and “Attack” demonstrate a vulnerability associated with the “Self-Destruct” opcode. This opcode, when misused, can lead to unintended behavior, allowing malicious actors to disrupt the intended functionality of contracts.

Vulnerable Contract: EtherGame

The “EtherGame” contract has a vulnerability that can be exploited through the “Attack” contract. The “EtherGame” contract’s logic relies on tracking the balance using `address(this).balance` and sets the winner based on the accumulated balance. However, this approach can be manipulated by an attacker to bypass the intended game rules.

Attack Scenario 🚀💥
1. Deploy EtherGame: Deploy the “EtherGame” contract.

2. Players Deposit Ether: Players deposit 1 Ether each into the “EtherGame” contract.

3. Deploy Attack: Deploy the “Attack” contract, passing the address of the “EtherGame” contract.

4. Call Attack.attack: By calling `Attack.attack` and sending a sufficient amount of Ether, the attacker forces the balance of the “EtherGame” contract to exceed the target amount (7 ether in the original contract). This breaks the game logic, preventing any legitimate player from becoming the winner.

Preventative Techniques and Best Practices 🔐🚀
To mitigate the vulnerabilities identified, here are some best practices and preventative techniques:

1. Avoid Reliance on `address(this).balance`: Instead of using `address(this).balance` to track balances, maintain a variable within the contract to accurately track the deposits. This ensures that the balance is maintained as intended and is not manipulated by attackers.

2. Use Require Statements Carefully: Ensure that require statements are appropriately placed to prevent unintended behavior. Validate conditions before they impact the contract’s state.

3. Access Control: Implement access control mechanisms to restrict functions like `claimReward` to authorized users only. This prevents unauthorized users from exploiting vulnerabilities.

4. Test Exhaustively: Thoroughly test the contract under various scenarios, including edge cases, to identify vulnerabilities early and ensure robust functionality.
*/


//Secured Contract: EtherGame (Example) 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract EtherGame {
 uint public targetAmount = 3 ether; // Adjusted target amount
 uint public balance;
 address public winner;
function deposit() public payable {
 require(msg.value == 1 ether, "You can only send 1 Ether");
balance += 1 ether; // Maintain accurate balance
 require(balance <= targetAmount, "Game is over");
if (balance == targetAmount) {
 winner = msg.sender;
 }
 }
function claimReward() public {
 require(msg.sender == winner, "Not winner");
(bool sent, ) = msg.sender.call{value: balance}("");
 require(sent, "Failed to send Ether");
 }
}