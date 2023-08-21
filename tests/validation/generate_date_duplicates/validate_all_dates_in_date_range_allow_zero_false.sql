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
                                  end_date = "date('2023-01-03')", 
                                  max_per_day = 3, 
                                  allow_zero = false ) }} 
),
distinct_dates as (
    select 
        count(
            case 
                when date = date('2023-01-01') then 1 
                else 0
            end
        ) as num_date_01_01, 
        count(
            case 
                when date = date('2023-01-02') then 1 
                else 0
            end
        ) as num_date_01_02, 
        count(
            case 
                when date = date('2023-01-03') then 1 
                else 0
            end
        ) as num_date_01_03
    from date_ranges 
    group by date
)
select 
    *
from distinct_dates
where num_date_01_01 = 0
or num_date_01_02 = 0
or num_date_01_03 = 0