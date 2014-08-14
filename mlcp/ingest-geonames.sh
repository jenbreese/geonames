COUNTRY=$1

mlcp.sh IMPORT \
  -host localhost \
  -port 8011 \
  -username admin \
  -password admin \
  -input_file_path ../data/$COUNTRY/$COUNTRY.txt \
  -input_file_type delimited_text \
  -output_collections "geonames,$COUNTRY" \
  -delimited_root_name feature \
  -namespace http://geonames.org \
  -options_file options.txt \
  -output_uri_prefix "/geonames/$COUNTRY/" \
  -transform_module "/xqy/lib/lib-geonames.xqy" \
  -transform_namespace "http://geonames.org" 
