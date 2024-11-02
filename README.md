# Apartment-Rental-Database

This project provides SQL scripts and database schema for a real estate management system. It includes table definitions, constraints, and sample data, supporting entities such as properties, profiles, and rental contracts.

## Files

- `create.sql`: Contains SQL statements for table creation, constraints, and primary and foreign keys.
- `insert.sql`: Inserts sample data into the database tables.
- `diagram.jpeg`: Shows the database schema diagram for a visual overview of table relationships.

## Features

- Tables for properties, addresses, profiles (individuals and businesses), tenants, landlords, payments, and lease agreements.
- Relationships defined with primary and foreign key constraints.
- Functions for data manipulation and resetting sequences.

## Setup

1. Run `create.sql` to create tables and constraints.
2. Execute `insert.sql` to populate the tables with sample data.
3. Refer to `diagram.jpeg` for the schema structure.

# Usage
- The database can be queried using standard SQL queries.
- Modifications and retrieval of data can be performed as per the needs.

## Requirements

- PostgreSQL database.
- PL/pgSQL language enabled for running functions.
