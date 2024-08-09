# Scramble DB values
Given a situation where we need to scramble field values in different database tables for audit purposes, we must execute a process for each table to read the values, scramble them, and then update the database accordingly. Since we might need to add more tables in the future, it's essential to have a flexible solution.

We can handle this situation by using the Command Pattern. Each database domain class should implement an interface with a method called process, which the caller can execute.

```abap
  " Creating a list of DB update obects (how we do that is not important)
  booking_single_list = create_process_class_list( ).

  " For each DB update object we execute the update process by calling the main method "process"
    LOOP AT booking_single_list INTO DATA(object).
      object->process( ).
    ENDLOOP.
```

Here, we are creating different database update instances using the Factory Pattern.

For a given list of database tables (table_list), we create an instance of the class zcl_vcd_scramble_book_process. We then transfer the table name and other necessary parameters to this instance.

```abap
  METHOD create_process_class_list.
    " Dynamischer Aufruf der Create Instance Methoden der DB Update Klassen
    " z.B. ZCL_VCD_SCRAMBLE_BOOK_DFKKOP
    LOOP AT table_list INTO DATA(table).
      TRY.
          DATA(object) = zcl_vcd_scramble_book_process=>create( hash_algo_values = VALUE #( BASE hash_algo_values
                                                                                            structure_name = table )
                                                                appl_log         = appl_log ).
          APPEND object TO result.
        CATCH cx_sy_dyn_call_illegal_class.
          RAISE EXCEPTION TYPE zcx_vcd_appl_error
            MESSAGE e189(zvcd2) WITH condense( table ).
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.
```

This allows us to determine, within the CREATE static method, which database operator we need to pass in order to make the class instance work for a specific database table.

```abap
  METHOD create.
    result = NEW zcl_vcd_scramble_book_process(
                    hash_algo_values = VALUE #( BASE hash_algo_values
                                                structure_name = hash_algo_values-structure_name )
                    appl_log         = appl_log
                    db_operator      = COND #( WHEN db_operator IS BOUND THEN db_operator
                                               ELSE create_new_instance( hash_algo_values-structure_name ) ) ).
  ENDMETHOD.
```

with ...

```abap
  METHOD create_new_instance.
    TRY.
        DATA(db_operator_name) = |{ db_operator_name_prefix }{ condense( COND #( WHEN structure_name = 'ZVCD_SVVSCPOS' THEN 'ZVVSCPOS'
                                                                                 ELSE structure_name ) ) }|.
        CREATE OBJECT result TYPE (db_operator_name).
      CATCH cx_sy_dyn_call_illegal_class.
        RAISE EXCEPTION TYPE zcx_vcd_appl_error
          MESSAGE e189(zvcd2) WITH condense( structure_name ).
    ENDTRY.
  ENDMETHOD.
```

