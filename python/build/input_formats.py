import enum
from   functools import reduce
import pandas as pd
import numpy as np
import pytest
import re
import sys


class VarContent(enum.Flag):
  NotAString    = enum.auto()
  HasNull        = enum.auto()
  Digits        = enum.auto()
  InteriorSpace = enum.auto()
  NonNumeric    = enum.auto()
  Period        = enum.auto()
  Comma         = enum.auto()
  ManyPeriods   = enum.auto()
  ManyCommas    = enum.auto()

if True:
  re_nonNumeric = re.compile( ".*[^0-9\s\.,]" )
  re_white      = re.compile( ".*[^\s].*\s.*[^\s]" )
  re_digits     = re.compile( ".*[0-9]" )
  re_p          = re.compile( ".*\." )
  re_c          = re.compile( ".*," )
  re_gt1p       = re.compile( ".*\..*\." )
  re_gt1c       = re.compile( ".*,.*," )

def varContentFormats( column ):
  # let c = column.apply( str.strip )
    # omitted because this is done to every column when subsampling
  if column.dtype not in [object]:
    return {VarContent.NotAString}

  acc = set()
  for i in column.index:
    if pd.isnull( column[i] ):
      acc.add( VarContent.HasNull )
    else:
      for ( regex, flag ) in [
          ( re_digits, VarContent.Digits )
          , ( re_white, VarContent.InteriorSpace )
          , ( re_nonNumeric, VarContent.NonNumeric )
          , ( re_p, VarContent.Period )
          , ( re_c, VarContent.Comma )
          , ( re_gt1p, VarContent.ManyPeriods )
          , ( re_gt1c, VarContent.ManyCommas ) ]:
        if regex.match( column[i] ):
          acc.add( flag )

  if VarContent.ManyPeriods in acc:
    acc.discard( VarContent.Period )
  if VarContent.ManyCommas in acc:
    acc.discard( VarContent.Comma )

  return acc


def test_re_nonNumeric():
  assert(      re_nonNumeric.match( " 1.#!,0 " ) )
  assert( not( re_nonNumeric.match( " 1.34 0 " ) ) )

def test_re_white():
  assert(      re_white.match( " db db " ) )
  assert( not( re_white.match( " dbdb "  ) ) )

def test_re_digits():
  assert( re_digits.match( ".21" ) )

def test_re_gt2p():
  assert( re_gt1p.match( "1.213.421,5" ) )

def test_re_gt2c():
  assert( re_gt1c.match( "1,213,421.5" ) )

def test_varContentFormats():
  assert( varContentFormats( pd.Series( [0,1] ) ) ==
          { VarContent.NotAString } )
  assert( varContentFormats( pd.Series( ["a a", " b "] ) ) ==
          { VarContent.NonNumeric
          , VarContent.InteriorSpace} )
  assert( varContentFormats( pd.Series( ["0.1.2", "0.1"] ) ) ==
          { VarContent.Digits
          , VarContent.ManyPeriods} )
  assert( varContentFormats( pd.Series( ["0,2", "0.1"] ) ) ==
          { VarContent.Digits
          , VarContent.Period
          , VarContent.Comma } )
  assert( varContentFormats( pd.Series( ["12709901", "inv02"] ) ) ==
          { VarContent.Digits
          , VarContent.NonNumeric } )
