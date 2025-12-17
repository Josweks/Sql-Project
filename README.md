# SQL Data Analysis Project

This repository contains SQL scripts for analyzing and investigating a dataset consisting of products and sales. This provides crucial insights into transaction details, product attributes, and their relationships.

## Features

1. **Database Creation**:
   - Creates a database named `Findout`.
   - Defines two tables: `product2` and `sale2`.

2. **Sample Data**:
   - Populates the `product2` and `sale2` tables with sample data for analysis.

3. **Queries and Analysis**:
   - Row counts, duplicate checks, and distinct values extraction.
   - Inspection of schema and data types using `INFORMATION_SCHEMA`.
   - Investigation of null values and literal `null` strings in the dataset.
   - Transaction status tracking and completed transaction analysis.
   - Joining tables to observe product sales relationships.

4. **Advanced Queries**:
   - Numeric summaries, filtering based on conditions, and date-based extractions.
   - Use of subqueries for detailed data filtering.
   - Application of conditional labeling using `CASE` statements.

5. **Procedures**:
   - `summary1`: Returns a summary of electronic products with `unit_price > 100` and `stock < 100`.
   - `summary2`: Returns all completed transactions with associated product categories.

6. **Common Table Expressions (CTEs)**:
   - Creates reusable queries for joined and filtered data.

7. **Window Functions**:
   - Ranks the number of electronic products in the `category` column.

## Usage

1. Import the script into your preferred SQL database environment.
2. Modify any paths or table names as required.
3. Explore the provided queries according to your data analysis needs.

## Contact

For issues or contributions, feel free to open an [issue](https://github.com/Josweks/Sql-Project/issues) in the repository.

---

*Happy Data Analyzing!*