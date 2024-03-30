/*

Chainlink Price Oracles are smart contracts that enable the retrieval of external data, such as cryptocurrency prices, stock prices, and more. These oracles ensure that DeFi applications have access to accurate, tamper-resistant data, preventing manipulation and ensuring the integrity of financial transactions.

Why Chainlink?
🔗 Chainlink has gained widespread adoption due to its unique features that make it a preferred choice for price oracles:

1. Decentralization: Chainlink leverages multiple nodes to fetch and aggregate data, enhancing resilience against single points of failure and promoting decentralization.

2. Data Source Variety: It integrates data from various sources, minimizing the risk of relying on a single, potentially compromised source.

3. Tamper-Proofing: Chainlink employs cryptographic proofs to verify the authenticity of the data, making it highly resistant to tampering and manipulation.

4. Customizability: Developers can tailor the oracle to meet specific requirements, ensuring compatibility with different DeFi applications.

*/


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract ChainlinkPriceOracle {
    AggregatorV3Interface internal priceFeed;

    constructor() {
        // ETH / USD
        priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    }

    function getLatestPrice() public view returns (int) {
        (
            uint80 roundID,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        // for ETH / USD price is scaled up by 10 ** 8
        return price / 1e8;
    }
}

interface AggregatorV3Interface {
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int answer,
            uint startedAt,
            uint updatedAt,
            uint80 answeredInRound
        );
}


/*

Understanding the Chainlink Price Oracle 🧐
The ChainlinkPriceOracle contract is designed to fetch real-time price data for Ether (ETH) in terms of the United States Dollar (USD). It leverages the Chainlink AggregatorV3Interface, a critical component for interacting with Chainlink’s decentralized oracle network.

Contract Structure 🏗️
Let’s break down the essential components of the ChainlinkPriceOracle contract:

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract ChainlinkPriceOracle {
 AggregatorV3Interface internal priceFeed;
constructor() {
 // ETH / USD
 priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
 }
function getLatestPrice() public view returns (int) {
 (
 uint80 roundID,
 int price,
 uint startedAt,
 uint timeStamp,
 uint80 answeredInRound
 ) = priceFeed.latestRoundData();
 // for ETH / USD price is scaled up by 10 ** 8
 return price / 1e8;
 }
}
- Constructor: The constructor initializes the contract with the Ethereum/USD price feed address.

- getLatestPrice(): This function retrieves the latest price data from the Chainlink aggregator. Note that the price is scaled up by 10⁸ to obtain the correct value.

Interface 🤝
The ChainlinkPriceOracle contract relies on the AggregatorV3Interface, which defines the structure of price data:

interface AggregatorV3Interface {
 function latestRoundData()
 external
 view
 returns (
 uint80 roundId,
 int answer,
 uint startedAt,
 uint updatedAt,
 uint80 answeredInRound
 );
}
This interface specifies a function `latestRoundData()` that returns essential price information.

*/