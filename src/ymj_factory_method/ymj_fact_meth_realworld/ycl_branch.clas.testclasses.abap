CLASS ltcl_branch DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    "! Test creation of Personal Bank Account
    METHODS creates_personal_acccount FOR TESTING.

    "! Test creation of Business Bank Account
    METHODS creates_business_account  FOR TESTING.
ENDCLASS.

CLASS ltcl_branch IMPLEMENTATION.

  METHOD creates_personal_acccount.
    " Create branch class by passing personal account factory
    DATA(cut) = NEW ycl_branch( NEW ycl_personal_account_factory( ) ).
    cut->open_account( ).

    " Get the created account
    DATA(account) = cut->get_account( ).

    " Determine class of created account. Here: Personal Account
    cl_abap_unit_assert=>assert_equals( exp = '\CLASS=YCL_PERSONAL_ACCOUNT'
                                        act = cl_abap_classdescr=>get_class_name( account ) ).
  ENDMETHOD.

  METHOD creates_business_account.
    " Create branch class by passing business account factory
    DATA(cut) = NEW ycl_branch( NEW ycl_business_account_factory( ) ).
    cut->open_account( ).

    " Get the created account
    DATA(account) = cut->get_account( ).

    " Determine class of created account. Here: Personal Account
    cl_abap_unit_assert=>assert_equals( exp = '\CLASS=YCL_BUSINESS_ACCOUNT'
                                        act = cl_abap_classdescr=>get_class_name( account ) ).
  ENDMETHOD.

ENDCLASS.
