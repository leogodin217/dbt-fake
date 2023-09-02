 -- depends_on: {{ ref('fake_companies') }}
 -- depends_on: {{ ref('fake_people') }}
 -- depends_on: {{ ref('fake_dates') }}
 -- depends_on: {{ ref('fake_numbers') }}

{# No unique key because this is append only #}
{{
  config(
    materialized = 'incremental',
    tags = ['base-table', 'employees']
    )
}}

{% set max_per_day = var('max_per_day', 10) %}
{% set allow_zero = var('allow_zero', True) %}
{% set start_date = get_default_start_date() %}
{% set end_date = get_default_end_date() %}

with people as (
{{ generate_source_model_query(seed_name='fake_people', 
                               max_per_day = max_per_day, 
                               allow_zero = allow_zero,
                               start_date = start_date, 
                               end_date = end_date, 
                               columns=['id', 'first_name', 'last_name', 'gender', 'email', 'age', 'username']
   )
}}
),
companies as (
  select 
      id,
      date_added,
      {{ xdb_random() }} as company_order
  from {{ ref('companies_base') }}
)
select 
    people.*,
    companies.id as company_id
from people 
left join companies 
    -- Only join to companies that existed on the fake date the employee was added
    on companies.date_added <= people.date_added
qualify row_number() over (partition by people.id order by {{ xdb_random() }}) = 1

