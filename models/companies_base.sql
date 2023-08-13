 -- depends_on: {{ ref('fake_companies') }}
{{
  config(
    materialized = 'incremental',
    unique_key = 'id',
    tags = ['base-table', 'companies']
    )
}}

{% set max_per_day = var('max_per_day', 3) %}
{% set start_date = get_default_start_date() %}
{% set end_date = get_default_end_date() %}

{{ generate_source_model_query(seed_name='fake_companies', 
                               max_per_day = max_per_day, 
                               start_date = start_date, 
                               end_date = end_date, 
                               columns=['id', 'name', 'slogan', 'purpose']
   )
}}