# Living objects
```abap
CLASS zcl_vcd_scramble_bookings DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: tt_fields_range_table TYPE RANGE OF name_feld.
    TYPES: BEGIN OF ts_hash_algo_values,
             hashsalt              TYPE string,
             hashalgo              TYPE string,
             codepage              TYPE cpcodepage,
             fields_range_table    TYPE tt_fields_range_table,
             package_size          TYPE i,
             structure_name        TYPE domvalue,
             opbel_range_table     TYPE zvcd_rt_opbel,
             budat_range_table     TYPE zvcd_rt_budat,
             table_list            TYPE string_t,
             show_alv              TYPE abap_bool,
             layout_variant        TYPE slis_vari,
             testrun               TYPE flag,
             reported_package_size TYPE i,
           END OF ts_hash_algo_values.
    TYPES tt_scramble_book_single TYPE STANDARD TABLE OF REF TO zcl_vcd_scramble_book_process WITH DEFAULT KEY.

    METHODS constructor IMPORTING hash_algo_values TYPE ts_hash_algo_values
                                  appl_log         TYPE REF TO zvcd_if_anwendungs_log.

    "! Hauptmethode für Anonymisierung Buchungsdaten
    "! @raising zcx_vcd_appl_error |
    METHODS process RAISING zcx_vcd_appl_error.
    "! Zeige aufbereitete Daten in ALV Liste
    METHODS show_alv RAISING zcx_vcd_appl_error.

  PRIVATE SECTION.
    CONSTANTS process_class_prefix TYPE classname VALUE 'ZCL_VCD_SCRAMBLE_BOOK_'.

    DATA appl_log         TYPE REF TO zvcd_if_anwendungs_log.
    DATA hash_algo_values TYPE ts_hash_algo_values.
    DATA booking_single_list TYPE zcl_vcd_scramble_bookings=>tt_scramble_book_single.

    METHODS create_process_class_list RETURNING VALUE(result) TYPE tt_scramble_book_single
                                      RAISING   zcx_vcd_appl_error.
    METHODS show_alv_list             IMPORTING alv_list TYPE zvcd_scrambl_fields_book_alv_t
                                      RAISING   zcx_vcd_appl_error.
    METHODS aggregate_alv_list        RETURNING VALUE(result) TYPE zvcd_scrambl_fields_book_alv_t.
    METHODS activate_all_functions    IMPORTING alv TYPE REF TO cl_salv_table.
    METHODS set_optimize_column_width IMPORTING alv TYPE REF TO cl_salv_table.
    METHODS set_color_column          IMPORTING alv TYPE REF TO cl_salv_table
                                      RAISING   cx_salv_data_error.
    METHODS enable_layout_functionality IMPORTING alv TYPE REF TO cl_salv_table.
    METHODS set_technical_column_names  IMPORTING alv TYPE REF TO cl_salv_table.

ENDCLASS.



CLASS zcl_vcd_scramble_bookings IMPLEMENTATION.


  METHOD activate_all_functions.
    DATA(lo_functions) = alv->get_functions( ).
    lo_functions->set_all( abap_true ).
  ENDMETHOD.


  METHOD aggregate_alv_list.
    " Liest die aufbereiteten Daten aus den erzeugten Instanzen für den DB Update
    " und hängt diese für die Anzeige in der ALV Liste an
    LOOP AT booking_single_list INTO DATA(object).
      APPEND LINES OF object->get_alv_values( ) TO result.
    ENDLOOP.
  ENDMETHOD.


  METHOD constructor.
    me->hash_algo_values = hash_algo_values.
    me->appl_log         = appl_log.
  ENDMETHOD.


  METHOD create_process_class_list.
    " Dynamischer Aufruf der Create Instance Methoden der DB Update Klassen
    " z.B. ZCL_VCD_SCRAMBLE_BOOK_DFKKOP
    LOOP AT hash_algo_values-table_list INTO DATA(table).
      TRY.
          DATA(object) = zcl_vcd_scramble_book_process=>create( hash_algo_values = VALUE #( BASE hash_algo_values
                                                                                            structure_name = table )
                                                                appl_log         = appl_log ).
          APPEND object TO result.
        CATCH cx_sy_dyn_call_illegal_class.
          RAISE EXCEPTION TYPE zcx_vcd_appl_error
            MESSAGE e189(zvcd2) WITH condense( table ).
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.


  METHOD enable_layout_functionality.
    DATA(layout) = alv->get_layout( ).
    layout->set_key( VALUE salv_s_layout_key( report = sy-repid ) ). " Announce report
    layout->set_save_restriction( if_salv_c_layout=>restrict_none ). " No restriction in saving layouts
    layout->set_initial_layout( hash_algo_values-layout_variant ).   " Set initial layout by user input
  ENDMETHOD.


  METHOD process.
***********************************************************************
* Identifikation
* ----------------------------------------------------------------------
* Methodenname    : PROCESS
* Klasse          : ZCL_VCD_SCRAMBLE_BOOKINGS
* Spezifikation   : Bug 659905 - Anonymisierung Buchungsdaten
* Programmtyp     : Methode
* Autor           : Martin Jonen / MJON
* Erstellungsdatum: 30.07.2024
************************************************************************
* Kurze Funktionsbeschreibung
*
* Hauptroutine für den Anonymisierungsprozess
*   - Erzeugt die Objekte für die einzelnen DB Tabellen Updates, die über
*     den Parameter hash_algo_values-table_list durch den User vorgegeben
*     wurden
*   - Führt die Process Methoden dieses erzeugten Klasseninstanzen aus
************************************************************************
* Änderungen
************************************************************************
* Nr.  Datum      Name        Änderung
*
************************************************************************
    " Erzeuge Liste der relevanten DB Updateobjekte
    booking_single_list = create_process_class_list( ).

    " Für alle erzeugten DB Updateobjekte für den Prozess via Methode
    " Process aus (Command Pattern)
    LOOP AT booking_single_list INTO DATA(object).
      object->process( ).
    ENDLOOP.
  ENDMETHOD.


  METHOD set_color_column.
    alv->get_columns( )->set_color_column( 'COLOR' ).
  ENDMETHOD.


  METHOD set_optimize_column_width.
    DATA(columns) = alv->get_columns( ).
    columns->set_optimize( 'X' ).
  ENDMETHOD.


  METHOD set_technical_column_names.
    " Setze die technischen Feldnamen als Überschrift in Tabellen Header
    LOOP AT alv->get_columns( )->get( ) ASSIGNING FIELD-SYMBOL(<column>).
      <column>-r_column->set_short_text( |{ <column>-r_column->get_columnname( ) }| ).
      <column>-r_column->set_medium_text( |{ <column>-r_column->get_columnname( ) }| ).
      <column>-r_column->set_long_text( |{ <column>-r_column->get_columnname( ) }| ).
    ENDLOOP.
  ENDMETHOD.


  METHOD show_alv.
***********************************************************************
* Identifikation
* ----------------------------------------------------------------------
* Methodenname    : SHOW_ALV
* Klasse          : ZCL_VCD_SCRAMBLE_BOOKINGS
* Spezifikation   : Bug 659905 - Anonymisierung Buchungsdaten
* Programmtyp     : Methode
* Autor           : Martin Jonen / MJON
* Erstellungsdatum: 30.07.2024
************************************************************************
* Kurze Funktionsbeschreibung
*
* Zeigt die aufbereiteten Daten in einer ALV Liste an.
************************************************************************
* Änderungen
************************************************************************
* Nr.  Datum      Name        Änderung
*
************************************************************************
    IF hash_algo_values-show_alv = abap_true.
      show_alv_list( aggregate_alv_list( ) ).
    ENDIF.
  ENDMETHOD.


  METHOD show_alv_list.
    DATA alv TYPE REF TO cl_salv_table.

    DATA(wa_alv_list) = alv_list.
    TRY.
        " Erzeuge ALV Instanz
        cl_salv_table=>factory( IMPORTING r_salv_table = alv
                                CHANGING  t_table      = wa_alv_list ).

        activate_all_functions( alv ).
        set_optimize_column_width( alv ).
        set_color_column( alv ).
        enable_layout_functionality( alv ).
        set_technical_column_names( alv ).

        alv->display( ).
      CATCH cx_salv_msg cx_salv_data_error.
        RAISE EXCEPTION TYPE zcx_vcd_appl_error
          MESSAGE ID 'ZVCD2' TYPE 'E' NUMBER 182.        "#EC NUMBER_OK
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
```

