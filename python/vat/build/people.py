import pandas as pd
import python.vat.build.classes as classes
import python.vat.build.common as common

files = [
  classes.File( "people"
    , "Caracteristicas_generales_personas.csv"
    , { **common.variables
      , "P6020" : "female"
      , "P6040" : "age"
      , "P6080" : "race"
      , "P5170" : "pre-k|daycare"
      , "P6170" : "student"
      , "P8610" : "beca"
      , "P6060" : "skipped 3 meals"
      , "P6160" : "literate"
      , "P6210" : "education"
      , "P6240" : "time use"
      , "P6800" : "hours worked, usual"
      , "P6850" : "hours worked, last week"
      , "P6300" : "want to work"
      , "P7422" : "income, labor, all"
      , "P6500" : "income, labor, formal"
      , "P6510S1" : "income, labor, overtime"
      , "P6510S2" : "income, labor, overtime overlooked"
      , "P6750" : "income, labor, contractor"
      , "P550" : "income, labor, rural business"
      , "P7500S1A1" : "income, rental, building"
      , "P7500S4A1" : "income, rental, land"
      , "P7500S5A1" : "income, rental, vehicles and equipment"
      , "P7500S2A1" : "income, benefit, pension+"
      , "P7500S3A1" : "income, benefit, alimony"
      , "P7510S1A1" : "income, benefit, remittance, native"
      , "P7510S2A1" : "income, benefit, remittance, foreign"
      , "P7510S3A1" : "income, benefit, charity, native"
      , "P7510S4A1" : "income, benefit, charity, foreign"
      , "P7510S6A1" : "income, benefit, layoff"
      , "P7510S5A1" : "income, investment, interest+"
      , "P7510S10A1" : "income, investment, dividend"
      , "P7510S9A1" : "income, investment, sale"
      , "P1668S1A1" : "income, benefit, Mas Familias en Accion"
      , "P1668S2A2" : "income, benefit, Programas de Adultos Mayores"
      , "P1668S3A2" : "income, benefit, Familias en su Tierra"
      , "P1668S4A2" : "income, benefit, Jovenes en Accion"
      , "P1668S5A2" : "income, benefit, Transferencias por Victimizacion"
    }
) ]
