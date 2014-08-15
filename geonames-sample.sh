#!/bin/bash

country=$1
mkdir data
cd data

mkdir $country
cd $country
curl -O http://download.geonames.org/export/dump/$country.zip
unzip $country.zip
cd ../..
./headers.sh $country

cd mlcp
./ingest-geonames.sh $country

