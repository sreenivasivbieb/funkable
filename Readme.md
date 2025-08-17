I've created a comprehensive README file for the Simple Fungible Token contract. 
The README includes:
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/bd2b8128-b444-49f7-9557-e13790094c3c" />
Address-STR4J9QNNYQF1F99P77ECDZENV0AXFMZ4CS79XG3.funkableSimple Token (STK)

A simple fungible token smart contract written in Clarity for the Stacks blockchain.
It defines a token with ERC20-like functionality including transfers, minting, and burning.

📋 Token Details

Name: Simple Token

Symbol: STK

Decimals: 18

Initial Supply: 1,000,000 STK (minted to contract deployer)

⚙️ Features

Token Info: get-name, get-symbol, get-decimals, get-total-supply

Balances: get-balance (account)

Transfers:

transfer (amount, recipient)

transfer-from (amount, sender, recipient)

Minting & Burning:

mint (amount, recipient) → only owner

burn (amount) → self-burn

Owner: get-owner

Initialization: mints 1,000,000 STK to contract owner at deployment

❌ Error Codes

u100 → Owner only

u101 → Insufficient balance

u102 → Invalid amount
