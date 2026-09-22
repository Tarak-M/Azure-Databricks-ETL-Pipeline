# Azure Databricks ETL Pipeline

An end-to-end Azure data engineering project demonstrating data ingestion, metadata-driven processing, data transformation, SQL-based status management, and failure notification using Azure Data Factory, ADLS Gen2, Azure Databricks, SQL, and Azure Logic Apps.


## Project Overview

This project implements an ETL workflow that moves data from an on-premises file system into Azure Data Lake Storage Gen2 and organizes the data into Bronze, Silver, and Gold layers.

Azure Data Factory is used for orchestration and data ingestion. Metadata-driven processing is implemented using SQL tables and stored procedures. Databricks notebooks are included for data cleaning, business logic, and loading data into the SQL layer.

Azure Logic Apps is used to provide email notifications when a pipeline failure occurs.


## Architecture

                    On-Premises File System
                             |
                             |
                  Self-Hosted Integration
                         Runtime
                             |
                             v
                   Azure Data Factory
                             |
                             v
                  ADLS Gen2 - Bronze
                             |
                             v
                    Data Transformation
                             |
                             v
                  ADLS Gen2 - Silver
                             |
                             v
                   Business Processing
                             |
                             v
                   ADLS Gen2 - Gold
                             |
                             v
              Azure Synapse / SQL Layer
                             |
                             v
                      Data Consumption
Failure Notification Flow
Azure Data Factory
       |
       | On Failure
       v
   Web Activity
       |
       v
 Azure Logic App
       |
       v
 HTTP Request Trigger
       |
       v
 Send Gmail V2
       |
       v
 Failure Notification
Technologies Used
Azure Data Factory
Azure Data Lake Storage Gen2
Azure Databricks
Azure Synapse Analytics / SQL
Azure Logic Apps
Azure Key Vault
Self-Hosted Integration Runtime
SQL Server Management Studio (SSMS)
GitHub
PySpark
SQL
Data Flow
1. On-Premises Data Ingestion

Source files are stored in an on-premises Windows file system.

Azure Data Factory uses a Self-Hosted Integration Runtime to securely access the local file system.

The source data is then transferred to Azure Data Lake Storage Gen2.

On-Premises Files
       |
       v
Self-Hosted IR
       |
       v
Azure Data Factory
       |
       v
ADLS Gen2
2. Bronze Layer

The initial copy of the source data is stored in the Bronze layer of ADLS Gen2.

The Bronze layer preserves the ingested source data before transformation.

Example structure:

global/
└── Bronze/
    ├── cust/
    ├── orders/
    ├── emp/
    └── discounts/
3. Metadata-Driven Processing

A SQL metadata table is used to control which source folders are processed.

The metadata table contains:

Source folder name
Storage path
Active status
Processing status

Example source entries include:

cust
orders
emp
discounts

The SQL scripts used for the metadata table are available under:

SQL/
├── metadata.sql
└── stored_procedures.sql
4. Azure Data Factory Orchestration

Azure Data Factory orchestrates the ETL workflow.

The pipeline uses:

Lookup activity
ForEach activity
Copy Data activity
Stored Procedure activities
Web activity
Failure handling

The Lookup activity reads metadata records and passes the results to the ForEach activity.

The ForEach activity processes the source folders dynamically.

Example metadata query:

SELECT *
FROM metadata
WHERE status = 'succeeded';

Dynamic source and destination paths are generated using metadata values.

5. Silver Layer

After ingestion, data can be processed and cleaned before being written to the Silver layer.

Typical transformation operations include:

Reading CSV data
Removing duplicate records
Validating data
Applying transformation logic
Writing the processed data to the Silver layer

Example structure:

global/
└── silver/
    ├── cust/
    ├── orders/
    ├── emp/
    └── discounts/

The Databricks notebooks used for transformation are stored under:

Databricks/
└── Notebooks/
6. Gold Layer

Business logic is applied to the processed Silver data to produce the Gold layer.

The Gold layer contains data prepared for downstream analytics and SQL-based consumption.

Example structure:

global/
└── gold/
    ├── cust/
    ├── orders/
    ├── emp/
    └── discounts/
