# The only thing to check is the increase in the set of columns.
# (Could check length, but a left merge cannot change that.)

if True:
  import sys
  import pandas as pd
  #
  import python.build.output_io as oio
  import python.common.common   as com
  import python.common.misc     as misc
  import python.common.util     as util


df1 = oio.readStage(com.subsample, 'people_1')
df2 = oio.readStage(com.subsample, 'people_2_buildings')

cs1 = set(df1.columns)
new_cols = {'estrato', 'region-1', 'region-2'}
cs2 = set(df2.columns)

assert util.unique( df2.columns )
assert util.unique( new_cols )

assert set.union(cs1,new_cols) == cs2
assert set.difference(cs2,cs1) == new_cols
assert len( df1.columns ) + len( new_cols ) == len( df2.columns )
  # This is useful since column names in Pandas need not be unique.

assert util.near( len(df2),
                  misc.num_people / com.subsample,
                  tol_frac = 1/5 )

oio.test_write( com.subsample,
                "people_2_buildings",
                "It worked." )
