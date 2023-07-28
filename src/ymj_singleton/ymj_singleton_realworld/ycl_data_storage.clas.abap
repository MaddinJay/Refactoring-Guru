CLASS ycl_data_storage DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_likp,
             vbeln TYPE char10,
           END OF ts_likp.

    "! Instance creator for singleton
    "! @parameter ro_object | Instance of class
    CLASS-METHODS create_object RETURNING VALUE(ro_object) TYPE REF TO ycl_data_storage.

    METHODS:
      get_likp RETURNING VALUE(r_result) TYPE ts_likp,
      set_likp IMPORTING i_ms_likp TYPE ts_likp.

  PRIVATE SECTION.
    CLASS-DATA: mo_data_storage TYPE REF TO ycl_data_storage.
    DATA ms_likp TYPE ts_likp.

ENDCLASS.

CLASS ycl_data_storage IMPLEMENTATION.

  METHOD create_object.
    " If instance already created, return it
    ro_object = mo_data_storage = COND #( WHEN mo_data_storage IS BOUND THEN mo_data_storage
                                         ELSE NEW ycl_data_storage( ) ).
  ENDMETHOD.

  METHOD get_likp.
    r_result = me->ms_likp.
  ENDMETHOD.

  METHOD set_likp.
    me->ms_likp = i_ms_likp.
  ENDMETHOD.

ENDCLASS.
