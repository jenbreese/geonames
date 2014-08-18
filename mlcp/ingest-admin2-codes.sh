mlcp.sh IMPORT \
  -host localhost \
  -port 8011 \
  -username admin \
  -password admin \
  -input_file_path ../data/admin2Codes.txt \
  -input_file_type delimited_text \
  -output_collections "geonames,admin2Code" \
  -delimited_root_name admin2 \
  -delimited_uri_id admin2-code \
  -namespace http://geonames.org/admin2Code \
  -options_file options.txt \
  -output_uri_prefix "/geonames/admin2Code/" \
  -transform_module "/ext/geonames/lib/lib-admin2-codes.xqy" \
  -transform_namespace "http://geonames.org/admin2Code"

