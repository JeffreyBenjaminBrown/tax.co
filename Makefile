SHELL := bash
.PHONY: show_params \
  input_subsamples \
  buildings \
  households_1_agg_plus \
  households_2_purchases \
  people_0 \
  people_1 \
  people_2_buildings \
  people_3_income_taxish \
  purchases_0 \
  purchases_1 \
  purchases_2_vat \
  purchase_sums \
  vat_rates \
  pics \
  purchase_pics \
  people_pics \
  household_pics \
  goods_by_income_decile \
  overview \
  tests \
  show_config


##=##=##=##=##=##=##=## Variables

##=##=##=##  Non-file variables

config_file?=config/shell.json
subsample?=1
  # default value; can be overridden from the command line,
  # as in "make raw subsample=10"
  # possibilities: 1, 10, 100 and 1000
ss=$(strip $(subsample))
  # removes trailing space
strategy?=detail
s_strategy=$(strip $(strategy))
strategy_suffix=$(strip $(s_strategy))
regime_year?=2016
  # possibilities: 2016, 2018
yr=$(strip $(regime_year))
strategy_year_suffix=$(strategy_suffix).$(yr)

python_from_here = PYTHONPATH='.' python3


##=##=##=##  Input data variables

enph_files =								\
  Caracteristicas_generales_personas					\
  Gastos_diarios_del_hogar_Urbano_-_Comidas_preparadas_fuera_del_hogar	\
  Gastos_diarios_personales_Urbano					\
  Gastos_diarios_Urbano_-_Capitulo_C					\
  Gastos_diarios_Urbanos						\
  Gastos_diarios_Urbanos_-_Mercados					\
  Gastos_menos_frecuentes_-_Articulos					\
  Gastos_menos_frecuentes_-_Medio_de_pago				\
  Gastos_personales_Rural_-_Comidas_preparadas_fuera_del_Hogar		\
  Gastos_personales_Rural						\
  Gastos_personales_Urbano_-_Comidas_preparadas_fuera_del_hogar		\
  Gastos_semanales_Rural_-_Capitulo_C					\
  Gastos_semanales_Rural_-_Comidas_preparadas_fuera_del_hogar		\
  Gastos_semanales_Rurales						\
  Gastos_semanales_Rurales_-_Mercados					\
  Viviendas_y_hogares

enph_orig = $(addsuffix .csv, $(addprefix data/enph-2017/3_csv/, $(enph_files)))


##=##=##=##  Target variables

input_subsamples = \
  $(addsuffix .csv, $(addprefix data/enph-2017/recip-$(ss)/, $(enph_files)))

buildings =          output/vat/data/recip-1/buildings.csv
households_1_agg_plus = \
  output/vat/data/recip-$(ss)/households_1_agg_plus.$(strategy_year_suffix).csv \
  output/vat/data/recip-$(ss)/households_decile_summary.$(strategy_year_suffix).csv
households_2_purchases = \
  output/vat/data/recip-$(ss)/households_2_purchases.$(strategy_year_suffix).csv
people_0 =           output/vat/data/recip-$(ss)/people_0.csv
people_1 =           output/vat/data/recip-$(ss)/people_1.csv
people_2_buildings = output/vat/data/recip-$(ss)/people_2_buildings.csv
people_3_income_taxish = \
  output/vat/data/recip-$(ss)/people_3_income_taxish.$(strategy_year_suffix).csv
purchases_0 =        output/vat/data/recip-$(ss)/purchases_0.csv
purchases_1 =        output/vat/data/recip-$(ss)/purchases_1.csv
purchases_2_vat =    output/vat/data/recip-$(ss)/purchases_2_vat.$(strategy_suffix).csv
purchase_sums =      output/vat/data/recip-$(ss)/purchase_sums.$(strategy_suffix).csv
vat_rates = \
  output/vat/data/recip-$(ss)/vat_coicop.$(strategy_suffix).csv \
  output/vat/data/recip-$(ss)/vat_cap_c.$(strategy_suffix).csv \
  output/vat/data/recip-$(ss)/vat_coicop_brief.$(strategy_suffix).csv \
  output/vat/data/recip-$(ss)/vat_cap_c_brief.$(strategy_suffix).csv

