xquery version "1.0-ml";

module namespace geo = "http://marklogic.com/rest-api/resource/geo-enrich";

declare namespace gn = "http://geonames.org";
declare namespace html = "http://www.w3.org/1999/xhtml";


declare function geo:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{
	let $text := text{ map:get($params, "text") }
	let $country-code as xs:string := map:get($params, "country-code")
	let $geos :=
      cts:search(
        fn:collection($country-code),
        cts:reverse-query($text)
      )
    return 
      document {
        <html:html> 
          <html:head />
          <html:body>
          {
            for $geo in $geos
            return 
              cts:highlight(
                <html:p>{ $text }</html:p>, 
                cts:query($geo/gn:geoname/gn:query/element()), 
                <html:span attribute="{ $geo/gn:geoname/gn:id/text() }">{ $cts:text }</html:span>
              )
          }
          </html:body> 
        </html:html>
	  }
};

declare function geo:post(
    $context as map:map,
    $params  as map:map,
    $input   as document-node()*
) as document-node()* {
  document{ <null /> }
};


