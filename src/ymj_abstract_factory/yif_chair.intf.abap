INTERFACE yif_chair
  PUBLIC .

  METHODS has_legs RETURNING VALUE(result) TYPE abap_bool.
  METHODS sit_on.

ENDINTERFACE.
