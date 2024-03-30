//SPDx-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CoinismusToken is ERC20Burnable, Ownable {

    constructor() ERC20("Coinismus", "CNS") {
        _mint(msg.sender, 1e9 ether);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}