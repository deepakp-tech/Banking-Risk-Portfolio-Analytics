-- ==============================================================================
-- Script: 01_schema_setup.sql
-- Purpose: Initialize the database schema for Banking Portfolio Risk Analytics
-- Dialect: MySQL
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS banking_risk_analytics;
USE banking_risk_analytics;

-- ------------------------------------------------------------------------------
-- 1. Create Dimension Tables
-- ------------------------------------------------------------------------------

-- Banking Relationship Dimension
CREATE TABLE IF NOT EXISTS dim_banking_relationship (
    BRId INT PRIMARY KEY,
    Relationship_Type VARCHAR(50) NOT NULL
);

-- Gender Dimension
CREATE TABLE IF NOT EXISTS dim_gender (
    GenderId INT PRIMARY KEY,
    Gender_Name VARCHAR(20) NOT NULL
);

-- Investment Advisor Dimension
CREATE TABLE IF NOT EXISTS dim_investment_advisor (
    IAId INT PRIMARY KEY,
    Advisor_Name VARCHAR(100)
);

-- ------------------------------------------------------------------------------
-- 2. Create Fact Table (Main Client Data)
-- ------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS fact_clients_banking (
    Client_ID VARCHAR(20) PRIMARY KEY,
    Client_Name VARCHAR(100),
    Age INT,
    Location_ID INT,
    Joined_Bank DATE,
    Banking_Contact VARCHAR(100),
    Nationality VARCHAR(50),
    Occupation VARCHAR(100),
    Fee_Structure VARCHAR(20),
    Loyalty_Classification VARCHAR(20),
    
    -- Financial Metrics (Using DECIMAL for exact financial precision)
    Estimated_Income DECIMAL(15, 2),
    Superannuation_Savings DECIMAL(15, 2),
    Amount_of_Credit_Cards INT,
    Credit_Card_Balance DECIMAL(15, 2),
    Bank_Loans DECIMAL(15, 2),
    Bank_Deposits DECIMAL(15, 2),
    Checking_Accounts DECIMAL(15, 2),
    Saving_Accounts DECIMAL(15, 2),
    Foreign_Currency_Account DECIMAL(15, 2),
    Business_Lending DECIMAL(15, 2),
    
    -- Risk & Asset Indicators
    Properties_Owned INT,
    Risk_Weighting INT,
    
    -- Foreign Keys mappings
    BRId INT,
    GenderId INT,
    IAId INT,
    
    FOREIGN KEY (BRId) REFERENCES dim_banking_relationship(BRId),
    FOREIGN KEY (GenderId) REFERENCES dim_gender(GenderId),
    FOREIGN KEY (IAId) REFERENCES dim_investment_advisor(IAId)
);