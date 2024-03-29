/*
Upgradeable proxies come to the rescue by allowing smart contracts to evolve over time while preserving their historical data and relationships with other contracts. In this article, we will dive deep into the upgradeable proxy pattern, its benefits, and how to implement it in Solidity.

What is an Upgradeable Proxy?
An upgradeable proxy is a smart contract design pattern that separates the implementation logic of a smart contract from its data storage. The proxy acts as an intermediary between users and the actual smart contract logic, known as the “implementation contract.” The implementation contract is the part of the system that holds the business logic, while the proxy facilitates interactions and delegates function calls to the implementation contract.


#100DaysOfSolidity #056 🚀 Upgradeable Proxy
Why Upgradeable Proxies?
🛠️ Flexibility: Upgradeable proxies allow smart contracts to adapt to changing requirements, bug fixes, and feature enhancements without disrupting the entire system. It saves users from having to migrate to a new contract and preserves the continuity of the application.

💾 Data Persistence: Since the proxy is separate from the implementation contract, upgrading the contract logic does not affect the stored data. Users can keep their data intact while enjoying the latest features and improvements.

🚀 Future-Proof: By using upgradeable proxies, developers can future-proof their applications. They can implement essential functionalities now and add more features as blockchain technology evolves.

How to Implement an Upgradeable Proxy?
Let’s explore how to create a basic upgradeable proxy in Solidity. For the sake of simplicity, we will focus on the logic of the proxy, leaving out certain security considerations such as access controls.
*/

//How to Implement an Upgradeable Proxy?

//Step1: The Proxy Contract

//SPDx-License-Idetnfier: MIt

pragma solidity ^0.8.0;

contract UpgradeableProxy {
    address public implementation;
    constructor(address _implementation) {
        implementation = _implementation;
    }

    fallback() external {
        address _impl = implementation;
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), _impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
                case 0 {
                    revert(0, returndatasize())
                }
                default {
                    return(0, returndatasize())
                }
        }
    }
}

//The proxy contract holds the address of the implementation contract, which is set during deployment. The fallback function allows the proxy to receive and forward function calls to the implementation contract using delegatecall.

//Step 2: The Implementation Contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Implementation {
    uint256 public data;
    function setData(uint256 _data) external {
        data = _data;
    }
    function getData() external view returns (uint256) {
        return data;
    }
}
// The implementation contract contains the business logic and in this example, it has a simple data storage functionality.

// Step 3: Upgrading the Implementation

// To upgrade the contract, a new implementation contract is deployed, and its address is updated in the proxy contract. The new implementation can have added functionalities or bug fixes. The upgrade process can be performed manually or automated based on specific conditions.


//Analysis of Upgradeable Proxy Smart Contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Transparent upgradeable proxy pattern

contract CounterV1 {
    uint public count;

    function inc() external {
        count += 1;
    }
}

contract CounterV2 {
    uint public count;

    function inc() external {
        count += 1;
    }

    function dec() external {
        count -= 1;
    }
}

contract BuggyProxy {
    address public implementation;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function _delegate() private {
        (bool ok, ) = implementation.delegatecall(msg.data);
        require(ok, "delegatecall failed");
    }

    fallback() external payable {
        _delegate();
    }

    receive() external payable {
        _delegate();
    }

    function upgradeTo(address _implementation) external {
        require(msg.sender == admin, "not authorized");
        implementation = _implementation;
    }
}

contract Dev {
    function selectors() external view returns (bytes4, bytes4, bytes4) {
        return (
            Proxy.admin.selector,
            Proxy.implementation.selector,
            Proxy.upgradeTo.selector
        );
    }
}

contract Proxy {
    // All functions / variables should be private, forward all calls to fallback

    // -1 for unknown preimage
    // 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
    bytes32 private constant IMPLEMENTATION_SLOT =
        bytes32(uint(keccak256("eip1967.proxy.implementation")) - 1);
    // 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103
    bytes32 private constant ADMIN_SLOT =
        bytes32(uint(keccak256("eip1967.proxy.admin")) - 1);

    constructor() {
        _setAdmin(msg.sender);
    }

    modifier ifAdmin() {
        if (msg.sender == _getAdmin()) {
            _;
        } else {
            _fallback();
        }
    }

    function _getAdmin() private view returns (address) {
        return StorageSlot.getAddressSlot(ADMIN_SLOT).value;
    }

    function _setAdmin(address _admin) private {
        require(_admin != address(0), "admin = zero address");
        StorageSlot.getAddressSlot(ADMIN_SLOT).value = _admin;
    }

    function _getImplementation() private view returns (address) {
        return StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value;
    }

    function _setImplementation(address _implementation) private {
        require(_implementation.code.length > 0, "implementation is not contract");
        StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value = _implementation;
    }

    // Admin interface //
    function changeAdmin(address _admin) external ifAdmin {
        _setAdmin(_admin);
    }

    // 0x3659cfe6
    function upgradeTo(address _implementation) external ifAdmin {
        _setImplementation(_implementation);
    }

    // 0xf851a440
    function admin() external ifAdmin returns (address) {
        return _getAdmin();
    }

    // 0x5c60da1b
    function implementation() external ifAdmin returns (address) {
        return _getImplementation();
    }

    // User interface //
    function _delegate(address _implementation) internal virtual {
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.

            // calldatacopy(t, f, s) - copy s bytes from calldata at position f to mem at position t
            // calldatasize() - size of call data in bytes
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.

            // delegatecall(g, a, in, insize, out, outsize) -
            // - call contract at address a
            // - with input mem[in…(in+insize))
            // - providing g gas
            // - and output area mem[out…(out+outsize))
            // - returning 0 on error (eg. out of gas) and 1 on success
            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            // returndatacopy(t, f, s) - copy s bytes from returndata at position f to mem at position t
            // returndatasize() - size of the last returndata
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                // revert(p, s) - end execution, revert state changes, return data mem[p…(p+s))
                revert(0, returndatasize())
            }
            default {
                // return(p, s) - end execution, return data mem[p…(p+s))
                return(0, returndatasize())
            }
        }
    }

    function _fallback() private {
        _delegate(_getImplementation());
    }

    fallback() external payable {
        _fallback();
    }

    receive() external payable {
        _fallback();
    }
}

