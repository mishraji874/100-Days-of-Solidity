/*
What is a Stable Swap AMM?
A Stable Swap AMM is a specialized type of automated market maker designed to facilitate the exchange of stablecoins in a decentralized manner. Stablecoins are cryptocurrencies that aim to maintain a stable value, often pegged to a fiat currency like the US Dollar. These tokens are vital for reducing the volatility typically associated with cryptocurrencies and are widely used in DeFi protocols.

Stable Swap AMMs offer a crucial infrastructure component for DeFi by allowing users to swap one type of stablecoin for another with low slippage and minimal fees. They are a key building block for decentralized exchanges (DEXs), lending platforms, and yield farming protocols. 💱🏦

How Does a Stable Swap AMM Work?
To understand how a Stable Swap AMM functions, we need to grasp the basics of traditional automated market makers (AMMs) like Uniswap and SushiSwap. These AMMs rely on liquidity pools, where users deposit their tokens to provide liquidity for trades. In return, they receive a share of the trading fees generated by the pool.

However, traditional AMMs work well for assets with similar price volatility. When it comes to stablecoins, which are designed to have a stable value, traditional AMMs encounter some challenges. Stable Swap AMMs address these challenges by optimizing for low slippage in stablecoin-to-stablecoin swaps.

Here’s a simplified breakdown of how a Stable Swap AMM operates:

1. Initial Pool Setup: Users deposit various stablecoins into a liquidity pool. These stablecoins should ideally have a 1:1 value ratio, meaning 1 USDT equals 1 USDC, for instance.

2. Invariant Function: Instead of using the constant product invariant (as seen in traditional AMMs), Stable Swap AMMs utilize an invariant function tailored to stablecoins. This function ensures that the value of assets in the pool remains balanced.

3. Swap Execution: When a user wants to swap one stablecoin for another, the Stable Swap AMM calculates the optimal trade path to minimize slippage. This involves adjusting the proportions of stablecoins in the pool dynamically.

4. Fees and Incentives: Users providing liquidity to the pool receive a portion of the trading fees generated. This incentivizes liquidity provision.

5. Stability Maintenance: The Stable Swap AMM continuously rebalances the pool to maintain stablecoin pegs. Arbitrageurs are motivated to correct deviations from the peg by profiting from price discrepancies on different exchanges.

*/


//Code Implementation

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns(bool) {
        // add other erc20 functions here
    }
}

contract StableSwapAMM {
    address public usdt;
    address public usdc;
    uint256 public usdtBalance;
    uint256 public usdcBalance;

    constructor(address _usdt, address _usdc) {
        usdt = _usdt;
        usdc = _usdc;
    }

    function swapUSDTtoUSDC(uint256 amount) external {
        //implement logic for swapping USDT to USDc
        //adjust balances and execute the swap
    }

    function swapUSDCtoUSDT(uint256 amount) external {
        //implement logic for swapping USDC to USDT
        //adjust balances and execute the swap
    }

    //add liquidity and other functions here
}


/*
Benefits of Stable Swap AMMs
Now that we have a solid grasp of how Stable Swap AMMs function, let’s explore their benefits:

1. Low Slippage
Stable Swap AMMs are optimized for stablecoin trading, ensuring minimal slippage even during significant volume fluctuations.

2. Reduced Fees
Compared to centralized exchanges, Stable Swap AMMs typically have lower trading fees, making them attractive to users.

3. Decentralization
They operate on blockchain networks, eliminating the need for intermediaries and providing users with full control over their assets.

4. Liquidity Provision
Users can earn passive income by providing liquidity to Stable Swap AMMs and receiving a share of the trading fees.

Challenges and Considerations
While Stable Swap AMMs offer numerous advantages, they also come with challenges and considerations:

1. Impermanent Loss
Liquidity providers may suffer impermanent loss when the relative prices of stablecoins in the pool deviate from the external market.

2. Algorithm Complexity
Developing an efficient Stable Swap AMM algorithm can be challenging due to the need to balance stability with flexibility.

3. Regulatory Scrutiny
The DeFi space, including Stable Swap AMMs, is under increasing regulatory scrutiny in various jurisdictions.
*/


// StableSwap AMM Report 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

/*
Invariant - price of trade and amount of liquidity are determined by this equation

An^n sum(x_i) + D = ADn^n + D^(n + 1) / (n^n prod(x_i))

Topics
0. Newton's method x_(n + 1) = x_n - f(x_n) / f'(x_n)
1. Invariant
2. Swap
   - Calculate Y
   - Calculate D
3. Get virtual price
4. Add liquidity
   - Imbalance fee
5. Remove liquidity
6. Remove liquidity one token
   - Calculate withdraw one token
   - getYD
TODO: test?
*/

