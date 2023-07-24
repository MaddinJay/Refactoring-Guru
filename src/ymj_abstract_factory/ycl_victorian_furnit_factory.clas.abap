CLASS ycl_victorian_furnit_factory DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES yif_furniture_factory.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ycl_victorian_furnit_factory IMPLEMENTATION.

  METHOD yif_furniture_factory~create_chair.
    ro_chair = NEW ycl_victorian_chair( ).
  ENDMETHOD.

ENDCLASS.
