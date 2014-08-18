mlcp.sh IMPORT \
  -host localhost \
  -port 8011 \
  -username admin \
  -password admin \
  -input_file_path ../data/featureCodes_en.txt \
  -input_file_type delimited_text \
  -output_collections "featureCodes,geonames" \
  -delimited_root_name feature-code \
  -namespace http://geonames.org/featureCodes \
  -options_file options.txt \
  -output_uri_prefix "/geonames/featureCodes/" \
  -transform_module "/ext/geonames/lib/lib-feature-codes.xqy" \
  -transform_namespace "http://geonames.org/featureCodes"

