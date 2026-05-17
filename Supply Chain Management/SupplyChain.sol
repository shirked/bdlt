// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {

    // --- The Status Labels ---
    // This creates a custom list of stages a product can be in.
    enum State { Created, InTransit, Delivered }

    // --- The Product Blueprint ---
    struct Product {
        string name;
        State currentState;
        
        // Participant Addresses
        address manufacturer;
        address transporter;
        address consumer;
        
        // Timestamps for the immutable record
        uint createdAt;
        uint shippedAt;
        uint deliveredAt;
    }

    // --- The Database ---
    uint public productCount;
    mapping(uint => Product) public products;

    // --- 1. Manufacturer makes the product ---
    function createProduct(string memory _name) public {
        productCount++;
        
        // address(0) is a blank address since it hasn't been shipped or bought yet
        products[productCount] = Product({
            name: _name,
            currentState: State.Created,
            manufacturer: msg.sender,
            transporter: address(0),
            consumer: address(0),
            createdAt: block.timestamp,
            shippedAt: 0,
            deliveredAt: 0
        });
    }

    // --- 2. Transporter picks it up ---
    function shipProduct(uint _id) public {
        require(_id > 0 && _id <= productCount, "Error: Invalid product ID.");
        
        // Make sure it hasn't already been shipped!
        require(products[_id].currentState == State.Created, "Error: Product is not ready to ship.");

        // Update the state, record the transporter's address, and log the time
        products[_id].currentState = State.InTransit;
        products[_id].transporter = msg.sender;
        products[_id].shippedAt = block.timestamp;
    }

    // --- 3. Consumer receives it ---
    function deliverProduct(uint _id) public {
        require(_id > 0 && _id <= productCount, "Error: Invalid product ID.");
        
        // Make sure it is actually in transit
        require(products[_id].currentState == State.InTransit, "Error: Product is not in transit.");

        // Update the state, record the buyer's address, and log the time
        products[_id].currentState = State.Delivered;
        products[_id].consumer = msg.sender;
        products[_id].deliveredAt = block.timestamp;
    }
}