#!/bin/bash

mkdir data
cd data

for country in `cut -f 1 countryInfo.csv`; do
  mkdir $country
  cd $country
  curl -O http://download.geonames.org/export/dump/$country.zip
  unzip $country.zip
  cd ../..
  ./headers.sh $country
  cd data
done