purchase_pics = \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/purchases/frequency.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/purchases/quantity.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/purchases/value.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/purchases/vat-in-pesos,max.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/purchases/vat-in-pesos,min.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/purchases/logx/quantity.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/purchases/logx/value.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/purchases/logx/vat-in-pesos,max.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/purchases/logx/vat-in-pesos,min.png

people_pics = \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/people/age.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/people/education.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/people/income,by-age-decile.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/people/income.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/people/spending-per-month.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/people/transactions-per-month.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/people/logx/income,by-age-decile.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/people/logx/income.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/people/logx/spending-per-month.png

household_pics = \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/households/income.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/households/logx/income.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/households/max-edu.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/households/oldest.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/households/size.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/households/transactions-per-month.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/households/VAT-over-consumption,-by-income-decile.png \
  output/vat/pics/recip-$(ss)/$(strategy_suffix)/households/youngest.png

pics = $(purchase_pics) $(people_pics) $(household_pics)

overview = \
  output/vat/tables/recip-$(ss)/overview_tmi.$(strategy_year_suffix).csv \
  output/vat/tables/recip-$(ss)/overview_tmi.$(strategy_year_suffix).tex \
  output/vat/tables/recip-$(ss)/overview_tmi.$(strategy_year_suffix).xlsx \
  output/vat/tables/recip-$(ss)/overview.$(strategy_year_suffix).csv \
  output/vat/tables/recip-$(ss)/overview.$(strategy_year_suffix).tex \
  output/vat/tables/recip-$(ss)/overview.$(strategy_year_suffix).xlsx

goods_by_income_decile = \
  output/vat/tables/recip-$(ss)/goods_by_income_decile.csv \
  output/vat/tables/recip-$(ss)/goods,first_six_deciles.csv


##=##=##=##=##=##=##=## Recipes

# Without this, the shell history would not be very useful,
# since the configuration file is edited frequently.
show_config:
	cat $(config_file)

##=##=##=## testing

##=## minor tests

lag:
	bash bash/overview_lag.sh $(config_file)

diff:
	$(python_from_here) python/test/overview_diff.py \
          $(config_file)

show_params:
	echo "config_file: "		-$(config_file)-
	echo "subsample: "		-$(subsample)-
	echo "ss: "			-$(ss)-
	echo "tax regime year: "	-$(yr)-
	echo "strategy: "		-$(strategy)-
	echo "strategy suffix: "	-$(strategy_suffix)-
	echo "strategy_year_suffix: "	-$(strategy_year_suffix)


##=## the run-after-every-change test suite

# Sufficiently simple and fast tests can stay in the master "tests" recipe here.
# But for any test complex enough to require an output file,
# make that output file a dependency.
# PITFALL: purchase_input.txt always uses the full sample
tests:							\
  rate_input_test \
  output/test/recip-$(ss)/households_1_agg_plus.txt	\
  output/test/recip-$(ss)/households_2_purchases.txt    \
  output/test/recip-$(ss)/build_classes.txt		\
  output/test/recip-$(ss)/build_purchases_2_vat.txt	\
  output/test/recip-$(ss)/build_purchase_sums.txt	\
  output/test/recip-1/build_ss_functions.txt		\
  output/test/recip-$(ss)/people_3_income_taxish.txt	\
  output/test/recip-$(ss)/common_misc.txt		\
  output/test/recip-$(ss)/common_util.txt		\
  output/test/recip-$(ss)/people_main.txt		\
  output/test/recip-$(ss)/people_2_buildings.txt	\
  output/test/recip-$(ss)/purchases_correct.txt		\
  output/test/recip-1/regime_r2018.txt              	\
  output/test/recip-$(ss)/vat_rates.txt			\
  output/test/recip-1/build_buildings.txt		\
  output/test/recip-1/purchase_inputs.txt
	printf '\nAll tests passed.\n\n'

common_test:							\
  python/common/common.py
	$(python_from_here) python/common/common_test.py	\
          $(config_file)

rate_input_test:
	$(python_from_here) python/build/rate_input_test.py $(config_file)

