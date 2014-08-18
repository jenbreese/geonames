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
	let $country-code as xs:string := map:get($params, "country-code")
  return geo:enrich($doc, $country-code)
};

declare function geo:post(
  $context as map:map,
  $params as map:map,
  $input as document-node()*)
  as document-node()*
{
  let $doc := <doc>{ map:get($params, "text") }</doc>
  let $country-code as xs:string := map:get($params, "country-code")
  return geo:enrich($doc, $country-code)
};


declare function geo:enrich($doc as element(doc), $country-code as xs:string)
  as document-node()
{
  let $geos :=
    cts:search(
      fn:collection($country-code),
      cts:reverse-query($doc),
      "unfiltered"
    )

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

declare function geo:collapse-spans($x as node()?, $map as map:map?)
{
  if (fn:empty($x)) then
    ()
  else
  typeswitch ($x)

  case element(html:span) return
    (: if there's one node child and it's an element, we have nested spans :)
    if (fn:count($x/node()) = 1 and fn:exists($x/element())) then
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