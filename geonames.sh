mkdir data
cd data
curl -O http://download.geonames.org/export/dump/countryInfo.txt
curl -O http://download.geonames.org/export/dump/admin1CodesASCII.txt

sed -n 51,`cat countryInfo.txt | wc -l`p countryInfo.txt > countryInfo.csv
sed -i '1s/#//g' countryInfo.csv
