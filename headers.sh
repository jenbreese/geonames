COUNTRY=$1

sed '1 i\geonameid	name	asciiname	alternatenames	latitude	longitude	feature-class	feature-code	country-code	cc2	admin1-code	admin2-code	admin3-code	admin4-code	population	elevation	dem	timezone	modification-date' data/$COUNTRY/$COUNTRY.txt > temp.txt && mv temp.txt data/$COUNTRY/$COUNTRY.txt 
