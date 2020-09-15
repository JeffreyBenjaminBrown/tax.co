# What to import if working from the repl (the Python shell).
# In this case there are no command-line arguments to interpret.
# Instead, the user can specify any such parameters by modifying this file.

import python.common.terms as t

subsample = 10
strategy = t.detail
regime_year = 2019
strategy_suffix = strategy
strategy_year_suffix = strategy + "." + str(regime_year)

