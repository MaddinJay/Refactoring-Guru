CLASS ltd_product_a DEFINITION INHERITING FROM ycl_product_a.

  PUBLIC SECTION.
    METHODS yif_product~do_stuff REDEFINITION.

    METHODS get_info RETURNING VALUE(rv_info) TYPE string.

  PRIVATE SECTION.
    DATA mv_info TYPE string.

ENDCLASS.

CLASS ltd_product_a IMPLEMENTATION.

  METHOD yif_product~do_stuff.
    mv_info = 'Product A is doing some stuff'.
  ENDMETHOD.

  METHOD get_info.
    rv_info = mv_info.
  ENDMETHOD.

ENDCLASS.
