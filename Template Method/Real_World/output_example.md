Imagine following situation.

![Template Method - Print Output](https://github.com/MaddinJay/Refactoring-Guru/blob/main/Template%20Method/Real_World/Template%20Method%20-%20Output%20example.PNG)

The standard main flow generates an output and print it in a special form. Now we have two new requirements: convert the output in a PDF format OR safe the output in the spool. For this we do not want to duplicate the whole main flow logic, that remains untouched. 
We "just" want to change the behaviour how the output is generated in the very end of the main flow (method generating_output).

We use inheritation and the template method pattern to reach our goal.

## Class Standard Output 

```
CLASS ycl_standard_output DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Generates the Output
    METHODS generating_output.

    "! Some helper function to read the Print Output
    "! @parameter rv_output |
    METHODS get_output RETURNING VALUE(rv_output) TYPE string.

  PROTECTED SECTION.
    DATA mv_output TYPE string.

    "! Print Output: Is redefined by Template Method in Sub Classes
    METHODS print_output.

ENDCLASS.

CLASS ycl_standard_output IMPLEMENTATION.

  METHOD print_output.
    mv_output = 'This is standard output'.
  ENDMETHOD.

  METHOD generating_output.
    " doing some stuff
    " ...
    print_output( ).
  ENDMETHOD.

  METHOD get_output.
    rv_output = mv_output.
  ENDMETHOD.

ENDCLASS.
```

### Sub-Class PDF Output

```
CLASS ycl_pdf_output DEFINITION
  PUBLIC
  CREATE PUBLIC INHERITING FROM ycl_standard_output.

  PROTECTED SECTION.
    METHODS print_output REDEFINITION.

ENDCLASS.

CLASS ycl_pdf_output IMPLEMENTATION.

  METHOD print_output.
    mv_output = 'This is PDF output'.
  ENDMETHOD.

ENDCLASS.
```

### Sub-Class Spool Output

```
CLASS ycl_spool_output DEFINITION
  PUBLIC
  CREATE PUBLIC INHERITING FROM ycl_standard_output.

  PROTECTED SECTION.
    METHODS print_output REDEFINITION.

ENDCLASS.

CLASS ycl_spool_output IMPLEMENTATION.

  METHOD print_output.
    mv_output = 'This is Spool output'.
  ENDMETHOD.

ENDCLASS.
```

## Test class to verify different behaviour

```
CLASS ltcl_output DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      " Test behaviour of Standard Output Class
      standard_output_test  FOR TESTING,
      " Test behaviour of PDF Output Class
      pdf_output_test       FOR TESTING,
      " Test behaviour of Spool Output Class
      spool_output_test     FOR TESTING.

ENDCLASS.


CLASS ltcl_output IMPLEMENTATION.

  METHOD standard_output_test.
    DATA(lo_output) = NEW ycl_standard_output( ).
    lo_output->generating_output( ).

    cl_abap_unit_assert=>assert_equals( exp = 'This is standard output'
                                        act = lo_output->get_output( ) ).
  ENDMETHOD.

  METHOD pdf_output_test.
    DATA(lo_output) = NEW ycl_pdf_output( ).
    lo_output->generating_output( ).

    cl_abap_unit_assert=>assert_equals( exp = 'This is PDF output'
                                        act = lo_output->get_output( ) ).
  ENDMETHOD.

  METHOD spool_output_test.
    DATA(lo_output) = NEW ycl_spool_output( ).
    lo_output->generating_output( ).

    cl_abap_unit_assert=>assert_equals( exp = 'This is Spool output'
                                        act = lo_output->get_output( ) ).
  ENDMETHOD.

ENDCLASS.
```
