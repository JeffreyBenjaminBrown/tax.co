#!/bin/bash

# Run some set of models, as determined by the values that
# `strategy` and `year` iterate over. Edit those here;
# provide the sample size at the command line.
#
# Usage:
#   bash <this script> <sample size>
# For instance, from within the docker image,
# from the root of the project (which was mounted at /mnt):
#   (base) root@127:/mnt# bash bash/make-all-models.sh 100

for strategy in detail; do # options: detail | vat_holiday_3
  for year in 2018; do # options: 2016 | 2018
    echo; echo "strategy:" $strategy $year; date
    make tests overview subsample=$1 \
                        regime_year=$year \
                        strategy=$strategy
  done
done

echo; date; echo
