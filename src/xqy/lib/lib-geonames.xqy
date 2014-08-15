xquery version "1.0-ml";

module namespace geonames = "http://geonames.org";

declare namespace fc = "http://geonames.org/featureCodes";
declare namespace a1 = "http://geonames.org/admin1Code";

declare function geonames:transform(
  $content as map:map,
  $context as map:map
) as map:map* {
  let $doc := map:get($content, "value")
  let $feature-code :=
    cts:search(
      fn:collection("featureCodes"),
      cts:and-query((
        cts:element-value-query(xs:QName("fc:feature-class"), $doc//geonames:feature-class/text()),
        cts:element-value-query(xs:QName("fc:feature-code"), $doc//geonames:feature-code/text())
      ))
    )
  let $admin1-code :=
    cts:search(
      fn:collection("admin1Code"),
      cts:and-query((
        cts:element-value-query(xs:QName("a1:country-code"), $doc//geonames:country-code/text()),
        cts:element-value-query(xs:QName("a1:admin1-code"), $doc//geonames:admin1-code/text())
      ))
    )
  let $params := map:map()
  let $_ :=
    (
      map:put($params, "feature", $feature-code)
    )
  let $_ := 
    map:put(
      $content, 
      "value", 
      document{ xdmp:xslt-invoke("/xsl/geonames.xsl", $doc, $params) }
    )
  return $content

};
