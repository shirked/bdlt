// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBank {
    
    // --- The Vault ---
    // Maps a user's wallet address to their specific integer balance
    mapping(address => uint) private balances;

    // --- 1. Deposit Points ---
    // Notice: Removed 'payable'. It now requires you to pass a number in the input box.
    function deposit(uint _amount) public {
        require(_amount > 0, "Error: You must deposit an amount greater than 0.");
        
        // Add the integer amount to the caller's specific balance
        balances[msg.sender] += _amount;
    }

    // --- 2. Withdraw Points ---
    function withdraw(uint _amount) public {
        require(_amount > 0, "Error: You must withdraw an amount greater than 0.");
        require(balances[msg.sender] >= _amount, "Error: Insufficient points in your account.");
        
        // Deduct the balance. 
        // Notice: We deleted the `.transfer()` line because no real ETH is moving!
        balances[msg.sender] -= _amount;
    }

    // --- 3. Check Balance ---
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
}