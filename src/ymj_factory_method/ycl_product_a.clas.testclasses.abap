CLASS ltcl_product_a DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  " This test class illustrates, that the specific behaviour of product A is
  " executed.

  " We use a Test-Double class ltd_product_a to make the logic accessible without
  " changing the productive class
  PRIVATE SECTION.
    DATA:
      mo_cut TYPE REF TO ltd_product_a.

    METHODS:
      check_do_stuff_of_product_a FOR TESTING.

ENDCLASS.

CLASS ltcl_product_a IMPLEMENTATION.

  METHOD check_do_stuff_of_product_a.
    mo_cut = NEW ltd_product_a( ).
    mo_cut->yif_product~do_stuff( ).

    cl_abap_unit_assert=>assert_equals( exp = 'Product A is doing some stuff'
                                        act = mo_cut->get_info( ) ).
  ENDMETHOD.

ENDCLASS.