```abap
CLASS zcl_vcd_scramble_book_process DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS create IMPORTING hash_algo_values TYPE zcl_vcd_scramble_bookings=>ts_hash_algo_values
                                   appl_log         TYPE REF TO zvcd_if_anwendungs_log
                                   db_operator      TYPE REF TO zif_vcd_db_operator OPTIONAL
                         RETURNING VALUE(result)    TYPE REF TO zcl_vcd_scramble_book_process
                         RAISING   zcx_vcd_appl_error.

    METHODS constructor IMPORTING hash_algo_values TYPE zcl_vcd_scramble_bookings=>ts_hash_algo_values
                                  appl_log         TYPE REF TO zvcd_if_anwendungs_log
                                  db_operator      TYPE REF TO zif_vcd_db_operator.

    "! Führt den Anonymisierungsprozess abhängig vom injizierten DB Operator aus
    "! @raising zcx_vcd_appl_error | Exception Class
    METHODS process RAISING   zcx_vcd_appl_error.

    "! Liefert die aufbereitete ALV Liste mit den DB selektierten und anonymisierten Daten
    "! @parameter result | ALV Liste
    METHODS get_alv_values RETURNING VALUE(result) TYPE zvcd_scrambl_fields_book_alv_t.

  PRIVATE SECTION.
    CONSTANTS db_operator_name_prefix       TYPE classname VALUE 'ZCL_VCD_DB_OPERATOR_'.
    CONSTANTS initial_reported_package_size TYPE i VALUE 100000.

    DATA db_operator      TYPE REF TO zif_vcd_db_operator.
    DATA appl_log         TYPE REF TO zvcd_if_anwendungs_log.

    DATA hash_algo_values           TYPE zcl_vcd_scramble_bookings=>ts_hash_algo_values.
    DATA counter_selected_positions TYPE i.
    DATA count_update_done          TYPE i.
    DATA alv_list                   TYPE zvcd_scrambl_fields_book_alv_t .
    DATA reported_package_size TYPE zcl_vcd_scramble_bookings=>ts_hash_algo_values-reported_package_size.

    CLASS-METHODS create_new_instance IMPORTING structure_name TYPE domvalue
                                      RETURNING VALUE(result)  TYPE REF TO zif_vcd_db_operator
                                      RAISING   zcx_vcd_appl_error.

    METHODS map_corresponding IMPORTING value_list    TYPE zvcd_scramble_fields_t
                                        db_value_list TYPE REF TO data
                              RETURNING VALUE(result) TYPE REF TO data
                              RAISING
                                        zcx_vcd_appl_error.
    METHODS create_field_list IMPORTING db_value_list      TYPE table
                              RETURNING VALUE(rt_names_gp) TYPE zvcd_scramble_fields_t.
    METHODS scramble_fields   IMPORTING field_list    TYPE zvcd_scramble_fields_t
                              RETURNING VALUE(result) TYPE zvcd_scramble_fields_t
                              RAISING   zcx_vcd_appl_error.
    METHODS open_cursor_db    IMPORTING opbel_range_table TYPE zvcd_rt_opbel
                                        budat_range_table TYPE zvcd_rt_budat
                              RAISING
                                        zcx_vcd_appl_error.
    METHODS fetch_next_package RETURNING VALUE(result) TYPE REF TO data.
    METHODS update_db          IMPORTING scrambled_value_list TYPE REF TO data
                               RAISING
                                         zcx_vcd_appl_error.
    METHODS create_line_names_gp IMPORTING line          TYPE any
                                 RETURNING VALUE(result) TYPE zvcd_scramble_fields.
    METHODS scramble_values IMPORTING db_value_list TYPE REF TO data
                            RETURNING VALUE(result) TYPE REF TO data
                            RAISING   zcx_vcd_appl_error.
    METHODS generate_spec_rule_list RETURNING VALUE(result) TYPE zcl_vcd_tools=>tt_spec_rule.
    METHODS create_sql_set_for_scramble RAISING zcx_vcd_appl_error.
    METHODS count_selected_positions IMPORTING value_list TYPE REF TO data.
    METHODS write_appl_log RAISING zcx_vcd_appl_error.
    METHODS is_db_response_initial IMPORTING db_value_list TYPE REF TO data
                                   RETURNING VALUE(result) TYPE abap_bool.
    METHODS add2alv_list           IMPORTING value_list TYPE REF TO data
                                             linecolor  TYPE lvc_col.
    METHODS write_package_info2job_log.
    METHODS commit_work
      RAISING
        zcx_vcd_appl_error.
    METHODS write_table_info2job_log.
    METHODS map_key_values
      IMPORTING
        line          TYPE any
      RETURNING
        VALUE(result) TYPE zvcd_scramble_fields-key.
    METHODS determine_table_key_fields
      RETURNING
        VALUE(rt_key_field) TYPE ddfields.

ENDCLASS.



CLASS zcl_vcd_scramble_book_process IMPLEMENTATION.


  METHOD add2alv_list.
    FIELD-SYMBOLS <value_list> TYPE table.

    CHECK hash_algo_values-show_alv = abap_true. " Nur merken, wenn ALV Anzeige gewünscht.
    ASSIGN value_list->* TO <value_list>.

    " Mappe Werte für die ALV Anzeige
    LOOP AT <value_list> ASSIGNING FIELD-SYMBOL(<line>).
      APPEND INITIAL LINE TO alv_list ASSIGNING FIELD-SYMBOL(<alv_line>).
      <alv_line> = CORRESPONDING #( <line> ).
      <alv_line>-strukt = hash_algo_values-structure_name.
      <alv_line>-color = VALUE #( ( color = VALUE #( col = linecolor int = 0 inv = 0 ) ) ). " Setze Farbe unterschiedlich zwischen DB und Scrambled Values
    ENDLOOP.
  ENDMETHOD.


  METHOD commit_work.
    TRY.
        IF hash_algo_values-testrun = abap_false.
          CALL FUNCTION 'DB_COMMIT'.
        ENDIF.
      CATCH cx_sql_exception INTO DATA(exception).
        RAISE EXCEPTION TYPE zcx_vcd_appl_error
          EXPORTING
            previous = exception.
    ENDTRY.
  ENDMETHOD.


  METHOD constructor.
    me->hash_algo_values      = hash_algo_values.
    me->appl_log              = appl_log.
    me->db_operator           = db_operator.
    me->reported_package_size = hash_algo_values-reported_package_size.
  ENDMETHOD.


  METHOD count_selected_positions.
    " Zähle Anzahl der Selektierten Werte für Protokoll
    FIELD-SYMBOLS <value_list> TYPE table.
    ASSIGN value_list->* TO <value_list>.
    IF <value_list> IS ASSIGNED.
      counter_selected_positions = counter_selected_positions + lines( <value_list> ).
    ENDIF.
  ENDMETHOD.


  METHOD create.
***********************************************************************
* Identifikation
* ----------------------------------------------------------------------
* Methodenname    : CREATE
* Klasse          : ZCL_VCD_SCRAMBLE_BOOK_PROCESS
* Spezifikation   : Bug 659905
* Programmtyp     : Methode
* Autor           : Martin Jonen / MJON
* Erstellungsdatum: 30.07.2024
************************************************************************
* Kurze Funktionsbeschreibung
*
* Erzeugt eine Instanz der Klasse ZCL_VCD_SCRAMBLE_BOOK_PROCESS für den
* Prozess des DB Updates für die über den Parameter hash_algo_values-
* structure_name importierte DB Tabelle
* Durch Übergabe der jeweiligen DB Operator Klasse wird
* die Prozesslogik für die DB Tabelle ausgeführt.
************************************************************************
* Änderungen
************************************************************************
* Nr.  Datum      Name        Änderung
*
************************************************************************
    result = NEW zcl_vcd_scramble_book_process(
                    hash_algo_values = VALUE #( BASE hash_algo_values
                                                structure_name = hash_algo_values-structure_name )
                    appl_log         = appl_log
                    db_operator      = COND #( WHEN db_operator IS BOUND THEN db_operator
                                               ELSE create_new_instance( hash_algo_values-structure_name ) ) ).
  ENDMETHOD.


  METHOD create_field_list.
    " Erzeuge Liste der Werte für den Aufruf der Scramble Routine
    rt_names_gp = VALUE #( FOR <line> IN db_value_list:
                             ( create_line_names_gp( <line> ) ) ).
  ENDMETHOD.


  METHOD create_line_names_gp.
    result         = CORRESPONDING zvcd_scramble_fields( line ).
    result-key     = map_key_values( line ).
    result-strukt  = hash_algo_values-structure_name.
    result-fields  = CORRESPONDING #( line ).
  ENDMETHOD.


  METHOD create_new_instance.
    TRY.
        DATA(db_operator_name) = |{ db_operator_name_prefix }{ condense( COND #( WHEN structure_name = 'ZVCD_SVVSCPOS' THEN 'ZVVSCPOS'
                                                                                 ELSE structure_name ) ) }|.
        CREATE OBJECT result TYPE (db_operator_name).
      CATCH cx_sy_dyn_call_illegal_class.
        RAISE EXCEPTION TYPE zcx_vcd_appl_error
          MESSAGE e189(zvcd2) WITH condense( structure_name ).
    ENDTRY.
  ENDMETHOD.


  METHOD create_sql_set_for_scramble.
    zcl_vcd_tools=>create_sql_sets_for_scramble( ).
  ENDMETHOD.


  METHOD fetch_next_package.
    result = db_operator->fetch_next_package( hash_algo_values-package_size ).
    count_selected_positions( result ).
  ENDMETHOD.


  METHOD generate_spec_rule_list.
    " Erzeuge, falls nötig eine Liste der Felder welche von Prozess ausgeschlossen  oder
    " gelöscht werden sollen
    result = db_operator->generate_spec_rule_list( ).
  ENDMETHOD.


  METHOD get_alv_values.
***********************************************************************
* Identifikation
* ----------------------------------------------------------------------
* Methodenname    : GET_ALV_VALUES
* Klasse          : ZCL_VCD_SCRAMBLE_BOOK_PROCESS
* Spezifikation   : Bug 65990
* Programmtyp     : Methode
* Autor           : Martin Jonen / MJON
* Erstellungsdatum: 30.07.2024
************************************************************************
* Kurze Funktionsbeschreibung
*
* Liefert die erzeugte ALV Liste mit den DB selektierten und anonymisierten
* Werten zurück
************************************************************************
* Änderungen
************************************************************************
* Nr.  Datum      Name        Änderung
*
************************************************************************
    result = alv_list.
  ENDMETHOD.


  METHOD is_db_response_initial.
    FIELD-SYMBOLS <value_list> TYPE table.
    ASSIGN db_value_list->* TO <value_list>.

    result = xsdbool( <value_list> IS INITIAL ).
  ENDMETHOD.


  METHOD map_corresponding.
    " Mappe Werte zurück in DB Selektion für späteren DB Update und zählen der
    " Anzahl der upgedateten Einträge
    result = db_operator->move_correspond_source2target( source_list        = value_list
                                                         target_list        = db_value_list
                                                         fields_range_table = hash_algo_values-fields_range_table ). " Ggf. durch User eingeschränkte Feldliste beachten

  ENDMETHOD.

  METHOD map_key_values.
    LOOP AT determine_table_key_fields( ) INTO DATA(field).
      ASSIGN COMPONENT field-fieldname OF STRUCTURE line TO FIELD-SYMBOL(<value>).
      " Mappe Key Values als String für eventuell Fehlermeldung beim Scramble Prozess
      result = COND #( WHEN result IS INITIAL THEN |{ <value> }|
                       ELSE condense( |{ result } / { <value> }| ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD determine_table_key_fields.
    DATA(rtti_struct) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_name( hash_algo_values-structure_name ) ).

    rt_key_field  = VALUE ddfields( FOR <field> IN rtti_struct->get_ddic_field_list( ) WHERE ( keyflag = 'X ' AND fieldname <> 'MANDT' )
                                     ( fieldname = <field>-fieldname ) ).
  ENDMETHOD.

  METHOD open_cursor_db.
    db_operator->open_cursor( opbel_range_table = opbel_range_table
                              budat_range_table = budat_range_table ).

  ENDMETHOD.

  METHOD process.
***********************************************************************
* Identifikation
* ----------------------------------------------------------------------
* Methodenname    : PROCESS
* Klasse          : ZCL_VCD_SCRAMBLE_BOOK_PROCESS
* Spezifikation   : Bug 65990
* Programmtyp     : Methode
* Autor           : Martin Jonen / MJON
* Erstellungsdatum: 30.07.2024
************************************************************************
* Kurze Funktionsbeschreibung
*
* Prozessiert die Anonymisiserung in Abhängigkeit vom injizierten DB
* Ooperator für die einzelnen DB Tabellen
* Z.B. Wird der DB Operator für DFKKOP (ZCL_VCD_DB_OPERATOR_DFKKOP) über
* den Constructor injiziert, wird die Logik mit den Daten der DFKKOP
* durchlaufen und so die Anonymisierung der Felder der DFKKOP durchgeführt
************************************************************************
* Änderungen
************************************************************************
* Nr.  Datum      Name        Änderung
*
************************************************************************
    " Info ins Job_log schreiben, welche Tabelleaktualisiert wird
    write_table_info2job_log( ).
    " Erzeuge die Selection und Update Expressions für den spezifischen
    " Select und Update Zugriff auf die DB Tabelle
    create_sql_set_for_scramble( ).

    " Eröffne den Cursor via DB Select
    open_cursor_db( opbel_range_table = hash_algo_values-opbel_range_table
                    budat_range_table = hash_algo_values-budat_range_table ).

    DO.
      " Solange wir Daten erhalten (FETCH DB), läuft der Anonymisierungsprozess
      DATA(db_value_list) = fetch_next_package( ).
      IF is_db_response_initial( db_value_list ).
        EXIT.
      ENDIF.
      " Merken der DB Selektion für spätere eventuelle ALV Anzeige
      add2alv_list( value_list = db_value_list
                    linecolor  = 1 ). " Standard Farbe
      " Führe die Anonymisierung durch
      DATA(scrambled_value_list) = scramble_values( db_value_list ).
      " DB Update (auch im Testfall; später ROLLBACK)
      update_db( scrambled_value_list ).

      " Merken der Anonymisierten Werte für spätere eventuelle ALV Anzeige
      add2alv_list( value_list = scrambled_value_list
                    linecolor  = 5 ). " Farbe Grün

      write_package_info2job_log( ).
    ENDDO.
    " Schreibe Protokoll-Einträge zu DB Update-Prozess
    write_appl_log( ).
  ENDMETHOD.


  METHOD scramble_fields.
    " Ausführen des Scramble Process
    result = zcl_vcd_tools=>scramble_gp_fields( it_daten     = field_list
                                                iv_salt      = hash_algo_values-hashsalt
                                                iv_algo      = hash_algo_values-hashalgo
                                                it_spec_rule = generate_spec_rule_list( ) " Spezifisch: ggf. Felder ausschliessen/löschen
                                                iv_codepage  = hash_algo_values-codepage
                                                ir_appl_log  = CAST #( appl_log ) ).
  ENDMETHOD.


  METHOD scramble_values.
    " Dynamische Value Übergabe
    ASSIGN db_value_list->* TO FIELD-SYMBOL(<db_value_list>).

    DATA(scramble_field_list) = create_field_list( <db_value_list> ).
    DATA(scrambled_values)    = scramble_fields( scramble_field_list ).
    result                    = map_corresponding( value_list    = scrambled_values
                                                   db_value_list = db_value_list ).
  ENDMETHOD.


  METHOD update_db.
    db_operator->update_db( value_list = scrambled_value_list
                            testrun    = hash_algo_values-testrun ).
    commit_work( ).
  ENDMETHOD.


  METHOD write_appl_log.
    " Schreibe Protokoll
    " Trenner |------------------------------------------------------------------------
    MESSAGE i997(>2) INTO DATA(lv_dummy).
    appl_log->add_message( zif_vcd_constants=>problem_class-high ).

    " Anzahl Belegpositionen (&1) selektiert: &2
    MESSAGE s187(zvcd2) INTO lv_dummy WITH hash_algo_values-structure_name condense( CONV string( db_operator->get_counter_selected( ) ) ).
    appl_log->add_message( zif_vcd_constants=>problem_class-high ).

    " Anzahl Belegpositionen (&1) aktualisiert: &2
    MESSAGE s188(zvcd2) INTO lv_dummy WITH hash_algo_values-structure_name condense( CONV string( db_operator->get_counter_updated( ) ) ).
    appl_log->add_message( zif_vcd_constants=>problem_class-high ).
  ENDMETHOD.


  METHOD write_package_info2job_log.
    CHECK sy-batch = abap_true.
    IF me->counter_selected_positions >= me->reported_package_size. " Package finished?
      " Nachricht: 'Verarbeitung abgeschlossen: &1 Records'
      MESSAGE i191(zvcd2) WITH me->reported_package_size.
      me->reported_package_size = me->reported_package_size + me->hash_algo_values-reported_package_size. " Next Package border
    ENDIF.
  ENDMETHOD.


  METHOD write_table_info2job_log.
    CHECK sy-batch = abap_true.
    MESSAGE i192(zvcd2) WITH me->hash_algo_values-structure_name.
  ENDMETHOD.
ENDCLASS.
```

