CLASS ltcl_singleton DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      " Test if singleton is working correctly
      test_create_instance FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_singleton IMPLEMENTATION.

  METHOD test_create_instance.
    " Create new instance of class Singleton
    DATA(lo_instance) = ycl_singleton=>create_instance( ).
    " Check if instance was bound
    cl_abap_unit_assert=>assert_bound( lo_instance ).

    " Second call of Create Instance ...
    DATA(lo_instance_two) = ycl_singleton=>create_instance( ).
    " ... should return same instance like in the first call
    cl_abap_unit_assert=>assert_equals( exp = lo_instance
                                        act = lo_instance_two ).
  ENDMETHOD.

ENDCLASS.
