mlcp.sh IMPORT \
  -host localhost \
  -port 8011 \
  -username admin \
  -password admin \
  -input_file_path ../data/admin1CodesASCII.txt \
  -input_file_type delimited_text \
  -output_collections "admin1Codes" \
  -delimited_root_name admin1Codes \
  -namespace http://geonames.org/admin1Codes \
  -options_file options.txt \
  -output_uri_prefix "/admin1Codes/"

