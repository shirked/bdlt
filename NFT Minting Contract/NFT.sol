// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NFT {
    
    // --- Token Details ---
    string public name = "My Digital Art";
    string public symbol = "ART";
    uint public totalSupply; // Keeps track of how many NFTs exist

    // --- The Ledger ---
    // Maps a unique NFT ID to a wallet address (Who owns what)
    mapping(uint => address) public ownerOf;
    
    // Maps a unique NFT ID to its metadata (The link to the image/data)
    mapping(uint => string) public tokenURI;

    // --- 1. Minting (Creating) an NFT ---
    function mint(string memory _metadataLink) public {
        // Increase the total supply to create a new, unique ID (1, then 2, then 3...)
        totalSupply++;
        uint newNFTId = totalSupply;

        // Assign ownership of this new ID to the person who clicked "Mint"
        ownerOf[newNFTId] = msg.sender;

        // Attach the metadata link to this specific ID
        tokenURI[newNFTId] = _metadataLink;
    }

    // --- 2. Transferring an NFT ---
    function transfer(address _to, uint _nftId) public {
        // Rule 1: The NFT must actually exist
        require(_nftId > 0 && _nftId <= totalSupply, "Error: This NFT does not exist.");
        
        // Rule 2: Only the current owner has the right to transfer it
        require(ownerOf[_nftId] == msg.sender, "Error: You do not own this NFT.");
        
        // Rule 3: Prevent accidental deletion by sending to a blank address
        require(_to != address(0), "Error: Cannot send to the zero address.");

        // Change the ownership in the ledger
        ownerOf[_nftId] = _to;
    }
}