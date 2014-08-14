mlcp.sh IMPORT \
  -host localhost \
  -port 8011 \
  -username admin \
  -password admin \
  -input_file_path ../data/countryInfo.csv \
  -input_file_type delimited_text \
  -output_collections "countryInfo" \
  -delimited_root_name country \
  -namespace http://geonames.org/countryInfo \
  -options_file options.txt \
  -output_uri_prefix "/countryInfo/"

