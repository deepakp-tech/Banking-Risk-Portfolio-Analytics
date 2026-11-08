-- ==============================================================================
-- Script: 02_data_import.sql
-- Purpose: Bulk load CSV data into the banking schema
-- ==============================================================================

USE banking_risk_analytics;

-- 1. Load Dimension Tables First (to respect Foreign Key constraints)

INSERT INTO dim_banking_relationship (BRId, Relationship_Type) VALUES 
(1, 'Retail'), 
(2, 'Institutional'), 
(3, 'Private Bank'), 
(4, 'Commercial');

INSERT INTO dim_gender (GenderId, Gender_Name) VALUES 
(1, 'Male'), 
(2, 'Female');

-- (Assuming you exported unique advisors to investment_advisors.csv)
LOAD DATA LOCAL INFILE '../data/processed/investment_advisors.csv'
INTO TABLE dim_investment_advisor
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 2. Load Fact Table

LOAD DATA LOCAL INFILE '../data/raw/Banking_Export.csv'
INTO TABLE fact_clients_banking
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    Client_ID, Client_Name, Age, Location_ID, @Joined_Bank, Banking_Contact, 
    Nationality, Occupation, Fee_Structure, Loyalty_Classification, 
    Estimated_Income, Superannuation_Savings, Amount_of_Credit_Cards, 
    Credit_Card_Balance, Bank_Loans, Bank_Deposits, Checking_Accounts, 
    Saving_Accounts, Foreign_Currency_Account, Business_Lending, 
    Properties_Owned, Risk_Weighting, BRId, GenderId, IAId
)
SET Joined_Bank = STR_TO_DATE(@Joined_Bank, '%d-%m-%Y'); 
-- Adjust the date format string if your raw CSV uses YYYY-MM-DD