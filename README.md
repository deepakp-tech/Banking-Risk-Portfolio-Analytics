# 🏦 Banking Portfolio Risk Analytics & BI Dashboard

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge&logo=jupyter&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)

---

## 📑 Executive Summary

This repository delivers an end-to-end data analytics and risk modeling pipeline evaluating the credit and liquidity risk across **3,000 retail, commercial, institutional, and private banking clients**.

* **Business Problem:** Financial institutions face recurring credit default risks when capital exposure is not proactively monitored across customer tiers. Without an integrated view combining liquid deposits, revolving debt, and commercial lending, credit officers cannot accurately evaluate portfolio concentration risk or counterparty default likelihoods.
* **Analytical Solution:** This project unifies multi-table relational banking data into a standardized data model. Through automated SQL staging, sequential Python feature engineering, and an interactive 4-page Power BI dashboard, risk officers and underwriters gain portfolio visibility into **\$4.38 Billion** in lending exposure and **\$3.77 Billion** in liquid deposits.

---

## 🏗️ Technical Architecture & Pipeline

```
┌────────────────────────┐      ┌────────────────────────┐      ┌────────────────────────┐
│  1. Database Staging   │      │ 2. Python Data Science │      │   3. Power BI & DAX    │
│       (MySQL)          │ ───► │   (Jupyter Pipeline)   │ ───► │  (Executive Dashboard) │
│  • Normalized Schema   │      │  • Missing Value Audit │      │  • Portfolio KPIs      │
│  • PK / FK Integrity   │      │  • Feature Engineering │      │  • Dynamic Slicing     │
│  • SQL KPI Validation  │      │  • KDE Distributions   │      │  • Custom UI Canvas    │
└────────────────────────┘      └────────────────────────┘      └────────────────────────┘
```

1. **Relational Staging (`sql/`):** Raw tables (`Clients - Banking`, `Banking Relationship`, `Gender`, `Investment Advisor`) are ingested into MySQL with primary and foreign key constraints to ensure referential integrity.
2. **Sequential Python Pipeline (`notebooks/`):**
   * `01_data_cleaning_final.ipynb`: Performs schema validation, parses dates, derives customer tenure (`Engagement Days`), bins continuous income into `Income Band` tiers, and exports `banking_cleaned.csv`.
   * `02_exploratory_data_analysis.ipynb`: Loads the cleaned file directly, profiles demographics, checks risk ratings, models heavy-tailed balance skewness using Kernel Density Estimation (KDE), and calculates a 12-variable financial correlation matrix.
3. **Business Intelligence Layer (`bi_dashboard/`):** Connects to the curated data model to deliver executive cards, regional drill-downs, and liquidity breakdowns powered by custom DAX formulas.

---

## 📊 Key Business Takeaways

| Strategic Area | Analytical Finding | Risk & Business Implication |
| :--- | :--- | :--- |
| **Income Segmentation** | **50.6%** of clients fall in the `Med` income tier (\$100k–\$300k); **34.2%** in `Low` (< \$100k); **15.2%** in `High` (> \$300k). | `Med` income accounts carry the largest aggregate borrowing exposure due to cohort volume, while `High` income clients hold larger per-capita commercial credit lines. |
| **Credit Risk Distribution** | **68.6%** of the portfolio is rated Low Risk (Grade 1: 27.9%, Grade 2: 40.7%). Only **5.3%** (160 accounts) sit in high-risk Grade 5. | Healthy baseline underwriting quality; credit monitoring resources can be concentrated on the 160 Grade 5 counterparties. |
| **Geographic Parity** | Default risk weightings are distributed proportionately across European and Asian accounts. | There is no systemic regional risk cluster; underwriting rules can remain consistent across geographic divisions. |
| **Liquidity Co-Movement** | Pearson correlation of **0.71** between `Bank Deposits` and `Checking Accounts`, and **0.42** with `Saving Accounts`. | High-net-worth clients consolidate liquid facilities within the bank, presenting prime cross-selling opportunities for treasury and wealth products. |
| **Revolving Debt Dynamics** | `Credit Card Balance` shows zero correlation ($-0.01$) with `Bank Loans` and `Estimated Income` ($0.01$). | Card drawdowns reflect day-to-day liquidity usage rather than structured borrowing capacity, requiring dedicated retail credit limits. |

---

## 📈 Macro Portfolio Financial Metrics

* **Total Active Clients:** 3,000 verified accounts
* **Total Portfolio Loan Exposure:** **\$4,380,317,947.64 (~$4.38B)**
  * Standard Bank Loans: \$1.77 Billion
  * Business & Commercial Lending: \$2.60 Billion
  * Revolving Credit Card Debt: \$9.53 Million
