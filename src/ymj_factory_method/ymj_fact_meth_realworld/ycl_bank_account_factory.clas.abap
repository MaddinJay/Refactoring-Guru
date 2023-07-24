CLASS ycl_bank_account_factory DEFINITION
  PUBLIC
  CREATE PUBLIC ABSTRACT.

  PUBLIC SECTION.
    METHODS create_account ABSTRACT
      RETURNING VALUE(ro_bank_account) TYPE REF TO yif_bank_account.

ENDCLASS.

CLASS ycl_bank_account_factory IMPLEMENTATION.
ENDCLASS.
