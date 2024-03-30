/*
What is Uniswap?
Before we dive into the technical details, let’s have a quick refresher on Uniswap. Uniswap is a decentralized exchange (DEX) that runs on the Ethereum blockchain. It allows users to swap various ERC-20 tokens directly from their wallets without the need for a traditional centralized exchange. Uniswap relies on liquidity providers who contribute their tokens to liquidity pools, earning fees in return.

Uniswap V2 Overview
Uniswap has seen several iterations, with Uniswap V2 being one of the most widely used versions. Uniswap V2 introduced several improvements over its predecessor, including support for more complex trading pairs and enhanced price oracles. In this article, we’ll focus on Uniswap V2, which is the go-to choice for many DeFi projects.


Adding Liquidity to Uniswap V2
One of the key features of Uniswap is its ability to provide liquidity to the network. Liquidity providers deposit pairs of tokens into smart contracts called liquidity pools. These pools are used for trading and earn fees from users who swap tokens. Let’s go through the process of adding liquidity step by step.

1. Selecting the Tokens
Before you can add liquidity, you need to select two tokens that you want to provide as a pair. For example, you might choose to provide liquidity for the ETH/DAI trading pair, meaning you’ll need an equal value of Ethereum (ETH) and DAI stablecoins.

2. Approval of Tokens
Before depositing tokens into the liquidity pool, you must approve the smart contract to spend your tokens. This is done through the ERC-20 token’s `approve` function. Here’s an example of how you can approve the contract to spend your tokens:

// Solidity code for token approval
token.approve(uniswapRouterAddress, amount);
3. Depositing Tokens
Once the tokens are approved, you can deposit them into the liquidity pool using the Uniswap V2 router contract. Here’s a code snippet that shows how to do this:

// Solidity code for adding liquidity
uniswapRouter.addLiquidity(
 tokenA,
 tokenB,
 amountADesired,
 amountBDesired,
 amountAMin,
 amountBMin,
 msg.sender,
 deadline
);
In this code:

- `tokenA` and `tokenB` are the addresses of the tokens you’re providing liquidity for.
- `amountADesired` and `amountBDesired` are the desired amounts of Token A and Token B you want to deposit.
- `amountAMin` and `amountBMin` are the minimum amounts you’re willing to deposit.
- `msg.sender` is your Ethereum address.
- `deadline` is a timestamp indicating when the transaction should expire.

4. Receiving LP Tokens
Once you’ve deposited your tokens into the liquidity pool, you’ll receive LP (Liquidity Provider) tokens in return. These LP tokens represent your share of the pool and can be used to redeem your portion of the liquidity at any time.

Removing Liquidity from Uniswap V2
Now that you’ve added liquidity to the pool, you might want to remove it at some point. Here’s how you can do it:

1. Approval for LP Tokens
Before you can remove liquidity, you need to approve the Uniswap V2 router contract to spend your LP tokens. This step is similar to approving the spending of tokens when adding liquidity.

// Solidity code for LP token approval
lpToken.approve(uniswapRouterAddress, lpAmount);
2. Removing Liquidity
Once your LP tokens are approved, you can call the Uniswap V2 router’s `removeLiquidity` function to withdraw your share of the tokens from the liquidity pool. Here’s how you can do it:

// Solidity code for removing liquidity
uniswapRouter.removeLiquidity(
 tokenA,
 tokenB,
 lpAmount,
 amountAMin,
 amountBMin,
 msg.sender,
 deadline
);
In this code:

- `tokenA` and `tokenB` are the addresses of the tokens in the pair.
- `lpAmount` is the number of LP tokens you want to redeem.
- `amountAMin` and `amountBMin` are the minimum amounts of Token A and Token B you want to receive.
- `msg.sender` is your Ethereum address.
- `deadline` is the transaction expiration timestamp.

Advanced Liquidity Management
While the above steps cover the basics of adding and removing liquidity from Uniswap V2, there are some advanced strategies you can employ to optimize your DeFi experience. Let’s explore a few of them.

Impermanent Loss Protection
When you provide liquidity to a pool, you expose yourself to impermanent loss, which occurs when the price of the tokens in the pool changes significantly. To mitigate this risk, some DeFi projects offer IL (Impermanent Loss) protection. This can involve receiving additional tokens or rewards in exchange for providing liquidity.

Yield Farming
Yield farming involves staking your LP tokens in other DeFi protocols to earn additional rewards. These rewards can come in the form of tokens, governance tokens, or other assets. It’s a way to maximize the return on your provided liquidity.

Liquidity Pools Composition
Choosing the right liquidity pools to participate in is crucial. Some pools may offer higher returns, while others may be more stable. Research the pools, their historical performance, and the assets involved before adding liquidity.

Security Considerations
While providing liquidity on Uniswap can be lucrative, it’s essential to keep security in mind. Here are some security considerations:

Smart Contract Audits
Before interacting with any DeFi protocol, including Uniswap, check if the smart contracts have undergone security audits by reputable firms. This helps ensure the code is safe and doesn’t have vulnerabilities.

Use Well-Known Interfaces
Interact with DeFi protocols using well-known interfaces like MetaMask or Trust Wallet. Be cautious of fake websites or apps that might steal your private keys.

Be Wary of High-Risk Pools
Some liquidity pools may offer exceptionally high returns but come with higher risks. Be cautious when participating in such pools, and only invest what you can afford to lose.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UniswapV2AddLiquidity {
    address private constant FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private constant ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;

    function addLiquidity(
        address _tokenA,
        address _tokenB,
        uint _amountA,
        uint _amountB
    ) external {
        safeTransferFrom(IERC20(_tokenA), msg.sender, address(this), _amountA);
        safeTransferFrom(IERC20(_tokenB), msg.sender, address(this), _amountB);

        safeApprove(IERC20(_tokenA), ROUTER, _amountA);
        safeApprove(IERC20(_tokenB), ROUTER, _amountB);

        (uint amountA, uint amountB, uint liquidity) = IUniswapV2Router(ROUTER)
            .addLiquidity(
                _tokenA,
                _tokenB,
                _amountA,
                _amountB,
                1,
                1,
                address(this),
                block.timestamp
            );
    }

    function removeLiquidity(address _tokenA, address _tokenB) external {
        address pair = IUniswapV2Factory(FACTORY).getPair(_tokenA, _tokenB);

        uint liquidity = IERC20(pair).balanceOf(address(this));
        safeApprove(IERC20(pair), ROUTER, liquidity);

        (uint amountA, uint amountB) = IUniswapV2Router(ROUTER).removeLiquidity(
            _tokenA,
            _tokenB,
            liquidity,
            1,
            1,
            address(this),
            block.timestamp
        );
    }

    /**
     * @dev The transferFrom function may or may not return a bool.
     * The ERC-20 spec returns a bool, but some tokens don't follow the spec.
     * Need to check if data is empty or true.
     */
    function safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint amount
    ) internal {
        (bool success, bytes memory returnData) = address(token).call(
            abi.encodeCall(IERC20.transferFrom, (sender, recipient, amount))
        );
        require(
            success && (returnData.length == 0 || abi.decode(returnData, (bool))),
            "Transfer from fail"
        );
    }

    /**
     * @dev The approve function may or may not return a bool.
     * The ERC-20 spec returns a bool, but some tokens don't follow the spec.
     * Need to check if data is empty or true.
     */
    function safeApprove(IERC20 token, address spender, uint amount) internal {
        (bool success, bytes memory returnData) = address(token).call(
            abi.encodeCall(IERC20.approve, (spender, amount))
        );
        require(
            success && (returnData.length == 0 || abi.decode(returnData, (bool))),
            "Approve fail"
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

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
}

interface IUniswapV2Factory {
    function getPair(address token0, address token1) external view returns (address);
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
Contract Overview 🔍
The contract provides two primary functions:

1. `addLiquidity`: Allows users to add liquidity to a Uniswap V2 pool by depositing two ERC-20 tokens. It follows these steps:
— Transfers the specified amounts of Token A and Token B from the user to the contract.
— Approves the Uniswap V2 router contract to spend these tokens.
— Calls the `addLiquidity` function of the router contract to add liquidity to the pool.
— Returns the resulting amounts of Token A, Token B, and liquidity tokens to the contract.

2. `removeLiquidity`: Allows users to remove liquidity from a Uniswap V2 pool. The steps include:
— Obtaining the address of the liquidity pool (pair) corresponding to the provided tokens.
— Approving the Uniswap V2 router contract to spend the liquidity tokens.
— Calling the `removeLiquidity` function of the router contract to remove liquidity from the pool.
— Returning the resulting amounts of Token A and Token B to the contract.

Security Considerations 🔐
The contract incorporates safety measures to handle tokens’ `transferFrom` and `approve` functions. It ensures the success of these operations and prevents unauthorized transfers.

Contract Interfaces 👩‍💻
This contract interacts with various interfaces to access Uniswap V2 functionality:

- `IUniswapV2Router`: Interface for Uniswap V2 Router, providing functions for adding and removing liquidity.

- `IUniswapV2Factory`: Interface for Uniswap V2 Factory, used to retrieve the liquidity pool address.

- `IERC20`: Interface for the ERC-20 token standard, ensuring compatibility with different tokens.

Usage and Deployment 📦
To use this contract, you’ll need to deploy it on the Ethereum network. Ensure that the `FACTORY`, `ROUTER`, `WETH`, and `USDT` addresses are correctly set to the corresponding contract addresses on the Ethereum mainnet or the target network.
*/