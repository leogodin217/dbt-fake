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
                                  end_date = "date('2023-06-30')", 
                                  max_per_day = 3, 
                                  allow_zero = true ) }} 
),
num_records as ( 
    select 
        'Should include 0 - 3' as test_case,
        count(
            case 
                when num_records = 0 then 1   
                else 0
            end
        ) as num_records_zero,
        count(
            case 
                when num_records = 1 then 1   
                else 0
            end
        ) as num_records_one,
        count(
            case 
                when num_records = 2 then 1   
                else 0
            end
        ) as num_records_two,
        count(
            case 
                when num_records = 3 then 1   
                else 0
            end
        ) as num_records_three,
    from date_ranges
    group by num_records 
)
select 
    *
from num_records
where num_records_zero = 0
or num_records_one = 0
or num_records_two = 0
or num_records_three = 0 
