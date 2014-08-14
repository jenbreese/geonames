#!/bin/bash

cd mlcp
for COUNTRY in `cut -f 1 ../data/countryInfo.csv`; do
  ./ingest-geonames.sh $COUNTRY
done
