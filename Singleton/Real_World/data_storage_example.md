Imagine we want to create some data and store it e.g. in the data base. During the workflow we do not want to create several instances of the domain class "Data Storage", nor we want to pass the instance of the class through all the mainflow.
To avoid the creation of several instances we use the singleton pattern.

![Data Storage](https://github.com/MaddinJay/Refactoring-Guru/blob/main/Singleton/Real_World/Singleton%20-%20Data%20Storage.PNG)

## Class Data Storage

```
CLASS ycl_data_storage DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    "! Instance creator for singleton
    "! @parameter ro_object | Instance of class
    CLASS-METHODS create_object RETURNING VALUE(ro_object) TYPE REF TO ycl_data_storage.

    METHODS:
      get_likp RETURNING VALUE(r_result) TYPE likp,
      set_likp IMPORTING i_ms_likp TYPE likp.

  PRIVATE SECTION.
    CLASS-DATA: mo_data_storage TYPE REF TO ycl_data_storage.
    DATA ms_likp TYPE likp.

ENDCLASS.

CLASS ycl_data_storage IMPLEMENTATION.

  METHOD create_object.
    " If instance already created, return it
    ro_object = mo_data_storage = COND #( WHEN mo_data_storage IS BOUND THEN mo_data_storage
                                         ELSE NEW ycl_data_storage( ) ).
  ENDMETHOD.

  METHOD get_likp.
    r_result = me->ms_likp.
  ENDMETHOD.

  METHOD set_likp.
    me->ms_likp = i_ms_likp.
  ENDMETHOD.

ENDCLASS.
```

### Test class Data Storage

```
CLASS ltcl_data_storage DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      " Test singleton by passing value and create "new" instance and check, if imported
      " value is the same
      test_singleton FOR TESTING.
ENDCLASS.

CLASS ltcl_data_storage IMPLEMENTATION.

  METHOD test_singleton.
    " Create Data Storage instance
    DATA(lo_data_storage) = ycl_data_storage=>create_object( ).
    " Pass some value
    lo_data_storage->set_likp( VALUE #( vbeln = '1234' ) ).

    " Create "another" Data Storage instance
    DATA(lo_data_storage_other) = ycl_data_storage=>create_object( ).
    " Read value from actual instance
    DATA(ls_likp) = lo_data_storage_other->get_likp( ).

    " Check if value is the passed one -> Object instance is the same
    cl_abap_unit_assert=>assert_equals( exp = '1234'
                                        act = ls_likp-vbeln ).
    " Alternative check: Instances are the same
    cl_abap_unit_assert=>assert_equals( exp = lo_data_storage
                                        act = lo_data_storage_other ).
  ENDMETHOD.

ENDCLASS.
```