output/test/recip-$(ss)/households_1_agg_plus.txt:	\
  $(households_1_agg_plus)				\
  python/build/households_1_agg_plus_test.py		\
  python/build/households_1_agg_plus_defs.py		\
  python/build/output_io.py				\
  python/common/common.py
	date
	$(python_from_here) python/build/households_1_agg_plus_test.py	\
          $(config_file)

output/test/recip-$(ss)/households_2_purchases.txt:	\
  $(households_2_purchases)				\
  python/build/output_io.py				\
  python/build/classes.py				\
  python/common/common.py				\
  python/common/util.py
	date
	$(python_from_here) python/build/households_2_purchases_test.py \
          $(config_file)

output/test/recip-$(ss)/build_classes.txt:	\
  python/build/classes.py			\
  python/build/classes_test.py
	date
	$(python_from_here) python/build/classes_test.py \
          $(config_file)

output/test/recip-$(ss)/common_misc.txt:	\
  python/build/output_io.py			\
  python/common/common.py			\
  python/common/misc.py				\
  python/common/misc_test.py
	date
	$(python_from_here) python/common/misc_test.py \
          $(config_file)

output/test/recip-$(ss)/common_util.txt:	\
  python/build/output_io.py			\
  python/common/util.py				\
  python/common/util_test.py
	date
	$(python_from_here) python/common/util_test.py \
          $(config_file)

output/test/recip-$(ss)/purchases_correct.txt:	\
  $(purchases_1)				\
  python/build/classes.py			\
  python/build/output_io.py			\
  python/build/purchases/correct_defs.py	\
  python/build/purchases/correct_test.py	\
  python/common/common.py			\
  python/common/misc.py
	date
	$(python_from_here) python/build/purchases/correct_test.py \
          $(config_file)

output/test/recip-$(ss)/build_purchases_2_vat.txt:	\
  $(purchases_2_vat)					\
  python/build/output_io.py				\
  python/build/purchases_2_vat.py			\
  python/build/purchases_2_vat_test.py			\
  python/common/common.py				\
  python/common/misc.py
	date
	$(python_from_here) python/build/purchases_2_vat_test.py \
          $(config_file)

output/test/recip-$(ss)/build_purchase_sums.txt:	\
  $(purchase_sums)					\
  python/build/purchase_sums_test.py			\
  python/build/output_io.py				\
  python/common/common.py				\
  python/common/misc.py					\
  python/common/util.py
	date
	$(python_from_here) python/build/purchase_sums_test.py	\
          $(config_file)

output/test/recip-$(ss)/people_main.txt: \
  $(people_1) \
  python/build/classes.py \
  python/build/output_io.py \
  python/build/people/files.py \
  python/build/people/main_test.py \
  python/common/common.py \
  python/common/misc.py \
  python/common/util.py
	date
	$(python_from_here) python/build/people/main_test.py \
          $(config_file)

# PITFALL: for buildings.csv we always use subsample=1.
output/test/recip-1/build_buildings.txt:	\
  $(buildings)					\
  python/build/buildings.py			\
  python/build/buildings_test.py		\
  python/build/classes.py			\
  python/build/output_io.py			\
  python/common/common.py			\
  python/common/misc.py
	date
	$(python_from_here) python/build/buildings_test.py \
          $(config_file)

output/test/recip-$(ss)/people_2_buildings.txt:	\
  $(people_1)					\
  $(people_2_buildings)				\
  python/build/people_2_buildings_test.py       \
  python/build/output_io.py			\
  python/common/common.py			\
  python/common/util.py
	date
	$(python_from_here) python/build/people_2_buildings_test.py \
          $(config_file)

# TODO: Currently 2018 is tested, regardless of the actual regime-year.
# It would be better to have separate tests for each year.
output/test/recip-1/regime_r2018.txt:			\
  python/regime/r2018.py				\
  python/build/output_io.py				\
  python/common/common.py				\
  python/common/misc.py					\
  python/common/util.py
	date
	$(python_from_here) python/regime/r2018_test.py \
          $(config_file)

