CLASS ycl_furniture_application DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING factory TYPE REF TO yif_furniture_factory.

    METHODS create_a_chair
      RETURNING VALUE(result) TYPE REF TO yif_chair.

  PRIVATE SECTION.
    DATA factory TYPE REF TO yif_furniture_factory.

ENDCLASS.

CLASS ycl_furniture_application IMPLEMENTATION.

  METHOD create_a_chair.
    result = factory->create_chair( ).
  ENDMETHOD.

  METHOD constructor.
    me->factory = factory.
  ENDMETHOD.

ENDCLASS.
