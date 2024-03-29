/*
Create2 is an EVM opcode introduced with Ethereum Improvement Proposal (EIP) 1014. Unlike the traditional contract deployment opcode (CREATE), which determines the contract address based on the sender and nonce, Create2 allows developers to calculate the contract address based on a deterministic salt value.

The formula to calculate the Create2 contract address is as follows:

contractAddress = hash(0xff ++ deployingAddress ++ salt ++ hash(initCode))[12:]
Here:
- `hash()` refers to the Keccak-256 hash function.
- `++` represents concatenation.
- `deployingAddress` is the address of the contract deployer.
- `salt` is a user-defined value used to make the address unique.
- `initCode` is the bytecode of the contract to be deployed.

By varying the `salt` value, developers can generate multiple contract addresses with the same `initCode`. This capability opens up a world of possibilities for optimizing contract deployments and interactions.

Benefits of Precomputing Contract Addresses with Create2 ✨
1. Gas Savings: Since contract addresses are precomputed off-chain, you can deploy the contract at a specific address. This eliminates the need to calculate the address on-chain, leading to reduced gas costs during deployment.

2. Time-Efficient Deployment: By precomputing the contract address, deployment can be performed quickly and efficiently, as the calculation is done off-chain.

3. Address Determinism: With Create2, you can ensure that the contract will be deployed at a known address, improving the predictability of your smart contract ecosystem.

4. Optimizing Contract Interactions: By deploying contracts at predetermined addresses, you can enhance contract interactions by making use of these predictable addresses.

5. Upgradeability and Versioning: Create2 also facilitates smart contract upgrades, as you can deploy new versions at the same predetermined addresses, allowing seamless migration of data and interactions.
*/


//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Contract to generate salt value
contract SaltGenerator {
    function generateSalt(address user) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(user));
    }
}

// Contract using Create2
contract PrecomputedContract {
    bytes32 public contractSalt;

    constructor(bytes32 salt) {
        contractSalt = salt;
    }
    function deployNewContract(bytes memory initCode) external {
        address contractAddress = address( // Convert last 20 bytes to address
        uint160( // Convert to 20 bytes
        uint256( // Convert to 32 bytes
        keccak256( // Hash the following data
        abi.encodePacked(
        bytes1(0xff), // EIP-191 header
        address(this), // Address of the contract
        contractSalt, // Salt value
        keccak256(initCode) // Hash of contract bytecode
        )
        )
        )
        )
        );
    // Deploy the contract at 'contractAddress' using initCode
        assembly {
            mstore(0x0, 0x00) // Place the length of initCode at the beginning of the memory
            mstore(0x20, mload(initCode)) // Copy initCode to memory
            create2(0, 0, 32, 0x20) // Deploy the contract using create2 opcode
        }
    }
}


/*
Real-World Use Cases 🌐
Let’s explore some practical use cases for precomputing contract addresses with Create2:

1. Decentralized Exchanges (DEXs): DEXs can use Create2 to precompute contract addresses for new trading pairs. This way, users can directly interact with the predictable contract addresses for their desired trading pairs, leading to improved trading efficiency and lower gas costs.

2. Token Vesting and Timelock Contracts: Projects with vesting or timelock contracts can precompute the contract addresses for each user’s vesting schedule. This ensures transparency and allows users to monitor their token release schedules without relying on complex calculations.

3. Upgradable Smart Contracts: Projects that require upgradability can use Create2 to deploy new contract versions at predetermined addresses. This approach simplifies the process of upgrading and migrating data while maintaining compatibility with existing systems.
*/

contract Factory {
    function deploy(address _owner, uint _foo, bytes32 _salt) public payable returns (address) {
        return address(new TestContract{salt: _salt}(_owner, _foo));
    }
}

/*
`TestContract` contract using the newer way of invoking `create2`. It accepts three parameters `_owner`, `_foo`, and `_salt`. When `deploy` is called, it creates a new instance of `TestContract` with the specified `_owner` and `_foo` values and deploys it using the provided `_salt`. This is a clean and straightforward way to utilize Create2, as it allows you to directly pass the `_salt` value to the contract constructor.
*/


contract FactoryAssembly {
    event Deployed(address addr, uint salt);
    function getBytecode(address _owner, uint _foo) public pure returns (bytes memory) {
        bytes memory bytecode = type(TestContract).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_owner, _foo));
    }
    function getAddress(bytes memory bytecode, uint _salt) public view returns (address) {
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(bytecode)));
        return address(uint160(uint(hash)));
    }
    function deploy(bytes memory bytecode, uint _salt) public payable {
        address addr;
        assembly {
            addr := create2(callvalue(), add(bytecode, 0x20), mload(bytecode), _salt)
            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }
        emit Deployed(addr, _salt);
    }
}

/*
The `FactoryAssembly` contract is an alternative implementation of the factory contract. It consists of three main functions: `getBytecode`, `getAddress`, and `deploy`.

- `getBytecode`: This function returns the bytecode needed to deploy the `TestContract` along with the constructor arguments `_owner` and `_foo`. It uses the `creationCode` of the `TestContract` to obtain the contract’s bytecode and then encodes the constructor arguments to be passed during deployment.

- `getAddress`: This function calculates the contract address that would be generated if the contract is deployed with the given `_salt`. It follows the same Create2 formula as shown in the introduction, including the EIP-191 header and the appropriate parameters.

- `deploy`: This function is similar to the `deploy` function in the `Factory` contract. It deploys the contract using the Create2 opcode with the provided bytecode and `_salt`. The `assembly` block contains low-level instructions to create the contract instance.
*/


contract TestContract {
    address public owner;
    uint public foo;
    constructor(address _owner, uint _foo) payable {
        owner = _owner;
        foo = _foo;
    }
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

/*
The `TestContract` is a simple contract with a constructor that sets the `owner` and `foo` variables and a `getBalance` function to return the contract’s balance.
*/