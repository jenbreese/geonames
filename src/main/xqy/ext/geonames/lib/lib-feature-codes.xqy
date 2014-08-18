xquery version "1.0-ml";

module namespace feature-code = "http://geonames.org/featureCodes";

declare function feature-code:transform(
  $content as map:map,
  $context as map:map
) as map:map* {
  let $doc := map:get($content, "value")
  let $_ := 
    map:put(
      $content, 
      "value", 
      document{ xdmp:xslt-invoke("/ext/geonames/xsl/feature-code.xsl", $doc) }
    )
  return $content

};
