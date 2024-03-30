/*

What is Uniswap V3?
Uniswap V3 is the third iteration of the Uniswap decentralized exchange protocol built on the Ethereum blockchain. It allows users to swap various ERC-20 tokens and provides liquidity providers with advanced features to optimize their capital efficiency.

🔧 Technical Underpinnings: Uniswap V3 is a smart contract-based protocol, which means that all its functionality is governed by code on the Ethereum blockchain. The key smart contracts that make Uniswap V3 work are the `SwapRouter`, `PositionManager`, and `NFTDescriptor`.

Liquidity Provision in Uniswap V3
Now, let’s delve into the heart of Uniswap V3 — liquidity provision. Liquidity providers play a crucial role in decentralized exchanges by supplying assets to the protocol’s liquidity pools. In return, they earn fees from traders who use these pools.

🚀 Unique Features: Uniswap V3 introduces several unique features that set it apart from its predecessors:

1. Concentrated Liquidity
In Uniswap V3, liquidity providers can create customized liquidity ranges. This means they can choose specific price ranges in which their assets will be available for trading. This allows for higher capital efficiency and potentially greater returns.

2. Multiple Fee Tiers
Liquidity providers can choose from three fee tiers: 0.05%, 0.3%, and 1%. This flexibility allows LPs to optimize their strategy based on their risk tolerance and market conditions.

3. Non-Fungible Position (NFP) Tokens
Each liquidity position in Uniswap V3 is represented by a non-fungible position (NFP) token. These tokens are unique and can be transferred or sold like other NFTs, opening up new possibilities for trading and investing in liquidity.

4. Impermanent Loss Mitigation
Uniswap V3 introduces features like active management of liquidity positions and the ability to concentrate liquidity, which can help mitigate impermanent loss, a common concern for liquidity providers.

How to Provide Liquidity on Uniswap V3
Now that you have an understanding of the unique features of Uniswap V3, let’s walk through the steps to provide liquidity on the platform.

Prerequisites:
- You need to have some tokens to provide as liquidity.
- An Ethereum wallet (e.g., MetaMask) with enough ETH for gas fees.

Here’s a step-by-step guide:
1. Access Uniswap V3
Visit the Uniswap V3 website and connect your Ethereum wallet. Ensure you’re on the correct network (usually Ethereum Mainnet).

2. Choose a Pool
Select the pool you want to provide liquidity for. Each pool has its own unique characteristics, so choose one that aligns with your investment goals.

3. Add Liquidity
Click the “Add Liquidity” button and choose the tokens you want to provide. Specify the price range and the amount of liquidity you wish to provide. Uniswap V3 will calculate your share of the pool.

4. Confirm Transaction
Review the transaction details, including gas fees, and confirm the transaction through your wallet.

5. Manage Your Position
After providing liquidity, you can actively manage your position. You can adjust your price range, change the fee tier, or withdraw your liquidity entirely whenever you want.

*/


/*

Interaction with Uniswap V3 using web3.js

const { ethers } = require('ethers');
const { Pool } = require('@uniswap/v3-sdk');
const { NonfungiblePositionManager } = require('@uniswap/v3-periphery');
// Replace with your Infura or Ethereum RPC URL
const provider = new ethers.providers.JsonRpcProvider('YOUR_INFURA_URL');
// Your Ethereum wallet's private key
const privateKey = 'YOUR_PRIVATE_KEY';
const wallet = new ethers.Wallet(privateKey, provider);
// Address of the Uniswap V3 NFT position manager
const positionManagerAddress = '0xC36442b4a4522E871399CD717aBDD847Ab11FE88';
const positionManager = new NonfungiblePositionManager(
    positionManagerAddress,
    wallet
);
async function createLiquidityPosition() {
 // Specify your token and pool details
    const token0 = '0xToken0Address';
    const token1 = '0xToken1Address';
    const fee = '3000'; // 0.3% fee tier
    const tickLower = '-5000'; // Lower tick range
    const tickUpper = '5000'; // Upper tick range
    const amount0Desired = ethers.utils.parseEther('100'); // Amount of token0 to provide
    const amount1Desired = ethers.utils.parseEther('200'); // Amount of token1 to provide
    const nonce = await positionManager.getNonce(wallet.address);
    const tx = await positionManager.connect(wallet).createAndInitializePosition({
        tokenId: nonce.toHexString(),
        fee,
        tickLower,
        tickUpper,
        amount0Desired,
        amount1Desired,
        amount0Min: 0,
        amount1Min: 0,
        recipient: wallet.address,
        deadline: Math.floor(Date.now() / 1000) + 600, // 10-minute deadline
    });
    await tx.wait();
    console.log('Liquidity position created!');
}
createLiquidityPosition();

*/


