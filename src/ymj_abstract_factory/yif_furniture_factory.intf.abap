INTERFACE yif_furniture_factory
  PUBLIC .

  METHODS:
    create_chair RETURNING VALUE(ro_chair) TYPE REF TO yif_chair.
ENDINTERFACE.