output/test/recip-1/build_ss_functions.txt:			\
  python/build/ss_functions_test.py				\
  python/build/ss_functions.py					\
  python/build/ss_schedules.py					\
  python/build/output_io.py					\
  python/common/misc.py						\
  python/common/util.py
	date
	$(python_from_here) python/build/ss_functions_test.py	\
          $(config_file)

output/test/recip-$(ss)/people_3_income_taxish.txt:	\
  $(people_3_income_taxish)                             \
  python/build/people_3_income_taxish_test.py		\
  python/build/people_3_income_taxish_functions.py	\
  python/build/output_io.py				\
  python/common/util.py					\
  python/common/util.py
	date
	$(python_from_here)				\
          python/build/people_3_income_taxish_test.py	\
          $(config_file)

# PITFALL: Sample size is hardcoded to 1, because otherwise
# certain rare values would never be encountered.
output/test/recip-1/purchase_inputs.txt: \
  $(input_subsamples) \
  python/build/classes.py \
  python/build/output_io.py \
  python/build/purchases/articulos.py \
  python/build/purchases/capitulo_c.py \
  python/build/purchases/input_test.py \
  python/build/purchases/nice_purchases.py \
  python/common/misc.py
	date
	$(python_from_here) python/build/purchases/input_test.py \
          $(config_file)

output/test/recip-$(ss)/vat_rates.txt:	\
  $(vat_rates.py)			\
  python/build/output_io.py		\
  python/build/vat_rates.py		\
  python/build/vat_rates_test.py	\
  python/common/common.py		\
  python/common/misc.py
	$(python_from_here) python/build/vat_rates_test.py \
          $(config_file)


##=##=##=## subsample, or very slightly tweak, some input data sets

input_subsamples: $(input_subsamples)
$(input_subsamples):	\
  $(enph_orig)		\
  python/subsample.py	\
  python/build/datafiles.py
	date
	# Next: Validating command-line arguments.
	$(python_from_here) python/common/common.py $(config_file)
	$(python_from_here) python/subsample.py

vat_rates: $(vat_rates)
$(vat_rates): \
  python/build/vat_rates.py \
  python/build/output_io.py \
  data/vat/vat-by-coicop.csv \
  python/common/misc.py \
  python/build/classes.py \
  data/vat/vat-by-capitulo-c.csv
	date
	$(python_from_here) python/build/vat_rates.py $(config_file)


##=##=##=## Build data from the ENPH

buildings: $(buildings)
$(buildings): \
  python/build/buildings.py \
  python/build/classes.py \
  python/build/output_io.py \
  python/common/common.py \
  python/common/misc.py \
  $(input_subsamples)
	date
	$(python_from_here) python/build/buildings.py $(config_file)

people_0: $(people_0)
$(people_0): \
  python/build/output_io.py \
  python/build/people/collect.py \
  python/build/people/files.py \
  python/common/common.py \
  python/common/misc.py \
  $(input_subsamples)
	date
	$(python_from_here) python/build/people/collect.py $(config_file)

people_1: $(people_1)
$(people_1): \
  python/build/classes.py \
  python/build/output_io.py \
  python/build/people/files.py \
  python/build/people/main.py \
  python/common/common.py \
  python/common/misc.py \
  $(people_0)
	date
	$(python_from_here) python/build/people/main.py $(config_file)

people_2_buildings: $(people_2_buildings)
$(people_2_buildings): \
  python/build/people_2_buildings.py \
  python/build/output_io.py \
  python/common/misc.py \
  python/build/classes.py \
  $(buildings) $(people_1)
	date
	$(python_from_here) python/build/people_2_buildings.py $(config_file)

people_3_income_taxish: $(people_3_income_taxish)
$(people_3_income_taxish):			\
  python/build/people_3_income_taxish.py	\
  python/build/output_io.py			\
  python/build/ss_schedules.py			\
  python/regime/r$(yr).py			\
  python/common/misc.py				\
  python/build/classes.py			\
  $(people_2_buildings)
	date
	$(python_from_here) python/build/people_3_income_taxish.py $(config_file)

