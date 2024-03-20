//What is Keccak256?
//Keccak256, a member of the illustrious Keccak family of hash functions, is a cryptographic algorithm that takes an input of any length and outputs a fixed-size (256-bit) hash value. After emerging victorious from the NIST hash function competition in 2012, Keccak256 found widespread adoption in blockchain networks, including Ethereum, owing to its robust security properties and computational efficiency.


// Generating a Deterministic Unique ID

pragma solidity ^0.8.0;
contract UniqueIDGenerator {
    function generateUniqueID(string memory input) public pure returns (bytes32) {
        bytes32 hash = keccak256(abi.encodePacked(input));
        return hash;
    }
}

/*
Explanation: One of the most common applications of Keccak256 is the creation of deterministic unique identifiers from input data. This technique proves invaluable when you need to generate a distinct identifier for an object or entity within a decentralized system.

In this code snippet, the `generateUniqueID` function accepts a string as input and leverages `keccak256` to compute the corresponding hash value. To ensure consistency, the `abi.encodePacked` function is employed to convert the input string into bytes before hashing. Finally, the function returns the resulting hash as a `bytes32` value. By employing this technique, you can ensure the uniqueness and integrity of identifiers within your decentralized application.
*/



//Commit-Reveal Scheme

pragma solidity ^0.8.0;
contract CommitReveal {
    bytes32 private commitHash;
    function commit(bytes32 hash) public {
        commitHash = hash;
    }
    function reveal(string memory secret) public view returns (bool) {
        bytes32 secretHash = keccak256(abi.encodePacked(secret));
        return secretHash == commitHash;
    }
}

/*Explanation: Keccak256 also shines when it comes to implementing commit-reveal schemes — a clever methodology for safeguarding information until a predetermined point in time. The commit phase involves hashing the secret information and submitting the hash to the blockchain, while the reveal phase entails disclosing the original information and verifying it against the previously committed hash.

In this example, the `commit` function takes a hash as input and stores it in the `commitHash` variable. During the reveal phase, the `reveal` function computes the hash of the secret and checks if it matches the previously committed hash. This scheme ensures that the secret remains concealed until the reveal phase, providing a secure and tamper-proof mechanism. 
*/


//Compact Cryptographic Signatures: 

pragma solidity ^0.8.0;
contract SignatureVerifier {
    function verifySignature(bytes memory signature, bytes32 dataHash) public pure returns (address) {
        bytes32 prefixedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash));
        address signer = ECDSA.recover(prefixedHash, signature);
        return signer;
    }
}

/*
Explanation: Keccak256 also plays a pivotal role in generating compact cryptographic signatures by signing the hash value rather than a larger input. This approach drastically reduces the size of the signature while preserving the integrity and authenticity of the data.

In this code snippet, the `verifySignature` function accepts a signature and a data hash as inputs. To conform to Ethereum signature standards, the `abi.encodePacked` function prefixes the data hash. Subsequently, the `ECDSA.recover` function recovers the signer’s address using the prefixed hash and the signature. By employing this technique, you can leverage compact and efficient cryptographic signatures within your Solidity contracts.
*/