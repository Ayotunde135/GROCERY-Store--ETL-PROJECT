# Tesca Grocery Analysis ETL Project

## Introduction
Welcome to the Tesca Grocery Analysis project, a comprehensive endeavor aimed at constructing an Enterprise Data Warehouse (EDW) to meet the analytical needs of Tesca Grocery Chain. This project involves the development of an end-to-end data pipeline using SQL Server Integration Services (SSIS). The primary objective is to derive valuable insights into various aspects of the business, including product movement, sales trends, promotional impacts, vendor dynamics, and more. The project also involves the creation of Data Mart Cubes for different functional areas and the utilization of visualization tools such as Tableau and Power BI to create intuitive data representations.

## Background
Tesca Grocery Chain is a large-scale operation comprising 830 stores spread across 74 states. The business model revolves around distributing products sourced from certified vendors to its stores, offering a diverse range of 40 products across 7 departments. Sales transactions are facilitated through barcode scanning at Point of Sale (POS) systems. Various promotional strategies, including coupons, temporary price reductions, advertisements, and in-store promotions, are employed to drive sales. Crucial data related to vendor transactions, salesperson overtime, and POS device replacements are meticulously tracked. Administrative access to both Analysis and Relational Database Instances has been granted by the Database Administrator.

## Project Steps:
The project involves several steps in the ETL (Extract, Transform, Load) process:

1. **Data Extraction from OLTP**: 
   - Extract data from the OLTP system, including sales transactions, vendor transactions, and other relevant data.

2. **Data Transformation and Loading to Staging Area**:
   - Transform the extracted data as per business requirements.
   - Load the transformed data into a staging area for further processing.

3. **Loading Dimensional Data into EDW**:
   - Transform and load dimensional data (e.g., product, store, time dimensions) into the Enterprise Data Warehouse (EDW).

4. **Loading Fact Data into EDW**:
   - Transform and load fact data (e.g., sales transactions) into the EDW, possibly from both OLTP and flat files.

5. **Data Mart Cube Creation**:
   - Create Data Mart Cubes for various functional areas (e.g., sales, inventory) to facilitate efficient analysis.

6. **Visualization using Tableau and Power BI**:
   - Utilize visualization tools such as Tableau and Power BI to create intuitive and insightful data representations for business users.

## Files Included:
- `Load From OLTP to Staging (DIMENSION).sql`
- `Load Staging Fact from OLTP and Flatfile.sql`
- `Loading From Staging To EDW (DIMENSION).sql`
- `Loading from OLTP to Staging (Fact).sql`
- `Loading from Staging to EDW (Fact).sql`
- `SQL DATE$HOUR DIMENSION.sql`
- `README.md`

## Instructions:
1. Execute the SQL scripts in the provided order to build the end-to-end data pipeline.
2. Customize the scripts as per specific business requirements and database configurations.
3. Utilize visualization tools like Tableau and Power BI to analyze and visualize the data stored in the EDW and Data Mart Cubes.


**Note:** This README serves as a guide to understanding the project structure and its components. Detailed documentation and code comments within the scripts provide further insights into the implementation specifics.
