/*
Introduction to Discrete Staking Rewards 🔄
In the world of cryptocurrencies and blockchain technology, staking has become a popular way for holders of certain tokens to earn passive income. Staking involves locking up a certain amount of tokens in a smart contract to support the network’s operations in exchange for rewards. These rewards are typically distributed in proportion to the amount staked by each participant. However, in the world of DeFi, innovation knows no bounds, and developers are constantly exploring new ways to enhance and customize staking experiences. This is where “Discrete Staking Rewards” come into play.

What Are Discrete Staking Rewards? 🧐
Discrete Staking Rewards are a novel approach to staking in DeFi that introduces a unique twist to the traditional staking model. Instead of receiving rewards continuously and proportionally, participants receive rewards at discrete intervals or under specific conditions. This can open up exciting possibilities for designing custom staking solutions tailored to different project requirements.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract DiscreteStakingRewards is Ownable {
    IERC20 public token; // The token users will stake.
    uint256 public stakingDuration; // Duration for staking in seconds.
    uint256 public rewardAmount; // Reward amount users will receive.
    uint256 public startTime; // Start time of the staking period.

    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public lastUpdateTime;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(
        address _token,
        uint256 _stakingDuration,
        uint256 _rewardAmount
    ) {
        token = IERC20(_token);
        stakingDuration = _stakingDuration;
        rewardAmount = _rewardAmount;
    }

    // Function to allow users to stake tokens.
    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(block.timestamp >= startTime, "Staking period has not started");

        // Transfer tokens from the user to this contract.
        token.transferFrom(msg.sender, address(this), amount);

        stakedBalance[msg.sender] += amount;
        lastUpdateTime[msg.sender] = block.timestamp;

        emit Staked(msg.sender, amount);
    }
 
    // Function to allow users to withdraw their staked tokens.
    function withdraw() external {
        uint256 amount = stakedBalance[msg.sender];
        require(amount > 0, "Nothing to withdraw");
        require(block.timestamp >= startTime + stakingDuration, "Staking period is not over");

        uint256 reward = calculateReward(msg.sender);
        stakedBalance[msg.sender] = 0;

        // Transfer staked tokens and rewards back to the user.
        token.transfer(msg.sender, amount);
        token.transfer(msg.sender, reward);

        emit Withdrawn(msg.sender, amount);
        emit RewardPaid(msg.sender, reward);
    }

    // Function to calculate the user's reward.
    function calculateReward(address user) internal view returns (uint256) {
        uint256 lastUpdate = lastUpdateTime[user];
        if (lastUpdate == 0 || lastUpdate >= startTime + stakingDuration) {
            return 0;
        }

        uint256 stakingTime = block.timestamp - lastUpdate;
        return (stakingTime * rewardAmount) / stakingDuration;
    }

    // Owner function to start the staking period.
    function startStaking() external onlyOwner {
        require(startTime == 0, "Staking has already started");
        startTime = block.timestamp;
    }
}

/*
In this smart contract:
- Users can stake tokens using the `stake` function.
- They can withdraw their staked tokens and rewards using the `withdraw` function.
- The owner can start the staking period with the `startStaking` function.

How It Works 🤔
1. Users stake tokens in the contract.
2. The staking period starts when the owner initiates it.
3. After the staking period ends, users can withdraw their staked tokens and rewards.
4. Rewards are calculated based on the time the tokens were staked and the total reward amount.

This is a simplified example, and in a real-world scenario, you would consider factors like security, governance, and possibly more complex reward distribution rules.

Customizing Discrete Staking Rewards 🎨
One of the exciting aspects of Discrete Staking Rewards is the ability to customize the reward distribution to meet the specific needs of your DeFi project. Here are some ideas for customization:

1. Conditional Rewards 🏆
You can set conditions for users to earn rewards. For example, users must hold a minimum number of tokens or participate in specific activities to qualify for rewards.

2. Variable Reward Intervals 🕐
Change the intervals at which rewards are distributed. You can have shorter or longer reward cycles to align with your project’s goals.

3. Dynamic Reward Calculation 📊
Implement dynamic reward calculation formulas that consider various factors like user activity, total staked amount, or market conditions.
*/


