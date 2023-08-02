CLASS ycl_round_hole DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING radius TYPE int1.

    METHODS get_radius RETURNING VALUE(radius) TYPE int1.
    METHODS fits IMPORTING peg               TYPE REF TO ycl_round_peg
                 RETURNING VALUE(is_fitting) TYPE abap_boolean.

  PRIVATE SECTION.
    DATA radius TYPE int1.

ENDCLASS.

CLASS ycl_round_hole IMPLEMENTATION.

  METHOD constructor.
    me->radius = radius.
  ENDMETHOD.

  METHOD get_radius.
    radius = me->radius.
  ENDMETHOD.

  METHOD fits.
    is_fitting = xsdbool( me->get_radius( ) >= peg->get_radius( ) ).
  ENDMETHOD.

ENDCLASS.
