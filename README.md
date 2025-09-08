# Data-Cleaning-in-SQL-Project
This project walks through a full SQL data cleaning process using a world layoffs dataset. I focused on cleaning errors, handling missing values, and getting the data ready for analysis.

## Files in this repo
- Layoffs SQL Data Cleaning.sql → main SQL script with all cleaning queries (removing duplicates, standardizing values, fixing dates, handling nulls, etc.)
- layoffs.csv → raw dataset containing company layoffs data (uncleaned)
- README.md → this file

## Goals
- Keep a backup of the original data before making changes
- Find and remove duplicate data
- Fix inconsistent values (like company names, countries, and industries)
- Change date values from text into proper date format
- Handle null and blank values
- Drop extra columns that were only used during cleaning

## Tools
- MySQL
- MySQL Workbench

## Steps performed
- Removed duplicate rows
- Standardized company, country, and industry values
- Converted dates into proper DATE format
- Filled missing and blank values where possible
- Dropped helper columns used for cleaning
- **Note: Some null values remain where accurate data could not be confirmed.**

  # Key Takeaways
- Cleaning your data is just as important as analyzing it. The raw dataset had duplicates, messy text, and inconsistent formats that needed to be fixed first.
- Making a backup copy of the original dataset is really useful because it allowed me test changes without worrying about losing the raw data.
- Not all missing values could be filled in. I decided to leave some nulls in place instead of guessing, since making up data could lead to biased results.
- After cleaning, the dataset is much easier to work with and ready for analysis.
