CLASS ycl_branch DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    "! <p class="shorttext synchronized" lang="en"></p>
    "! Constructor: Importing specific Bank Account Factory Class for process
    "! @parameter io_bank_account_factory | <p class="shorttext synchronized" lang="en"></p>
    METHODS constructor IMPORTING io_bank_account_factory TYPE REF TO ycl_bank_account_factory.


    "! <p class="shorttext synchronized" lang="en"></p>
    "! Create a bank account, according the imported Factory class (Personal or Business)
    METHODS open_account.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Just some helper method for testing the class work flow
    "! @parameter ro_bank_account | <p class="shorttext synchronized" lang="en"></p>
    METHODS get_account RETURNING VALUE(ro_bank_account) TYPE REF TO yif_bank_account.

  PRIVATE SECTION.
    DATA mo_bank_account_factory TYPE REF TO ycl_bank_account_factory.
    DATA mo_bank_account         TYPE REF TO yif_bank_account.

ENDCLASS.

CLASS ycl_branch IMPLEMENTATION.

  METHOD constructor.
    mo_bank_account_factory = io_bank_account_factory.
  ENDMETHOD.

  METHOD open_account.
    " Create Bank account by factory method
    mo_bank_account = mo_bank_account_factory->create_account( ).

    " Open bank account
    mo_bank_account->validate_user_identiy( ).
    mo_bank_account->calculate_interest_rate( ).
    mo_bank_account->register_account( ).
  ENDMETHOD.

  METHOD get_account.
    ro_bank_account = mo_bank_account.
  ENDMETHOD.

ENDCLASS.
