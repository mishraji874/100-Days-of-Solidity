/*
Understanding Payment Channels
Before diving into the intricacies of bi-directional payment channels, let’s first establish a foundational understanding of payment channels in general.

Payment channels are a mechanism in blockchain technology that enables participants to conduct multiple transactions off-chain while minimizing the on-chain interactions. These channels open up a direct and private channel between two parties, allowing them to exchange assets without the need for every transaction to be recorded on the main blockchain. This significantly reduces transaction costs and processing time, making it a compelling solution for scaling blockchain networks.

The One-Way Payment Channel 📈
The one-way payment channel is the simplest form of a payment channel. It allows transactions to flow in one direction, typically from the sender to the receiver. The channel operates as follows:

1. Channel Opening: The sender locks a certain amount of funds on the blockchain into a smart contract, known as the “channel contract.”

2. Off-Chain Transactions: Once the channel is open, the sender and receiver can perform multiple off-chain transactions, updating the distribution of funds within the channel’s smart contract.

3. Closing the Channel: Either party can choose to close the payment channel at any time. The final distribution of funds is then recorded on the blockchain, settling the transactions.

The one-way payment channel offers significant improvements in terms of speed and cost-effectiveness, but it is limited to one-directional flow of funds.

The Evolution: Bi-Directional Payment Channel 🔄
Here comes the star of our discussion — the bi-directional payment channel! As the name suggests, this channel facilitates two-way transactions, allowing both parties to exchange assets in both directions. This advancement takes the benefits of payment channels to a whole new level.

To implement the bi-directional payment channel, we leverage the concept of “hash time-locked contracts” (HTLCs). HTLCs introduce an additional layer of security and flexibility, making it possible to safely conduct cross-chain transactions.

Hash Time-Locked Contracts (HTLCs) 🔒⌛
HTLCs are smart contracts that enable conditional payments. They use cryptographic hash functions and time locks to ensure secure and reliable execution of transactions. Here’s how they work:

1. Hash Locking: The sender generates a cryptographic hash of a secret value and adds it to the contract. This hash serves as the condition for the payment.

2. Time Locking: A time lock is set, specifying a window during which the receiver must claim the payment by revealing the pre-image of the hash (the secret value).

3. Conditional Payment: The receiver can claim the payment by presenting the pre-image of the hash, which proves they know the secret value.

4. Refund: If the receiver fails to claim the payment within the specified time window, the sender can reclaim the locked funds.

HTLCs provide a trustless and secure way to perform cross-chain transactions without the risk of one party defaulting on their obligations.
*/

//Building the Bi-Directional Payment Channel in Solidity

// Solidity contract for Bi-Directional Payment Channel with HTLCs
contract BiDirectionalPaymentChannel {
    address public sender;
    address public receiver;
    uint256 public expiration;
    bytes32 public hashedSecret;
    uint256 public amount;
    constructor(address _receiver, uint256 _duration) public payable {
        sender = msg.sender;
        receiver = _receiver;
        amount = msg.value;
        expiration = block.timestamp + _duration;
        hashedSecret = 0; // The hashed secret will be set later
    }
    // Function to set the hash of the secret
    function setHashedSecret(bytes32 _hashedSecret) external {
        require(msg.sender == sender, "Only sender can set the hashed secret.");
        require(hashedSecret == 0, "Hashed secret has already been set.");
        hashedSecret = _hashedSecret;
    }
    // Function for the receiver to claim the payment using the pre-image of the secret
    function claimPayment(bytes32 _secret) external {
        require(msg.sender == receiver, "Only receiver can claim the payment.");
        require(keccak256(abi.encodePacked(_secret)) == hashedSecret, "Invalid secret.");
        // Validate if the current time is within the expiration period
        require(block.timestamp <= expiration, "Payment channel has expired.");
        selfdestruct(payable(receiver));
    }
    // Function for the sender to reclaim the locked funds if the payment channel expires
    function reclaimFunds() external {
        require(msg.sender == sender, "Only sender can reclaim funds.");
        require(block.timestamp > expiration, "Payment channel has not expired yet.");
        selfdestruct(payable(sender));
    }
}

/*
The Solidity contract above implements a simple bi-directional payment channel with HTLCs. The sender creates the channel, setting the receiver and the duration for which the channel will remain open. The hashed secret is set by the sender later, and the receiver can claim the payment by revealing the pre-image of the secret before the expiration time.
*/