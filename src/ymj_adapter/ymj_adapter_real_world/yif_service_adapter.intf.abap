INTERFACE yif_service_adapter
  PUBLIC .
  TYPES documents_list TYPE STANDARD TABLE OF string WITH EMPTY KEY.

  METHODS call_service IMPORTING documents TYPE documents_list.

ENDINTERFACE.
