#!/bin/bash

mkdir data
cd data

curl -O http://download.geonames.org/export/dump/countryInfo.txt
sed -n 51,`cat countryInfo.txt | wc -l`p countryInfo.txt > countryInfo.csv
sed -i '1s/#//g' countryInfo.csv
rm countryInfo.txt

curl -O http://download.geonames.org/export/dump/admin1CodesASCII.txt
sed -i '1 c\admin1_code	name	asciiname	geonamesid' admin1CodesASCII.txt

curl -O http://download.geonames.org/export/dump/admin2Codes.txt
sed -i '1 c\admin2-code	name	asciiname	geonamesid' admin2Codes.txt

curl -O http://download.geonames.org/export/dump/featureCodes_en.txt
sed -i '1 c\feature-code	name	description' featureCodes_en.txt

cd ../mlcp
./ingest-feature-codes.sh
./ingest-admin1-codes.sh
./ingest-admin2-codes.sh
