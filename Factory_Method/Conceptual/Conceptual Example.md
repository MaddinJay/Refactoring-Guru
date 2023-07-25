# Factory Method

Example illustrated in https://refactoring.guru/design-patterns/factory-method

![Factory Method - Product Creator](https://github.com/MaddinJay/Refactoring-Guru/blob/main/Factory_Method/Conceptual/Factory%20Method%20-%20Product%20Creator.png)

## Class ycl_creator

```
CLASS ltcl_creator DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  " This test class helps to illustrate which product class is created by the
  " creator sub-classes
  PRIVATE SECTION.
    DATA:
        mo_cut TYPE REF TO ycl_creator.
    METHODS:
      check_creation_of_product_a FOR TESTING,
      check_creation_of_product_b FOR TESTING.
ENDCLASS.


CLASS ltcl_creator IMPLEMENTATION.

  METHOD check_creation_of_product_a.
    " The concrete Creator A ...
    mo_cut ?= NEW ycl_concrete_creator_a( ).
    DATA(lo_product) = mo_cut->create_product( ).

    " ... creates an instance of product A class
    cl_abap_unit_assert=>assert_equals( exp = '\CLASS=YCL_PRODUCT_A'
                                        act = cl_abap_classdescr=>get_class_name( lo_product ) ).
  ENDMETHOD.

  METHOD check_creation_of_product_b.
    " The concrete Creator B ...
    mo_cut ?= NEW ycl_concrete_creator_b( ).
    DATA(lo_product) = mo_cut->create_product( ).

    " ... creates an instance of product B class
    cl_abap_unit_assert=>assert_equals( exp = '\CLASS=YCL_PRODUCT_B'
                                        act = cl_abap_classdescr=>get_class_name( lo_product ) ).
  ENDMETHOD.

ENDCLASS.
```

## Sub-Class ycl_concrete_creator_a

```
CLASS ycl_concrete_creator_a DEFINITION
  PUBLIC
  CREATE PUBLIC INHERITING FROM ycl_creator.
  " Creates instance of product A class and return it to the caller
  PUBLIC SECTION.
    METHODS create_product REDEFINITION.

ENDCLASS.

CLASS ycl_concrete_creator_a IMPLEMENTATION.

  METHOD create_product.
    ro_product = NEW ycl_product_a( ).
  ENDMETHOD.

ENDCLASS.

```

## Sub-Class ycl_concrete_creator_b

```
CLASS ycl_concrete_creator_b DEFINITION
  PUBLIC
  CREATE PUBLIC INHERITING FROM ycl_creator.
  " Creates instance of product B class and returns it to the caller
  PUBLIC SECTION.
    METHODS create_product REDEFINITION.

ENDCLASS.

CLASS ycl_concrete_creator_b IMPLEMENTATION.

  METHOD create_product.
    ro_product = NEW ycl_product_b( ).
  ENDMETHOD.

ENDCLASS.
```

## Class ycl_product_a

```
CLASS ycl_product_a DEFINITION
  PUBLIC
  CREATE PUBLIC .
  " Product A class implements the logic regarding product A
  PUBLIC SECTION.
    INTERFACES: yif_product.

ENDCLASS.

CLASS ycl_product_a IMPLEMENTATION.

  METHOD yif_product~do_stuff.
    " Product A is doing some stuff here
  ENDMETHOD.

ENDCLASS.
```

## Class ycl_product_b
```
CLASS ycl_product_b DEFINITION
  PUBLIC
  CREATE PUBLIC .
  " Product B is implementing the logic regarding product B
  PUBLIC SECTION.
    INTERFACES: yif_product.

ENDCLASS.

CLASS ycl_product_b IMPLEMENTATION.

  METHOD yif_product~do_stuff.
    " Product is doing some stuff
  ENDMETHOD.

ENDCLASS.
```