7. SQL Status Management

Stored procedures are used by Azure Data Factory to update the processing status of metadata records.

The project includes procedures for:

Success Processing

Updates the status of the processed source folder to:

succeeded
Failure Processing

Updates the status when a pipeline operation fails.

Status Reset

Resets metadata records to:

ready

The SQL implementation is available in:

SQL/stored_procedures.sql
8. Failure Notification

Azure Logic Apps provides failure notification.

When an appropriate Azure Data Factory activity fails:

ADF Activity
     |
     | On Failure
     v
Web Activity
     |
     v
Logic App
     |
     v
Gmail Notification

The Logic App uses:

Trigger: When an HTTP request is received

Method: GET

Action: Send Gmail V2

The Logic App documentation is available in:

LogicApp/README.md

Sensitive Logic App URLs and credentials are intentionally excluded from this repository.

9. Security

Sensitive credentials are not stored in the GitHub repository.

The project uses Azure security services and configuration mechanisms for sensitive information.

The following should not be committed to the repository:

Passwords
Storage account access keys
Client secrets
API keys
Access tokens
Key Vault secret values
SQL connection strings containing credentials
Logic App URLs containing sensitive access information

Azure Key Vault is used to securely manage sensitive configuration values.

Repository Structure
Azure-Databricks-ETL-Pipeline/
│
├── Databricks/
│   └── Notebooks/
│       ├── businessLogic_silver_to_gold
│       ├── Data_cleaning
│       └── Load_Data_into_SQLDW
│
├── SQL/
│   ├── metadata.sql
│   └── stored_procedures.sql
│
├── LogicApp/
│   └── README.md
│
├── dataset/
│
├── factory/
│
├── integrationRuntime/
│
├── linkedService/
│
├── pipeline/
│
├── README.md
│
└── publish_config.json
Azure Data Factory Components

The repository contains the exported Azure Data Factory project artifacts, including:

Pipelines
Datasets
Linked Services
Integration Runtime configuration
Factory configuration
Publish configuration

These files allow the Data Factory project structure to be version-controlled through GitHub.

Databricks Notebooks

The repository contains the following notebooks:

Data_cleaning

Used for data cleaning and preparation before downstream processing.

businessLogic_silver_to_gold

Contains business transformation logic used to prepare processed data for the Gold layer.

Load_Data_into_SQLDW

Contains the logic associated with loading processed data into the SQL/Synapse layer.

SQL Components

The SQL directory contains:

SQL/
├── metadata.sql
└── stored_procedures.sql

metadata.sql contains the metadata table definition and initial metadata records.

stored_procedures.sql contains the stored procedures used to manage processing status.

Project Workflow

The overall workflow can be summarized as:

1. Source files are stored on-premises
             |
             v
2. Self-Hosted Integration Runtime
             |
             v
3. Azure Data Factory
             |
             v
4. ADLS Gen2 Bronze
             |
             v
5. Data Cleaning
             |
             v
6. ADLS Gen2 Silver
             |
             v
7. Business Logic
             |
             v
8. ADLS Gen2 Gold
             |
             v
9. SQL / Synapse
             |
             v
10. Downstream Data Consumption

Failure handling runs alongside the pipeline:

Pipeline Failure
       |
       v
Web Activity
       |
       v
Logic App
       |
       v
Email Notification
GitHub Version Control

The project uses GitHub to maintain version control for:

Azure Data Factory artifacts
Databricks notebooks
SQL scripts
Logic App documentation
Project documentation

This repository provides a centralized location for the project's source code and configuration artifacts.

Key Features
On-premises to Azure data ingestion
Self-Hosted Integration Runtime
Metadata-driven processing
Dynamic file and folder processing
ADLS Gen2 Bronze/Silver/Gold architecture
Data cleaning and transformation
Business logic processing
SQL-based metadata management
Stored procedure-based status tracking
Pipeline failure handling
Automated email notification
Azure Key Vault integration
GitHub version control
Project Outcome

This project demonstrates an Azure-based ETL architecture that integrates data ingestion, cloud storage, transformation, SQL processing, orchestration, error handling, and notification into a single data engineering workflow.
