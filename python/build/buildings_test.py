import pandas as pd

import python.common.cl_args as cl
import python.common.util as util
import python.build.output_io as oio


def check_types( df ):
  for (c,t) in [ ("household","int64")
               , ("region-1","O")
               , ("region-2","O")
               , ("estrato","int64") ]:
    assert df[c].dtype == t

def check_nullity( df ):
  for c in ["household","region-1","region-2"]:
    assert len( df[ pd.isnull( df[c] ) ] ) == 0
  
  for c in ["region-1","region-2"]:
    # none of these strings should be empty
    assert df[c].apply( lambda x: len(x) > 0 
                      ) . all() 
  
  assert ( len( df[ ( df["estrato"]==9 ) |
                    ( pd.isnull( df["estrato"] ) )
              ] ) <
           ( len(df) / 50 ) )

if True: # run tests
  log = "starting\n"
  bs = oio.readStage( 1 # PITFALL: For buildings, we always use the full sample.
                    , 'buildings' )
  check_types( bs )
  check_nullity( bs )
  oio.test_write( 1 # PITFALL: For buildings, we always use the full sample.
                , "build_buildings"
                , log )
