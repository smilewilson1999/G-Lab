# InsuranceDataAccess Smart Contract

This repository contains the Solidity smart contract `InsuranceDataAccess` which manages encrypted data access for insurance companies. The contract allows the owner to authorize insurers, manage encrypted data, handle payments for data access, and withdraw accumulated funds.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Installation](#installation)
  - [Usage](#usage)
- [Contract Details](#contract-details)
  - [State Variables](#state-variables)
  - [Modifiers](#modifiers)
  - [Events](#events)
  - [Methods](#methods)

## Introduction

This project determines the pricing of vehicle insurance premiums based on G-sensors attached to vehicles. In Japan, insurance premiums are usually determined by age and license color (number of violations and driver history). The system forces young people who can actually drive safely to pay more and paper drivers who have not driven for many years to pay less. In essence, insurance rates should be determined by daily driving skills. Privacy compliance is also necessary. The project does not use GPS or any other means to determine where you drive or whether you are obeying the speed limit on a given road; it determines how small the load changes are based on G-sensors. The G-sensor data is recorded on-chain, and a third-party insurance company determines your monthly premium based on the results.

## Features

- **Authorization Management**: The contract owner can authorize or revoke access for insurance companies.
- **Payments Handling**: Authorized insurers can make payments to access encrypted data.
- **Data Management**: The contract owner can update encrypted data for insurers.
- **Funds Withdrawal**: The contract owner can withdraw accumulated funds from the contract.

## Prerequisites

- **Solidity Compiler**: Version ^0.8.0
- **Ethereum Development Environment**: Tools like Remix, Truffle, or Hardhat

## Getting Started

### Installation

1. **Clone the Repository**:

   ```sh
   git clone https://github.com/smilewilson1999/G-Lab.git
   cd G-Lab
   ```

2. **Open in Your Preferred Development Environment**:
   - Remix: Open the Remix IDE and load the `InsuranceDataAccess.sol` file.
   - Truffle/Hardhat: Ensure you have Node.js installed, and install Truffle or Hardhat globally using npm.

### Usage

1. **Compile the Contract**
   Ensure that the Solidity compiler version is set to ^0.8.0 in your development environment and compile the contract.

2. **Deploy the Contract**
   Deploy the contract to your desired Ethereum network. For example, using Remix, you can deploy it directly to the Ethereum testnet.

3. **Interact with the Contract**
   Once deployed, you can interact with the contract functions as described below.

## Contract Details

### State Variables

- `address public owner`: The owner of the contract.
- `mapping(address => bool) public authorizedInsurers`: Tracks authorized insurers.
- `mapping(address => uint256) public payments`: Tracks payments made by insurers.
- `mapping(address => string) public encryptedData`: Stores encrypted data for insurers.

### Modifiers

- `onlyOwner`: Ensures only the contract owner can call certain functions.

```solidity
modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
}
```

- `onlyAuthorized`: Ensures only authorized insurers can access certain functions.

```solidity
modifier onlyAuthorized() {
    require(authorizedInsurers[msg.sender], "Not authorized");
    _;
}
```

### Events

- `PaymentReceived(address insurer, uint256 amount)`: Emitted when an insurer makes a payment.
- `DataUpdated(address insurer)`: Emitted when encrypted data is updated.

### Methods

#### authorizeInsurer

Authorizes a new insurance company.

```solidity
function authorizeInsurer(address insurer) external onlyOwner {
    authorizedInsurers[insurer] = true;
}
```

#### revokeInsurer

Revokes access for an insurance company.

```solidity
function revokeInsurer(address insurer) external onlyOwner {
    authorizedInsurers[insurer] = false;
}
```

#### payForData

Allows authorized insurers to pay for data access.

```solidity
function payForData() external payable onlyAuthorized {
    payments[msg.sender] += msg.value;
    emit PaymentReceived(msg.sender, msg.value);
}
```

#### updateEncryptedData

Allows the owner to update encrypted data for insurers.

```solidity
function updateEncryptedData(address insurer, string memory _data) external onlyOwner {
    encryptedData[insurer] = _data;
    emit DataUpdated(insurer);
}
```

#### getEncryptedData

Allows authorized insurers to retrieve their encrypted data.

```solidity
function getEncryptedData() external view onlyAuthorized returns (string memory) {
    return encryptedData[msg.sender];
}
```

#### withdrawFunds

Allows the owner to withdraw accumulated funds from the contract.

```solidity
function withdrawFunds() external onlyOwner {
    payable(owner).transfer(address(this).balance);
}
```
