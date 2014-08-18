xquery version "1.0-ml";

declare namespace gn = "http://geonames.org";
declare namespace fc = "http://geonames.org/featureCodes";
declare namespace a1 = "http://geonames.org/admin1Code";
declare namespace a2 = "http://geonames.org/admin2Code";
declare namespace html = "http://www.w3.org/1999/xhtml";

declare variable $uri as xs:string external;
declare variable $country-code as xs:string external;

let $doc := fn:doc($uri)
let $geos := 
  cts:search(
    fn:collection($country-code), 
    cts:and-query((
      cts:reverse-query($doc)
    ))
  )
for $geo in $geos
let $q := $geo//cts:or-query
return 
  cts:highlight(
    $doc,
    cts:query($q),  
    <html:span geonames-id="{ $geo//gn:id/text() }">{$cts:text}</html:span>
  )

  