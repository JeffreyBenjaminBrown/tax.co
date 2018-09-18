# This file is relevant only to the extent that it records house purchases.

import pandas as pd
from numpy import nan
import python.vat.build.classes as classes
import python.vat.build.common as common


files = [
  classes.File( "urban capitulo c"
    , "Gastos_diarios_Urbano_-_Capitulo_C.csv"
    , { **common.variables
      , "NC2_CC_P1"    : "25-broad-categs"
      , "NC2_CC_P2"    : "freq"
      , "NC2_CC_P3_S1" : "value"
    }, [ classes.Correction.Create_Constant_Column( "quantity", 1 )
       , classes.Correction.Create_Constant_Column( "how-got", 1 )
       , classes.Correction.Create_Constant_Column( "coicop", nan ) ]
      + common.corrections
        # TODO : "where-got"
        # TODO : "freq"
  )

  , classes.File( "rural capitulo c"
    , "Gastos_semanales_Rural_-_Capitulo_C.csv"
    , { **common.variables
      , "NC2_CC_P1"    : "25-broad-categs"
      , "NC2_CC_P2"    : "freq"
      , "NC2_CC_P3_S1" : "value"
    }, [ classes.Correction.Create_Constant_Column( "quantity", 1 )
       , classes.Correction.Create_Constant_Column( "how-got", 1 )
       , classes.Correction.Create_Constant_Column( "coicop", nan ) ]
      + common.corrections
        # TODO : "where-got"
        # TODO : "freq"
) ]