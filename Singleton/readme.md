# Singleton

Example illustrated in https://refactoring.guru/design-patterns/singleton.

[Singleton](https://github.com/MaddinJay/Refactoring-Guru/blob/main/Singleton/Design%20Pattern%20Singleton.PNG)

## Class ycl_singleton

```
CLASS ycl_singleton DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    " Creates Instance of class and always returns the same instance of its own
    " class
    " No constructor, single point of entry/class instance creation
    CLASS-METHODS create_instance RETURNING VALUE(ro_instance) TYPE REF TO ycl_singleton.

  PRIVATE SECTION.
    CLASS-DATA:
      mo_instance TYPE REF TO ycl_singleton.
ENDCLASS.

CLASS ycl_singleton IMPLEMENTATION.

  METHOD create_instance.
    ro_instance = mo_instance = COND #( WHEN mo_instance IS BOUND THEN mo_instance
                                        ELSE NEW ycl_singleton( ) ).
  ENDMETHOD.

ENDCLASS.
```

## Class ltcl_singleton - Simulates client call

```
CLASS ltcl_singleton DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      " Test if singleton is working correctly
      test_create_instance FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_singleton IMPLEMENTATION.

  METHOD test_create_instance.
    " Create new instance of class Singleton
    DATA(lo_instance) = ycl_singleton=>create_instance( ).
    " Check if instance was bound
    cl_abap_unit_assert=>assert_bound( lo_instance ).

    " Second call of Create Instance ...
    DATA(lo_instance_two) = ycl_singleton=>create_instance( ).
    " ... should return same instance like in the first call
    cl_abap_unit_assert=>assert_equals( exp = lo_instance
                                        act = lo_instance_two ).
  ENDMETHOD.

ENDCLASS.
```


