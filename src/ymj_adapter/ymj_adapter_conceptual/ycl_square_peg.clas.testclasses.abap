CLASS ltcl_square_peg DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS should_create_instance FOR TESTING.
ENDCLASS.

CLASS ltcl_square_peg IMPLEMENTATION.

  METHOD should_create_instance.
    DATA(cut) = NEW ycl_square_peg( 10 ).

    cl_abap_unit_assert=>assert_equals( exp = 10 act = cut->get_width( ) ).
  ENDMETHOD.

ENDCLASS.
