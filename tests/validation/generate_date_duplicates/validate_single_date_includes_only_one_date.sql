{{
  config(
    tags = ['validation'],
    enabled = var('test_validation', false )
  )
}}

{# With ~180 days and 4 possibilities, we are very close to 100% probablity of each one occuring #}
with date_ranges as (
      {{ generate_date_duplicates(
                                  start_date = "date('2023-01-01')", 
                                  end_date = "date('2023-01-01')", 
                                  max_per_day = 3, 
                                  allow_zero = false ) }} 
)
select 
    *
from date_ranges
where date <> date('2023-01-01')