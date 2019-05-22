import pandas as pd
import python.build.classes as cla


def test_re_nonNumeric():
  assert(      cla.re_nonNumeric.match( "1-" ) )
  assert( not( cla.re_nonNumeric.match( "-1" ) ) )
  assert(      cla.re_nonNumeric.match( " 1.#!,0 " ) )
  assert( not( cla.re_nonNumeric.match( " 1.34 0 " ) ) )

def test_re_white():
  assert(      cla.re_white.match( " db db " ) )
  assert( not( cla.re_white.match( " dbdb "  ) ) )

def test_re_digits():
  assert( cla.re_digits.match( ".21" ) )

def test_re_gt2p():
  assert( cla.re_gt1p.match( "1.213.421,5" ) )

def test_re_gt2c():
  assert( cla.re_gt1c.match( "1,213,421.5" ) )

def test_varContentFormats():
  assert( cla.varContentFormats( pd.Series( [0,1] ) ) ==
          { cla.VarContent.NotAString } )
  assert( cla.varContentFormats( pd.Series( ["a a", " b "] ) ) ==
          { cla.VarContent.NonNumeric
          , cla.VarContent.InteriorSpace} )
  assert( cla.varContentFormats( pd.Series( ["0.1.2", "0.1"] ) ) ==
          { cla.VarContent.Digits
          , cla.VarContent.ManyPeriods} )
  assert( cla.varContentFormats( pd.Series( ["0,2", "0.1"] ) ) ==
          { cla.VarContent.Digits
          , cla.VarContent.Period
          , cla.VarContent.Comma } )
  assert( cla.varContentFormats( pd.Series( ["12709901", "inv02"] ) ) ==
          { cla.VarContent.Digits
          , cla.VarContent.NonNumeric } )

def test_File():
  f = cla.File( "sassafrass"
          , "sassafrass.csv"
          , [("ugly input.csv","dirt","beautiful output.csv","gold")] )
  assert ( cla.name_map( f.col_specs )
           == { "ugly input.csv" : "beautiful output.csv" } )
  assert ( cla.input_map( f.col_specs )
           == { "ugly input.csv" : "dirt" } )
  assert ( cla.output_map( f.col_specs )
           == { "beautiful output.csv" : "gold" } )

if True: # run the tests
  test_re_nonNumeric()
  test_re_white()
  test_re_digits()
  test_re_gt2p()
  test_re_gt2c()
  test_varContentFormats()
  test_File()
  print("Success!")
