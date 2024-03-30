/*
🧩 Understanding Automated Market Makers (AMMs)
Automated Market Makers (AMMs) are decentralized protocols that facilitate the exchange of assets without the need for traditional order books or intermediaries. They rely on smart contracts to enable users to trade cryptocurrencies directly from their wallets. One of the earliest and most influential AMMs is the Constant Product AMM.

🎯 The Constant Product Formula
At the heart of the Constant Product AMM lies a simple yet elegant mathematical formula:

x * y = k

Here, ‘x’ and ‘y’ represent the quantities of two assets in a liquidity pool, and ‘k’ is a constant. This formula is commonly known as the “invariant,” and it plays a vital role in determining the prices of assets in the pool.

🌐 How the Constant Product AMM Works
1. Initial Liquidity: To kickstart a Constant Product AMM, users deposit an equal value of two different assets into a liquidity pool. For instance, if you want to create a pool for trading Ethereum (ETH) and DAI stablecoins, you would deposit an equal value of ETH and DAI.

2. Price Determination: As traders begin to swap one asset for another within the pool, the constant ‘k’ remains unchanged. This implies that any change in the quantity of one asset will result in a corresponding change in the quantity of the other. Therefore, the price of an asset relative to the other is determined by the ratio of their quantities in the pool.

3. Trading Dynamics: When a trader wishes to make a trade, they interact with the AMM smart contract. The contract calculates the number of tokens they will receive based on the current pool ratios. This ensures that large trades can cause significant price slippage, making AMMs more suitable for smaller trades.

4. Liquidity Providers: Liquidity providers earn fees by supplying assets to the pool. They receive a share of the trading fees in proportion to their contribution to the liquidity pool. This incentivizes users to provide liquidity and maintain the AMM’s operations.

5. Impermanent Loss: Liquidity providers should be aware of impermanent loss, a concept unique to AMMs. It occurs when the price of assets in the pool diverges significantly from the external market. In such cases, liquidity providers may have been better off holding their assets, as impermanent loss can erode potential gains.

*/


//Coding a Constant Product AMM

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ConstantProductAMM {
    address public tokenA;
    address public tokenB;
    uint256 public reserveA;
    uint256 public reserveB;
    event Swap(address indexed trader, uint256 amountAIn, uint256 amountBOut);

    constructor(address _tokenA, address _tokenB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Must provide liquidity");
        reserveA += amountA;
        reserveB += amountB;
    }

    function swap(uint256 amountAIn, uint256 amountBOut) external {
        require(amountAIn > 0 && amountBOut > 0, "Invalid swap");
        uint256 amountBOptimal = (amountAIn + reserveB) / reserveA;
        require(amountBOut <= amountBOptimal, "Insufficient liquidity");
        reserveA += amountAIn;
        reserveB -= amountBOut;
        emit Swap(msg.sender, amountAIn, amountBOut);
    }
}

/*
🔄 Benefits and Challenges of Constant Product AMMs
Benefits:
1. Liquidity Provision: Constant Product AMMs encourage users to provide liquidity, fostering deeper and more efficient markets for a wide range of assets.

2. Accessibility: These AMMs are accessible to anyone with an Ethereum wallet, promoting inclusivity in the world of finance.

3. Decentralization: Constant Product AMMs operate autonomously through smart contracts, eliminating the need for intermediaries.

Challenges:
1. Impermanent Loss: Liquidity providers face the risk of impermanent loss, which can be substantial during periods of high volatility.

2. Limited Price Accuracy: AMMs might not provide the same level of price accuracy as traditional order book exchanges, especially for large trades.

3. Front-Running: AMMs are susceptible to front-running attacks, where malicious actors manipulate the order of transactions to their advantage.
*/

