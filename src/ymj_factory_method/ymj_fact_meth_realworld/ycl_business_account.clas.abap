CLASS ycl_business_account DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES yif_bank_account.

  PRIVATE SECTION.
    DATA text TYPE string.

ENDCLASS.

CLASS ycl_business_account IMPLEMENTATION.
  METHOD yif_bank_account~calculate_interest_rate.
    " Do something
  ENDMETHOD.

  METHOD yif_bank_account~register_account.
    text = 'Business Account registered'.
  ENDMETHOD.

  METHOD yif_bank_account~validate_user_identiy.
    " Do something
  ENDMETHOD.

ENDCLASS.
