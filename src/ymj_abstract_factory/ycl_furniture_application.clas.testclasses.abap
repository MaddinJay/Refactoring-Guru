*"* use this source file for your ABAP unit test classes
CLASS ltc_application DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    DATA cut TYPE REF TO ycl_furniture_application.

    METHODS should_create_modern_chair FOR TESTING.
    METHODS should_create_victorian_chair FOR TESTING.

ENDCLASS.


CLASS ltc_application IMPLEMENTATION.

  METHOD should_create_modern_chair.

    cut = NEW #( NEW ycl_modern_furniture_factory( ) ).

    cl_abap_unit_assert=>assert_true( act = xsdbool( cut->create_a_chair( ) IS INSTANCE OF ycl_modern_chair )
                                      msg = 'False chair type.' ).

  ENDMETHOD.

  METHOD should_create_victorian_chair.


    cut = NEW #( NEW ycl_victorian_furnit_factory( ) ).

    cl_abap_unit_assert=>assert_true( act = xsdbool( cut->create_a_chair( ) IS INSTANCE OF ycl_victorian_chair )
                                      msg = 'False chair type.' ).

  ENDMETHOD.

ENDCLASS.
