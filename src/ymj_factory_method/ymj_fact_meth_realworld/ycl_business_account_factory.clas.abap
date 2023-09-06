CLASS ycl_business_account_factory DEFINITION
  PUBLIC
  CREATE PUBLIC INHERITING FROM ycl_bank_account_factory.

  PUBLIC SECTION.
    METHODS create_account REDEFINITION.

ENDCLASS.

CLASS ycl_business_account_factory IMPLEMENTATION.

  METHOD create_account.
    result ?= NEW ycl_business_account( ).
  ENDMETHOD.

ENDCLASS.
