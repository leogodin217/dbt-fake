{% macro get_default_end_date() %}
{% if not execute %}
    {{return('')}}
{% endif %}

{% set end_date = var('end_date', 'current_date() - 1') %}
{% if 'current_date()' in end_date %}
    {{ return(end_date) }}
{% else %}
    {{ return("'" + end_date + "'") }}
{% endif %}

{% endmacro %}