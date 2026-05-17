// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {
    
    // --- The Roles & Defaults ---
    address public buyer;
    address public seller;
    
    uint public escrowAmount = 1000;         // Default integer points locked in escrow
    uint public deadline;                    // Time limit for disputes
    
    bool public buyerApproved = false;
    bool public sellerApproved = false;
    bool public isDisputed = false;
    bool public fundsReleased = false;

    // The Integer Ledger (To hold the final points)
    mapping(address => uint) public balances;

    // --- Setup ---
    constructor() {
        buyer = msg.sender;                      // Deployer is the buyer
        deadline = block.timestamp + 1 minutes;  // 1 minute default for testing
    }

    // --- 1. Seller Joins ---
    function joinAsSeller() public {
        require(seller == address(0), "Error: Seller is already set.");
        require(msg.sender != buyer, "Error: Buyer cannot also be the seller.");
        seller = msg.sender;
    }

    // --- 2. Agreement (Both must approve) ---
    function approve() public {
        require(msg.sender == buyer || msg.sender == seller, "Error: Only buyer or seller can approve.");
        
        if (msg.sender == buyer) buyerApproved = true;
        if (msg.sender == seller) sellerApproved = true;

        // If both agree, release the points immediately
        if (buyerApproved && sellerApproved && !fundsReleased) {
            releasePoints();
        }
    }

    // --- 3. Raise Dispute ---
    function raiseDispute() public {
        require(msg.sender == buyer || msg.sender == seller, "Error: Only parties can dispute.");
        isDisputed = true;
    }

    // --- 4. Timeout Release (If no disputes) ---
    function claimTimeout() public {
        require(msg.sender == seller, "Error: Only seller can claim the timeout.");
        require(block.timestamp >= deadline, "Error: You must wait 1 minute first.");
        require(isDisputed == false, "Error: The buyer raised a dispute!");
        require(fundsReleased == false, "Error: Funds already released.");

        releasePoints();
    }

    // --- Internal Action ---
    // 'private' means this can only be triggered by the contract itself, not clicked by a user
    function releasePoints() private {
        fundsReleased = true;
        balances[seller] += escrowAmount;
    }
}