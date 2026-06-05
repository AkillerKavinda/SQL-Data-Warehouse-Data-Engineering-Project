# Data Warehouse Project (SQL Server)

## Overview
This project builds a simple data warehouse using a Medallion Architecture:
- Bronze: Raw data ingestion from CSV files
- Silver: Cleaned and standardized data
- Gold: Business-ready views for reporting

## Tech Stack
- Microsoft SQL Server
- T-SQL (Stored Procedures, Views)
- ETL using Stored Procedures

## Project Structure
- datasets/ → Source CSV files
- scripts/ → SQL scripts for all layers (Bronze, Silver, Gold)

## How to Run
1. Run Bronze scripts to create and load raw tables
   EXEC bronze.load_bronze;

2. Run Silver scripts to clean and transform data
   EXEC silver.load_silver;

3. Run Gold scripts to create reporting views

## Output
Final Gold layer contains:
- Fact Sales
- Dim Customers
- Dim Products
