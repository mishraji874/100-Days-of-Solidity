// Interfaces
// When it comes to smart contracts, interaction between different contracts is a common requirement. However, in order to effectively communicate, a contract needs to understand the functions and their signatures implemented by other contracts. Interfaces play a pivotal role here by providing a blueprint of required functions and their specifications. With interfaces, contracts can communicate seamlessly without needing to delve into the intricate implementation details. 


/*
 Anatomy of Solidity Interfaces
Solidity interfaces possess distinctive attributes that make them a powerful tool for contract interaction:

1️⃣ No implemented functions: Interfaces solely define functions and their signatures, leaving the implementation to the contracts that conform to them. This abstraction fosters modularity and reusability.

2️⃣ External functions: All functions in an interface are declared as external, allowing them to be accessed only from outside the contract. This design choice ensures consistency in contract communication patterns.

3️⃣ Inheritance support: Interfaces can inherit from other interfaces, facilitating code reuse and composition. Developers can build upon existing interfaces to create more complex communication structures.

4️⃣ No constructor declaration: Since interfaces are not meant to be deployed as standalone contracts, they do not require a constructor. Interfaces are used as blueprints, guiding the implementation of other contracts.

5️⃣ No state variables: Interfaces solely focus on defining functions and their signatures and do not include state variables. This allows for clean and precise communication definitions.
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract MyContract {
    function incrementCounter(address _counter) external {
        ICounter(_counter).increment();
    }

    function getCount(address _counter) external view returns (uint) {
        return ICounter(_counter).count();
    }
}

//Explanation: MyContract showcases two functions: `incrementCounter()` and `getCount()`. The `incrementCounter()` function takes an address `_counter` as an argument and utilizes the Counter interface to invoke the `increment()` function in the Counter contract. Similarly, the `getCount()` function employs the Counter interface to call the `count()` function and retrieve the current count value. Through this seamless integration, contracts can communicate and perform operations on shared data.


// Uniswap Example

interface UniswapV2Factory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}
interface UniswapV2Pair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}
contract UniswapExample {
    address private factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    function getTokenReserves() external view returns (uint, uint) {
        address pair = UniswapV2Factory(factory).getPair(dai, weth);
        (uint reserve0, uint reserve1, ) = UniswapV2Pair(pair).getReserves();
        return (reserve0, reserve1);
    }
}

//Explanation: In this example, we define two interfaces: `UniswapV2Factory` and `UniswapV2Pair`. The `UniswapV2Factory` interface provides the `getPair()` function, which retrieves the pair contract address for a given token pair. The `UniswapV2Pair` interface exposes the `getReserves()` function to retrieve the reserves of the token pair. Within the UniswapExample contract, we utilize these interfaces to retrieve the reserves of a specific token pair. By invoking the `getPair()` function from the `UniswapV2Factory` interface, we obtain the address of the pair contract for the DAI-WETH token pair. Subsequently, we utilize the `UniswapV2Pair` interface to retrieve the reserves using the `getReserves()` function.