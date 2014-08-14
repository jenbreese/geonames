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

