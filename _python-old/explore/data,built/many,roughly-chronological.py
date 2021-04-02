import python.build.main as data  

import python.common.util as util
import python.build.classes as classes
import python.common.misc as c
import python.common.common as c

import pandas as pd
import numpy as np
import re as regex

import python.build.buildings.files as bldg
import python.build.people.files as ppl
import python.build.purchases.nice_purchases as nice_purchases
import python.build.purchases.medios as medios
import python.build.purchases.articulos as articulos
import python.build.purchases.capitulo_c as capitulo_c


dfc = data.purchases[ data.purchases["file-origin"]=="rural capitulo c" ]

data.purchases[[ "vat", "vat_x","vat_y" ]]
data.purchases[[  "min vat frac", "min vat frac_x","min vat frac_y" ]]
data.purchases[[  "min vat frac", "max vat frac_x","max vat frac_y" ]]
data.purchases[[  "min vat", "min vat_x","min vat_y" ]]
data.purchases[[  "min vat", "max vat_x","max vat_y" ]]

dfc[[  "min vat frac", "min vat frac_x","min vat frac_y" ]]
dfc[[  "min vat frac", "max vat frac_x","max vat frac_y" ]]
dfc[[  "min vat", "min vat_x","min vat_y" ]]
dfc[[  "min vat", "max vat_x","max vat_y" ]]


util.describeWithMissing(
  data.people[ data.people["age"] >= 18 ]
  [ data.cols_benefit_in_kind + data.cols_benefit_cash ]
)

raw = pd.read_csv( "data/enph-2017/recip-100/Caracteristicas_generales_personas.csv" )
raw = c.all_columns_to_numbers(
  raw.rename( columns = {
    "P6040"      : "age"
  , "P1668S1A4"  : "familias en accion"
  , "P1668S3A4"  : "familias en su tierra"
  , "P1668S4A4"  : "jovenes en accion"
  , "P1668S2A4"  : "programa de adultos mayores"
  , "P1668S5A4"  : "transferencias por victimizacion"
} ) )

util.describeWithMissing( raw[ raw["age"] >= 18 ]
                          [[ "familias en accion"
                             , "familias en su tierra"
                             , "jovenes en accion"
                             , "programa de adultos mayores"
                             , "transferencias por victimizacion"
                             ]] )

util.describeWithMissing( data.people[ data.people["age"] >= 18 ]
  [["income, year : benefit : familias en accion, in-kind"
  , "income, year : benefit : familias en su tierra, in-kind"
  , "income, year : benefit : jovenes en accion, in-kind"
  , "income, year : benefit : programa de adultos mayores, in-kind"
  , "income, year : benefit : transferencias por victimizacion, in-kind"
  , "total income, monthly : benefit, cash"
  , "total income, monthly : benefit, in-kind"
]] )



df = data.people.copy()
df = df.rename( columns = {
    'total income, monthly : labor, cash'    : "labor cash"
  , 'total income, monthly : labor, in-kind' : "labor in-kind"
  , 'total income, monthly : capital'        : "capital"
} )
df["total"] = df["labor cash"] + df["labor in-kind"] + df["capital"]
df["total cash"] = df["labor cash"] + df["capital"]
util.describeWithMissing( df[ df["age"] >= 18]
                          [["labor cash","labor in-kind","capital","total","total cash"]]
)

util.describeWithMissing( df[ df["age"] >= 18]
[[ 'total income, monthly : benefit, cash',
   'total income, monthly : benefit, in-kind', 'capital',
   'total income, monthly : grant, cash',
   'total income, monthly : grant, in-kind',
   'total income, monthly : infrequent', 'labor cash', 'labor in-kind'
   ]]
)





df = pd.DataFrame( [[1,2],[3,np.nan]], columns = ["a","b"] )
df2 = df.drop( df[ df["a"]==1 ].index )
df2
df3 = classes.Correction.Drop_Row_If_Column_Equals( "a", 1 ).correct( df )
df3

df = pd.read_csv( "data/enph-2017/recip-100/"
                  + "Gastos_diarios_Urbano_-_Capitulo_C.csv" )
df = pd.read_csv( "data/enph-2017/recip-100/"
                  + "Gastos_semanales_Rural_-_Capitulo_C.csv" )
df["NC2_CC_P3_S2"].unique()

dfd = classes.Correction.Drop_Row_If_Column_Equals(
  "NC2_CC_P3_S2", 2 ).correct( df )  
dfd["NC2_CC_P3_S2"].unique()

x = c.collect_files(
    capitulo_c.files
  )

x[ x["duplicated"]==2 ]["file-origin"].unique()
purchases[ purchases["duplicated"]==2 ]["file-origin"].unique()
data.purchases[ data.purchases["duplicated"]==2 ]["file-origin"].unique()

# Even when purhcase=1, in some files there are a substantial number
# of observations where where-got is missing.
util.dwmByGroup( "file-origin",
                 data.purchases[ data.purchases["is-purchase"]==1 ]
                 [["file-origin","per month"]] )

for c in data.people.filter(regex="income").columns:
  util.describeWithMissing( data.people[[c]] )


data.purchases[
  (~ data.purchases["coicop"].isnull())
  | (~ data.purchases["25-broad-categs"].isnull()) ].count()


### How I determined which "total labor income" variable to use, and which to ignore.

df = data.people.filter(regex="labor").copy()
df = df[ (df.T != 0).any() ] # delete the all-zero rows

df = df.rename( columns = dict( zip(
  df.columns,
  ["formal", "independiente", "rural business", "all ? 1", "all ? 2"] ) ) )

df["formal - ?1"] = df["formal"] - df["all ? 1"]
df["formal - ?2"] = df["formal"] - df["all ? 2"]

dfc = df.drop( columns = ["independiente", "rural business"] )

util.describeWithMissing( dfc )


####

data.people["beca"].unique()
non_numbers = people["female"].str.contains( "[^0-9\.\,]", regex=True )

for c in data.people.columns:
  util.describeWithMissing( data.people[[c]] )


## older; to check the values present in the data against those described in the data documentation.

file_names = [
    "articulos"
  , "medios"
  , "rural capitulo c"
  , "urban capitulo c"
  , "rural_personal"
  , "rural_personal_fuera"
  , "rural_semanal"
  , "rural_semanal_fuera"
  , "urban_diario"
  , "urban_diario_fuera"
  , "urban_diario_personal"
  , "urban_personal_fuera"
  ]

df = enph.purchases

def check(file_name,col_name):
  dff = df[ df["file-origin"]==file_name ]
  vals = list( dff[col_name].unique() )
  for i in sorted( [str(v) for v in vals] ):
    print(i)

for fn in file_names:
  print("\n\n" + fn)
  check(fn,"per month")
