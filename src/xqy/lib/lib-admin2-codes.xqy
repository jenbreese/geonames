xquery version "1.0-ml";

module namespace code = "http://geonames.org/admin2Code";

declare function code:transform(
  $content as map:map,
  $context as map:map
) as map:map* {
  let $doc := map:get($content, "value")
  let $_ := 
    map:put(
      $content, 
      "value", 
      document{ xdmp:xslt-invoke("/xsl/admin2-code.xsl", $doc) }
    )
  return $content

};
