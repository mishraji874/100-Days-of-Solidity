/*
Merkle trees are hierarchial data structures where each non-leaf node represents the hash of its child nodes.
Starting from the bottom layer, which consists of individual elements or data blocks, each subsequent layer encompasses the hash of its child nodes.
This recursive construction continues until a single root hash is obtained at the top, known as the Merkle root.

Efficient Verification with Merkle Proof 🌐
Merkle trees offer a remarkable advantage: the ability to efficiently verify the presence of an element in a set without revealing the entire set itself. This is accomplished through the generation of a Merkle proof, also known as a Merkle path or authentication path. A Merkle proof serves as a compact representation of the path from a leaf node to the root, including the hashes of sibling nodes along the way. By presenting this proof, one can cryptographically demonstrate the inclusion of an element in the set, all while keeping the set’s details private. 🎩🔍

Let’s visualize this with an example. Imagine a Merkle tree representing a set of transactions in a blockchain. To verify whether a specific transaction is part of the set, we begin with the transaction itself and traverse the tree by hashing and concatenating the child nodes until we reach the Merkle root. Throughout the traversal, we store the hashes of the sibling nodes as part of the Merkle proof. By providing the transaction, the Merkle root, and the Merkle proof, anyone can independently verify the transaction’s inclusion in the set, without compromising the confidentiality of the remaining transactions. 📚🔒

The use of Merkle proofs drastically reduces the amount of data required for verification, making it an incredibly efficient method, particularly for large datasets. It enables the verification process to operate with logarithmic complexity, scaling proportionally to the height of the Merkle tree. 📉⚡️

Applications in Blockchain Technology ⛓️💡
Within the world of blockchain technology, Merkle trees hold a pivotal role in ensuring the integrity of transactions within blocks. Each block contains a set of transactions, and the Merkle tree guarantees their consistency and validity.

By including the Merkle root in the block header, blockchain technology allows for efficient verification of the block’s contents. This empowers network nodes to validate the integrity of transactions without needing to store and process every individual transaction within the block, thus enhancing scalability and reducing computational overhead. 🚀💻

Moreover, Merkle trees play a crucial role in securing blockchain systems. By verifying the consistency and integrity of the Merkle tree, malicious actors find it incredibly challenging to tamper with the block’s contents or forge transactions. This property is fundamental in maintaining the immutability and trustworthiness of distributed ledgers, bolstering the overall security of blockchain networks. 🛡️🔒
*/


/*
To gain the deeper understaning of Merkle trees, let's implement it in python:

import hashlib
def build_merkle_tree(data):
    if len(data) == 1:
        return data[0]
    next_level = []
    for i in range(0, len(data), 2):
        hash_1 = hashlib.sha256(data[i].encode()).hexdigest()
        if i + 1 < len(data):
            hash_2 = hashlib.sha256(data[i + 1].encode()).hexdigest()
        else:
            hash_2 = hash_1
            next_level.append(hashlib.sha256((hash_1 + hash_2).encode()).hexdigest())
            return build_merkle_tree(next_level)
# Example usage
data = ['transaction1', 'transaction2', 'transaction3', 'transaction4']
merkle_root = build_merkle_tree(data)
print("Merkle Root:", merkle_root)

In this code snippet, we define a function `build_merkle_tree` that takes a list of data as input and recursively constructs the Merkle tree. The SHA-256 cryptographic hash function is utilized to compute the hashes of individual elements and their concatenations. By running this code, you can observe the magic of Merkle trees in action!
*/


//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract MerkleProof {
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf,
        uint index
    ) public pure returns (bool) {
        bytes32 hash = leaf;

        for(uint i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if(index % 2 == 0) {
                hash = keccak256(abi.encodePacked(hash, proofElement));
            } else {
                hash = keccak256(abi.encodePacked(proofElement, hash));
            }

            index = index / 2;
        }

        return hash == root;
    }
}

contract TestMerkleProof is MerkleProof {
    bytes32[] public hashes;

    constructor() {
        string[4] memory transactions = [
            "alice -> bob",
            "bob -> dave",
            "carol -> alice",
            "dave -> bob"
        ];

        for(uint i = 0; i < transactions.length; i++) {
            hashes.push(keccak256(abi.encodePacked(transactions[i])));
        }

        uint n = transactions.length;
        uint offset = 0;

        while(n > 0) {
            for(uint i = 0; i < n - 1; i += 2) {
                hashes.push(
                    keccak256(
                        abi.encodePacked(hashes[offset + i], hashes[offset + i + 1])
                    )
                );
            }
            offset += n;
            n = n /2;
        }
    }

    function getRoot() public view returns (bytes32) {
        return hashes[hashes.length - 1];
    }
}


/*
Explanation:

Contract Overview 📝
The contract consists of two main contracts: `MerkleProof` and `TestMerkleProof`.

The `MerkleProof` contract contains a single function called `verify`. This function takes in several parameters: `proof`, `root`, `leaf`, and `index`. The purpose of this function is to verify the inclusion of a leaf node in a Merkle tree. The function uses a loop to iterate through the provided `proof` array, which represents the authentication path from the leaf to the root of the Merkle tree. The function computes the hash of the leaf and combines it with the corresponding proof elements to generate the resulting hash. It continues this process until the loop ends. Finally, the function checks if the resulting hash is equal to the provided `root` hash and returns a boolean value indicating the success of the verification process.

The `TestMerkleProof` contract inherits from the `MerkleProof` contract and adds additional functionality for testing purposes. It includes a storage variable called `hashes`, which is an array of `bytes32` values.

Constructor Initialization 🚀
The `TestMerkleProof` contract contains a constructor function that is executed upon contract deployment. In the constructor, an array of string transactions is initialized. Each transaction is encoded using `abi.encodePacked` and then hashed using `keccak256`. The resulting hash is added to the `hashes` array.

Next, the constructor proceeds with building the Merkle tree. It utilizes a loop that repeatedly divides the number of transactions by two and computes the hash of adjacent elements in the `hashes` array, resulting in a new hash. This process is repeated until a single root hash is obtained. The `hashes` array effectively stores all the nodes of the Merkle tree, from the leaf nodes to the root.

getRoot Function 🌿
The `getRoot` function is a public view function that simply returns the last element in the `hashes` array, which represents the Merkle root.
*/