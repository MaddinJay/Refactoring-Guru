CLASS ltcl_modern_furniture_fact DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      create_modern_chair FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_modern_furniture_fact IMPLEMENTATION.

  METHOD create_modern_chair.
    DATA(mo_chair) = NEW ycl_modern_furniture_factory( )->yif_furniture_factory~create_chair( ).
    cl_abap_unit_assert=>assert_equals( exp = '\CLASS=YCL_MODERN_CHAIR'
                                        act = cl_abap_classdescr=>get_class_name( mo_chair ) ).
  ENDMETHOD.

ENDCLASS.
