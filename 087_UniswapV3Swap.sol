/*

Uniswap V3 is an upgrade to the popular Uniswap V2 protocol, introducing concentrated liquidity and multiple fee tiers. This allows liquidity providers to be more strategic with their positions and traders to have more control over their swaps. Uniswap V3 is a technical marvel, and understanding its inner workings is essential for DeFi developers.

Concentrated Liquidity
In Uniswap V3, liquidity providers can concentrate their funds within specific price ranges. This means that instead of providing liquidity across the entire price spectrum, you can choose to provide liquidity in a narrower range. This is especially useful in markets with high volatility.

Multiple Fee Tiers
Uniswap V3 introduces multiple fee tiers, enabling liquidity providers to earn fees at different rates depending on the range they provide liquidity to. This allows LPs to optimize their fee earnings based on market conditions.

*/


/*

Uniswap V3 Swap Examples

1. Swap tokens using Web3.js

// Import necessary libraries
const Web3 = require('web3');
const { ethers } = require('ethers');
const { abi, bytecode } = require('uniswap-v3-core/artifacts/contracts/UniswapV3Swap.sol/UniswapV3Swap.json');
// Initialize Web3.js
const web3 = new Web3('YOUR_ETHEREUM_NODE_URL');
// Create a signer
const provider = new ethers.providers.Web3Provider(web3.currentProvider);
const signer = provider.getSigner();
// Deploy the UniswapV3Swap contract
const factory = new ethers.ContractFactory(abi, bytecode, signer);
const uniswapV3Swap = await factory.deploy();
// Perform a token swap
const tokenIn = '0xTokenInAddress';
const tokenOut = '0xTokenOutAddress';
const amountIn = ethers.utils.parseUnits('1', 18); // 1 token with 18 decimals
const amountOutMin = ethers.utils.parseUnits('0', 18); // Minimum amount of tokenOut to receive
const deadline = Math.floor(Date.now() / 1000) + 60 * 10; // 10 minutes from now
const recipient = '0xRecipientAddress';
const tx = await uniswapV3Swap.swapExactTokensForTokens(
 amountIn,
 amountOutMin,
 [tokenIn, tokenOut],
 recipient,
 deadline
);
console.log('Swap transaction hash:', tx.hash);



2. Python script for Uniswap V3 swaps

from web3 import Web3
from eth_account import Account
from uniswapv3 import UniswapV3
# Connect to Ethereum
w3 = Web3(Web3.HTTPProvider('YOUR_ETHEREUM_NODE_URL'))
# Your private key and sender address
private_key = 'YOUR_PRIVATE_KEY'
sender_address = '0xYourAddress'
# Initialize the UniswapV3 class
uniswap = UniswapV3(private_key=private_key, provider=w3)
# Specify swap details
token_in = '0xTokenInAddress'
token_out = '0xTokenOutAddress'
amount_in = 1000000000000000000 # 1 ETH in Wei
amount_out_min = 0
deadline = 3600 # 1 hour from now
# Perform the swap
tx_hash = uniswap.swap_tokens(token_in, token_out, amount_in, amount_out_min, deadline)
print('Swap transaction hash:', tx_hash)

*/

/*
Uniqueness of Uniswap V3
Uniswap V3 stands out in the DeFi space for several reasons:

1. Concentrated Liquidity Management
The ability to concentrate liquidity within specific price ranges is a game-changer. It allows liquidity providers to maximize their capital efficiency and potentially earn higher fees.

2. Multiple Fee Tiers
With Uniswap V3, liquidity providers can choose from multiple fee tiers, which enables them to adapt to market conditions. This flexibility is crucial for LPs looking to optimize their fee earnings.

3. Capital Efficiency
Uniswap V3 offers improved capital efficiency by allowing LPs to provide liquidity where they think it’s most needed. This reduces the opportunity cost of holding funds in a non-optimized manner.

4. Improved Slippage Control
Traders using Uniswap V3 have more control over slippage due to the concentrated liquidity pools. This is particularly important in volatile markets where large price swings can lead to significant losses.
*/


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UniswapV3SwapExamples {
    ISwapRouter constant router =
        ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);

    function swapExactInputSingleHop(
        address tokenIn,
        address tokenOut,
        uint24 poolFee,
        uint amountIn
    ) external returns (uint amountOut) {
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenIn).approve(address(router), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        amountOut = router.exactInputSingle(params);
    }

    function swapExactInputMultiHop(
        bytes calldata path,
        address tokenIn,
        uint amountIn
    ) external returns (uint amountOut) {
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenIn).approve(address(router), amountIn);

        ISwapRouter.ExactInputParams memory params = ISwapRouter.ExactInputParams({
            path: path,
            recipient: msg.sender,
            deadline: block.timestamp,
            amountIn: amountIn,
            amountOutMinimum: 0
        });
        amountOut = router.exactInput(params);
    }
}

