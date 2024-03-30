/*
What are Flash Swaps?

Flash Swaps are a type of DeFi transaction that allows users to borrow assets from a decentralized lending protocol like Aave, execute arbitrary logic, and return the borrowed assets within a single Ethereum transaction. This unique feature eliminates the need for collateral, making it possible to access a substantial amount of liquidity with minimal initial funds.

Uniswap V2: The Pioneer of Flash Swaps

Uniswap V2 introduced Flash Swaps as part of its functionality. These swaps are particularly popular because they leverage Uniswap’s automated market maker (AMM) model, which provides liquidity on decentralized exchanges.

How Flash Swaps Work
1. Borrowing Assets : A Flash Swap begins with the user borrowing assets from a lending protocol. This can include any ERC-20 token supported by the lending platform. Importantly, no collateral is required at this stage.

2. Executing Logic : Once the assets are borrowed, the user can execute any arbitrary logic within the Ethereum Virtual Machine (EVM). This opens up a world of possibilities, from arbitrage opportunities to liquidation strategies.

3. Repaying the Loan : After executing their logic, the user must return the borrowed assets to the lending protocol along with any accrued interest or fees. If this step is not completed within a single transaction, the entire Flash Swap fails, and any changes made during the transaction are reversed.

Use Cases and Applications
1. Arbitrage Opportunities : Flash Swaps are a powerful tool for arbitrageurs. They can borrow assets, analyze market conditions, and execute profitable trades within a single transaction. This allows traders to capitalize on price differences between different decentralized exchanges (DEXs) or liquidity pools.

2. Liquidations : Flash Swaps can be used to liquidate undercollateralized positions on lending platforms. If a user’s position falls below the required collateral ratio, Flash Swaps can be used to repay the debt and seize the collateral.

3. Complex Trading Strategies : Advanced traders and developers can use Flash Swaps to create complex trading strategies that involve multiple steps and interactions with various DeFi protocols. These strategies can be executed in a single atomic transaction, reducing the risk of front-running or other forms of exploitation.
*/

//Flash Swap Contracts

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import IUniswapV2Router02 from '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';
import IERC20 from '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract FlashSwapExample {
    IUniswapV2Router02 public uniswapRouter;

    constructor(address _router) {
        uniswapRouter = IUniswapV2Router02(_router);
    }

    function flashSwap(address token, uint amount) external {
        // step1: borrow assets
        IERC20(token).approve(address(uniswapRouter), amount);

        //step2: execute logic

        //step3: repay the loan
        IERC20(token).transferFrom(address(this), address(this), amount);
    }
}


/*
Flash Swap Risks
While Flash Swaps offer immense potential, they also come with certain risks:

- Impermanent Loss: If market conditions change drastically during the Flash Swap, you might experience impermanent loss, which could offset your gains.

- Front-Running: Flash Swaps can be vulnerable to front-running, where other traders observe your transaction and execute a similar one before yours, potentially impacting your profits.

- Gas Costs: Flash Swaps involve multiple transactions in a single atomic transaction. Gas costs can be high, so careful cost analysis is crucial.
*/


//UniswapV2 Flash Swap Contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IUniswapV2Callee {
    function uniswapV2Call(
        address sender,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) external;
}

contract UniswapV2FlashSwap is IUniswapV2Callee {
    address private constant UNISWAP_V2_FACTORY =
        0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;

    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    IUniswapV2Factory private constant factory = IUniswapV2Factory(UNISWAP_V2_FACTORY);

    IERC20 private constant weth = IERC20(WETH);

    IUniswapV2Pair private immutable pair;

    // For this example, store the amount to repay
    uint public amountToRepay;

    constructor() {
        pair = IUniswapV2Pair(factory.getPair(DAI, WETH));
    }

    function flashSwap(uint wethAmount) external {
        // Need to pass some data to trigger uniswapV2Call
        bytes memory data = abi.encode(WETH, msg.sender);

        // amount0Out is DAI, amount1Out is WETH
        pair.swap(0, wethAmount, address(this), data);
    }

    // This function is called by the DAI/WETH pair contract
    function uniswapV2Call(
        address sender,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) external {
        require(msg.sender == address(pair), "not pair");
        require(sender == address(this), "not sender");

        (address tokenBorrow, address caller) = abi.decode(data, (address, address));

        // Your custom code would go here. For example, code to arbitrage.
        require(tokenBorrow == WETH, "token borrow != WETH");

        // about 0.3% fee, +1 to round up
        uint fee = (amount1 * 3) / 997 + 1;
        amountToRepay = amount1 + fee;

        // Transfer flash swap fee from caller
        weth.transferFrom(caller, address(this), fee);

        // Repay
        weth.transfer(address(pair), amountToRepay);
    }
}

interface IUniswapV2Pair {
    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;
}

interface IUniswapV2Factory {
    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);
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

Contract Interfaces
- The contract implements the `IUniswapV2Callee` interface.

Contract Constants

- `UNISWAP_V2_FACTORY`: The address of the Uniswap V2 Factory contract.
- `DAI`: The address of the DAI token contract.
- `WETH`: The address of the Wrapped Ether (WETH) token contract.

Contract Variables
- `factory`: An instance of the Uniswap V2 Factory contract.
- `weth`: An instance of the Wrapped Ether (WETH) token.
- `pair`: An immutable instance of the Uniswap V2 Pair contract.
- `amountToRepay`: A variable to store the amount to repay.

Constructor
- The constructor initializes the `pair` variable by creating an instance of the Uniswap V2 Pair contract for the DAI-WETH pair using the Uniswap V2 Factory.

Functions
1. `flashSwap(uint wethAmount) external`
— **Description**: Initiates a flash swap.
— **Parameters**:
— `wethAmount`: The amount of WETH to be swapped.
— **Details**: This function initiates a flash swap by swapping a specified amount of WETH for DAI. It passes data to trigger the `uniswapV2Call` function in the DAI-WETH pair contract.

2. `uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external`
— Description: Callback function called by the DAI-WETH pair contract.
— Parameters:
— `sender`: The sender address.
— `amount0`: The amount of DAI received.
— `amount1`: The amount of WETH received.
— `data`: Additional data containing tokenBorrow and caller addresses.
— Details: This function is called by the DAI-WETH pair contract after a flash swap. It calculates the fee, transfers the fee from the caller, and repays the flash swap.

Interfaces
1. `IUniswapV2Pair`
— Defines the `swap` function for executing swaps in Uniswap V2 pairs.

2. `IUniswapV2Factory`
— Provides a method to retrieve the address of a Uniswap V2 pair contract for a given token pair.

3. `IERC20`
— Defines standard ERC-20 token functions.

4. `IWETH`
— Extends `IERC20` and includes functions for depositing and withdrawing Ether to/from the WETH contract.

Risk Considerations
- Impermanent Loss: Users engaging in flash swaps may encounter impermanent loss due to rapid market fluctuations.

- Front-Running: Flash swaps can be vulnerable to front-running, where others execute similar transactions before the intended user, potentially impacting profits.

- Gas Costs: Flash swaps involve multiple transactions in a single atomic transaction, resulting in high gas costs.

*/