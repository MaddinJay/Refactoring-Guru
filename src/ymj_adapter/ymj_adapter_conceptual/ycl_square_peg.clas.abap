CLASS ycl_square_peg DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING width TYPE int1.
    METHODS get_width   RETURNING VALUE(result) TYPE int1.

  PRIVATE SECTION.
    DATA width TYPE int1.

ENDCLASS.

CLASS ycl_square_peg IMPLEMENTATION.

  METHOD constructor.
    me->width = width.
  ENDMETHOD.

  METHOD get_width.
    result = me->width.
  ENDMETHOD.

ENDCLASS.
