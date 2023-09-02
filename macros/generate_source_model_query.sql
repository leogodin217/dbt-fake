{% macro generate_source_model_query(seed_name, max_per_day, start_date, end_date, columns, allow_zero) %}

{% if not execute %} 
    {{ return('') }}
{% endif %} 

with dates as (
    {{ generate_date_duplicates(start_date, end_date, max_per_day, allow_zero ) }}
),
models as (
    select
    {%- for column in columns %}
        {{ column }}, 
    {%- endfor %}
    row_number() over (order by {{ xdb_random() }}) as row_num
    from {{ ref(seed_name) }} as seed  

    {% if is_incremental() %}
        where not exists (
            select 
                1
            from {{ this }} as current_seed
            where seed.id = current_seed.id
        )
    {% endif %}
    order by {{ xdb_random() }}
)

select 
    {% for column in columns -%}
        models.{{ column }},
    {% endfor -%}
    dates.date as date_added
from dates  
left join models 
    on models.row_num = dates.row_num
{% endmacro %}