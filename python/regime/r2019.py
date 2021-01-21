import pandas as pd
import python.common.misc as misc
from   python.common.misc import muvt


income_tax_columns = [ "tax, income"
                     , "tax, income, most"
                     , "tax, income, dividend"
                     , "tax, income, ganancia ocasional"
                     , "tax, income, gmf"
                     ]

gravable_pre = "cedula general gravable, sums before exemptions"

def income_taxes( ppl : pd.dataframe ) -> pd.dataframe:
  """pitfall: destructive."""
  new_columns = pd.dataframe()
  temp_columns = pd.dataframe()
  temp_columns["claims dependent (labor income tax)"] = ppl["claims dependent (labor income tax)"]
  temp_columns[gravable_pre] = (
    ( ( ppl["income, labor"]
      - ppl["tax, ss, total employee contribs"] )
    + ppl["income, rental + interest"]
    + ppl["income, non-labor (tax def)"]
    ) )

  temp_columns["cedula general gravable"] = (
    temp_columns .
    apply(taxable, axis=1) )

  new_columns["tax, income, most"] = (
    temp_columns["cedula general gravable"] +
    ppl["income, pension"]
  ) . apply( most_income_tax )

  new_columns["tax, income, dividend"] = (
    ppl["income, dividend"].apply( lambda x:
      0 if x < (300*muvt)
      else (x - 300*muvt) * 0.1 ) )

  new_columns["tax, income, ganancia ocasional"] = (
    ppl["income, ganancia ocasional, 10%-taxable"] * 0.1 +
    ppl["income, ganancia ocasional, 20%-taxable"] * 0.2 )

  # a.k.a. the "4 por mil" -- a 0.4% tax
  # levided on transactions involving someone's bank account.
  new_columns["tax, income, gmf"] = (
      0.004 * ( ppl["income, cash"] - misc.gmf_threshold)
      ).apply( lambda x: max(0,x) )

  # TODO: This is dangerous: It duplicates some information from
  # income_tax_columns, so they can get out of sync.
  new_columns["tax, income"] = (
      new_columns [[ "tax, income, most"
                   , "tax, income, dividend"
                   , "tax, income, ganancia ocasional"
                   , "tax, income, gmf" ]] .
      sum( axis = "columns" ) )

  return pd.concat( [ppl, new_columns], axis = 1 )

def most_income_tax( income : float ) -> float:
  # see test/income_tax_2018.hs for code that generates these formulas.
  # Run this to test the accumulated totals
  # (the numbers just after the + signs):
  #   ns = [ 0.19 * (1700 - 1090),
  #        0.28 * (4100 - 1700),
  #        0.33 * (8670 - 4100),
  #        0.35 * (18970 - 8670),
  #        0.37 * (31000 - 18970) ]
  #   for i in range(0,5):
  #     print( sum( ns[0:i+1] ) )

  x = income
  return (
    0                                           if x < (1090 *muvt)
    else ( (x - 1090 *muvt)*0.19                if x < (1700 *muvt)
    else ( (x - 1700 *muvt)*0.28 + 115.9  *muvt if x < (4100 *muvt)
    else ( (x - 4100 *muvt)*0.33 + 787.9  *muvt if x < (8670 *muvt)
    else ( (x - 8670 *muvt)*0.35 + 2296   *muvt if x < (18970*muvt)
    else ( (x - 18970*muvt)*0.37 + 5901   *muvt if x < (31000*muvt)
    else   (x - 31000*muvt)*0.39 + 10352.1*muvt
    ) ) ) ) ) )

def taxable( row: pd.Series ) -> float:
  """
  The first stage of "renta gravable laboral" is someone's income,
  minus either 32.5% or 5040 UVTs, whichever is smaller.
  If someone can claim no dependents, then their second stage renta gravable
  is the same as the first.
  If they can, and S1 is the value of the first stage,
  then the second stage is equal to S1 minus 10% or 32 UVT,
  whichever is smaller.
  """
  s1 = (
    row               [gravable_pre]
    - min( 0.325 * row[gravable_pre],
           5040 * muvt ) )
  s2 = ( s1 if not row["claims dependent (labor income tax)"]
         else  s1 - min( 0.1 * s1,
                         32 * muvt ) )
  return s2
