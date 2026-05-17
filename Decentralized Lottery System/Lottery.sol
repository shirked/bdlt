// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    
    uint public ticketPrice = 10; // Points required to enter
    address[] public players;     // List of participants
    
    // Ledger to hold the winning points
    mapping(address => uint) public balances;

    // --- 1. Buy Ticket ---
    function buyTicket(uint _amount) public {
        require(_amount == ticketPrice, "Error: Ticket costs exactly 10 points.");
        players.push(msg.sender);
    }

    // --- 2. Pick Winner & Reset ---
    function pickWinner() public {
        require(players.length > 0, "Error: No players have joined.");

        // Generate a pseudo-random index
        uint randomIndex = uint(keccak256(abi.encodePacked(block.timestamp, players.length))) % players.length;
        
        address winner = players[randomIndex];
        uint totalPrize = players.length * ticketPrice;

        // Give the points to the winner
        balances[winner] += totalPrize;

        // Clear the players list to automatically start the next round
        delete players;
    }
}