* **Total Deposit Liquidity:** **\$3,773,205,820.73 (~$3.77B)**
  * General Bank Deposits: \$2.01 Billion
  * Checking Accounts: \$963 Million
  * Savings Accounts: \$699 Million
  * Foreign Currency Holdings: \$90 Million
* **Projected Annual Fee Revenue:** **\$170,473,086.10 (~$170M+)**

---

## 📂 Repository Organization

```text
banking-risk-analytics/
├── README.md                              # Main portfolio documentation
├── requirements.txt                       # Python dependencies
│
├── docs/                                  # Business Analyst specifications
│   ├── business_requirements_document     # Business problem, objectives, and scope
│   ├── kpi_definitions_and_dax.md         # DAX formulas and metric logic
│   ├── Banking Report                     #summary of the results 
│   └── Banking.pptx
│
│
├── data/                                  
│   ├── raw/                               # Unmodified source files
│   │   └── Banking.csv
│   └── processed/                         # Pipeline output from Notebook 01
│     
│
├── notebooks/                             # Sequential analytical pipeline
│   ├── 01_data_cleaning_final.ipynb       # Data audit, type conversion, and feature engineering
│   └── 02_exploratory_data_analysis.ipynb # Visual distributions, KDE plots, and correlation matrix
│
├── sql/                                   # Relational database scripts (MySQL)
│   ├── 01_schema_setup.sql                # DDL: Tables, Primary Keys, Foreign Keys
│   ├── 02_data_import.sql                 # Data staging and ingestion scripts
│   └── 03_kpi_verification.sql            # Analytical queries validating dashboard metrics
│
└── bi_dashboard/                          # Power BI project assets
    ├── Banking_Risk_Dashboard.pbix        # Interactive report file
    ├── templates_and_backgrounds/         # UI canvas backgrounds
    └── screenshots/                       # Exported dashboard views
        ├── 01_home_overview.png
        ├── 02_loan_risk_analysis.png
        ├── 03_deposit_analysis.png
        └── 04_portfolio_summary.png
```

---


## 📐 Core DAX Formulas

All measures are centralized within a dedicated `_Measures` table inside Power BI:

```dax
-- 1. Unique Customer Volume
Total Clients = DISTINCTCOUNT('Clients - Banking'[Client ID])

-- 2. Aggregate Lending Exposure
Total Loan = 
    SUM('Clients - Banking'[Bank Loans]) + 
    SUM('Clients - Banking'[Business Lending]) + 
    SUM('Clients - Banking'[Credit Card Balance])

-- 3. Total Portfolio Liquidity
Total Deposit = 
    SUM('Clients - Banking'[Bank Deposits]) + 
    SUM('Clients - Banking'[Saving Accounts]) + 
    SUM('Clients - Banking'[Checking Accounts]) + 
    SUM('Clients - Banking'[Foreign Currency Account])

-- 4. Dynamic Processing Fee Revenue
Total Fees = 
    SUMX(
        'Clients - Banking', 
        [Total Loan] * 'Clients - Banking'[Processing Fee Rate]
    )

-- 5. Customer Relationship Tenure
Engagement Days = DATEDIFF('Clients - Banking'[Joined Bank], TODAY(), DAY)
```

---

## ⚙️ Setup and Execution Guide

### 1. Clone the Project
```bash
git clone https://github.com/<your-username>/banking-risk-analytics.git
cd banking-risk-analytics
```

### 2. Set Up Python Environment
```bash
# Create and activate virtual environment
python -m venv venv
source venv/bin/activate       # On Windows: venv\Scripts\activate

# Install required packages
pip install pandas numpy matplotlib seaborn jupyter openpyxl
```

### 3. Run the Sequential Notebooks
Execute the notebooks in sequence to maintain pipeline dependencies:
1. Open and run all cells in `notebooks/01_data_cleaning_final.ipynb` to validate raw data and generate `data/processed/banking_cleaned.csv`.
2. Open and run `notebooks/02_exploratory_data_analysis.ipynb` to generate distributions, KDE skewness charts, and correlation heatmaps.

### 4. Run Relational Verification (MySQL)
```bash
# Log in to MySQL
mysql -u root -p

# Execute SQL scripts in sequence
SOURCE sql/01_schema_setup.sql;
SOURCE sql/02_data_import.sql;
SOURCE sql/03_kpi_verification.sql;
```

### 5. Access Power BI Dashboard
1. Open [Power BI Desktop](https://powerbi.microsoft.com/desktop/).
2. Open `bi_dashboard/Banking_Risk_Dashboard.pbix`.
3. If prompted to refresh data, verify the data source path points to `data/processed/banking_cleaned.csv` or your local MySQL server.

---

## 👤 Author & Contact

* **Author:** Deepak Panigrahi
* **Tools Used:** Python, MySQL, Power BI Desktop, DAX, Canva UI
