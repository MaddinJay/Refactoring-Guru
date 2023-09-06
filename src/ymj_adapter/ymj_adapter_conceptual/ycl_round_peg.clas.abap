CLASS ycl_round_peg DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING radius TYPE int1.
    METHODS get_radius  RETURNING VALUE(result) TYPE int1.

  PRIVATE SECTION.
    DATA radius TYPE int1.

ENDCLASS.

CLASS ycl_round_peg IMPLEMENTATION.

  METHOD constructor.
    me->radius = radius.
  ENDMETHOD.

  METHOD get_radius.
    result = me->radius.
  ENDMETHOD.

ENDCLASS.
