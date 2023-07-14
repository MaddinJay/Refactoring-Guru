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
