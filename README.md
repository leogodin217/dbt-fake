One of the most difficult tasks when learning DBT is finding good datasets that update over time. This
project uses DBT to generate fake data that will update daily. With simple commands, we can generate a history of data.
Then, we can update the data each day to mimic a real company.  

This project is in early stages, with just two tables; companies_base and employees_base. Right now, we can add new
companies and employees each day, but existing records will never change. Future enhancements will include: 

- Additional models for products, orders, and something marketing related. Maybe email campaigns or Google ads. 
- Macros to randomly change existing dimensional records
- Macros to introduce data-quality errors that will require fixing. 
- Cross-database support (Currently only works on Bigquery)
- Better code validation (Using multiple methods to demonstrate possibilities)


### Generating Fake Data 

**Load the seed data:**
- dbt seed
- This only needs to be run once

**Load a history:**

All models support the following optional arguments
- start_date - default current_date() - 1 
- end_date - default current_date() - 1
- max_per_day - default 3 for companies, 10 for employees
- allow_zero - default true. True allows a day to have 0 records.
- dbt build -s tag:base-table --vars '{start_date: "some_date", end_date: "some_date", max_per_day: some_number, allow_zero: true|false}'

example: Create records starting 2023-01-01 and ending 2023-08-20. 0-3 companies, 0-10 employees \
dbt build -s tag:base-table --vars '{start_date: "2023-01-01", end_date: "2023-08-20"}'

example: Create records starting 2023-01-01 and ending 2023-08-20. 1-3 companies per day, 1-10 employees per day \
dbt build -s tag:base-table --vars '{start_date: "2023-01-01", end_date: "2023-08-20", allow_zero: false}'

example: Create company records for 2023-01-01 and ending 2023-08-20, 1-20 employees per day \
dbt build -s employees_base --vars '{start_date: "2023-01-01", end_date: "2023-08-20", num_records: 20, allow_zero: false}'

**Load daily records:**

example: Create records for yesterday. 0-3 companies, 0-10 employees \
dbt build -s tag:base-table

example: Load companies for yesterday with 1-3 companies \
dbt build -s companies_base --vars '{num_records: 3, allow_zero=false}'

example: Load employees for yesterday with 0-3 employees \
dbt build -s companies_base --vars '{num_records: 3}'


**Ways to Use this Project**

First, do the [free DBT tutorials](https://courses.getdbt.com/collections). They are short and very good. They will teach the basics of DBT, even if they do not have data
that updates every day. Start with fundamentals, then materializations, then jinja and macros. 

Once you understand the basics. Get this project running in your own environment or in DBT cloud. Start building models and fixing things. Practice stuff you want to learn. 

In general, the output tables are intended to be sources in another project. A good practice is to keep this project completely
separate and create a sources.yml in your own project. With this method, you can still modify this project if the output data
does not meet your needs.  

To see documentation on each table, look in *_base.yml or run:
- dbt docs generate
- dbt docs serve


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
