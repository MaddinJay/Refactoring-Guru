CLASS ltcl_data_storage DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      " Test singleton by passing value and create "new" instance and check, if imported
      " value is the same
      test_singleton FOR TESTING.
ENDCLASS.

CLASS ltcl_data_storage IMPLEMENTATION.

  METHOD test_singleton.
    " Create Data Storage instance
    DATA(lo_data_storage) = ycl_data_storage=>create_object( ).
    " Pass some value
    lo_data_storage->set_likp( VALUE #( vbeln = '1234' ) ).

    " Create "another" Data Storage instance
    DATA(lo_data_storage_other) = ycl_data_storage=>create_object( ).
    " Read value from actual instance
    DATA(ls_likp) = lo_data_storage_other->get_likp( ).

    " Check if value is the passed one -> Object instance is the same
    cl_abap_unit_assert=>assert_equals( exp = '1234'
                                        act = ls_likp-vbeln ).
    " Alternative check: Instances are the same
    cl_abap_unit_assert=>assert_equals( exp = lo_data_storage
                                        act = lo_data_storage_other ).
  ENDMETHOD.

ENDCLASS.
