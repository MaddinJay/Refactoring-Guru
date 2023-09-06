INTERFACE yif_furniture_factory
  PUBLIC .

  METHODS create_chair RETURNING VALUE(result) TYPE REF TO yif_chair.

ENDINTERFACE.
