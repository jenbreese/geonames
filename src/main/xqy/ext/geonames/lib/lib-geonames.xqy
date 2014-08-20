xquery version "1.0-ml";

module namespace geonames = "http://geonames.org";

declare namespace fc = "http://geonames.org/featureCodes";
declare namespace a1 = "http://geonames.org/admin1Code";
declare namespace a2 = "http://geonames.org/admin2Code";

(: excluded names list started with list from an earlier WB POC :)
(: https://github.com/marklogic/WBG-POC-II/blob/b754f31acd55f2f3f12bafee0b7a4fc4b9c3a20b/poc-roxy/src/pipelines/email-city-process.xqy :)
declare variable $EXCLUDED-NAMES :=
(
  "A", "Along", "An", "And", "Any", "Arms", "As", "Asia", "At", "Bad", "Bank", "Best", "But", "Car",
  "Center", "Central", "Centre", "CEO", "College", "Com", "Data", "Date", "Day", "Deal", "DLI",
  "Due", "From", "Gantt", "Gap", "George", "Gram", "Grant", "Harding", "I", "In", "Job",
  "Lab", "Lead", "List", "Manage", "Makes", "Minor", "Mission", "Mobile", "Most", "New",
  "Path", "Philip", "Phone", "Plan", "Post", "Progress",
  "Re", "Rj", "Say", "See", "St", "Starbuck", "Street", "Such", "The World", "Tool", "TPA",
  "University", "Used", "Ward", "We",

  "January", "February", "March", "April", "May", "June", "July", "August", "September", "October",
  "November", "December", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov",
  "Dec"
);

declare variable $EXCLUDED-MAP :=
  let $map := map:map()
  let $_ :=
    for $name in $EXCLUDED-NAMES
    return map:put($map, fn:lower-case($name), 1)
  return $map
;


declare function geonames:filter-names(
  $names as xs:string*)
  as xs:string*
{
  for $name in $names
  return
    if (map:contains($EXCLUDED-MAP, fn:lower-case($name))) then
      ()
    else
      $name
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

  let $name := $doc//geonames:name/text()
  let $asciiname := $doc//geonames:asciiname/text()
  let $altnames := fn:tokenize($doc//geonames:alternatenames/text(), ',')
  let $query-names := fn:distinct-values(($name, $asciiname, $altnames))
  let $query-names := geonames:filter-names($query-names)

  let $params := map:map()
  let $_ :=
    (
      map:put($params, "feature", $feature-code),
      map:put($params, "admin1-code", $admin1-code),
      map:put($params, "admin2-code", $admin2-code),
      map:put($params, "query-names", $query-names)
    )
  let $_ :=
    map:put(
      $content,
      "value",
      document{ xdmp:xslt-invoke("/ext/geonames/xsl/geonames.xsl", $doc, $params) }
    )
  return $content

};
