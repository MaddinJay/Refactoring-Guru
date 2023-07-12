CLASS ltd_product_b DEFINITION INHERITING FROM ycl_product_b.

  PUBLIC SECTION.
    METHODS yif_product~do_stuff REDEFINITION.

    METHODS get_info RETURNING VALUE(rv_info) TYPE string.

  PRIVATE SECTION.
    DATA mv_info TYPE string.

ENDCLASS.

CLASS ltd_product_b IMPLEMENTATION.

  METHOD yif_product~do_stuff.
    mv_info = 'Product B is doing some stuff'.
  ENDMETHOD.

  METHOD get_info.
    rv_info = mv_info.
  ENDMETHOD.

ENDCLASS.
