{% macro generate_date_duplicates(start_date, end_date, max_per_day, allow_zero) %}
{% if not execute %}
    return('')
{% endif %}

    with dates as (
        select 
            date,
            cast(
                floor(
                    {{ xdb_random() }} * {% if allow_zero %} ({{ max_per_day }} + 1) {% else %} {{ max_per_day }} + 1  {% endif %}
                )
            as int) as num_records
        from {{ ref('fake_dates') }} 
        where date between {{ start_date }} and {{ end_date }}
    ),
    date_rows as (
        select 
            date,
            num_records,
            row_number() over (order by null) as row_num
        from dates 
        -- This join creates the duplicate dates
        inner join {{ ref('fake_numbers') }} as numbers
            on dates.num_records = numbers.number
    )    
    select * from date_rows
{% endmacro %}