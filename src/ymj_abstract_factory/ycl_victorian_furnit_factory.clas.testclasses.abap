CLASS ltcl_vict_furniture_fact DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      create_vict_chair FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_vict_furniture_fact IMPLEMENTATION.

  METHOD create_vict_chair.
    DATA(mo_chair) = NEW ycl_victorian_furnit_factory( )->yif_furniture_factory~create_chair( ).
    cl_abap_unit_assert=>assert_equals( exp = '\CLASS=YCL_VICTORIAN_CHAIR'
                                        act = cl_abap_classdescr=>get_class_name( mo_chair ) ).
  ENDMETHOD.

ENDCLASS.
