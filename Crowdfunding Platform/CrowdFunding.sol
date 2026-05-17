// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrowdFunding {
    
    // --- The Rules & Defaults ---
    address public creator;
    uint public goal;
    uint public deadline;
    uint public totalRaised;
    bool public fundsClaimed; // Added to track if the creator took the points

    // Tracks how many integers/points each wallet pledged
    mapping(address => uint) public donations;

    // --- Setup ---
    constructor() {
        creator = msg.sender;                
        goal = 1000;                         // Just a normal integer, no 'wei'
        deadline = block.timestamp + 5 minutes; 
    }

    // --- 1. Donate ---
    function donate(uint _amount) public {
        require(block.timestamp < deadline, "Error: The campaign has ended.");
        require(_amount > 0, "Error: You must donate an amount greater than 0.");

        // Record the integer amount
        donations[msg.sender] += _amount;
        totalRaised += _amount;
    }

    // --- 2. Creator Claims ---
    function claimFunds() public {
        require(msg.sender == creator, "Error: Only the creator can claim.");
        require(block.timestamp >= deadline, "Error: The campaign is still running.");
        require(totalRaised >= goal, "Error: The funding goal was not reached.");
        require(!fundsClaimed, "Error: Funds have already been claimed.");

        // We just update the ledger to prove the creator officially finalized the campaign.
        fundsClaimed = true;
    }

    // --- 3. Donors Refund ---
    function getRefund() public {
        require(block.timestamp >= deadline, "Error: The campaign is still running.");
        require(totalRaised < goal, "Error: The goal was reached, no refunds allowed.");
        
        uint myDonation = donations[msg.sender];
        require(myDonation > 0, "Error: You did not donate or already refunded.");

        // We reset their integer balance to 0. 
        donations[msg.sender] = 0;
    }
}