//Uniswap V3 Liquidity Contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

contract UniswapV3Liquidity is IERC721Receiver {
    IERC20 private constant dai = IERC20(DAI);
    IWETH private constant weth = IWETH(WETH);

    int24 private constant MIN_TICK = -887272;
    int24 private constant MAX_TICK = -MIN_TICK;
    int24 private constant TICK_SPACING = 60;

    INonfungiblePositionManager public nonfungiblePositionManager =
        INonfungiblePositionManager(0xC36442b4a4522E871399CD717aBDD847Ab11FE88);

    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata
    ) external returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    function mintNewPosition(
        uint amount0ToAdd,
        uint amount1ToAdd
    ) external returns (uint tokenId, uint128 liquidity, uint amount0, uint amount1) {
        dai.transferFrom(msg.sender, address(this), amount0ToAdd);
        weth.transferFrom(msg.sender, address(this), amount1ToAdd);

        dai.approve(address(nonfungiblePositionManager), amount0ToAdd);
        weth.approve(address(nonfungiblePositionManager), amount1ToAdd);

        INonfungiblePositionManager.MintParams
            memory params = INonfungiblePositionManager.MintParams({
                token0: DAI,
                token1: WETH,
                fee: 3000,
                tickLower: (MIN_TICK / TICK_SPACING) * TICK_SPACING,
                tickUpper: (MAX_TICK / TICK_SPACING) * TICK_SPACING,
                amount0Desired: amount0ToAdd,
                amount1Desired: amount1ToAdd,
                amount0Min: 0,
                amount1Min: 0,
                recipient: address(this),
                deadline: block.timestamp
            });

        (tokenId, liquidity, amount0, amount1) = nonfungiblePositionManager.mint(
            params
        );

        if (amount0 < amount0ToAdd) {
            dai.approve(address(nonfungiblePositionManager), 0);
            uint refund0 = amount0ToAdd - amount0;
            dai.transfer(msg.sender, refund0);
        }
        if (amount1 < amount1ToAdd) {
            weth.approve(address(nonfungiblePositionManager), 0);
            uint refund1 = amount1ToAdd - amount1;
            weth.transfer(msg.sender, refund1);
        }
    }

    function collectAllFees(
        uint tokenId
    ) external returns (uint amount0, uint amount1) {
        INonfungiblePositionManager.CollectParams
            memory params = INonfungiblePositionManager.CollectParams({
                tokenId: tokenId,
                recipient: address(this),
                amount0Max: type(uint128).max,
                amount1Max: type(uint128).max
            });

        (amount0, amount1) = nonfungiblePositionManager.collect(params);
    }

    function increaseLiquidityCurrentRange(
        uint tokenId,
        uint amount0ToAdd,
        uint amount1ToAdd
    ) external returns (uint128 liquidity, uint amount0, uint amount1) {
        dai.transferFrom(msg.sender, address(this), amount0ToAdd);
        weth.transferFrom(msg.sender, address(this), amount1ToAdd);

        dai.approve(address(nonfungiblePositionManager), amount0ToAdd);
        weth.approve(address(nonfungiblePositionManager), amount1ToAdd);

        INonfungiblePositionManager.IncreaseLiquidityParams
            memory params = INonfungiblePositionManager.IncreaseLiquidityParams({
                tokenId: tokenId,
                amount0Desired: amount0ToAdd,
                amount1Desired: amount1ToAdd,
                amount0Min: 0,
                amount1Min: 0,
                deadline: block.timestamp
            });

        (liquidity, amount0, amount1) = nonfungiblePositionManager.increaseLiquidity(
            params
        );
    }

    function decreaseLiquidityCurrentRange(
        uint tokenId,
        uint128 liquidity
    ) external returns (uint amount0, uint amount1) {
        INonfungiblePositionManager.DecreaseLiquidityParams
            memory params = INonfungiblePositionManager.DecreaseLiquidityParams({
                tokenId: tokenId,
                liquidity: liquidity,
                amount0Min: 0,
                amount1Min: 0,
                deadline: block.timestamp
            });

        (amount0, amount1) = nonfungiblePositionManager.decreaseLiquidity(params);
    }
}

