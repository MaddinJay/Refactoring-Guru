CLASS ltcl_round_hole DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      peg_fits_round_hole FOR TESTING,
      test_hole_peg_comparisson FOR TESTING.

ENDCLASS.

CLASS ltcl_round_hole IMPLEMENTATION.

  METHOD peg_fits_round_hole.
    DATA(cut) = NEW ycl_round_hole( 5 ).
    DATA(peg) = NEW ycl_round_peg( 5 ).

    cl_abap_unit_assert=>assert_equals( exp = abap_true act = cut->fits( peg ) ).
  ENDMETHOD.

  METHOD test_hole_peg_comparisson.
    DATA(hole) = NEW ycl_round_hole( 5 ).
    DATA(rpeg) = NEW ycl_round_peg( 5 ).

    cl_abap_unit_assert=>assert_equals( exp = abap_true
                                        act = hole->fits( rpeg ) ).
  ENDMETHOD.

ENDCLASS.