households_1_agg_plus: $(households_1_agg_plus)
$(households_1_agg_plus):			\
  python/build/households_1_agg_plus.py		\
  python/build/households_1_agg_plus_defs.py	\
  python/common/util.py				\
  python/build/output_io.py			\
  python/regime/r$(yr).py			\
  $(people_3_income_taxish)
	date
	$(python_from_here) python/build/households_1_agg_plus.py $(config_file)

households_2_purchases: $(households_2_purchases)
$(households_2_purchases):			\
  $(households_1_agg_plus)			\
  $(purchase_sums)				\
  python/build/households_2_purchases.py	\
  python/build/output_io.py			\
  python/common/common.py			\
  python/common/util.py
	date
	$(python_from_here) python/build/households_2_purchases.py $(config_file)

purchases_0: $(purchases_0)
$(purchases_0):					\
  python/build/purchases/collect.py		\
  python/build/output_io.py			\
  python/build/purchases/nice_purchases.py	\
  python/build/purchases/articulos.py		\
  python/build/purchases/capitulo_c.py		\
  python/common/common.py			\
  $(input_subsamples)
	date
	$(python_from_here) python/build/purchases/collect.py $(config_file)

purchases_1: $(purchases_1)
$(purchases_1):					\
  $(purchases_0)				\
  python/build/purchases/correct.py		\
  python/build/purchases/correct_defs.py	\
  python/build/classes.py			\
  python/build/output_io.py			\
  python/build/purchases/nice_purchases.py	\
  python/build/purchases/articulos.py		\
  python/build/purchases/capitulo_c.py		\
  python/common/common.py			\
  python/common/misc.py				\
  python/build/classes.py			\
  $(input_subsamples)
	date
	$(python_from_here) python/build/purchases/correct.py $(config_file)

purchases_2_vat: $(purchases_2_vat)
$(purchases_2_vat): \
  python/build/purchases_2_vat.py \
  python/build/output_io.py \
  python/build/purchases/legends.py \
  $(vat_rates) \
  python/common/misc.py \
  python/build/classes.py \
  output/vat/data/recip-$(ss)/purchases_1.csv
	date
	$(python_from_here) python/build/purchases_2_vat.py $(config_file)

purchase_sums: $(purchase_sums)
$(purchase_sums): \
  python/build/purchase_sums.py \
  python/build/output_io.py \
  python/common/misc.py \
  python/build/classes.py \
  $(purchases_2_vat)
	date
	$(python_from_here) python/build/purchase_sums.py $(config_file)


##=##=##=## Make charts, diagrams, tiny latex tables

purchase_pics: $(purchase_pics)
$(purchase_pics): \
  python/report/pics/purchases.py \
  python/draw/util.py \
  python/common/misc.py \
  python/common/common.py \
  $(purchases_2_vat)
	date
	$(python_from_here) python/report/pics/purchases.py $(config_file)

household_pics: $(household_pics)
$(household_pics): \
  python/report/pics/households.py \
  python/draw/util.py \
  python/common/misc.py \
  python/common/common.py \
  $(households_1_agg_plus)
	date
	$(python_from_here) python/report/pics/households.py $(config_file)

people_pics: $(people_pics)
$(people_pics): \
  python/report/pics/people.py \
  python/draw/util.py \
  python/common/misc.py \
  python/common/common.py \
  $(people_3_income_taxish)
	date
	$(python_from_here) python/report/pics/people.py $(config_file)

pics: $(pics)

overview: $(overview)
$(overview): \
  python/report/overview.py \
  python/common/util.py \
  python/build/output_io.py \
  python/build/people/files.py \
  python/regime/r$(yr).py \
  python/draw/util.py \
  python/common/misc.py \
  python/common/common.py \
  python/build/classes.py \
  $(households_2_purchases)
	date
	$(python_from_here) python/report/overview.py $(config_file)

# PITFALL: Always reads households_1_agg_plus from the detail vat strategy, because vat irrelevant.
goods_by_income_decile: $(goods_by_income_decile)
$(goods_by_income_decile): \
  python/build/goods-by-income-decile.py \
  output/vat/data/recip-$(ss)/households_1_agg_plus.detail_.csv \
  output/vat/data/recip-$(ss)/purchases_1.csv
	date
	$(python_from_here) python/build/goods-by-income-decile.py $(config_file)
