xquery version "1.0-ml";

module namespace geo = "http://marklogic.com/rest-api/resource/geo-enrich";

declare namespace html = "http://www.w3.org/1999/xhtml";

declare function get(
  $context as map:map,
  $params  as map:map
  ) as document-node()*
{
	let $text as xs:string := text{ map:get($params, "text") }
	let $country-code as xs:string := map:get($params, "country-code")
	return document{ <html:html>{ $country-code }</html:html> }  
};
