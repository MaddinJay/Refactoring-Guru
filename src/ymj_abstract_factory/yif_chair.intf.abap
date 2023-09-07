INTERFACE yif_chair
  PUBLIC .

  METHODS:
    has_legs RETURNING VALUE(rv_has_legs) TYPE abap_bool,
    sit_on .

ENDINTERFACE.
