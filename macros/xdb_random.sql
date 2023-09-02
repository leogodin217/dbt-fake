{%- macro xdb_random() %}
  {{ return(adapter.dispatch('xdb_random')()) }} 
{% endmacro -%}

{%- macro default__xdb_random() -%}
    rand()  
{%- endmacro -%}

{%- macro snowflake__xdb_random() -%}
    uniform(0::float, 1::float, random())  
{%- endmacro -%}

{%- macro duckdb__xdb_random() -%}
    random()
{%- endmacro -%}

