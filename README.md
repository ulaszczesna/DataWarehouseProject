# Data Warehouse Project

## 📌 Project Overview
This project focuses on building a **Data Warehouse** that integrates and processes data from multiple sources, including CRM and ERP systems. The data flows through different layers (**Bronze, Silver, and Gold**) to ensure quality, transformation, and aggregation before being used for analytics and reporting.

## 🏗️ Data Warehouse Architecture
The ETL process consists of three layers:

1. **Bronze Layer**: Raw data is loaded directly from CSV files without transformation.
2. **Silver Layer**: Data cleansing, deduplication, and transformation occur.
3. **Gold Layer**: Aggregated and structured data is stored for reporting and business intelligence.

## 📊 Data Flow Diagram

![Data Flow Diagram](docs/diagram (1).svg)

## 📂 Repository Structure
```
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│ 
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project
```


