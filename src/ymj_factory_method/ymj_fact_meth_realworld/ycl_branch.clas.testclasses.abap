CLASS ltcl_branch DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      "! Test creation of Personal Bank Account
      create_personal_acccount FOR TESTING,

      "! Test creation of Business Bank Account
      create_business_account  FOR TESTING.
ENDCLASS.

CLASS ltcl_branch IMPLEMENTATION.

  METHOD create_personal_acccount.
    " Create branch class by passing personal account factory
    DATA(lo_cut) = NEW ycl_branch( NEW ycl_personal_account_factory( ) ).
    lo_cut->open_account( ).

    " Get the created account
    DATA(lo_account) = lo_cut->get_account( ).

    " Determine class of created account. Here: Personal Account
    cl_abap_unit_assert=>assert_equals( exp = '\CLASS=YCL_PERSONAL_ACCOUNT'
                                        act = cl_abap_classdescr=>get_class_name( lo_account ) ).
  ENDMETHOD.

  METHOD create_business_account.
    " Create branch class by passing business account factory
    DATA(lo_cut) = NEW ycl_branch( NEW ycl_business_account_factory( ) ).
    lo_cut->open_account( ).

    " Get the created account
    DATA(lo_account) = lo_cut->get_account( ).

    " Determine class of created account. Here: Personal Account
    cl_abap_unit_assert=>assert_equals( exp = '\CLASS=YCL_BUSINESS_ACCOUNT'
                                        act = cl_abap_classdescr=>get_class_name( lo_account ) ).
  ENDMETHOD.

ENDCLASS.
