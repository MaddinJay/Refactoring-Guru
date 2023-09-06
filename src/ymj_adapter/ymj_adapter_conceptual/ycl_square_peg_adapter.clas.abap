CLASS ycl_square_peg_adapter DEFINITION
  PUBLIC
  CREATE PUBLIC INHERITING FROM ycl_round_peg.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized" lang="en"></p>
    "! Contains an instance of the SquarePeg Class
    "! @parameter peg | <p class="shorttext synchronized" lang="en"></p>
    METHODS constructor IMPORTING peg TYPE REF TO ycl_square_peg.

    METHODS get_radius  REDEFINITION.

  PRIVATE SECTION.
    DATA peg TYPE REF TO ycl_square_peg.

ENDCLASS.

CLASS ycl_square_peg_adapter IMPLEMENTATION.

  METHOD constructor.
    super->constructor( get_radius( ) ).
    me->peg = peg.
  ENDMETHOD.

  METHOD get_radius.
    " The adapter pretends that it's a round peg with a
    " radius that could fit the square peg that the adapter
    " actually wraps.
    IF peg IS NOT BOUND.
      RETURN.
    ENDIF.

    result = sqrt( 2 ) * peg->get_width( ) / 2.
  ENDMETHOD.

ENDCLASS.
