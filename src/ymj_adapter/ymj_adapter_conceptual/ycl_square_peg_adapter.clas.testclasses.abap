CLASS ltcl_square_peg_adapter DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      " Integration testing
      test_get_radius             FOR TESTING,
      " Test comparisson of peg/peg and peg/square
      test_peg_square_comparisson FOR TESTING.
ENDCLASS.


CLASS ltcl_square_peg_adapter IMPLEMENTATION.

  METHOD test_get_radius.
    DATA(cut) = NEW ycl_square_peg_adapter( NEW ycl_square_peg( 10 ) ).

    cl_abap_unit_assert=>assert_equals( exp = 7
                                        act = cut->get_radius( ) ).
  ENDMETHOD.

  METHOD test_peg_square_comparisson.
    DATA small_sqpeg_adapter TYPE REF TO ycl_round_peg.
    DATA large_sqpeg_adapter TYPE REF TO ycl_round_peg.

    DATA(hole) = NEW ycl_round_hole( 5 ).

    small_sqpeg_adapter ?= NEW ycl_square_peg_adapter( NEW ycl_square_peg( 5 ) ).  " Cast as Peg
    large_sqpeg_adapter ?= NEW ycl_square_peg_adapter( NEW ycl_square_peg( 10 ) ). " Cast as Peg

    cl_abap_unit_assert=>assert_equals( exp = abap_true
                                        act = hole->fits( small_sqpeg_adapter ) ).

    cl_abap_unit_assert=>assert_equals( exp = abap_false
                                        act = hole->fits( large_sqpeg_adapter ) ).
  ENDMETHOD.

ENDCLASS.
