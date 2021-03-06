# Determines whether the latest "overview, tmi"
# and the previous are equal or not.
# Intended as a hand-run check on whether changes to the code
# have caused changes in output.

import pandas as pd
import numpy as np

import python.common.util as util
import python.common.common as cl


latest_dir = "output/vat/tables/recip-"      + str(cl.subsample) + "/"
prev_dir   = "output/vat/tables/prev/recip-" + str(cl.subsample) + "/"

latest =  pd.read_csv(
  latest_dir + "overview, tmi." + cl.strategy_suffix + ".csv",
  index_col=0 )
prev = pd.read_csv(
  prev_dir + "overview, tmi." + cl.strategy_suffix + ".csv",
  index_col=0 )

# This is necessary in order to compare them.
prev   = prev   . replace( np.nan, 0 )
latest = latest . replace( np.nan, 0 )

print("\nColumn names: equal?")
util.print_trueBlack_falseRed(
    np.all( latest.columns == prev.columns )
    , "Yes.", "No." )

print("\nIndexes: equal?")
util.print_trueBlack_falseRed(
    np.all( latest.index == prev.index )
    , "Yes.", "No." )

print("\nContents: equal?")
util.print_trueBlack_falseRed(
    np.all( latest == prev )
    , "Yes.", "No." )
