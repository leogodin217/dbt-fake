 -- depends_on: {{ ref('fake_companies') }}
 -- depends_on: {{ ref('fake_dates') }}
 -- depends_on: {{ ref('fake_numbers') }}

{# No unique key, because this is append only #}
{{
  config(
    materialized = 'incremental',
    tags = ['base-table', 'companies']
    )
}}

{% set max_per_day = var('max_per_day', 3) %}
{% set allow_zero = var('allow_zero', True) %}
{% set start_date = get_default_start_date() %}
{% set end_date = get_default_end_date() %}

{{ generate_source_model_query(seed_name='fake_companies', 
                               max_per_day = max_per_day, 
                               allow_zero = allow_zero,
                               start_date = start_date, 
                               end_date = end_date, 
                               columns=['id', 'name', 'slogan', 'purpose']
   )
}}
