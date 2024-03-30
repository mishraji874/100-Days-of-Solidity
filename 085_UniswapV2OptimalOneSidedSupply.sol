/*
Understanding One-Sided Liquidity
In the world of DeFi, liquidity providers play a vital role by supplying assets to liquidity pools. These pools consist of two main tokens, typically in equal proportions, creating a balanced pool. However, one-sided liquidity refers to a situation where a liquidity provider supplies only one of the two tokens in the pair.

For instance, instead of providing an equal amount of ETH and DAI to a Uniswap pool, a liquidity provider might choose to supply only ETH. This results in an unbalanced pool, and it’s here that the Uniswap V2 Optimal One-Sided Supply strategy comes into play.

The Optimal One-Sided Supply Strategy
The Optimal One-Sided Supply strategy is a DeFi technique that aims to maximize yield for liquidity providers who are inclined to supply only one token to a Uniswap V2 liquidity pool. This strategy takes advantage of the fact that many traders only swap one side of the pair, creating an opportunity for liquidity providers to optimize their returns.

Benefits of the Strategy
1. Higher Yield: By providing liquidity on one side of a pool, you can earn a higher percentage of trading fees since your assets are used more frequently in trades.

2. Reduced Impermanent Loss: Impermanent loss occurs when the price of the tokens in the pool changes relative to when you provided liquidity. One-sided liquidity providers are less exposed to this risk since they only supply one token.

3. Capital Efficiency: This strategy allows you to make the most of your assets by concentrating them in a single token, rather than splitting them between two.
*/


//Basic Code for Optimal One Sided Supply

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract OneSidedSupplyStrategy {
    address public owner;
    IUniswapV2Router02 public router;
    address public tokenToProvide;
    uint256 public amountToProvide;

    constructor(
        address _router,
        address _tokenToProvide,
        uint256 _amountToProvide
    ) {
        owner = msg.sender;
        router = IUniswapV2Router02(_router);
        tokenToProvide = _tokenToProvide;
        amountToProvide = _amountToProvide;
    }

    //approve the router to spend your tokens
    function approveRouter() external {
        IERC20(tokenToProvide).approve(address(router), amountToProvide);
    }

    //execute the optimal one-sided supply
    function provideOneSidedLiquidity() external {
        //perform checks here, such as ensuring the contract balance is sufficient
        //to handle potential withdrawls

        //Add liquidity with one-sided supply
        router.addLiquidityETH{value: msg.value} (
            tokenToProvide,
            amountToProvide,
            0,
            0,
            address(this),
            block.timestamp + 3600
        );
    }

    //withdraw liquidity and tokens
    function withdrawLiquidity(uint256 _liquidity) external {
        //implement withdrawal logic here, considering potential fees and locks.
    }

    //other functions
}


// Uniswap Optimal One-sided Supply

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TestUniswapOptimalOneSidedSupply {
    address private constant FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private constant ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function sqrt(uint y) private pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    /*
    s = optimal swap amount
    r = amount of reserve for token a
    a = amount of token a the user currently has (not added to reserve yet)
    f = swap fee percent
    s = (sqrt(((2 - f)r)^2 + 4(1 - f)ar) - (2 - f)r) / (2(1 - f))
    */
    function getSwapAmount(uint r, uint a) public pure returns (uint) {
        return (sqrt(r * (r * 3988009 + a * 3988000)) - r * 1997) / 1994;
    }

    /* Optimal one-sided supply
    1. Swap optimal amount from token A to token B
    2. Add liquidity
    */
    function zap(address _tokenA, address _tokenB, uint _amountA) external {
        require(_tokenA == WETH || _tokenB == WETH, "!weth");

        IERC20(_tokenA).transferFrom(msg.sender, address(this), _amountA);

        address pair = IUniswapV2Factory(FACTORY).getPair(_tokenA, _tokenB);
        (uint reserve0, uint reserve1, ) = IUniswapV2Pair(pair).getReserves();

        uint swapAmount;
        if (IUniswapV2Pair(pair).token0() == _tokenA) {
            // swap from token0 to token1
            swapAmount = getSwapAmount(reserve0, _amountA);
        } else {
            // swap from token1 to token0
            swapAmount = getSwapAmount(reserve1, _amountA);
        }

        _swap(_tokenA, _tokenB, swapAmount);
        _addLiquidity(_tokenA, _tokenB);
    }

    function _swap(address _from, address _to, uint _amount) internal {
        IERC20(_from).approve(ROUTER, _amount);

        address[] memory path = new address[](2);
        path = new address[](2);
        path[0] = _from;
        path[1] = _to;

        IUniswapV2Router(ROUTER).swapExactTokensForTokens(
            _amount,
            1,
            path,
            address(this),
            block.timestamp
        );
    }

    function _addLiquidity(address _tokenA, address _tokenB) internal {
        uint balA = IERC20(_tokenA).balanceOf(address(this));
        uint balB = IERC20(_tokenB).balanceOf(address(this));
        IERC20(_tokenA).approve(ROUTER, balA);
        IERC20(_tokenB).approve(ROUTER, balB);

        IUniswapV2Router(ROUTER).addLiquidity(
            _tokenA,
            _tokenB,
            balA,
            balB,
            0,
            0,
            address(this),
            block.timestamp
        );
    }
}

interface IUniswapV2Router {
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}

interface IUniswapV2Factory {
    function getPair(address token0, address token1) external view returns (address);
}

interface IUniswapV2Pair {
    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
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
}


/*
Summary
The Uniswap Optimal One-Sided Supply contract was audited to assess its security, functionality, and compliance with best practices. The audit identified several areas that require attention and recommended improvements. While the contract demonstrates a functional One-Sided Liquidity Supply strategy for Uniswap, it should undergo further testing and code optimization before deployment.

Findings and Recommendations
1. Lack of Comprehensive Comments
Severity: Moderate

Recommendation: It is crucial to provide comprehensive inline comments explaining the functionality of functions, variables, and any complex logic. This will enhance code readability and make it easier for developers to understand the contract.

2. Missing Error Handling
Severity: High

Recommendation: The contract lacks error handling for critical operations like token transfers and approvals. Implementing proper error handling with meaningful error messages is essential to ensure the safety of the contract.

3. No Reentrancy Protection
Severity: High

Recommendation: The contract does not include any reentrancy protection mechanisms. Consider implementing reentrancy guards using the “ReentrancyGuard” pattern or similar methods to prevent potential reentrancy attacks.

4. Incomplete Implementation
Severity: High

Recommendation: The contract references external interfaces like IUniswapV2Router, IUniswapV2Factory, IUniswapV2Pair, and IERC20. However, the code does not include the full implementation of these interfaces. Ensure that the required interface functions are correctly implemented for the contract to work as intended.

5. Lack of Withdrawal Function
Severity: Moderate

Recommendation: The contract lacks a withdrawal function for users to retrieve their provided liquidity. Implement a withdrawal function with appropriate logic to allow users to withdraw their assets from the contract.

6. Code Optimization
Severity: Low

Recommendation: The contract contains some redundant code, such as initializing the “path” array multiple times in the “_swap” function. Removing redundancy and optimizing the code can reduce gas costs and improve efficiency.
*/