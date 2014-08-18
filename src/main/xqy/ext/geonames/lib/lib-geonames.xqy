xquery version "1.0-ml";

module namespace geonames = "http://geonames.org";

declare namespace fc = "http://geonames.org/featureCodes";
declare namespace a1 = "http://geonames.org/admin1Code";
declare namespace a2 = "http://geonames.org/admin2Code";

declare function geonames:filter-name(
  $name as xs:string
 ) as xs:string {
  (: filter list came from an earlier WB POC :)
  (: https://github.com/marklogic/WBG-POC-II/blob/b754f31acd55f2f3f12bafee0b7a4fc4b9c3a20b/poc-roxy/src/pipelines/email-city-process.xqy :)
  let $ignoredNames := ("A", "As", "Com", "Due", "I", "Phone", "Car", "In", "Bank", "Asia", "CEO", "An", "At", "January", "February", "March", "April", "May",
                        "June", "July", "August", "September", "October", "November", "December", "DLI", "TPA", "We", "From", "Makes", "Re", "Deal", "Gap",
                        "St", "Date", "List", "Street", "Best", "See", "Starbuck", "Tool", "College", "University", "Used", "Along", "Center", "Centre",
                        "Grant", "Harding", "Job", "Lab", "Lead", "Manage", "Minor", "Mission", "Mobile", "Most", "Philip", "Plan", "Post", "Progress", "Ward",
                        "George", "Central", "Gram", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Gantt")
  let $name := if (fn:count($name[. = $ignoredNames]) gt 0) then () else $name 
  let $name := $name[fn:string-length(.) gt 2]
  return 
    if (fn:empty($name)) then "false" else "true"
};

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
    )[1]
  let $admin1-code :=
    cts:search(
      fn:collection("admin1Code"),
      cts:and-query((
        cts:element-value-query(xs:QName("a1:country-code"), $doc//geonames:country-code/text()),
        cts:element-value-query(xs:QName("a1:code-id"), $doc//geonames:admin1-code/text())
      ))
    )[1]
  let $admin2-code := 
    cts:search(
      fn:collection("admin2Code"), 
      cts:and-query((
        cts:element-value-query(xs:QName("a2:country-code"), $doc//geonames:country-code/text()),
        cts:element-value-query(xs:QName("a2:admin2-code"), $doc//geonames:admin2-code/text())
      ))
    )[1]
  let $params := map:map()
  let $_ :=
    (
      map:put($params, "feature", $feature-code),
      map:put($params, "admin1-code", $admin1-code),
      map:put($params, "admin2-code", $admin2-code),
      map:put($params, "add-query", geonames:filter-name($doc//geonames:name/text()))
    )
  let $_ := 
    map:put(
      $content, 
      "value", 
      document{ xdmp:xslt-invoke("/ext/geonames/xsl/geonames.xsl", $doc, $params) }
    )
  return $content

};
