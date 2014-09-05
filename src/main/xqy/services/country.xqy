xquery version "1.0-ml";

module namespace country = "http://marklogic.com/rest-api/resource/country";

import module namespace json="http://marklogic.com/xdmp/json"
at "/MarkLogic/json/json.xqy";

declare namespace cc = "http://geonames.org/countryInfo";


declare function country:get(
  $context as map:map,
  $params  as map:map)
as document-node()*
{
  let $_ := map:put($context,"output-types","application/json")
  let $country-code as xs:string? := map:get($params, "country-code")
  let $abbr as xs:boolean := fn:boolean(map:get($params, "abbr"))
  let $config := json:config("custom")
  let $_ := map:put($config, "array-element-names", fn:QName("http://geonames.org/countryInfo","country"))
  let $countries :=
    if ($country-code)
    then cts:search(/cc:country,
      cts:or-query((
        cts:element-value-query(fn:QName("http://geonames.org/countryInfo", "ISO"), $country-code),
        cts:element-value-query(fn:QName("http://geonames.org/countryInfo", "ISO3"), $country-code)
      ))
    )
    else element countries {
      if ($abbr)
      then
        for $country in /cc:country
        order by $country/cc:Country
        return element cc:country { $country/cc:Country, $country/cc:ISO }
      else /cc:country
    }

  return document { text { json:transform-to-json($countries, $config) } }
};
