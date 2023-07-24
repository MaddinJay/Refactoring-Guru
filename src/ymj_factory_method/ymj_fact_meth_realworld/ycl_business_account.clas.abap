CLASS ycl_business_account DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES yif_bank_account.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mv_text TYPE string.

ENDCLASS.

CLASS ycl_business_account IMPLEMENTATION.
  METHOD yif_bank_account~calculate_interest_rate.
    " Do something
  ENDMETHOD.

  METHOD yif_bank_account~register_account.
    mv_text = 'Business Account registered'.
  ENDMETHOD.

  METHOD yif_bank_account~validate_user_identiy.
    " Do something
  ENDMETHOD.

ENDCLASS.
