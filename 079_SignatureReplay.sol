/*
🔍 Understanding the Vulnerability
The “Signature Replay” vulnerability arises when a contract accepts signed messages as a means of authorization without considering the uniqueness of these signatures. This can lead to a scenario where an attacker can reuse a valid signature to execute a function multiple times, even if the signer’s intention was to approve the transaction only once
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/utils/cryptography/ECDSA.sol";
contract MultiSigWallet {
 using ECDSA for bytes32;
address[2] public owners;
constructor(address[2] memory _owners) payable {
 owners = _owners;
 }
function deposit() external payable {}
function transfer(address _to, uint _amount, bytes[2] memory _sigs) external {
 bytes32 txHash = getTxHash(_to, _amount);
 require(_checkSigs(_sigs, txHash), "invalid sig");
(bool sent, ) = _to.call{value: _amount}("");
 require(sent, "Failed to send Ether");
 }
function getTxHash(address _to, uint _amount) public view returns (bytes32) {
 return keccak256(abi.encodePacked(_to, _amount));
 }
function _checkSigs(
 bytes[2] memory _sigs,
 bytes32 _txHash
 ) private view returns (bool) {
 bytes32 ethSignedHash = _txHash.toEthSignedMessageHash();
for (uint i = 0; i < _sigs.length; i++) {
 address signer = ethSignedHash.recover(_sigs[i]);
 bool valid = signer == owners[i];
if (!valid) {
 return false;
 }
 }
return true;
 }
}


/*
🔐 Enhanced Security Measures
In the improved version, the `transfer` function now requires a nonce value to be provided. This nonce value, along with the contract address and other transaction parameters, is used to generate the transaction hash. Additionally, a `mapping` named `executed` is introduced to keep track of executed transactions based on their hashes. This prevents the reexecution of the same transaction.
*/