interface ISwapRouter {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint deadline;
        uint amountIn;
        uint amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    /// @notice Swaps amountIn of one token for as much as possible of another token
    /// @param params The parameters necessary for the swap, encoded as ExactInputSingleParams in calldata
    /// @return amountOut The amount of the received token
    function exactInputSingle(
        ExactInputSingleParams calldata params
    ) external payable returns (uint amountOut);

    struct ExactInputParams {
        bytes path;
        address recipient;
        uint deadline;
        uint amountIn;
        uint amountOutMinimum;
    }

    /// @notice Swaps amountIn of one token for as much as possible of another along the specified path
    /// @param params The parameters necessary for the multi-hop swap, encoded as ExactInputParams in calldata
    /// @return amountOut The amount of the received token
    function exactInput(
        ExactInputParams calldata params
    ) external payable returns (uint amountOut);
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

interface IWETH is IERC20 {
    function deposit() external payable;

    function withdraw(uint amount) external;
}


/*

Understanding Uniswap V3
Uniswap V3 is a significant upgrade from its predecessor, Uniswap V2. It introduces several key features that make it unique and powerful. Let’s dive into these features using our Solidity code as a reference. 📈💡

1. Concentrated Liquidity
Uniswap V3 allows liquidity providers to concentrate their funds within specific price ranges. This means they can provide liquidity in a narrower range, optimizing their capital efficiency and reducing exposure to volatile price swings. The code provided demonstrates how to perform a single-hop swap with concentrated liquidity. 💰💧

function swapExactInputSingleHop(
 address tokenIn,
 address tokenOut,
 uint24 poolFee,
 uint amountIn
) external returns (uint amountOut) {
 // Transfer tokens and approve the router
 IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
 IERC20(tokenIn).approve(address(router), amountIn);
// Define swap parameters
 ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
 tokenIn: tokenIn,
 tokenOut: tokenOut,
 fee: poolFee,
 recipient: msg.sender,
 deadline: block.timestamp,
 amountIn: amountIn,
 amountOutMinimum: 0,
 sqrtPriceLimitX96: 0
 });
// Execute the swap
 amountOut = router.exactInputSingle(params);
}
2. Multiple Fee Tiers
Uniswap V3 introduces multiple fee tiers, allowing liquidity providers to choose the fee rate that suits their strategy. This flexibility is a significant advantage in a dynamic market. Unfortunately, our code example focuses on single-hop swaps, so we won’t delve deeper into this feature here. 📊🤝

Performing Uniswap V3 Swaps
Our Solidity code showcases two essential functions for performing swaps on Uniswap V3: `swapExactInputSingleHop` and `swapExactInputMultiHop`. These functions enable users to execute swaps using smart contracts, adding another layer of automation to DeFi. 🔄🤖

Single-Hop Swap
The `swapExactInputSingleHop` function is designed for simple, one-step swaps. Users specify the input and output tokens, the pool fee, and the amount to be swapped. The function then transfers the tokens, approves the router, and executes the swap. It’s an efficient way to trade assets within a specific price range. 🎯📉

Multi-Hop Swap
The `swapExactInputMultiHop` function is more versatile, allowing users to define a path of tokens for multi-hop swaps. While this function is included in the code, we did not provide a detailed example. However, it’s a crucial feature for more complex trading strategies. 
*/