library Math {
    function abs(uint x, uint y) internal pure returns (uint) {
        return x >= y ? x - y : y - x;
    }
}

contract StableSwap {
    // Number of tokens
    uint private constant N = 3;
    // Amplification coefficient multiplied by N^(N - 1)
    // Higher value makes the curve more flat
    // Lower value makes the curve more like constant product AMM
    uint private constant A = 1000 * (N ** (N - 1));
    // 0.03%
    uint private constant SWAP_FEE = 300;
    // Liquidity fee is derived from 2 constraints
    // 1. Fee is 0 for adding / removing liquidity that results in a balanced pool
    // 2. Swapping in a balanced pool is like adding and then removing liquidity
    //    from a balanced pool
    // swap fee = add liquidity fee + remove liquidity fee
    uint private constant LIQUIDITY_FEE = (SWAP_FEE * N) / (4 * (N - 1));
    uint private constant FEE_DENOMINATOR = 1e6;

    address[N] public tokens;
    // Normalize each token to 18 decimals
    // Example - DAI (18 decimals), USDC (6 decimals), USDT (6 decimals)
    uint[N] private multipliers = [1, 1e12, 1e12];
    uint[N] public balances;

    // 1 share = 1e18, 18 decimals
    uint private constant DECIMALS = 18;
    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address[N] memory _tokens) {
        tokens = _tokens;
    }

    function _mint(address _to, uint _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function _burn(address _from, uint _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    // Return precision-adjusted balances, adjusted to 18 decimals
    function _xp() private view returns (uint[N] memory xp) {
        for (uint i; i < N; ++i) {
            xp[i] = balances[i] * multipliers[i];
        }
    }

    /**
     * @notice Calculate D, sum of balances in a perfectly balanced pool
     * If balances of x_0, x_1, ... x_(n-1) then sum(x_i) = D
     * @param xp Precision-adjusted balances
     * @return D
     */
    function _getD(uint[N] memory xp) private pure returns (uint) {
        /*
        Newton's method to compute D
        -----------------------------
        f(D) = ADn^n + D^(n + 1) / (n^n prod(x_i)) - An^n sum(x_i) - D 
        f'(D) = An^n + (n + 1) D^n / (n^n prod(x_i)) - 1

                     (as + np)D_n
        D_(n+1) = -----------------------
                  (a - 1)D_n + (n + 1)p

        a = An^n
        s = sum(x_i)
        p = (D_n)^(n + 1) / (n^n prod(x_i))
        */
        uint a = A * N; // An^n

        uint s; // x_0 + x_1 + ... + x_(n-1)
        for (uint i; i < N; ++i) {
            s += xp[i];
        }

        // Newton's method
        // Initial guess, d <= s
        uint d = s;
        uint d_prev;
        for (uint i; i < 255; ++i) {
            // p = D^(n + 1) / (n^n * x_0 * ... * x_(n-1))
            uint p = d;
            for (uint j; j < N; ++j) {
                p = (p * d) / (N * xp[j]);
            }
            d_prev = d;
            d = ((a * s + N * p) * d) / ((a - 1) * d + (N + 1) * p);

            if (Math.abs(d, d_prev) <= 1) {
                return d;
            }
        }
        revert("D didn't converge");
    }

    /**
     * @notice Calculate the new balance of token j given the new balance of token i
     * @param i Index of token in
     * @param j Index of token out
     * @param x New balance of token i
     * @param xp Current precision-adjusted balances
     */
    function _getY(
        uint i,
        uint j,
        uint x,
        uint[N] memory xp
    ) private pure returns (uint) {
        /*
        Newton's method to compute y
        -----------------------------
        y = x_j

        f(y) = y^2 + y(b - D) - c

                    y_n^2 + c
        y_(n+1) = --------------
                   2y_n + b - D

        where
        s = sum(x_k), k != j
        p = prod(x_k), k != j
        b = s + D / (An^n)
        c = D^(n + 1) / (n^n * p * An^n)
        */
        uint a = A * N;
        uint d = _getD(xp);
        uint s;
        uint c = d;

        uint _x;
        for (uint k; k < N; ++k) {
            if (k == i) {
                _x = x;
            } else if (k == j) {
                continue;
            } else {
                _x = xp[k];
            }

            s += _x;
            c = (c * d) / (N * _x);
        }
        c = (c * d) / (N * a);
        uint b = s + d / a;

        // Newton's method
        uint y_prev;
        // Initial guess, y <= d
        uint y = d;
        for (uint _i; _i < 255; ++_i) {
            y_prev = y;
            y = (y * y + c) / (2 * y + b - d);
            if (Math.abs(y, y_prev) <= 1) {
                return y;
            }
        }
        revert("y didn't converge");
    }

    /**
     * @notice Calculate the new balance of token i given precision-adjusted
     * balances xp and liquidity d
     * @dev Equation is calculate y is same as _getY
     * @param i Index of token to calculate the new balance
     * @param xp Precision-adjusted balances
     * @param d Liquidity d
     * @return New balance of token i
     */
    function _getYD(uint i, uint[N] memory xp, uint d) private pure returns (uint) {
        uint a = A * N;
        uint s;
        uint c = d;

        uint _x;
        for (uint k; k < N; ++k) {
            if (k != i) {
                _x = xp[k];
            } else {
                continue;
            }

            s += _x;
            c = (c * d) / (N * _x);
        }
        c = (c * d) / (N * a);
        uint b = s + d / a;

        // Newton's method
        uint y_prev;
        // Initial guess, y <= d
        uint y = d;
        for (uint _i; _i < 255; ++_i) {
            y_prev = y;
            y = (y * y + c) / (2 * y + b - d);
            if (Math.abs(y, y_prev) <= 1) {
                return y;
            }
        }
        revert("y didn't converge");
    }

    // Estimate value of 1 share
    // How many tokens is one share worth?
    function getVirtualPrice() external view returns (uint) {
        uint d = _getD(_xp());
        uint _totalSupply = totalSupply;
        if (_totalSupply > 0) {
            return (d * 10 ** DECIMALS) / _totalSupply;
        }
        return 0;
    }

    /**
     * @notice Swap dx amount of token i for token j
     * @param i Index of token in
     * @param j Index of token out
     * @param dx Token in amount
     * @param minDy Minimum token out
     */
    function swap(uint i, uint j, uint dx, uint minDy) external returns (uint dy) {
        require(i != j, "i = j");

        IERC20(tokens[i]).transferFrom(msg.sender, address(this), dx);

        // Calculate dy
        uint[N] memory xp = _xp();
        uint x = xp[i] + dx * multipliers[i];

        uint y0 = xp[j];
        uint y1 = _getY(i, j, x, xp);
        // y0 must be >= y1, since x has increased
        // -1 to round down
        dy = (y0 - y1 - 1) / multipliers[j];

        // Subtract fee from dy
        uint fee = (dy * SWAP_FEE) / FEE_DENOMINATOR;
        dy -= fee;
        require(dy >= minDy, "dy < min");

        balances[i] += dx;
        balances[j] -= dy;

        IERC20(tokens[j]).transfer(msg.sender, dy);
    }

    function addLiquidity(
        uint[N] calldata amounts,
        uint minShares
    ) external returns (uint shares) {
        // calculate current liquidity d0
        uint _totalSupply = totalSupply;
        uint d0;
        uint[N] memory old_xs = _xp();
        if (_totalSupply > 0) {
            d0 = _getD(old_xs);
        }

        // Transfer tokens in
        uint[N] memory new_xs;
        for (uint i; i < N; ++i) {
            uint amount = amounts[i];
            if (amount > 0) {
                IERC20(tokens[i]).transferFrom(msg.sender, address(this), amount);
                new_xs[i] = old_xs[i] + amount * multipliers[i];
            } else {
                new_xs[i] = old_xs[i];
            }
        }

        // Calculate new liquidity d1
        uint d1 = _getD(new_xs);
        require(d1 > d0, "liquidity didn't increase");

        // Reccalcuate D accounting for fee on imbalance
        uint d2;
        if (_totalSupply > 0) {
            for (uint i; i < N; ++i) {
                // TODO: why old_xs[i] * d1 / d0? why not d1 / N?
                uint idealBalance = (old_xs[i] * d1) / d0;
                uint diff = Math.abs(new_xs[i], idealBalance);
                new_xs[i] -= (LIQUIDITY_FEE * diff) / FEE_DENOMINATOR;
            }

            d2 = _getD(new_xs);
        } else {
            d2 = d1;
        }

        // Update balances
        for (uint i; i < N; ++i) {
            balances[i] += amounts[i];
        }

        // Shares to mint = (d2 - d0) / d0 * total supply
        // d1 >= d2 >= d0
        if (_totalSupply > 0) {
            shares = ((d2 - d0) * _totalSupply) / d0;
        } else {
            shares = d2;
        }
        require(shares >= minShares, "shares < min");
        _mint(msg.sender, shares);
    }

    function removeLiquidity(
        uint shares,
        uint[N] calldata minAmountsOut
    ) external returns (uint[N] memory amountsOut) {
        uint _totalSupply = totalSupply;

        for (uint i; i < N; ++i) {
            uint amountOut = (balances[i] * shares) / _totalSupply;
            require(amountOut >= minAmountsOut[i], "out < min");

            balances[i] -= amountOut;
            amountsOut[i] = amountOut;

            IERC20(tokens[i]).transfer(msg.sender, amountOut);
        }

        _burn(msg.sender, shares);
    }

    /**
     * @notice Calculate amount of token i to receive for shares
     * @param shares Shares to burn
     * @param i Index of token to withdraw
     * @return dy Amount of token i to receive
     *         fee Fee for withdraw. Fee already included in dy
     */
    function _calcWithdrawOneToken(
        uint shares,
        uint i
    ) private view returns (uint dy, uint fee) {
        uint _totalSupply = totalSupply;
        uint[N] memory xp = _xp();

        // Calculate d0 and d1
        uint d0 = _getD(xp);
        uint d1 = d0 - (d0 * shares) / _totalSupply;

        // Calculate reduction in y if D = d1
        uint y0 = _getYD(i, xp, d1);
        // d1 <= d0 so y must be <= xp[i]
        uint dy0 = (xp[i] - y0) / multipliers[i];

        // Calculate imbalance fee, update xp with fees
        uint dx;
        for (uint j; j < N; ++j) {
            if (j == i) {
                dx = (xp[j] * d1) / d0 - y0;
            } else {
                // d1 / d0 <= 1
                dx = xp[j] - (xp[j] * d1) / d0;
            }
            xp[j] -= (LIQUIDITY_FEE * dx) / FEE_DENOMINATOR;
        }

        // Recalculate y with xp including imbalance fees
        uint y1 = _getYD(i, xp, d1);
        // - 1 to round down
        dy = (xp[i] - y1 - 1) / multipliers[i];
        fee = dy0 - dy;
    }

    function calcWithdrawOneToken(
        uint shares,
        uint i
    ) external view returns (uint dy, uint fee) {
        return _calcWithdrawOneToken(shares, i);
    }

    /**
     * @notice Withdraw liquidity in token i
     * @param shares Shares to burn
     * @param i Token to withdraw
     * @param minAmountOut Minimum amount of token i that must be withdrawn
     */
    function removeLiquidityOneToken(
        uint shares,
        uint i,
        uint minAmountOut
    ) external returns (uint amountOut) {
        (amountOut, ) = _calcWithdrawOneToken(shares, i);
        require(amountOut >= minAmountOut, "out < min");

        balances[i] -= amountOut;
        _burn(msg.sender, shares);

        IERC20(tokens[i]).transfer(msg.sender, amountOut);
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

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
}


/*
Code Overview 🧮
The provided code presents a foundational implementation of a StableSwap AMM in Solidity. Let’s break down some critical components:

1. Math Library: A custom Math library is included to calculate absolute differences between two numbers.

2. Constructor: The contract constructor initializes the StableSwap with an array of stablecoin tokens. In this example, it’s set to work with three tokens: DAI, USDC, and USDT.

3. Constants: Constants like the number of tokens (N), amplification coefficient (A), and fees are defined. Notably, the swap fee and liquidity fee are set at 0.03% each.

4. Balances and Multipliers: Balances for each token and their corresponding multipliers (for normalizing decimals) are maintained.

5. Liquidity Management: Functions for adding and removing liquidity are implemented, with logic for calculating shares and fees.

6. Swap Function: The swap function allows users to exchange one stablecoin for another. It calculates the expected output amount while considering fees.

7. getVirtualPrice: This function estimates the virtual price of one share in the pool.

8. Internal Functions: Several internal functions, like `_xp`, `_getD`, `_getY`, and `_getYD`, are used to perform precise calculations within the StableSwap AMM.

Mathematics Behind StableSwap 🧮
The StableSwap AMM relies on complex mathematical equations, including Newton’s method, to calculate values like the invariant “D” and exchange amounts accurately. These equations ensure that the pool remains balanced and the stablecoin pegs are maintained.

Benefits and Challenges 📈📉
StableSwap AMMs offer low slippage, reduced fees, decentralization, and opportunities for liquidity providers. However, they also face challenges such as impermanent loss and algorithm complexity.

*/