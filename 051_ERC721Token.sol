/*
ERC-721 token is a technical standard for non-fungible tokens (NFTs) on Ethereum! Unlike their fungible ERC-20 cousins, ERC-721 tokens are one-of-a-kind wonders, each possessing its own special charm and distinctiveness.

🔍 Unraveling the Mysteries of ERC-721 🔍
The ERC-721 interface, a treasure trove of functions, is the heart of this enigma. Let’s briefly explore some of its key elements:

1. 📈 `balanceOf`: This mystical function reveals the number of tokens owned by a specific address.

2. 👑 `ownerOf`: Behold! This function unveils the rightful owner of a token, given its unique token ID.

3. 🚚 `safeTransferFrom`: Witness the secure transfer of tokens from one address to another, performed with utmost care and diligence.

4. 🏛️ `approve`: Through this ancient ritual, approval is granted to a trusted address to transfer a specific token on behalf of the owner.

5. 📜 `getApproved`: Enter the realm of approvals, where the address permitted to manage a particular token shall be revealed.

6. ✍️ `setApprovalForAll`: A potent incantation that grants or revokes approval for an entire set of tokens.

7. 🧙‍♂️ `isApprovedForAll`: A mystical gaze into the unknown, revealing whether an address wields approval to manage all tokens of an owner
*/


// Creating your own ERC-721 token

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract MyERC721 is ERC721 {
    constructor() ERC721("MyERC721", "M721") {}

    uint256 private tokenIdCounter = 0;

    function mintToken(address to) external {
        _mint(to, tokenIdCounter);
        tokenIdCounter++;
    }
}


// Unveiling the secrets of metadata and token uri


contract MyERC721Metadata is ERC721 {
    
    mapping(uint256 => string) private _tokenURIs;

    constructor() ERC721("MyERC721Metadata", "M721M") external {
        _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }

    function _setTokenURI(uint256 tokenId, string calldata tokenURI) internal {
        _tokenURI[tokenId] = tokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return _tokenURIs[tokenId];
    }
}

/*
🌐 Unveiling the Vast ERC-721 Ecosystem 🌐
Enter the thriving ecosystem of ERC-721, a realm teeming with remarkable NFT marketplaces, enchanting use cases, and fascinating innovations:

🏬 NFT Marketplaces: OpenSea, Rarible, SuperRare, and Foundation are the bustling marketplaces where creators and collectors converge to trade their priceless creations.

💼 NFT Use Cases: 🎨 Digital art, 🎮 gaming assets, 🏰 virtual real estate, 📦 supply chain tracking, and 🌐 virtual worlds are just a glimpse of the myriad applications of ERC-721 tokens.

🔄 ERC-721 vs. ERC-20: While ERC-20 tokens rule the realm of DeFi, ERC-721 tokens reign supreme in the mystical world of NFTs, bringing uniqueness, provable scarcity, and individuality to the forefront. ✨

🔒 Security Considerations: A wise conjurer must always prioritize security. Employ access control, safeguard metadata, optimize gas usage, and plan for contract upgradability to ward off potential threats.
*/


// Analyzing the smart contract

pragma solidity ^0.8.17;

interface IERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

interface IERC721 is IERC165 {
    function balanceOf(address owner) external view returns (uint balance);

    function ownerOf(uint tokenId) external view returns (address owner);

    function safeTransferFrom(address from, address to, uint tokenId) external;

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes calldata data
    ) external;

    function transferFrom(address from, address to, uint tokenId) external;

    function approve(address to, uint tokenId) external;

    function getApproved(uint tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool);
}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

