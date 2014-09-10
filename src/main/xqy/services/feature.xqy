xquery version "1.0-ml";

module namespace feature-code = "http://marklogic.com/rest-api/resource/feature";

import module namespace json="http://marklogic.com/xdmp/json"
at "/MarkLogic/json/json.xqy";

declare namespace fc = "http://geonames.org/featureCodes";


declare function feature-code:get(
  $context as map:map,
  $params  as map:map)
as document-node()*
{
  let $_ := map:put($context,"output-types","application/json")
  let $feature-code as xs:string? := map:get($params, "feature-code")
  let $abbr as xs:boolean := fn:boolean(map:get($params, "abbr"))
  let $config := json:config("custom")
  let $_ := map:put($config, "array-element-names", fn:QName("http://geonames.org/featureCodes","feature-code"))
  let $features :=
    if ($feature-code)
    then cts:search(/fc:feature-code,cts:element-value-query(fn:QName("http://geonames.org/featureCodes", "name"), $feature-code))
    else element features {
      if ($abbr)
      then
        for $feature in /fc:feature-code
        order by $feature/fc:name
        return element fc:feature-code { $feature/fc:name }
      else /fc:feature-code
    }

  return document { text { json:transform-to-json($features, $config) } }
};
