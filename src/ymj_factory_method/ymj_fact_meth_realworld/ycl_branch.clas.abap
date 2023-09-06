CLASS ycl_branch DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    "! <p class="shorttext synchronized" lang="en"></p>
    "! Constructor: Importing specific Bank Account Factory Class for process
    "! @parameter bank_account_factory | <p class="shorttext synchronized" lang="en"></p>
    METHODS constructor IMPORTING bank_account_factory TYPE REF TO ycl_bank_account_factory.


    "! <p class="shorttext synchronized" lang="en"></p>
    "! Create a bank account, according the imported Factory class (Personal or Business)
    METHODS open_account.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Just some helper method for testing the class work flow
    "! @parameter result | <p class="shorttext synchronized" lang="en"></p>
    METHODS get_account RETURNING VALUE(result) TYPE REF TO yif_bank_account.

  PRIVATE SECTION.
    DATA bank_account_factory TYPE REF TO ycl_bank_account_factory.
    DATA bank_account         TYPE REF TO yif_bank_account.

ENDCLASS.

CLASS ycl_branch IMPLEMENTATION.

  METHOD constructor.
    me->bank_account_factory = bank_account_factory.
  ENDMETHOD.

  METHOD open_account.
    " Create Bank account by factory method
    bank_account = me->bank_account_factory->create_account( ).

    " Open bank account
    bank_account->validate_user_identiy( ).
    bank_account->calculate_interest_rate( ).
    bank_account->register_account( ).
  ENDMETHOD.

  METHOD get_account.
    result = bank_account.
  ENDMETHOD.

ENDCLASS.
