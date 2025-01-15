# Crowdfunding-Smartcontract
# Documentation


This is a simple crowdfunding smart contract written in Solidity. The contract allows users to contribute ether to a campaign and offers refund options if the funding goal is not reached.

---

## Features:
1. Accept ETH contributions from multiple users.
2. Refund contributors if the funding goal is not reached by the deadline.
3. Allow only the manager to withdraw funds if the target is achieved.
4. Track the total raised amount and number of contributors.

---

## How It Works:
### 1. Contract Deployment
When the contract is deployed:
- The **manager** (the person deploying the contract) is set.
- The **target** funding amount and **deadline** (in seconds) are provided as input.

### 2. Sending ETH
- Users can contribute ETH using the `sendEth` function.
- Contributions must meet the **minimum contribution** (100 wei).
- Contributions after the deadline are not accepted.

### 3. Checking Balance
- Use the `getContractBalance` function to check how much ETH has been contributed to the contract.

### 4. Refunds
- If the target is not reached by the deadline, contributors can call the `refund` function to get their ETH back.

### 5. Withdrawing Funds
- Only the **manager** can withdraw funds if the target is reached before the deadline.
- The `withdrawFunds` function transfers all the ETH from the contract to the manager.

---

## Functions:
### 1. `constructor(uint _target, uint _deadline)`
- Sets the target amount, deadline, and manager.

### 2. `sendEth()`
- Accepts ETH contributions from users.
- Updates the contributor's amount and the total raised amount.

### 3. `getContractBalance()`
- Returns the current balance of the contract.

### 4. `refund()`
- Allows contributors to claim a refund if:
  - The deadline has passed.
  - The funding goal was not reached.
  - The contributor has made a valid contribution.

### 5. `withdrawFunds()`
- Allows the manager to withdraw funds if:
  - The funding target is met.
  - Only the manager can call this function.

---

## How to Run:
1. Deploy the contract using Remix or your preferred Solidity environment.
2. Set the target funding amount and deadline during deployment.
3. Call the `sendEth` function to contribute ETH.
4. Check the balance using `getContractBalance`.
5. After the deadline, either:
   - Call `refund` to get your ETH back (if the target is not reached).
   - Or, the manager can call `withdrawFunds` to transfer funds (if the target is reached).

---

## Notes:
- **Minimum Contribution**: 100 wei.
- The contract uses `block.timestamp` to handle deadlines.
- Refunds are only available if the funding goal is not met.


