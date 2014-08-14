#!/bin/bash

mkdir data
cd data

#download countryInfo and format
curl -O http://download.geonames.org/export/dump/countryInfo.txt
sed -n 51,`cat countryInfo.txt | wc -l`p countryInfo.txt > countryInfo.csv
sed -i '1s/#//g' countryInfo.csv
rm countryInfo.txt

curl -O http://download.geonames.org/export/dump/admin1CodesASCII.txt
sed -i '1 c\admin1_code	name	asciiname	geonamesid' admin1CodesASCII.txt

curl -O http://download.geonames.org/export/dump/featureCodes_en.txt
sed -i '1 c\feature-code	name	description' featureCodes_en.txt

for country in `cut -f 1 countryInfo.csv`; do
  mkdir $country
  cd $country
  curl -O http://download.geonames.org/export/dump/$country.zip
  unzip $country.zip
  cd ../..
  ./headers.sh $country
  cd data
done

cd mlcp
./ingest-feature-codes.sh

