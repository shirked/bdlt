// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VerySimpleCoin {
    
    // 1. The Ledger: A simple dictionary that links a wallet address to a number (their balance)
    mapping(address => uint256) public balances;

    // 2. The Mint: Runs exactly once when you click "Deploy"
    constructor(uint256 _initialSupply) {
        // Give 100% of the starting coins to the person who deploys the contract
        balances[msg.sender] = _initialSupply; 
    }

    // 3. The Transaction: How people send coins to each other
    function transfer(address _to, uint256 _amount) public {
        
        // Step A: Make sure the sender actually has enough coins to send
        require(balances[msg.sender] >= _amount, "Error: You do not have enough coins!");

        // Step B: Deduct the coins from the sender's balance
        balances[msg.sender] -= _amount;
        
        // Step C: Add the coins to the receiver's balance
        balances[_to] += _amount;
    }
}