// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleElection {
    // --- The Rules ---
    address public admin;
    bool public votingActive;

    // --- The Data ---
    // Tracks who has voted (Address -> True/False)
    mapping(address => bool) public hasVoted;
    
    // Tracks Candidates and their scores
    mapping(uint => string) public candidateNames;
    mapping(uint => uint) public candidateVotes;

    // --- Setup ---
    constructor() {
        admin = msg.sender;     // The person who deploys the contract is the admin
        votingActive = false;   // Voting is closed by default
        
        // Load the default candidates immediately
        candidateNames[1] = "Alice";
        candidateNames[2] = "Bob";
    }

    // --- Admin Functions ---
    function startVoting() public {
        require(msg.sender == admin, "Error: Only admin can start the election");
        votingActive = true;
    }

    function endVoting() public {
        require(msg.sender == admin, "Error: Only admin can end the election");
        votingActive = false;
    }

    // --- Voter Functions ---
    function vote(uint _candidateID) public {
        // 1. Check if voting is open
        require(votingActive == true, "Error: Voting is currently closed");
        
        // 2. Check if they already voted (The One-Vote Rule)
        require(hasVoted[msg.sender] == false, "Error: You have already voted");
        
        // 3. Check if they are voting for either Candidate 1 or 2
        require(_candidateID == 1 || _candidateID == 2, "Error: Invalid candidate ID");

        // Record that this person has voted
        hasVoted[msg.sender] = true;
        
        // Add one vote to the chosen candidate
        candidateVotes[_candidateID]++;
    }

    // --- Scoreboard Function ---
    function getAllVotes() public view returns (uint aliceScore, uint bobScore) {
        return (candidateVotes[1], candidateVotes[2]);
    }
}