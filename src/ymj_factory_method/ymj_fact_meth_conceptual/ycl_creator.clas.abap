CLASS ycl_creator DEFINITION
  PUBLIC
  CREATE PUBLIC ABSTRACT.
    " The creator class declares the factory method (abstract) which is supposed to
    " return an of object of one of the product classes.
    " The creator sub-classes provide the implementation of this factory method

  PUBLIC SECTION.
    "! <p class="shorttext synchronized" lang="en"></p>
    "! Do some operation with created product instance
    METHODS some_operation.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Factory method which is implemented in each sub-product-class (here A and B)
    "! @parameter result | Instance of the product <p class="shorttext synchronized" lang="en"></p>
    METHODS create_product ABSTRACT
      RETURNING VALUE(result) TYPE REF TO yif_product.

  PROTECTED SECTION.
    DATA mo_product TYPE REF TO yif_product.

ENDCLASS.

CLASS ycl_creator IMPLEMENTATION.

  METHOD some_operation.
    mo_product = me->create_product( ).
    mo_product->do_stuff( ).
  ENDMETHOD.

ENDCLASS.
