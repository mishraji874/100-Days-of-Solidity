// Ether: Ether symbolized by ETH, serves as the most important currency of the Ethereum blockchain. It assumes a multitude of roles, from paying transaction fees and rewarding miners to serving as a medium of exchange within dApps.

//Wei: It is the smallest indivisible uint of Ether. 1 Ether = 10^18 Wei, which symbolizing the vastness of the ethereum cosmos and its potential for microtransactions.


//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract EtherAndWei {
    uint public oneWei = 1 wei;
    bool public isOneWei = 1 wei == 1;
    uint public oneEther = 1 ether;
    bool public isOneEther = 1 ether == 1e18;

    function convertWeiToEther(uint weiAmount) public pure returns (uint) {
        return weiAmount / 1 ether; //converting wei to ether
    }

    function convertEtherToWei(uint etherAmount) public pure returns (uint) {
        return etherAmount * 1 ether; // converting ether to wei
    }
}