CLASS ycl_standard_output DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Generates the Output
    METHODS generating_output.

    "! Some helper function to read the Print Output
    "! @parameter rv_output |
    METHODS get_output RETURNING VALUE(rv_output) TYPE string.

  PROTECTED SECTION.
    DATA mv_output TYPE string.

    "! Print Output: Is redefined by Template Method in Sub Classes
    METHODS print_output.

ENDCLASS.

CLASS ycl_standard_output IMPLEMENTATION.

  METHOD print_output.
    mv_output = 'This is standard output'.
  ENDMETHOD.

  METHOD generating_output.
    " doing some stuff
    " ...
    print_output( ).
  ENDMETHOD.

  METHOD get_output.
    rv_output = mv_output.
  ENDMETHOD.

ENDCLASS.

