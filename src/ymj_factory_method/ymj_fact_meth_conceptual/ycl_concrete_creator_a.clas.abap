CLASS ycl_concrete_creator_a DEFINITION
  PUBLIC
  CREATE PUBLIC INHERITING FROM ycl_creator.
  " Creates instance of product A class and return it to the caller
  PUBLIC SECTION.
    METHODS create_product REDEFINITION.

ENDCLASS.

CLASS ycl_concrete_creator_a IMPLEMENTATION.

  METHOD create_product.
    result ?= NEW ycl_product_a( ).
  ENDMETHOD.

ENDCLASS.
