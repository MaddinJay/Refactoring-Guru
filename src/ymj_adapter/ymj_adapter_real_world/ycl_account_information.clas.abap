CLASS ycl_account_information DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    "! <p class="shorttext synchronized" lang="en"></p>
    "! Executing Business logic to create and send document informations
    METHODS process.

  PRIVATE SECTION.
    DATA service_adapter TYPE REF TO yif_service_adapter.
ENDCLASS.

CLASS ycl_account_information IMPLEMENTATION.

  METHOD process.

    DATA documents TYPE yif_service_adapter=>documents_list.
    " Create document informations in client format

    " Call serive via adapter to convert documents from client format to XML format
    service_adapter->call_service( documents ).
  ENDMETHOD.

ENDCLASS.
