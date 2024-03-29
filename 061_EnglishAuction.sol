/*
What is an English Auction?
The English Auction, also known as the open ascending price auction, is one of the most popular auction formats. It’s widely used in both traditional and online auctions. In this type of auction, the auctioneer starts with a low initial price, and potential buyers compete by successively increasing their bids until no higher bids are offered. The auction continues until a final bid stands unchallenged for a predetermined period, and the item is sold to the highest bidder at that final price.

🔎 So, how does this mechanism work? Let’s break it down step by step:

1. Auction Setup: The auctioneer announces the item to be sold, the starting bid (minimum bid amount), and the bidding duration (time window within which bidders can place their bids).

2. Bidding Process: Bidders submit their bids, and each new bid must be higher than the previous one. The auctioneer continuously updates the current highest bid and the bidder associated with it.

3. End of Auction: The auction ends when the bidding duration expires. At this point, the highest bid becomes the winning bid, and the item is sold to the highest bidder at that final price.

The English Auction is a thrilling and transparent mechanism, and implementing it as a decentralized application (DApp) on the Ethereum blockchain allows for a trustless and censorship-resistant auction environment.
*/

// Smart Contract Design

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract EnglishAuction {
    address public auctioneer;
    address public highestBidder;
    uint256 public highestBid;
    uint256 public biddingEndTime;
    bool public auctionEnded;
    // Constructor to set the auctioneer and bidding duration
    constructor(uint256 _biddingDuration) {
        auctioneer = msg.sender;
        biddingEndTime = block.timestamp + _biddingDuration;
    }
    
    function placeBid() public payable {
        require(!auctionEnded, "Auction has ended");
        require(block.timestamp < biddingEndTime, "Bidding has ended");
        require(msg.value > highestBid, "Bid amount is not higher than the current highest bid");
        if (highestBid != 0) {
            // Refund the previous highest bidder
            payable(highestBidder).transfer(highestBid);
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
    }
    
    function endAuction() public {
        require(!auctionEnded, "Auction has already ended");
        require(block.timestamp >= biddingEndTime, "Bidding period has not ended");
        auctionEnded = true;
        // Transfer the item to the highest bidder
        // (You can implement your own logic for item transfer)
        // Transfer the funds to the auctioneer after deducting any fees
        uint256 auctioneerFee = highestBid * 1 / 100; // 1% fee
        payable(auctioneer).transfer(highestBid - auctioneerFee);
    }
}

/*
In the above contract, we’ve defined some essential state variables to keep track of the auction status, highest bid, highest bidder, and auction end time. We also set the auctioneer as the contract deployer and initialize the bidding end time based on the provided `_biddingDuration`.

The `placeBid` function ensures that the auction is still ongoing, the bidding period has not expired, and the submitted bid is higher than the current highest bid. If a new bid is higher than the current highest bid, the previous highest bidder is refunded, and the new bidder becomes the highest bidder.

The `endAuction` function checks if the bidding period has ended and the auction has not already ended. It then marks the auction as ended and performs the necessary fund transfers, including the auctioneer’s fee.
*/
