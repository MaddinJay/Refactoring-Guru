Assuming that we have following situtation:

![Accounting - Example](https://github.com/MaddinJay/Refactoring-Guru/blob/main/Factory_Method/Real_World/Factory_Method%20-%20Real_World_Example.PNG)

An accountant wants to create two types of bank accounts:

- Personal bank account
- Business bank account

For the creation of each bank account three steps have to be executed:

- Validation of user identity
- Calculation of the interest rate
- Registration of the account

These steps are handled differently regarding the type of the bank account. The accountant wants to avoid duplication in her or his workflow and does not want to care about which type is processed in the moment.

To avoid code duplication and make the accountant workflow not dependent on the type of the bank account type, we introduce the Factory Method Pattern. 

## Class Accountant (user of the bank account classes)

```
CLASS ycl_accountant DEFINITION
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

CLASS ycl_accountant IMPLEMENTATION.

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
```

### Test class for calling/consuming class Accountant

```
CLASS ltcl_accountant DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      "! Test creation of Personal Bank Account
      create_personal_acccount FOR TESTING,

      "! Test creation of Business Bank Account
      create_business_account  FOR TESTING.
ENDCLASS.

CLASS ltcl_accountant IMPLEMENTATION.

  METHOD create_personal_acccount.
    " Create branch class by passing personal account factory
    DATA(lo_cut) = NEW ycl_accountant( NEW ycl_personal_account_factory( ) ).
    lo_cut->open_account( ).

    " Get the created account
    DATA(lo_account) = lo_cut->get_account( ).

    " Determine class of created account. Here: Personal Account
    cl_abap_unit_assert=>assert_equals( exp = '\CLASS=YCL_PERSONAL_ACCOUNT'
                                        act = cl_abap_classdescr=>get_class_name( lo_account ) ).
  ENDMETHOD.

  METHOD create_business_account.
    " Create branch class by passing business account factory
    DATA(lo_cut) = NEW ycl_accountant( NEW ycl_business_account_factory( ) ).
    lo_cut->open_account( ).

    " Get the created account
    DATA(lo_account) = lo_cut->get_account( ).

    " Determine class of created account. Here: Personal Account
    cl_abap_unit_assert=>assert_equals( exp = '\CLASS=YCL_BUSINESS_ACCOUNT'
                                        act = cl_abap_classdescr=>get_class_name( lo_account ) ).
  ENDMETHOD.

ENDCLASS.
```

## Abstract class Bank Account Factory

```
CLASS ycl_bank_account_factory DEFINITION
  PUBLIC
  CREATE PUBLIC ABSTRACT.

  PUBLIC SECTION.
    METHODS create_account ABSTRACT
      RETURNING VALUE(ro_bank_account) TYPE REF TO yif_bank_account.

ENDCLASS.

CLASS ycl_bank_account_factory IMPLEMENTATION.
ENDCLASS.
```

### Class Personal Bank Account Factory

```
CLASS ycl_personal_account_factory DEFINITION
  PUBLIC
  CREATE PUBLIC INHERITING FROM ycl_bank_account_factory.

  PUBLIC SECTION.
    METHODS create_account REDEFINITION.

ENDCLASS.

CLASS ycl_personal_account_factory IMPLEMENTATION.

  METHOD create_account.
    ro_bank_account = NEW ycl_personal_account( ).
  ENDMETHOD.

ENDCLASS.
```

### Class Business Bank Account Factory

```
CLASS ycl_business_account_factory DEFINITION
  PUBLIC
  CREATE PUBLIC INHERITING FROM ycl_bank_account_factory.

  PUBLIC SECTION.
    METHODS create_account REDEFINITION.

ENDCLASS.

CLASS ycl_business_account_factory IMPLEMENTATION.

  METHOD create_account.
    ro_bank_account = NEW ycl_business_account( ).
  ENDMETHOD.

ENDCLASS.
```

## Interface Bank Account

```
INTERFACE yif_bank_account
  PUBLIC .
  METHODS validate_user_identiy.
  METHODS calculate_interest_rate.
  METHODS register_account.
ENDINTERFACE.
```

### Class Personal Bank Account

```
CLASS ycl_personal_account DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES yif_bank_account.
  PRIVATE SECTION.
    DATA mv_text TYPE string.
ENDCLASS.

CLASS ycl_personal_account IMPLEMENTATION.

  METHOD yif_bank_account~calculate_interest_rate.
    " do something
  ENDMETHOD.

  METHOD yif_bank_account~register_account.
    mv_text = 'Personal Account registered'.
  ENDMETHOD.

  METHOD yif_bank_account~validate_user_identiy.
    " do something
  ENDMETHOD.

ENDCLASS.
```

### Class Business Bank Account

```
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
```
