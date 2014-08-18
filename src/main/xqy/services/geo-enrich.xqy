xquery version "1.0-ml";

module namespace geo = "http://marklogic.com/rest-api/resource/geo-enrich";

declare namespace gn = "http://geonames.org";
declare namespace html = "http://www.w3.org/1999/xhtml";

declare option xdmp:mapping "false";

declare function geo:get(
  $context as map:map,
  $params  as map:map)
  as document-node()*
{
	let $doc := <doc>{ map:get($params, "text") }</doc>
	let $country-codes as xs:string := map:get($params, "country-code")
  let $country-codes :=
    for $code in $country-codes
    return fn:tokenize($code, ",")

  let $feature-types as xs:string := map:get($params, "feature-type")
  let $feature-types :=
    for $ft in $feature-types
    return fn:tokenize($ft, ",")

  let $geos :=
    if (fn:exists($country-codes) and fn:exists($feature-types)) then
      cts:search(/gn:geoname[gn:country-code = $country-codes and gn:feature-code/gn:name = $feature-types],
        cts:reverse-query($doc), "unfiltered")
    else if (fn:exists($country-codes)) then
      cts:search(/gn:geoname[gn:country-code = $country-codes],
        cts:reverse-query($doc), "unfiltered")
    else if (fn:exists($feature-types)) then
      cts:search(/gn:geoname[gn:feature-code/gn:name = $feature-types],
        cts:reverse-query($doc), "unfiltered")
    else
      cts:search(doc(), cts:reverse-query($doc), "unfiltered")

  let $_ :=
    for $geo in $geos
    return
      xdmp:set($doc,
        cts:highlight(
          $doc,
          cts:query($geo/gn:geoname/gn:query/element()),
          <span xmlns="http://www.w3.org/1999/xhtml"
            geonames-id="{ $geo/gn:geoname/gn:id/text() }">{ $cts:text }</span>
        )
      )

  let $doc := geo:collapse-spans($doc, ())

  return
    document {
      <html xmlns="http://www.w3.org/1999/xhtml">
        <head />
        <body>
          <p xmlns="http://www.w3.org/1999/xhtml">{ $doc/node() }</p>
        </body>
      </html>
    }
};

declare function geo:post(
  $context as map:map,
  $params as map:map,
  $input as document-node()*)
  as document-node()*
{
  let $doc := $input/*[1]

  let $country-codes as xs:string := map:get($params, "country-code")
  let $country-codes :=
    for $code in $country-codes
    return fn:tokenize($code, ",")

  let $feature-types as xs:string := map:get($params, "feature-type")
  let $feature-types :=
    for $ft in $feature-types
    return fn:tokenize($ft, ",")

  let $geos :=
    if (fn:exists($country-codes) and fn:exists($feature-types)) then
      cts:search(/gn:geoname[gn:country-code = $country-codes and gn:feature-code/gn:name = $feature-types],
        cts:reverse-query($doc), "unfiltered")
    else if (fn:exists($country-codes)) then
      cts:search(/gn:geoname[gn:country-code = $country-codes],
        cts:reverse-query($doc), "unfiltered")
    else if (fn:exists($feature-types)) then
      cts:search(/gn:geoname[gn:feature-code/gn:name = $feature-types],
        cts:reverse-query($doc), "unfiltered")
    else
      cts:search(doc(), cts:reverse-query($doc), "unfiltered")

  let $_ :=
    for $geo in $geos
    return
      xdmp:set($doc,
        cts:highlight(
          $doc,
          cts:query($geo/gn:geoname/gn:query/element()),
          <span xmlns="http://www.w3.org/1999/xhtml"
            geonames-id="{ $geo/gn:geoname/gn:id/text() }">{ $cts:text }</span>
        )
      )

  let $doc := geo:collapse-spans($doc, ())

  return document { $doc }
};


declare function geo:collapse-spans($x as node()?, $map as map:map?)
{
  if (fn:empty($x)) then
    ()
  else
  typeswitch ($x)

  case element(html:span) return
    (: if there's one node child and it's a span element, we have nested spans :)
    if (fn:count($x/node()) = 1 and fn:exists($x/element()) and fn:local-name($x/element()) = "span") then
      let $inner := geo:collapse-spans($x/element(), $map)
      return
        <span xmlns="http://www.w3.org/1999/xhtml">
        {
          attribute { "geonames-id" } { fn:string-join(($x/@geonames-id, $inner/@geonames-id), ",") },
          $inner/node()
        }
        </span>
    else
      geo:preserve-and-recurse($x, $map)

  case element() return
    geo:preserve-and-recurse($x, $map)

  case document-node() return
    geo:collapse-spans($x/*[1], $map)

  case processing-instruction() return
    $x

  case comment() return
    $x

  case text() return
    $x

  default return
    geo:preserve-and-recurse($x, $map)
};


declare function geo:transform-children($x as element(), $arg) as node()*
{
  for $z in $x/node()
  return geo:collapse-spans($z, $arg)
};

declare function geo:preserve-and-recurse($x as element(), $arg) as element()
{
  element { fn:node-name($x) }
  {
    $x/attribute::*,
    geo:transform-children($x, $arg)
  }
};