// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract InsuranceDataAccess {
    address public owner;
    mapping(address => bool) public authorizedInsurers;
    mapping(address => uint256) public payments;
    mapping(address => string) public encryptedData;

    event PaymentReceived(address insurer, uint256 amount);
    event DataUpdated(address insurer);

    constructor() {
        owner = msg.sender;
    }

    // Ensures only the contract owner can call certain functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // Ensures only authorized insurers can access certain functions
    modifier onlyAuthorized() {
        require(authorizedInsurers[msg.sender], "Not authorized");
        _;
    }

    // Allows the owner to authorize new insurance companies
    function authorizeInsurer(address insurer) external onlyOwner {
        authorizedInsurers[insurer] = true;
    }

    // Allows the owner to revoke access for insurance companies
    function revokeInsurer(address insurer) external onlyOwner {
        authorizedInsurers[insurer] = false;
    }

    // Allows authorized insurers to pay for data access
    function payForData() external payable onlyAuthorized {
        payments[msg.sender] += msg.value;
        emit PaymentReceived(msg.sender, msg.value);
    }

    // Allows the owner to update encrypted data for insurers
    function updateEncryptedData(address insurer, string memory _data) external onlyOwner {
        encryptedData[insurer] = _data;
        emit DataUpdated(insurer);
    }

    // Allows authorized insurers to retrieve their encrypted data
    function getEncryptedData() external view onlyAuthorized returns (string memory) {
        return encryptedData[msg.sender];
    }

    // Allows the owner to withdraw accumulated funds from the contract
    function withdrawFunds() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
