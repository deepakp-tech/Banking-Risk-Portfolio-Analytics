-- ==============================================================================
-- Script: 03_kpi_verification.sql
-- Purpose: Verify macro portfolio KPIs against Python/Power BI dashboard totals
-- ==============================================================================

USE banking_risk_analytics;

-- ------------------------------------------------------------------------------
-- 1. Portfolio Macro Financial Totals (The "Executive Summary" KPIs)
-- ------------------------------------------------------------------------------
SELECT 
    COUNT(DISTINCT Client_ID) AS Total_Active_Clients,
    
    SUM(Bank_Loans + Business_Lending + Credit_Card_Balance) AS Total_Loan_Exposure,
    
    SUM(Bank_Deposits + Saving_Accounts + Checking_Accounts + Foreign_Currency_Account) AS Total_Deposit_Liquidity,
    
    -- Replicating the SUMX logic for Processing Fees based on fee tiers
    SUM(
        (Bank_Loans + Business_Lending + Credit_Card_Balance) * 
        CASE 
            WHEN Fee_Structure = 'High' THEN 0.05
            WHEN Fee_Structure = 'Mid' THEN 0.03
            WHEN Fee_Structure = 'Low' THEN 0.015
            ELSE 0.02 
        END
    ) AS Total_Projected_Fees
    
FROM fact_clients_banking;


-- ------------------------------------------------------------------------------
-- 2. Aggregate Lending Exposure by Income Band
-- ------------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN Estimated_Income < 100000 THEN 'Low'
        WHEN Estimated_Income >= 100000 AND Estimated_Income < 300000 THEN 'Med'
        ELSE 'High'
    END AS Income_Band,
    COUNT(Client_ID) AS Client_Count,
    SUM(Bank_Loans + Business_Lending + Credit_Card_Balance) AS Total_Loan_Exposure
FROM fact_clients_banking
GROUP BY 
    CASE 
        WHEN Estimated_Income < 100000 THEN 'Low'
        WHEN Estimated_Income >= 100000 AND Estimated_Income < 300000 THEN 'Med'
        ELSE 'High'
    END
ORDER BY Total_Loan_Exposure DESC;


-- ------------------------------------------------------------------------------
-- 3. Risk Weighting Distribution by Relationship Division
-- ------------------------------------------------------------------------------
SELECT 
    dbr.Relationship_Type,
    fcb.Risk_Weighting,
    COUNT(fcb.Client_ID) AS Number_of_Clients
FROM fact_clients_banking fcb
JOIN dim_banking_relationship dbr ON fcb.BRId = dbr.BRId
GROUP BY 
    dbr.Relationship_Type, 
    fcb.Risk_Weighting
ORDER BY 
    dbr.Relationship_Type ASC, 
    fcb.Risk_Weighting DESC;