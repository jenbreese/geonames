mkdir US
cd US
curl -O http://download.geonames.org/export/dump/US.zip 
cd ..
unzip US/US.zip

mlcp.sh IMPORT \
  -host localhost \
  -port 8011 \
  -username admin \
  -password admin \
  -input_file_path ./MX/MX.txt \
  -input_file_type delimited_text \
  -output_collections "geonames" \
  -delimited_root_name feature \
  -namespace http://geonames.org \
  -options_file options.txt \
  -output_uri_prefix "/geonames/"

sed '-1 i\geonameid	name	asciiname	alternatenames	latitude	longitude	feature-class	feature-code	country-code	cc2	admin1-code	admin2-code	admin4-code	population	elevation	dem	timezone	modification-date' US/US.txt | tee US/US.txt
