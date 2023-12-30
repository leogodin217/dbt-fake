{% macro change_bulk_numbers(model_name, column_name, ids, id_column='id') %}

    {% set ids_csv = ids | join(', ') %}
    {% set sql %}
        update {{ ref(model_name) }} 
        set {{ column_name }} = {{ column_name }} + 1 
        where id in ({{ ids_csv }}) 
    {% endset %}  

    {% do run_query(sql) %}

    {% set num_rows = ids | length | string %}
    {{ log('MACRO-change_bulk_numbers: ' + num_rows + ' Rows Updated on ' + model_name + '.' + column_name, info=True )}}
{% endmacro %}