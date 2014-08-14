xquery version "1.0-ml";

module namespace geonames = "http://geonames.org";

declare function geonames:transform(
  $content as map:map,
  $context as map:map
) as map:map* {
  let $doc := map:get($content, "value")
  let $_ := 
    map:put(
      $content, 
      "value", 
      document{ xdmp:xslt-invoke("/xsl/geonames.xsl", $doc) }
    )
  return $content

};
