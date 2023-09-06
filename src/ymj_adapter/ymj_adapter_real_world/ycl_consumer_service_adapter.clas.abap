CLASS ycl_consumer_service_adapter DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES yif_service_adapter.

    METHODS constructor.

  PRIVATE SECTION.
    DATA consumer_service TYPE REF TO ycl_consumer_service.

    "! <p class="shorttext synchronized" lang="en"></p>
    "! Converting data to service XML format
    "! @parameter documents | <p class="shorttext synchronized" lang="en">Documents in client format</p>
    "! @parameter result | <p class="shorttext synchronized" lang="en">Documents in XML format</p>
    METHODS convert_to_xml IMPORTING documents     TYPE yif_service_adapter=>documents_list
                           RETURNING VALUE(result) TYPE ycl_consumer_service=>xml_documents_list.

ENDCLASS.

CLASS ycl_consumer_service_adapter IMPLEMENTATION.

  METHOD constructor.
    consumer_service = NEW ycl_consumer_service( ).
  ENDMETHOD.

  METHOD yif_service_adapter~call_service.
    DATA(documents_xml) = convert_to_xml( documents ).
    consumer_service->send_data( documents_xml ).
  ENDMETHOD.

  METHOD convert_to_xml.
    " converts documents from clients format to XML format for consumer service
  ENDMETHOD.


ENDCLASS.
