#!/bin/bash

COUNTRY=$1

cd mlcp

if [ "$COUNTRY" == "all" ]; then 
  for country in `cut -f 1 countryInfo.csv`; do
    ./ingest-geonames.sh $country
  done
else
  ./ingest-geonames.sh $COUNTRY
fi

cd ..

