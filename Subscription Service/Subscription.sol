// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Subscription {
    
    // --- Subscription Rules ---
    // Notice: 'wei' is completely removed. It is just the number 100 now.
    uint public cost = 100;
    uint public duration = 1 minutes; // 1 minute for easy testing

    // --- The Database ---
    // Maps a user's wallet address to the exact timestamp their access expires
    mapping(address => uint) public subscriptionEndsAt;

    // --- 1. Pay to Subscribe (Using integers/points) ---
    // Notice: Removed 'payable' and added the '_amountPaid' parameter
    function subscribe(uint _amountPaid) public {
        // Enforce the exact payment amount
        require(_amountPaid == cost, "Error: You must pay exactly 100 points.");

        // If they already have an active subscription, add 1 minute to their existing time.
        // If they are new (or expired), start the 1-minute clock from right now.
        if (subscriptionEndsAt[msg.sender] > block.timestamp) {
            subscriptionEndsAt[msg.sender] += duration;
        } else {
            subscriptionEndsAt[msg.sender] = block.timestamp + duration;
        }
    }

    // --- 2. Check Access (The Bouncer) ---
    function hasAccess() public view returns (bool) {
        // This will return 'true' if the current time is before their expiration date.
        // It will return 'false' if their time has run out, or if they never subscribed.
        return block.timestamp < subscriptionEndsAt[msg.sender];
    }
}