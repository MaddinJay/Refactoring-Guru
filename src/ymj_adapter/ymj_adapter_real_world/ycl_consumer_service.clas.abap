CLASS ycl_consumer_service DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES tt_documents_xml TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Calls the webservice to transfer data in XML format to receiver system
    "! @parameter documents | <p class="shorttext synchronized" lang="en"></p>
    METHODS send_data IMPORTING documents TYPE tt_documents_xml.

ENDCLASS.

CLASS ycl_consumer_service IMPLEMENTATION.

  METHOD send_data.
    " Send Data in XML format to other system
  ENDMETHOD.

ENDCLASS.
