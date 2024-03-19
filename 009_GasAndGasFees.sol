// Gas and its role: Gas as the currency of computation in the ethereum ecosystem. Every operation from basic arithmetic to complex contract execution consumes a specific amount of gas.

// Gas Usage and Cost: Each operation in ethereum has a gas cost associated with it, depending on its complexity. Simple tasks will be relatively gas-efficient, while more complex operations, like interacting with external contracts, incur higher gas costs.

// The total gas cost of a transaction is the sum of the gas costs of all its individual operations.

// Gas Limit: It represents the maximum amount of gas you allocate to your transaction. When sending a transaction, you can set the gas limit as asafeguard against runaway computations. If a transaction exceeds this limit, it will be automatically reverted, and any changes made during its execution will be undone.

// Block Gas Limit: Thje block gas limit is the upper bound on the total gas allowed wwithin a single block. This limit is collectively st by the netwwork's miners, ensuring thhat blocks do not become excessively large and congested. If the total gas usage within a block surpases the block gas limit, some transactions may have to wait for the next block to be processed.


/*
The Dance of Gas Price and Gas Fee:
💰 The gas price is the amount of ether you are willing to pay for each unit of gas. It acts as an auction for transaction priority, as miners are incentivized to include transactions with higher gas prices in the blocks they mine. The gas fee for a transaction is calculated by multiplying the gas spent by the gas price. It’s crucial to strike a balance between a reasonable gas price and the urgency of your transaction.

Embracing Efficiency: Gas Refunds and Optimization Techniques:
🔄 Ethereum rewards developers who employ gas-saving strategies in their smart contracts. When a transaction consumes less gas than the allocated gas limit, the unused gas is refunded back to the sender. Here are some gas optimization techniques for frugal Ethereum pioneers:

1. ⚙️ Minimize External Calls: Interacting with external contracts incurs additional gas costs. Try to reduce the number of external calls or batch them together for efficiency.

2. 🔄 Use Loops Wisely: Loops can be gas-intensive, especially if the number of iterations is uncertain. Optimize your code to reduce unnecessary looping and computational overhead.

3. 💾 Storage Optimization: Storage operations are gas-heavy. Be mindful of state changes and prefer memory-based operations when possible.

4. 📚 Libraries are Your Friends: Leverage existing libraries to reuse well-audited and gas-optimized code. Importing established libraries also reduces deployment and initialization costs.
*/


// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract GasAndGasFees {

    //example of calculating gas
    function calculateGas() public pure returns (uint) {
        uint startGas = gasleft();
        // perform computations or operations
        uint endGas = gasleft();
        return startGas - endGas;
    }


    //example of calculating gas price
    uint public gasPrice;
    function setGasPrice(uint _gasPrice) public {
        require(_gasPrice > 0, "Gas Price should be greater than zero");
        gasPrice = _gasPrice;
    }
}