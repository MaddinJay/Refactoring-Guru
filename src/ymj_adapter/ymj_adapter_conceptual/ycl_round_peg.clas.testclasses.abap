CLASS ltcl_round_peg DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS should_create_object FOR TESTING.

ENDCLASS.

CLASS ltcl_round_peg IMPLEMENTATION.

  METHOD should_create_object.
    DATA(cut) = NEW ycl_round_peg( 5 ).
    cl_abap_unit_assert=>assert_equals( exp = 5
                                        act = cut->get_radius( ) ).
  ENDMETHOD.

ENDCLASS.
