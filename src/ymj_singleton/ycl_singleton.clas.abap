CLASS ycl_singleton DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    " Creates Instance of class and always returns the same instance of its own
    " class
    " No constructor, single point of entry/class instance creation
    CLASS-METHODS create_instance RETURNING VALUE(ro_instance) TYPE REF TO ycl_singleton.

  PRIVATE SECTION.
    CLASS-DATA:
      mo_instance TYPE REF TO ycl_singleton.
ENDCLASS.

CLASS ycl_singleton IMPLEMENTATION.

  METHOD create_instance.
    ro_instance = mo_instance = COND #( WHEN mo_instance IS BOUND THEN mo_instance
                                        ELSE NEW ycl_singleton( ) ).
  ENDMETHOD.

ENDCLASS.
