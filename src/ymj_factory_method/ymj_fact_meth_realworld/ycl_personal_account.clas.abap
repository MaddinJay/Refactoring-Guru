CLASS ycl_personal_account DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES yif_bank_account.

  PRIVATE SECTION.
    DATA text TYPE string.

ENDCLASS.

CLASS YCL_PERSONAL_ACCOUNT IMPLEMENTATION.

  METHOD yif_bank_account~calculate_interest_rate.
    " do something
  ENDMETHOD.


  METHOD yif_bank_account~register_account.
    text = 'Personal Account registered'.
  ENDMETHOD.


  METHOD yif_bank_account~validate_user_identiy.
    " do something
  ENDMETHOD.

ENDCLASS.
