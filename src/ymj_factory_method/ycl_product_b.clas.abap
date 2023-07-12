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
