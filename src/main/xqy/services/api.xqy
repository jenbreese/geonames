xquery version "1.0-ml";

module namespace api = "http://marklogic.com/rest-api/resource/api";

declare namespace rapi  = "http://marklogic.com/rest-api";

declare function get(
  $context as map:map,
  $params  as map:map
  ) as document-node()*
{
  let $options := xdmp:eval(
    fn:concat(
      'xquery version "1.0-ml"; ',
      'import module namespace config-query = "http://marklogic.com/rest-api/models/config-query" at "/MarkLogic/rest-api/models/config-query-model.xqy"; ',
      'config-query:get-list(map:map(), map:map())'
    )
  )
  
  let $_ := xdmp:log($options)
  
  let $resources := xdmp:eval(
  	fn:concat(
  		'xquery version "1.0-ml"; ',
  		'import module namespace rsrcmodqry = "http://marklogic.com/rest-api/models/resource-model-query" at "/MarkLogic/rest-api/models/resource-model-query.xqy"; ',
  		'rsrcmodqry:list-sources("xml", ())'
  	)
  )

  return 
   xdmp:xslt-invoke("/ext/geonames/xsl/resource-list-transform.xsl",
    document {
      element rapi:Config {
        $resources,
        $options
      } 
    }
  ) 
};