//Discrete Staking Rewards Contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DiscreteStakingRewards {
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardToken;

    mapping(address => uint) public balanceOf;
    uint public totalSupply;

    uint private constant MULTIPLIER = 1e18;
    uint private rewardIndex;
    mapping(address => uint) private rewardIndexOf;
    mapping(address => uint) private earned;

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }

    function updateRewardIndex(uint reward) external {
        rewardToken.transferFrom(msg.sender, address(this), reward);
        rewardIndex += (reward * MULTIPLIER) / totalSupply;
    }

    function _calculateRewards(address account) private view returns (uint) {
        uint shares = balanceOf[account];
        return (shares * (rewardIndex - rewardIndexOf[account])) / MULTIPLIER;
    }

    function calculateRewardsEarned(address account) external view returns (uint) {
        return earned[account] + _calculateRewards(account);
    }

    function _updateRewards(address account) private {
        earned[account] += _calculateRewards(account);
        rewardIndexOf[account] = rewardIndex;
    }

    function stake(uint amount) external {
        _updateRewards(msg.sender);

        balanceOf[msg.sender] += amount;
        totalSupply += amount;

        stakingToken.transferFrom(msg.sender, address(this), amount);
    }

    function unstake(uint amount) external {
        _updateRewards(msg.sender);

        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;

        stakingToken.transfer(msg.sender, amount);
    }

    function claim() external returns (uint) {
        _updateRewards(msg.sender);

        uint reward = earned[msg.sender];
        if (reward > 0) {
            earned[msg.sender] = 0;
            rewardToken.transfer(msg.sender, reward);
        }

        return reward;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}


/*
Smart Contract Overview 📜
The smart contract, named `DiscreteStakingRewards`, is designed to facilitate staking and reward distribution for two types of tokens: the staking token and the reward token. Let’s break down its key components:

- stakingToken and rewardToken: These are ERC-20 token interfaces, representing the tokens used for staking and rewards, respectively.

- balanceOf: A mapping that stores the balance of staked tokens for each user.

- totalSupply: A variable tracking the total amount of staked tokens across all users.

- MULTIPLIER: A constant used for precision in reward calculations.

- rewardIndex: A variable tracking the cumulative rewards index.

- rewardIndexOf: A mapping that stores the last known reward index for each user.

- earned: A mapping to keep track of earned rewards for each user.

Reward Distribution 🤑
The primary function of this contract is to enable users to stake tokens and receive rewards based on their share of the total staked tokens. Here’s how it works:

1. Staking: Users can stake tokens using the `stake` function. When they do so, the contract calculates and updates their earned rewards up to that point.

2. Unstaking: Users can unstake tokens using the `unstake` function. Similar to staking, this action triggers a calculation and update of their rewards.

3. Claiming Rewards: Users can claim their rewards using the `claim` function. This function checks the accumulated rewards and transfers them to the user if they have any.

4. Updating Reward Index: The `updateRewardIndex` function allows anyone to update the reward index. This is typically done by transferring reward tokens to the contract, which are then used to increase the reward index. The reward tokens are distributed proportionally to stakers based on their shares.

Reward Calculation 🧮
The core of this contract’s functionality lies in reward calculation. It calculates rewards based on a user’s staked balance and the change in the cumulative reward index since their last interaction with the contract. This ensures that users receive rewards in proportion to their contributions and the time they spent staking.

Conclusion and Potential Improvements 🌟
The provided smart contract is a foundational implementation of Discrete Staking Rewards. However, it can be further enhanced and customized for specific DeFi projects. Here are some potential improvements and customizations:

- Vesting Periods: Add vesting periods to lock rewards for a certain time after claiming.

- Governance: Implement governance mechanisms to allow users to vote on parameters like reward distribution rules.

- Advanced Reward Models: Explore more complex reward distribution models, such as curve-based rewards.

- Security Audits: Conduct thorough security audits to ensure the contract is robust against potential attacks.

*/