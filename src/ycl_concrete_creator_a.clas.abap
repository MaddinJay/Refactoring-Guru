CLASS ycl_concrete_creator_a DEFINITION
  PUBLIC
  CREATE PUBLIC INHERITING FROM ycl_creator.

  PUBLIC SECTION.
    METHODS create_product REDEFINITION.

ENDCLASS.

CLASS ycl_concrete_creator_a IMPLEMENTATION.

  METHOD create_product.
    ro_product = NEW ycl_product_a( ).
  ENDMETHOD.

ENDCLASS.
