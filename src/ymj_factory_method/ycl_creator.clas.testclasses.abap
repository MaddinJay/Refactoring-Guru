CLASS ltcl_creator DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  " This test class helps to illustrate which product class is created by the
  " creator sub-classes
  PRIVATE SECTION.
    DATA:
        mo_cut TYPE REF TO ycl_creator.
    METHODS:
      check_creation_of_product_a FOR TESTING,
      check_creation_of_product_b FOR TESTING.
ENDCLASS.


CLASS ltcl_creator IMPLEMENTATION.

  METHOD check_creation_of_product_a.
    " The concrete Creator A ...
    mo_cut ?= NEW ycl_concrete_creator_a( ).
    DATA(lo_product) = mo_cut->create_product( ).

    " ... creates an instance of product A class
    cl_abap_unit_assert=>assert_equals( exp = '\CLASS=YCL_PRODUCT_A'
                                        act = cl_abap_classdescr=>get_class_name( lo_product ) ).
  ENDMETHOD.

  METHOD check_creation_of_product_b.
    " The concrete Creator B ...
    mo_cut ?= NEW ycl_concrete_creator_b( ).
    DATA(lo_product) = mo_cut->create_product( ).

    " ... creates an instance of product B class
    cl_abap_unit_assert=>assert_equals( exp = '\CLASS=YCL_PRODUCT_B'
                                        act = cl_abap_classdescr=>get_class_name( lo_product ) ).
  ENDMETHOD.

ENDCLASS.