```abap
CLASS zcl_vcd_db_operator_dfkkop DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_vcd_db_operator.

  PRIVATE SECTION.
    TYPES tt_sel_table TYPE zvcd_tt_sel_dfkkop.

    CONSTANTS structure_name TYPE domvalue VALUE 'DFKKOP'.

    DATA db_cursor           TYPE cursor.
    DATA counter_db_updated  TYPE int4.
    DATA counter_db_selected TYPE int4.
    DATA db_connection TYPE REF TO cl_sql_connection.

ENDCLASS.

CLASS zcl_vcd_db_operator_dfkkop IMPLEMENTATION.

  METHOD zif_vcd_db_operator~open_cursor.
***********************************************************************
* Identifikation
* ----------------------------------------------------------------------
* Methodenname    : OPEN_CURSOR
* Klasse          : ZCL_VCD_DB_OPERATOR_DFKKOP
* Spezifikation   : Bug 659905
* Programmtyp     : Methode
* Autor           : Martin Jonen / MJON
* Erstellungsdatum: 30.07.2024
************************************************************************
* Kurze Funktionsbeschreibung
*
* Setze den Cursor für den DB Select auf die Tabelle DFKKOP
*
************************************************************************
* Änderungen
************************************************************************
* Nr.  Datum      Name        Änderung
*
************************************************************************
    TRY.
        OPEN CURSOR WITH HOLD @db_cursor
          FOR SELECT (zcl_vcd_tools=>ov_sel_dfkkop)
                FROM dfkkop
                WHERE augst IN ('','9')
                AND   opbel IN @opbel_range_table
                AND   budat IN @budat_range_table.
      CATCH cx_sql_exception INTO DATA(exception).
        RAISE EXCEPTION TYPE zcx_vcd_appl_error
          EXPORTING
            previous = exception.
    ENDTRY.
  ENDMETHOD.

  METHOD zif_vcd_db_operator~update_db.
***********************************************************************
* Identifikation
* ----------------------------------------------------------------------
* Methodenname    : UPDATE_DB
* Klasse          : ZCL_VCD_DB_OPERATOR_DFKKOP
* Spezifikation   : Bug 659905
* Programmtyp     : Methode
* Autor           : Martin Jonen / MJON
* Erstellungsdatum: 30.07.2024
************************************************************************
* Kurze Funktionsbeschreibung
*
* Update der DB mit eingeschränkten Update Parametern
************************************************************************
* Änderungen
************************************************************************
* Nr.  Datum      Name        Änderung
*
************************************************************************
    FIELD-SYMBOLS <values> TYPE tt_sel_table.

    IF zcl_vcd_tools=>ot_upd_dfkkop IS INITIAL.
      RAISE EXCEPTION TYPE zcx_vcd_appl_error MESSAGE e135(zvcd2) WITH structure_name.
    ENDIF.

    ASSIGN value_list->* TO <values>.

    LOOP AT <values> INTO DATA(ls_dfkkop).
      UPDATE dfkkop SET (zcl_vcd_tools=>ot_upd_dfkkop)
        WHERE opbel = @ls_dfkkop-opbel
          AND opupw = @ls_dfkkop-opupw
          AND opupk = @ls_dfkkop-opupk
          AND opupz = @ls_dfkkop-opupz.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcx_vcd_appl_error MESSAGE e089(zvcd) WITH structure_name.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD zif_vcd_db_operator~move_correspond_source2target.
***********************************************************************
* Identifikation
* ----------------------------------------------------------------------
* Methodenname    : MOVE_CORRESPOND_SOURCE2TARGET
* Klasse          : ZCL_VCD_DB_OPERATOR_DFKKOP
* Spezifikation   : Bug 659905
* Programmtyp     : Methode
* Autor           : Martin Jonen / MJON
* Erstellungsdatum: 30.07.2024
************************************************************************
* Kurze Funktionsbeschreibung
*
* Mappt die anonymisierten Werte zurück in die DB Selektionsliste
* Dabei wird die eventuelle Einschränkung auf bestimmte Felder durch den
* User berücksichtigt
************************************************************************
* Änderungen
************************************************************************
* Nr.  Datum      Name        Änderung
*
************************************************************************
    FIELD-SYMBOLS <values> TYPE tt_sel_table.

    result = target_list.
    ASSIGN result->* TO <values>.

    DATA(wa_source_list) = source_list.
    SORT wa_source_list BY strukt opbel opupk opupw opupz.

    LOOP AT <values> ASSIGNING FIELD-SYMBOL(<dfkkop>).
      READ TABLE wa_source_list ASSIGNING FIELD-SYMBOL(<names_gp>) WITH KEY strukt = structure_name
                                                                            opbel = <dfkkop>-opbel
                                                                            opupk = <dfkkop>-opupk
                                                                            opupw = <dfkkop>-opupw
                                                                            opupz = <dfkkop>-opupz BINARY SEARCH.
      IF sy-subrc = 0.
        zcl_vcd_tools=>move_corresponding_in_range( EXPORTING ir_struc_src   = <names_gp>-fields
                                                              ir_selop_range = fields_range_table
                                                              iv_not_inital  = abap_false
                                                    CHANGING  cr_struc_dst   = <dfkkop> ).
        counter_db_updated = counter_db_updated + 1. " Merke Anzahl für Protokoll
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD zif_vcd_db_operator~fetch_next_package.
***********************************************************************
* Identifikation
* ----------------------------------------------------------------------
* Methodenname    : FETCH_NEXT_PACKAGE
* Klasse          : ZCL_VCD_DB_OPERATOR_DFKKOP
* Spezifikation   : Bug 659905
* Programmtyp     : Methode
* Autor           : Martin Jonen / MJON
* Erstellungsdatum: 30.07.2024
************************************************************************
* Kurze Funktionsbeschreibung
*
* Liefert für den gesetzten Cursor das nächste Data Package
************************************************************************
* Änderungen
************************************************************************
* Nr.  Datum      Name        Änderung
*
************************************************************************
    FIELD-SYMBOLS: <values> TYPE tt_sel_table.

    CREATE DATA result TYPE tt_sel_table.
    ASSIGN result->* TO <values>.
    TRY.
        FETCH NEXT CURSOR @db_cursor INTO TABLE @<values> PACKAGE SIZE @package_size.
        IF sy-subrc <> 0.
          CLOSE CURSOR @db_cursor.
        ENDIF.
      CATCH cx_sy_open_sql_db.
        CLOSE CURSOR @db_cursor.
    ENDTRY.

    " Merke Anzahl für Protokoll
    counter_db_selected = counter_db_selected + lines( <values> ).
  ENDMETHOD.

  METHOD zif_vcd_db_operator~generate_spec_rule_list.
***********************************************************************
* Identifikation
* ----------------------------------------------------------------------
* Methodenname    : GENERATE_SPEC_RULE_LIST
* Klasse          : ZCL_VCD_DB_OPERATOR_DFKKOP
* Spezifikation   : Bug 659905
* Programmtyp     : Methode
* Autor           : Martin Jonen / MJON
* Erstellungsdatum: 30.07.2024
************************************************************************
* Kurze Funktionsbeschreibung
*
* Generiere Liste von Feldern, die von Anonymisierung ausgeschlossen
* oder gelöscht werden sollen
************************************************************************
* Änderungen
************************************************************************
* Nr.  Datum      Name        Änderung
*
************************************************************************
    " Spezial Verschlüsselungsregel 'Z' für Felder, welche gelöscht werden sollen
    " für Methode zcl_vcd_tools=>scramble_gp_fields
    result = VALUE zcl_vcd_tools=>tt_spec_rule(
                     ( fieldname = 'EMGPA' rule = 'Z' )
                     ( fieldname = 'EMBVT' rule = 'Z' ) ).
  ENDMETHOD.

  METHOD zif_vcd_db_operator~get_counter_selected.
***********************************************************************
* Identifikation
* ----------------------------------------------------------------------
* Methodenname    : GET_COUNTER_SELECTED
* Klasse          : ZCL_VCD_DB_OPERATOR_DFKKOP
* Spezifikation   : Bug 659905
* Programmtyp     : Methode
* Autor           : Martin Jonen / MJON
* Erstellungsdatum: 30.07.2024
************************************************************************
* Kurze Funktionsbeschreibung
*
* Liefert die Anzahl der selektierten DB Einträge zurück
************************************************************************
* Änderungen
************************************************************************
* Nr.  Datum      Name        Änderung
*
************************************************************************
    result = counter_db_selected.
  ENDMETHOD.

  METHOD zif_vcd_db_operator~get_counter_updated.
***********************************************************************
* Identifikation
* ----------------------------------------------------------------------
* Methodenname    : GET_COUNTER_UPDATED
* Klasse          : ZCL_VCD_DB_OPERATOR_DFKKOP
* Spezifikation   : Bug 659905
* Programmtyp     : Methode
* Autor           : Martin Jonen / MJON
* Erstellungsdatum: 30.07.2024
************************************************************************
* Kurze Funktionsbeschreibung
*
* Liefert die Anzahl der anonymisierten und upgedateten DB Einträge zurück
************************************************************************
* Änderungen
************************************************************************
* Nr.  Datum      Name        Änderung
*
************************************************************************
    result = counter_db_updated.
  ENDMETHOD.



ENDCLASS.
```
with testclass
```abap
CLASS ltd_db_operator DEFINITION.

  PUBLIC SECTION.
    INTERFACES zif_vcd_db_operator.

  PRIVATE SECTION.
    DATA call_already_done TYPE abap_bool.

ENDCLASS.

CLASS ltd_db_operator IMPLEMENTATION.

  METHOD zif_vcd_db_operator~fetch_next_package.
    " Only for first round -> Simulate DB value selection of all relevant fields for scramble process
    IF call_already_done = abap_false.
      CREATE DATA result TYPE zvcd_tt_sel_dfkkop.
      ASSIGN result->* TO FIELD-SYMBOL(<values>).
      <values> = VALUE zvcd_tt_sel_dfkkop( ( opbel = '1'
                                             opupw = '1'
                                             zzv_name_first = 'Martin' "#EC NOTEXT
                                             zzv_name_last  = 'Jonen'  "#EC NOTEXT
                                             zzv_txtvw1     = 'RandomText1'
                                             zzv_txtvw2     = 'RandomText2'
                                             zzv_txtvw3     = 'RandomText3'
                                             zzv_txtvw4     = 'RandomText4' ) ).
      call_already_done = abap_true.
      RETURN.
    ENDIF.

    " Second round -> Return empty list like DB select would do
    CREATE DATA result TYPE zvcd_tt_sel_dfkkop.
    ASSIGN result->* TO <values>.
    <values> = VALUE zvcd_tt_sel_dfkkop(  ).
  ENDMETHOD.

  METHOD zif_vcd_db_operator~move_correspond_source2target.
    " Execute call like in productive workflow
    result = NEW zcl_vcd_db_operator_dfkkop( )->zif_vcd_db_operator~move_correspond_source2target(
                                               source_list        = source_list
                                               target_list        = target_list
                                               fields_range_table = fields_range_table
                                             ).
  ENDMETHOD.

  METHOD zif_vcd_db_operator~open_cursor.
    " Nothing to do
  ENDMETHOD.

  METHOD zif_vcd_db_operator~update_db.
    " Check if values were scrambled correctly. This simulates the DB update
    FIELD-SYMBOLS <value_list> TYPE zvcd_tt_sel_dfkkop.
    ASSIGN value_list->* TO <value_list>.

    " Result for test method all_fields_are_scrambled
    IF <value_list> <> VALUE zvcd_tt_sel_dfkkop( ( opbel = '1'
                                                   opupw = '1'
                                                   zzv_name_first = 'accéfe'
                                                   zzv_name_last  = 'beddc'
                                                   zzv_txtvw1     = 'JfrweexbPJÄ'
                                                   zzv_txtvw2     = 'JVPeébfVÄVU'
                                                   zzv_txtvw3     = 'VbJÄdaéfUbm'
                                                   zzv_txtvw4     = 'eVUmVÄxedJJ'
                                                    ) )
    " Result for test method one_fields_are_scrambled
    AND <value_list> <> VALUE zvcd_tt_sel_dfkkop( ( opbel = '1'
                                                    opupw = '1'
                                                    zzv_name_first = 'accéfe'
                                                    zzv_name_last  = 'Jonen'
                                                    zzv_txtvw1     = 'RandomText1'
                                                    zzv_txtvw2     = 'RandomText2'
                                                    zzv_txtvw3     = 'RandomText3'
                                                    zzv_txtvw4     = 'RandomText4'
                                                    ) ).
      RAISE EXCEPTION TYPE zcx_vcd_appl_error.
    ENDIF.
  ENDMETHOD.

  METHOD zif_vcd_db_operator~generate_spec_rule_list.
    " Execute call like in productive workflow
    result = NEW zcl_vcd_db_operator_dfkkop( )->zif_vcd_db_operator~generate_spec_rule_list( ).
  ENDMETHOD.

  METHOD zif_vcd_db_operator~get_counter_selected.
    " Nothing to do
  ENDMETHOD.

  METHOD zif_vcd_db_operator~get_counter_updated.
    " Nothing to do
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_scramble_book_dfkkop DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA cut TYPE REF TO zcl_vcd_scramble_book_process.

    METHODS:
      create_cut4all_fields_scram RETURNING VALUE(result) TYPE REF TO zcl_vcd_scramble_book_process
                                  RAISING   zcx_vcd_appl_error,
      create_cut4one_field_scram  RETURNING VALUE(result) TYPE REF TO zcl_vcd_scramble_book_process
                                  RAISING   zcx_vcd_appl_error,

      " GIVEN: DB entry with values in all relevant fields WHEN: Process is executed THEN: ...
      all_fields_are_scrambled FOR TESTING,
      " GIVEN: DB entry with values in all relevant fields and ...
      "        ... restricted field ZZV_NAME_FIRST change
      " WHEN: Process is executed
      " THEN: ...
      firstname_is_scrambled FOR TESTING.
ENDCLASS.

CLASS ltcl_scramble_book_dfkkop IMPLEMENTATION.

  METHOD all_fields_are_scrambled.
    " Implicit Check in DB operator method UPDATE_DB
    " Relevant fields:
    " - zzv_name_first, zzv_name_last, zzv_txtvw1-4
    TRY.
        create_cut4all_fields_scram( )->process( ).
      CATCH zcx_vcd_appl_error.
        cl_abap_unit_assert=>fail( ).
    ENDTRY.
  ENDMETHOD.

  METHOD firstname_is_scrambled.
    " Implicit Check in DB operator method UPDATE_DB
    TRY.
        create_cut4one_field_scram( )->process( ).
      CATCH zcx_vcd_appl_error.
        cl_abap_unit_assert=>fail( ).
    ENDTRY.
  ENDMETHOD.

  METHOD create_cut4all_fields_scram.
    result = zcl_vcd_scramble_book_process=>create(
          hash_algo_values = VALUE #( hashsalt           = 'zUiFlkWj'
                                      hashalgo           = 'SHA512'
                                      codepage           = '1252'
                                      structure_name     = 'DFKKOP'
                                      fields_range_table = VALUE #( )
                                      package_size       = 200
                                      opbel_range_table  = VALUE #( )
                                      budat_range_table  = VALUE #( ) )
          appl_log         = NEW zvcd_cl_anwendungs_log( i_object        = 'ZVCD_REPORTS'
                                                         i_subobject     = 'ZVCD_MIG'
                                                         i_extnumber     = ''
                                                         i_prog          = 'ZVCD_SCRAMBLE_BOOKINGS' )
          db_operator      = NEW ltd_db_operator( )
        ).
  ENDMETHOD.

  METHOD create_cut4one_field_scram.
    result = zcl_vcd_scramble_book_process=>create(
          hash_algo_values = VALUE #( hashsalt           = 'zUiFlkWj'
                                      hashalgo           = 'SHA512'
                                      codepage           = '1252'
                                      structure_name     = 'DFKKOP'
                                      fields_range_table = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZZV_NAME_FIRST' ) )
                                      package_size       = 200
                                      opbel_range_table  = VALUE #( )
                                      budat_range_table  = VALUE #( ) )
          appl_log         = NEW zvcd_cl_anwendungs_log( i_object        = 'ZVCD_REPORTS'
                                                         i_subobject     = 'ZVCD_MIG'
                                                         i_extnumber     = ''
                                                         i_prog          = 'ZVCD_SCRAMBLE_BOOKINGS' )
          db_operator      = NEW ltd_db_operator( )
        ).
  ENDMETHOD.

ENDCLASS.
```
