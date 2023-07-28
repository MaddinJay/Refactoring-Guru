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
