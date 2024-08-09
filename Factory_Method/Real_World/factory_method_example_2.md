# Create DB update object instances dynamically

Given a situation where we need to create several instances of a domain class with different injected database operator classes to adapt the main flow to specific database tables:

We have a list of database tables (table_list). For each table, we create an instance of our domain class zcl_vcd_scramble_book_process.
```abap
    LOOP AT table_list INTO DATA(table).
      TRY.
          DATA(object) = zcl_vcd_scramble_book_process=>create( hash_algo_values = VALUE #( BASE hash_algo_values
                                                                                            structure_name = table )
                                                                appl_log         = appl_log ).
          APPEND object TO result.
        CATCH cx_sy_dyn_call_illegal_class.
          RAISE EXCEPTION TYPE zcx_vcd_appl_error
            MESSAGE e189(zvcd2) WITH condense( table ).
      ENDTRY.
    ENDLOOP.
```

In the domain class, using the IMPORTING parameter structure name, we can create different instances of various database operator classes to adapt the algorithm to a specific database table.

```abap
    CLASS-METHODS create IMPORTING hash_algo_values TYPE zcl_vcd_scramble_bookings=>ts_hash_algo_values
                                   appl_log         TYPE REF TO zvcd_if_anwendungs_log
                                   db_operator      TYPE REF TO zif_vcd_db_operator OPTIONAL
                         RETURNING VALUE(result)    TYPE REF TO zcl_vcd_scramble_book_process
                         RAISING   zcx_vcd_appl_error.

  METHOD create.
    result = NEW zcl_vcd_scramble_book_process(
                    hash_algo_values = VALUE #( BASE hash_algo_values
                                                structure_name = hash_algo_values-structure_name )
                    appl_log         = appl_log
                    db_operator      = COND #( WHEN db_operator IS BOUND THEN db_operator
                                               ELSE create_new_instance( hash_algo_values-structure_name ) ) ).
  ENDMETHOD.
```
with...
```abap
  CLASS-METHODS create_new_instance IMPORTING structure_name TYPE domvalue
                                      RETURNING VALUE(result)  TYPE REF TO zif_vcd_db_operator
                                      RAISING   zcx_vcd_appl_error.

  METHOD create_new_instance.
    TRY.
        DATA(db_operator_name) = |{ db_operator_name_prefix }{ condense( COND #( WHEN structure_name = 'ZVCD_SVVSCPOS' THEN 'ZVVSCPOS'
                                                                                 ELSE structure_name ) ) }|.
        CREATE OBJECT result TYPE (db_operator_name).
      CATCH cx_sy_dyn_call_illegal_class.
        RAISE EXCEPTION TYPE zcx_vcd_appl_error
          MESSAGE e189(zvcd2) WITH condense( structure_name ).
    ENDTRY.
  ENDMETHOD.
```
