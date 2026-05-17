// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Certificate {
    
    address public issuer;
    uint public totalCertificates;

    // --- Verification Ledgers ---
    // Because these are 'public', anyone can read them to verify authenticity.
    
    // 1. Verify by ID: Enter integer Cert ID -> Returns Student Address
    mapping(uint => address) public getStudentById;
    
    // 2. Verify by Address: Enter Student Address -> Returns integer Cert ID
    mapping(address => uint) public getIdByAddress;

    // 3. Verify Course: Enter integer Cert ID -> Returns integer Course Number
    mapping(uint => uint) public getCourseById;

    // --- Setup ---
    constructor() {
        issuer = msg.sender; // The deployer is the official authority
    }

    // --- Issue Certificate ---
    function issueCertificate(address _student, uint _courseNumber) public {
        require(msg.sender == issuer, "Error: Only the official issuer can grant certificates.");
        require(getIdByAddress[_student] == 0, "Error: This student already has a certificate.");

        totalCertificates++;
        uint newCertId = totalCertificates;

        // Securely link all the data together on the blockchain
        getStudentById[newCertId] = _student;
        getIdByAddress[_student] = newCertId;
        getCourseById[newCertId] = _courseNumber;
    }
}