contract ProxyAdmin {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    function getProxyAdmin(address proxy) external view returns (address) {
        (bool ok, bytes memory res) = proxy.staticcall(abi.encodeCall(Proxy.admin, ()));
        require(ok, "call failed");
        return abi.decode(res, (address));
    }

    function getProxyImplementation(address proxy) external view returns (address) {
        (bool ok, bytes memory res) = proxy.staticcall(
            abi.encodeCall(Proxy.implementation, ())
        );
        require(ok, "call failed");
        return abi.decode(res, (address));
    }

    function changeProxyAdmin(address payable proxy, address admin) external onlyOwner {
        Proxy(proxy).changeAdmin(admin);
    }

    function upgrade(address payable proxy, address implementation) external onlyOwner {
        Proxy(proxy).upgradeTo(implementation);
    }
}

library StorageSlot {
    struct AddressSlot {
        address value;
    }

    function getAddressSlot(
        bytes32 slot
    ) internal pure returns (AddressSlot storage r) {
        assembly {
            r.slot := slot
        }
    }
}

contract TestSlot {
    bytes32 public constant slot = keccak256("TEST_SLOT");

    function getSlot() external view returns (address) {
        return StorageSlot.getAddressSlot(slot).value;
    }

    function writeSlot(address _addr) external {
        StorageSlot.getAddressSlot(slot).value = _addr;
    }
}

/*
Explanation:

1. CounterV1 and CounterV2 Contracts: These are two versions of a simple counter smart contract. CounterV1 has a single function `inc()` to increase the count, while CounterV2 adds a new function `dec()` to decrease the count.

2. BuggyProxy Contract: This is the main proxy contract that implements the upgradeable proxy pattern. It has the following features:
— It stores the address of the admin (contract owner) and the implementation contract in specific storage slots using the `StorageSlot` library.
— The `fallback()` and `receive()` functions are used to receive and forward function calls to the implementation contract using `delegatecall`.
— The `upgradeTo(address _implementation)` function allows the admin to upgrade the implementation contract to a new version. This is done by changing the implementation address stored in the proxy.

3. Dev Contract: This contract is used to retrieve the selectors of the functions in the Proxy contract. The selectors are the first four bytes of the function signatures, used to identify functions in the Ethereum Virtual Machine (EVM).

4. ProxyAdmin Contract: This contract serves as an admin interface to manage the proxy. It allows the owner to change the admin of the proxy and upgrade the implementation contract.

5. StorageSlot Library: This library provides utility functions to interact with specific storage slots in the EVM. It is used in the Proxy contract to store and retrieve addresses.

6. TestSlot Contract: This contract is a simple example demonstrating how the StorageSlot library can be used to read and write data to a specific slot.
*/

/*
Working of the Upgradable Proxy Works

1. The `BuggyProxy` contract receives and forwards all function calls to the implementation contract using `delegatecall`. This means that the implementation contract’s logic is executed in the context of the proxy contract, and the implementation contract’s storage is used.

2. When an upgrade is requested via the `upgradeTo(address _implementation)` function, the `BuggyProxy` contract changes the address of the implementation contract stored in the proxy. This effectively upgrades the logic without losing any stored data.

3. The `ProxyAdmin` contract allows the owner to change the admin address of the proxy and upgrade the implementation contract.

Known Issues and Security Considerations

The code provided is labeled as “Never use this in production” for good reason. It demonstrates the basic concept of an upgradeable proxy pattern, but it has several critical security flaws and limitations:

- Lack of Access Control: The code does not implement proper access control mechanisms to ensure that only authorized users can perform administrative actions such as upgrading the contract or changing the admin.

- Lack of Version Control: The code lacks a proper version control mechanism to handle different versions of the implementation contract. Upgrading the contract without proper checks could lead to unintended behavior.

- Potential Reentrancy Vulnerability: The use of `delegatecall` in the proxy contract can lead to reentrancy vulnerabilities if not handled correctly. This could result in a malicious implementation contract draining funds from the proxy.

- Limited Error Handling: The code does not handle all possible error scenarios adequately, which may lead to unexpected contract behavior or erroneous state changes.

To use an upgradeable proxy pattern safely in production, it is recommended to use well-audited libraries like OpenZeppelin’s upgradeable contracts, which address many of these security concerns and offer a more robust and tested implementation.
*/