//Constant Product AMM Contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CPAMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint public reserve0;
    uint public reserve1;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address _to, uint _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function _burn(address _from, uint _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    function _update(uint _reserve0, uint _reserve1) private {
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }

    function swap(address _tokenIn, uint _amountIn) external returns (uint amountOut) {
        require(
            _tokenIn == address(token0) || _tokenIn == address(token1),
            "invalid token"
        );
        require(_amountIn > 0, "amount in = 0");

        bool isToken0 = _tokenIn == address(token0);
        (IERC20 tokenIn, IERC20 tokenOut, uint reserveIn, uint reserveOut) = isToken0
            ? (token0, token1, reserve0, reserve1)
            : (token1, token0, reserve1, reserve0);

        tokenIn.transferFrom(msg.sender, address(this), _amountIn);

        /*
        How much dy for dx?

        xy = k
        (x + dx)(y - dy) = k
        y - dy = k / (x + dx)
        y - k / (x + dx) = dy
        y - xy / (x + dx) = dy
        (yx + ydx - xy) / (x + dx) = dy
        ydx / (x + dx) = dy
        */
        // 0.3% fee
        uint amountInWithFee = (_amountIn * 997) / 1000;
        amountOut = (reserveOut * amountInWithFee) / (reserveIn + amountInWithFee);

        tokenOut.transfer(msg.sender, amountOut);

        _update(token0.balanceOf(address(this)), token1.balanceOf(address(this)));
    }

    function addLiquidity(uint _amount0, uint _amount1) external returns (uint shares) {
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);

        /*
        How much dx, dy to add?

        xy = k
        (x + dx)(y + dy) = k'

        No price change, before and after adding liquidity
        x / y = (x + dx) / (y + dy)

        x(y + dy) = y(x + dx)
        x * dy = y * dx

        x / y = dx / dy
        dy = y / x * dx
        */
        if (reserve0 > 0 || reserve1 > 0) {
            require(reserve0 * _amount1 == reserve1 * _amount0, "x / y != dx / dy");
        }

        /*
        How much shares to mint?

        f(x, y) = value of liquidity
        We will define f(x, y) = sqrt(xy)

        L0 = f(x, y)
        L1 = f(x + dx, y + dy)
        T = total shares
        s = shares to mint

        Total shares should increase proportional to increase in liquidity
        L1 / L0 = (T + s) / T

        L1 * T = L0 * (T + s)

        (L1 - L0) * T / L0 = s 
        */

        /*
        Claim
        (L1 - L0) / L0 = dx / x = dy / y

        Proof
        --- Equation 1 ---
        (L1 - L0) / L0 = (sqrt((x + dx)(y + dy)) - sqrt(xy)) / sqrt(xy)
        
        dx / dy = x / y so replace dy = dx * y / x

        --- Equation 2 ---
        Equation 1 = (sqrt(xy + 2ydx + dx^2 * y / x) - sqrt(xy)) / sqrt(xy)

        Multiply by sqrt(x) / sqrt(x)
        Equation 2 = (sqrt(x^2y + 2xydx + dx^2 * y) - sqrt(x^2y)) / sqrt(x^2y)
                   = (sqrt(y)(sqrt(x^2 + 2xdx + dx^2) - sqrt(x^2)) / (sqrt(y)sqrt(x^2))
        
        sqrt(y) on top and bottom cancels out

        --- Equation 3 ---
        Equation 2 = (sqrt(x^2 + 2xdx + dx^2) - sqrt(x^2)) / (sqrt(x^2)
        = (sqrt((x + dx)^2) - sqrt(x^2)) / sqrt(x^2)  
        = ((x + dx) - x) / x
        = dx / x

        Since dx / dy = x / y,
        dx / x = dy / y

        Finally
        (L1 - L0) / L0 = dx / x = dy / y
        */
        if (totalSupply == 0) {
            shares = _sqrt(_amount0 * _amount1);
        } else {
            shares = _min(
                (_amount0 * totalSupply) / reserve0,
                (_amount1 * totalSupply) / reserve1
            );
        }
        require(shares > 0, "shares = 0");
        _mint(msg.sender, shares);

        _update(token0.balanceOf(address(this)), token1.balanceOf(address(this)));
    }

    function removeLiquidity(
        uint _shares
    ) external returns (uint amount0, uint amount1) {
        /*
        Claim
        dx, dy = amount of liquidity to remove
        dx = s / T * x
        dy = s / T * y

        Proof
        Let's find dx, dy such that
        v / L = s / T
        
        where
        v = f(dx, dy) = sqrt(dxdy)
        L = total liquidity = sqrt(xy)
        s = shares
        T = total supply

        --- Equation 1 ---
        v = s / T * L
        sqrt(dxdy) = s / T * sqrt(xy)

        Amount of liquidity to remove must not change price so 
        dx / dy = x / y

        replace dy = dx * y / x
        sqrt(dxdy) = sqrt(dx * dx * y / x) = dx * sqrt(y / x)

        Divide both sides of Equation 1 with sqrt(y / x)
        dx = s / T * sqrt(xy) / sqrt(y / x)
           = s / T * sqrt(x^2) = s / T * x

        Likewise
        dy = s / T * y
        */

        // bal0 >= reserve0
        // bal1 >= reserve1
        uint bal0 = token0.balanceOf(address(this));
        uint bal1 = token1.balanceOf(address(this));

        amount0 = (_shares * bal0) / totalSupply;
        amount1 = (_shares * bal1) / totalSupply;
        require(amount0 > 0 && amount1 > 0, "amount0 or amount1 = 0");

        _burn(msg.sender, _shares);
        _update(bal0 - amount0, bal1 - amount1);

        token0.transfer(msg.sender, amount0);
        token1.transfer(msg.sender, amount1);
    }

    function _sqrt(uint y) private pure returns (uint z) {
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

    function _min(uint x, uint y) private pure returns (uint) {
        return x <= y ? x : y;
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

🛠️ Contract Overview
The CPAMM contract facilitates the exchange of two ERC-20 tokens while maintaining a constant product of their reserves. Let’s break down the key components:

🔑 Key Variables
- `token0` and `token1`: Immutable addresses of the two ERC-20 tokens involved.
- `reserve0` and `reserve1`: Current reserves of token0 and token1.
- `totalSupply`: Total supply of liquidity tokens minted.
- `balanceOf`: A mapping that keeps track of each user’s liquidity token balance.

📝 Functions
1. `swap`: Allows users to swap one token for another within the AMM.
2. `addLiquidity`: Enables users to add liquidity to the AMM pool.
3. `removeLiquidity`: Allows liquidity providers to remove their share of liquidity.

🧮 Mathematical Magic
The contract’s core logic revolves around maintaining the constant product (xy = k) of the two token reserves. This ensures that changes in the quantity of one asset directly impact the quantity of the other, ultimately determining the token prices within the pool.

🤯 Advanced Mathematics
The contract employs advanced mathematical calculations to determine the outcomes of swaps and liquidity additions. These calculations consider fees, price ratios, and proportional shares for liquidity providers.

🧪 Testing the Code
For accurate testing and deployment, it’s essential to consider different scenarios and edge cases. Ensure that the contract functions as expected under various conditions.

📈 Pros and Cons
Pros:

- 🌊 Liquidity Provision: Facilitates liquidity provision in DeFi, enhancing market depth.
- 🌐 Accessibility: Allows anyone with an Ethereum wallet to participate in DeFi.
- 🔐 Decentralization: Operates autonomously via smart contracts, eliminating intermediaries.

Cons:

- 📉 Impermanent Loss: Liquidity providers face the risk of impermanent loss during volatile market conditions.
- 💹 Limited Price Accuracy: May not offer the same price accuracy as traditional order book exchanges for large trades.
- 🏃 Front-Running: Vulnerable to front-running attacks, where malicious actors manipulate transaction order for personal gain.

*/