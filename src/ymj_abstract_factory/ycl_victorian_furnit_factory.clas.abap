CLASS ycl_victorian_furnit_factory DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES yif_furniture_factory.

ENDCLASS.

CLASS ycl_victorian_furnit_factory IMPLEMENTATION.

  METHOD yif_furniture_factory~create_chair.
    result = NEW ycl_victorian_chair( ).
  ENDMETHOD.

ENDCLASS.
