/*
What is Crowd Funding?
Crowd funding is a method of raising capital from a large number of individuals, typically through small contributions. Traditionally, this was done through centralized platforms where a company or individual would pitch their idea or project, and interested parties would invest money in exchange for potential rewards or equity. However, the emergence of blockchain technology has paved the way for decentralized crowd funding, eliminating the need for intermediaries and providing greater transparency and trust.

Advantages of Decentralized Crowd Funding 🎯
Decentralized crowd funding brings several key advantages to the table:

1. Transparency: The blockchain ensures that all transactions and contributions are visible to everyone, promoting transparency and accountability.

2. Global Accessibility: Anyone with an internet connection can participate in decentralized crowd funding, regardless of their location or background.

3. Lower Fees: By removing intermediaries, decentralized crowd funding reduces fees and allows more funds to reach the project creators.

4. Smart Contracts: With Solidity smart contracts, we can automate the entire crowd funding process, ensuring that funds are released only when certain conditions are met.

5. Trustless Environment: Participants can engage in crowd funding without having to trust a central authority, as the rules are enforced by the smart contract code.
*/

//Designing the Crowd Fund Smart Contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract CrowdFund {
 address public projectCreator;
 uint public goalAmount;
 uint public deadline;
 mapping(address => uint) public contributions;
 uint public totalContributions;
 bool public fundingComplete;
// Events to emit status changes
 event GoalReached(uint totalContributions);
 event FundTransfer(address backer, uint amount);
constructor(uint _goalAmount, uint _durationInDays) {
 projectCreator = msg.sender;
 goalAmount = _goalAmount * 1 ether; // Convert to wei (1 ether = 1e18 wei)
 deadline = block.timestamp + (_durationInDays * 1 days);
 }
modifier onlyProjectCreator() {
 require(msg.sender == projectCreator, "Only the project creator can perform this action.");
 _;
 }
modifier goalNotReached() {
 require(!fundingComplete && block.timestamp < deadline, "Goal already reached or deadline passed.");
 _;
 }
function contribute() external payable goalNotReached {
 contributions[msg.sender] += msg.value;
 totalContributions += msg.value;
 if (totalContributions >= goalAmount) {
 fundingComplete = true;
 emit GoalReached(totalContributions);
 }
 emit FundTransfer(msg.sender, msg.value);
 }
function withdrawFunds() external onlyProjectCreator {
 require(fundingComplete, "Funding goal not reached yet.");
 payable(projectCreator).transfer(address(this).balance);
 }
function refundContribution() external goalNotReached {
 require(contributions[msg.sender] > 0, "You have not contributed to the crowd fund.");
 uint amountToRefund = contributions[msg.sender];
 contributions[msg.sender] = 0;
 totalContributions -= amountToRefund;
 payable(msg.sender).transfer(amountToRefund);
 }
function getRemainingTime() external view returns (uint) {
 if (block.timestamp >= deadline) {
 return 0;
 } else {
 return deadline - block.timestamp;
 }
 }
}

/*
Understanding the Smart Contract 🤓
1. `CrowdFund`: This is our main smart contract where crowd funding logic is implemented.
2. `projectCreator`: The address of the account that deployed the contract and created the crowd fund campaign.
3. `goalAmount`: The total amount of funds (in wei) required to successfully complete the crowd fund.
4. `deadline`: The timestamp until which the crowd fund will be open for contributions.
5. `contributions`: A mapping that stores the contribution amount of each participant.
6. `totalContributions`: The total amount of funds (in wei) contributed by all participants.
7. `fundingComplete`: A boolean flag indicating whether the crowd fund goal has been reached or not.

The contract consists of the following functions:

1. `constructor`: Initializes the crowd fund campaign with the desired `goalAmount` and `deadline`.

2. `contribute`: Allows anyone to contribute funds to the crowd fund as long as the deadline has not passed and the goal has not been reached. The contributed amount is added to the `contributions` mapping and `totalContributions`.

3. `withdrawFunds`: The project creator can withdraw the funds once the crowd fund goal has been reached. The total amount raised is transferred to the project creator’s address.

4. `refundContribution`: In case the crowd fund goal is not reached before the deadline, contributors can request a refund of their contributions.

5. `getRemainingTime`: A helper function to check how much time is remaining until the crowd fund deadline.
*/