contract ERC721 is IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed id);
    event Approval(address indexed owner, address indexed spender, uint indexed id);
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    // Mapping from token ID to owner address
    mapping(uint => address) internal _ownerOf;

    // Mapping owner address to token count
    mapping(address => uint) internal _balanceOf;

    // Mapping from token ID to approved address
    mapping(uint => address) internal _approvals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    function ownerOf(uint id) external view returns (address owner) {
        owner = _ownerOf[id];
        require(owner != address(0), "token doesn't exist");
    }

    function balanceOf(address owner) external view returns (uint) {
        require(owner != address(0), "owner = zero address");
        return _balanceOf[owner];
    }

    function setApprovalForAll(address operator, bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function approve(address spender, uint id) external {
        address owner = _ownerOf[id];
        require(
            msg.sender == owner || isApprovedForAll[owner][msg.sender],
            "not authorized"
        );

        _approvals[id] = spender;

        emit Approval(owner, spender, id);
    }

    function getApproved(uint id) external view returns (address) {
        require(_ownerOf[id] != address(0), "token doesn't exist");
        return _approvals[id];
    }

    function _isApprovedOrOwner(
        address owner,
        address spender,
        uint id
    ) internal view returns (bool) {
        return (spender == owner ||
            isApprovedForAll[owner][spender] ||
            spender == _approvals[id]);
    }

    function transferFrom(address from, address to, uint id) public {
        require(from == _ownerOf[id], "from != owner");
        require(to != address(0), "transfer to zero address");

        require(_isApprovedOrOwner(from, msg.sender, id), "not authorized");

        _balanceOf[from]--;
        _balanceOf[to]++;
        _ownerOf[id] = to;

        delete _approvals[id];

        emit Transfer(from, to, id);
    }

    function safeTransferFrom(address from, address to, uint id) external {
        transferFrom(from, to, id);

        require(
            to.code.length == 0 ||
                IERC721Receiver(to).onERC721Received(msg.sender, from, id, "") ==
                IERC721Receiver.onERC721Received.selector,
            "unsafe recipient"
        );
    }

    function safeTransferFrom(
        address from,
        address to,
        uint id,
        bytes calldata data
    ) external {
        transferFrom(from, to, id);

        require(
            to.code.length == 0 ||
                IERC721Receiver(to).onERC721Received(msg.sender, from, id, data) ==
                IERC721Receiver.onERC721Received.selector,
            "unsafe recipient"
        );
    }

    function _mint(address to, uint id) internal {
        require(to != address(0), "mint to zero address");
        require(_ownerOf[id] == address(0), "already minted");

        _balanceOf[to]++;
        _ownerOf[id] = to;

        emit Transfer(address(0), to, id);
    }

    function _burn(uint id) internal {
        address owner = _ownerOf[id];
        require(owner != address(0), "not minted");

        _balanceOf[owner] -= 1;

        delete _ownerOf[id];
        delete _approvals[id];

        emit Transfer(owner, address(0), id);
    }
}

contract MyNFT is ERC721 {
    function mint(address to, uint id) external {
        _mint(to, id);
    }

    function burn(uint id) external {
        require(msg.sender == _ownerOf[id], "not owner");
        _burn(id);
    }
}


/*
Explanation: 

Interfaces:
1. `IERC165`: This interface defines the `supportsInterface` function, which allows a contract to check if it supports a particular interface based on its ID.
2. `IERC721`: This interface extends `IERC165` and defines functions specific to ERC-721 tokens, such as `balanceOf`, `ownerOf`, `safeTransferFrom`, `approve`, and more.
3. `IERC721Receiver`: This interface defines the `onERC721Received` function, which a contract must implement to handle incoming ERC-721 token transfers.

Contract: ERC721
- This contract implements the `IERC721` interface, inheriting functions like `balanceOf`, `ownerOf`, `safeTransferFrom`, `approve`, and others.
- It includes several mappings to manage the token ownership, approvals, and operator permissions.
- The `setApprovalForAll`, `approve`, and `getApproved` functions handle the approval of token transfers between different addresses.
- The `transferFrom` function allows token transfers from one address to another, with proper authorization checks.
- The `safeTransferFrom` functions provide additional safety checks before transferring tokens, ensuring that the recipient contract supports ERC-721 tokens (`onERC721Received`).
- The `_mint` function is an internal function used to create new tokens and assign them to a specific address.
- The `_burn` function is an internal function used to burn (destroy) existing tokens.

Contract: MyNFT
- This contract extends the `ERC721` contract and provides two external functions: `mint` and `burn`.
- The `mint` function allows the contract creator to mint new NFTs and assign them to a specific address.
- The `burn` function allows the token owner to burn (destroy) their own NFTs, removing them from circulation.

💡 Definition: ERC-721

ERC-721 is a technical standard for representing non-fungible tokens (NFTs) on the Ethereum blockchain. Unlike ERC-20 tokens that are interchangeable, ERC-721 tokens are unique and indivisible. Each ERC-721 token represents a distinct asset and has its own unique identifier. This standard has unlocked a world of possibilities, enabling applications like digital art, collectibles, gaming assets, and much more. ERC-721 has played a crucial role in the rise of NFTs and their growing popularity across various industries.
*/