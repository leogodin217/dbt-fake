 -- depends_on: {{ ref('fake_dates') }}
 -- depends_on: {{ ref('fake_numbers') }}

{# No unique key because this is append only #}
{{
  config(
    materialized = 'incremental',
    tags = ['base-table', 'enterprise-orders']
    )
}}

{% set max_per_day = var('max_per_day', 10) %}
{% set allow_zero = var('allow_zero', True) %}
{% set start_date = get_default_start_date() %}
{% set end_date = get_default_end_date() %}


with dates as (
    {{ generate_date_duplicates(start_date, end_date, max_per_day, allow_zero ) }}
),    
products as (
    select 
        dates.date,
        products.id as product_id,
        dates.row_num
    from dates 
    left join {{ ref('products_base') }} as products 
        on products.date_added <= dates.date
    qualify row_number() over (partition by dates.row_num order by {{ xdb_random() }}) = 1
),
employees as (
    select 
        dates.date,
        employees.id as employee_id,
        dates.row_num
    from dates 
    left join {{ ref('employees_base') }} as employees 
        on employees.date_added <= dates.date
    qualify row_number() over (partition by dates.row_num order by {{ xdb_random() }}) = 1
)

select 
    employees.date,
    employees.employee_id,
    products.product_id,
    cast(
        floor(
            ({{ xdb_random() }} * 10) + 1 -- 1 - 10 products
        )
    as int) as num_items
from employees 
left join products 
    on employees.row_num = products.row_num 