interface INonfungiblePositionManager {
    struct MintParams {
        address token0;
        address token1;
        uint24 fee;
        int24 tickLower;
        int24 tickUpper;
        uint amount0Desired;
        uint amount1Desired;
        uint amount0Min;
        uint amount1Min;
        address recipient;
        uint deadline;
    }

    function mint(
        MintParams calldata params
    )
        external
        payable
        returns (uint tokenId, uint128 liquidity, uint amount0, uint amount1);

    struct IncreaseLiquidityParams {
        uint tokenId;
        uint amount0Desired;
        uint amount1Desired;
        uint amount0Min;
        uint amount1Min;
        uint deadline;
    }

    function increaseLiquidity(
        IncreaseLiquidityParams calldata params
    ) external payable returns (uint128 liquidity, uint amount0, uint amount1);

    struct DecreaseLiquidityParams {
        uint tokenId;
        uint128 liquidity;
        uint amount0Min;
        uint amount1Min;
        uint deadline;
    }

    function decreaseLiquidity(
        DecreaseLiquidityParams calldata params
    ) external payable returns (uint amount0, uint amount1);

    struct CollectParams {
        uint tokenId;
        address recipient;
        uint128 amount0Max;
        uint128 amount1Max;
    }

    function collect(
        CollectParams calldata params
    ) external payable returns (uint amount0, uint amount1);
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

🧐 The UniswapV3Liquidity smart contract is a Solidity contract that facilitates the management of liquidity positions on the Uniswap V3 decentralized exchange. It provides methods for minting new liquidity positions, collecting fees, and increasing or decreasing liquidity within the specified price range.

🌐 Interfaces:
The contract implements the `IERC721Receiver` interface, allowing it to receive ERC-721 tokens. It also interacts with various other interfaces such as `INonfungiblePositionManager`, `IERC20`, and `IWETH` to handle liquidity management and token transfers.

🤖 Key Features:
1. Minting New Positions: Users can mint new liquidity positions by providing an amount of DAI (an ERC-20 token) and WETH (Wrapped Ether) to the contract. These positions are created within a specified price range with customized parameters like desired amounts and fee tiers.

2. Collecting Fees: Users can collect fees earned from their liquidity positions by calling the `collectAllFees` function. It collects fees in both DAI and WETH.

3. Increasing Liquidity: Liquidity providers can add more liquidity to their existing positions within the current price range using the `increaseLiquidityCurrentRange` function. This allows them to increase their share of the liquidity pool.

4. Decreasing Liquidity: Users can also reduce their liquidity by calling the `decreaseLiquidityCurrentRange` function, effectively withdrawing a portion of their assets from the liquidity pool.

🔄 Token Handling:
The contract interacts with DAI and WETH tokens, transferring, and approving them as needed for liquidity provision and fee collection. Token transfers are performed securely to prevent unauthorized access.

🔒 Security:
The contract uses various constants and parameters to ensure that liquidity positions are created and managed within the specified price ranges. This helps prevent impermanent loss and other potential risks associated with liquidity provision.

📜 Events:
The contract emits events for critical actions like token transfers (`Transfer` and `Approval` events) and interactions with liquidity positions. These events provide transparency and a way to track contract activity.

🤝 Integration with Uniswap V3:
The contract interacts with Uniswap V3 through the `INonfungiblePositionManager` interface, allowing it to create, manage, and collect fees from liquidity positions within the Uniswap V3 ecosystem.

🚧 Caution:
Users interacting with this contract should exercise caution and ensure they understand the risks associated with liquidity provision on Uniswap V3. Additionally, it’s important to set the correct parameters when calling functions to prevent potential loss of funds.

*/