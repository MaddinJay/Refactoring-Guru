INTERFACE yif_service_adapter
  PUBLIC .
  TYPES: tt_documents TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

  METHODS call_service IMPORTING documents TYPE tt_documents.
ENDINTERFACE.
