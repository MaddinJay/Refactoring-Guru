Example illustrated in [https://refactoring.guru/design-patterns/factory-method](https://refactoring.guru/design-patterns/adapter)

![Adapter - Round Peg Example](https://github.com/MaddinJay/Refactoring-Guru/blob/main/Adapter/Conceptual/Adapter_Conceptual_Example.PNG)

## Class ycl_round_hole

```ABAP
CLASS ycl_round_hole DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING radius TYPE int1.
    METHODS get_radius RETURNING VALUE(result) TYPE int1.
    METHODS fits IMPORTING peg           TYPE REF TO ycl_round_peg
                 RETURNING VALUE(result) TYPE abap_boolean.

  PRIVATE SECTION.
    DATA radius TYPE int1.

ENDCLASS.

CLASS ycl_round_hole IMPLEMENTATION.

  METHOD constructor.
    me->radius = radius.
  ENDMETHOD.

  METHOD get_radius.
    result = me->radius.
  ENDMETHOD.

  METHOD fits.
    result = xsdbool( me->get_radius( ) >= peg->get_radius( ) ).
  ENDMETHOD.

ENDCLASS.
```

### Test-Class ltcl_round_hole

Comparison of peg and hole is no problem.

```ABAP
CLASS ltcl_round_hole DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS peg_fits_round_hole FOR TESTING.
    METHODS test_hole_peg_comparisson FOR TESTING.

ENDCLASS.

CLASS ltcl_round_hole IMPLEMENTATION.

  METHOD peg_fits_round_hole.
    DATA(cut) = NEW ycl_round_hole( 5 ).
    DATA(peg) = NEW ycl_round_peg( 5 ).

    cl_abap_unit_assert=>assert_equals( exp = abap_true act = cut->fits( peg ) ).
  ENDMETHOD.

  METHOD test_hole_peg_comparisson.
    DATA(hole) = NEW ycl_round_hole( 5 ).
    DATA(rpeg) = NEW ycl_round_peg( 5 ).

    cl_abap_unit_assert=>assert_equals( exp = abap_true
                                        act = hole->fits( rpeg ) ).
  ENDMETHOD.

ENDCLASS.
```

## Class ycl_round_peg

```ABAP
CLASS ycl_round_peg DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING radius TYPE int1.
    METHODS get_radius  RETURNING VALUE(result) TYPE int1.

  PRIVATE SECTION.
    DATA radius TYPE int1.

ENDCLASS.

CLASS ycl_round_peg IMPLEMENTATION.

  METHOD constructor.
    me->radius = radius.
  ENDMETHOD.

  METHOD get_radius.
    result = me->radius.
  ENDMETHOD.

ENDCLASS.
```

### Test class ltcl_round_peg

```ABAP
CLASS ltcl_round_peg DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS should_create_object FOR TESTING.

ENDCLASS.

CLASS ltcl_round_peg IMPLEMENTATION.

  METHOD should_create_object.
    DATA(cut) = NEW ycl_round_peg( 5 ).
    cl_abap_unit_assert=>assert_equals( exp = 5
                                        act = cut->get_radius( ) ).
  ENDMETHOD.

ENDCLASS.
```

## Class ycl_square_peg_adapter

```ABAP
CLASS ycl_square_peg_adapter DEFINITION
  PUBLIC
  CREATE PUBLIC INHERITING FROM ycl_round_peg.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized" lang="en"></p>
    "! Contains an instance of the SquarePeg Class
    "! @parameter peg | <p class="shorttext synchronized" lang="en"></p>
    METHODS constructor IMPORTING peg TYPE REF TO ycl_square_peg.

    METHODS get_radius  REDEFINITION.

  PRIVATE SECTION.
    DATA peg TYPE REF TO ycl_square_peg.

ENDCLASS.

CLASS ycl_square_peg_adapter IMPLEMENTATION.

  METHOD constructor.
    super->constructor( get_radius( ) ).
    me->peg = peg.
  ENDMETHOD.

  METHOD get_radius.
    " The adapter pretends that it's a round peg with a
    " radius that could fit the square peg that the adapter
    " actually wraps.
    IF peg IS NOT BOUND.
      RETURN.
    ENDIF.

    result = sqrt( 2 ) * peg->get_width( ) / 2.
  ENDMETHOD.

ENDCLASS.
```

### Test class ltcl_square_peg_adapter

```ABAP
CLASS ltcl_square_peg_adapter DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      " Integration testing
      test_get_radius             FOR TESTING,
      " Test comparisson of peg/peg and peg/square
      test_peg_square_comparisson FOR TESTING.
ENDCLASS.


CLASS ltcl_square_peg_adapter IMPLEMENTATION.

  METHOD test_get_radius.
    DATA(cut) = NEW ycl_square_peg_adapter( NEW ycl_square_peg( 10 ) ).

    cl_abap_unit_assert=>assert_equals( exp = 7
                                        act = cut->get_radius( ) ).
  ENDMETHOD.

  METHOD test_peg_square_comparisson.
    DATA small_sqpeg_adapter TYPE REF TO ycl_round_peg.
    DATA large_sqpeg_adapter TYPE REF TO ycl_round_peg.

    DATA(hole) = NEW ycl_round_hole( 5 ).

    small_sqpeg_adapter ?= NEW ycl_square_peg_adapter( NEW ycl_square_peg( 5 ) ).  " Cast as Peg
    large_sqpeg_adapter ?= NEW ycl_square_peg_adapter( NEW ycl_square_peg( 10 ) ). " Cast as Peg

    cl_abap_unit_assert=>assert_equals( exp = abap_true
                                        act = hole->fits( small_sqpeg_adapter ) ).

    cl_abap_unit_assert=>assert_equals( exp = abap_false
                                        act = hole->fits( large_sqpeg_adapter ) ).
  ENDMETHOD.

ENDCLASS.
```

## Class ycl_square_peg

```ABAP
CLASS ycl_square_peg DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING width TYPE int1.
    METHODS get_width   RETURNING VALUE(result) TYPE int1.

  PRIVATE SECTION.
    DATA width TYPE int1.

ENDCLASS.

CLASS ycl_square_peg IMPLEMENTATION.

  METHOD constructor.
    me->width = width.
  ENDMETHOD.

  METHOD get_width.
    result = me->width.
  ENDMETHOD.

ENDCLASS.
```

### Test class ltcl_square_peg (Integration testing, client's call)

```ABAP
CLASS ltcl_square_peg DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS should_create_instance FOR TESTING.
ENDCLASS.

CLASS ltcl_square_peg IMPLEMENTATION.

  METHOD should_create_instance.
    DATA(cut) = NEW ycl_square_peg( 10 ).

    cl_abap_unit_assert=>assert_equals( exp = 10 act = cut->get_width( ) ).
  ENDMETHOD.

ENDCLASS.
```
