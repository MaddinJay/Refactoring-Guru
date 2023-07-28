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
