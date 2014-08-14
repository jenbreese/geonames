mlcp.sh IMPORT \
  -host localhost \
  -port 8011 \
  -username admin \
  -password admin \
  -input_file_path ../data/admin1CodesASCII.txt \
  -input_file_type delimited_text \
  -output_collections "geonames,admin1Code" \
  -delimited_root_name admin1Code \
  -namespace http://geonames.org/admin1Code \
  -options_file options.txt \
  -output_uri_prefix "/geonames/admin1Code/" 
 # -transform_module "/xqy/lib/lib-admin1-codes.xqy" \
 # -transform_namespace "http://geonames.org/admin1Code"

