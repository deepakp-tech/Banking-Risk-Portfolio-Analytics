# KPI Definitions and DAX Formulas

This document outlines the core business logic and Power BI DAX expressions used in the Banking Risk Analytics project.

## 1. Portfolio Demographics
*   **Total Clients:** The total count of unique accounts in the portfolio.
    *   **DAX:** `Total Clients = DISTINCTCOUNT('Clients - Banking'[Client ID])`
*   **Engagement Days:** The total number of days a client has been with the bank since their `Joined Bank` date.
    *   **DAX:** `Engagment Days = DATEDIFF('Clients - Banking'[Joined Bank], TODAY(), DAY)`

## 2. Credit Exposure Metrics
*   **Bank Loan:** The principal loan amount scheduled for repayment by the client.
    *   **DAX:** `Bank Loan = SUM('Clients - Banking'[Bank Loans])`
*   **Business Lending:** Commercial loan amounts issued to small and medium business clients.
    *   **DAX:** `Business Lending = SUM('Clients - Banking'[Business Lending])`
*   **Credit Cards Balance:** The total revolving debt currently owed by a cardholder.
    *   **DAX:** `Credit Cards Balance = SUM('Clients - Banking'[Credit Card Balance])`
*   **Total Loan:** The aggregate credit liability of a client across all borrowing facilities.
    *   **DAX (Calculated):** `Total Loan = [Bank Loan] + [Business Lending] + [Credit Cards Balance]`

## 3. Liquidity & Deposit Metrics
*   **Bank Deposit:** Standard funds held in core banking accounts.
    *   **DAX:** `Bank Deposit = SUM('Clients - Banking'[Bank Deposits])`
*   **Savings Account:** Interest-bearing deposit accounts.
    *   **DAX:** `Savings Account = SUM('Clients - Banking'[Saving Accounts])`
*   **Checking Accounts:** Liquid transactional accounts for daily banking.
    *   **DAX:** `Checking Accounts = SUM('Clients - Banking'[Checking Accounts])`
*   **Foreign Currency Account:** Accounts held in non-domestic currencies.
    *   **DAX:** `Foreign Currency Account = SUM('Clients - Banking'[Foreign Currency Account])`
*   **Total Deposit:** The combined liquidity available across a client's portfolio.
    *   **DAX (Calculated):** `Total Deposit = [Bank Deposit] + [Savings Account] + [Foreign Currency Account] + [Checking Accounts]`

## 4. Revenue Metrics
*   **Total Fees:** The operational revenue charged by the bank for account setup, maintenance, and processing. Calculated by applying the processing fee rate to the total loan exposure.
    *   **DAX:** `Total Fees = SUMX('Clients - Banking', [Total Loan] * 'Clients - Banking'[Processing Fees])`
