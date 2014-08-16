#!/bin/bash

COUNTRY=$1

function loadCountry {
  mkdir $1
  cd $1
  curl -O http://download.geonames.org/export/dump/$1.zip
  unzip $1.zip
  rm -f $1.zip
  rm -f readme.txt
  cd ../..
  ./headers.sh $1
  cd data
}

mkdir data
cd data

if [ "$COUNTRY" == "all" ]; then 
  for country in `cut -f 1 countryInfo.csv`; do
    loadCountry $country
  done
else
  loadCountry $COUNTRY
fi


