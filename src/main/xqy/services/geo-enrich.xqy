xquery version "1.0-ml";

module namespace geo = "http://marklogic.com/rest-api/resource/geo-enrich";

import module namespace libg = "http://geonames.org" at "/ext/geonames/lib/lib-geonames.xqy";

declare namespace fc = "http://geonames.org/featureCodes";
declare namespace gn = "http://geonames.org";
declare namespace html = "http://www.w3.org/1999/xhtml";

declare option xdmp:mapping "false";


declare function geo:get(
  $context as map:map,
  $params  as map:map)
  as document-node()*
{
	let $doc := <doc>{ map:get($params, "text") }</doc>
	let $country-codes as xs:string? := map:get($params, "country-code")
  let $country-codes :=
    for $code in $country-codes
    return fn:tokenize($code, ",")

  let $feature-types as xs:string? := map:get($params, "feature-type")
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
      cts:search(/gn:geoname, cts:reverse-query($doc), "unfiltered")

  let $doc := geo:highlight($doc, $geos)
  let $doc := geo:collapse-spans($doc, ())

  let $summary := geo:geonames-summary($doc)

  return
    document {
      <html xmlns="http://www.w3.org/1999/xhtml">
        <head />
        <body>
          <p xmlns="http://www.w3.org/1999/xhtml">{ $doc/node() }</p>
        </body>
      </html>
      ,
      $summary
    }
};

declare function geo:post(
  $context as map:map,
  $params as map:map,
  $input as document-node()*)
  as document-node()*
{
  let $doc := $input/*[1]

  let $country-codes as xs:string? := map:get($params, "country-code")
  let $country-codes :=
    for $code in $country-codes
    return fn:tokenize($code, ",")

  let $feature-types as xs:string? := map:get($params, "feature-type")
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
      cts:search(/gn:geoname, cts:reverse-query($doc), "unfiltered")

  let $doc := geo:highlight($doc, $geos)
  let $doc := geo:collapse-spans($doc, ())

  let $summary := geo:geonames-summary($doc)

  return document { $doc, $summary }
};

declare function geo:highlight($doc as element(), $geos as item()*)
  as element()
{
  if (fn:empty($geos)) then
    $doc
  else
    let $geos :=
      for $geo in $geos
      return
        if ($geo instance of document-node()) then
          $geo/geo:geoname
        else
          $geo
    let $text-id-map := map:map()
    let $_ :=
      for $geo in $geos
      let $id := $geo/fn:data(gn:id)
      let $texts := $geo/gn:query//fn:data(cts:text)
      let $texts := libg:filter-names($texts)
      for $text in $texts
      return map:put($text-id-map, $text, ($id, map:get($text-id-map, $text)))

    let $texts := map:keys($text-id-map)
    let $texts :=
      for $text in $texts
      order by fn:string-length($text) descending
      return $text

    let $_ :=
      for $text in $texts
      let $ids := map:get($text-id-map, $text)
      let $ids :=
        for $id in $ids
        order by xs:integer($id)
        return $id
      return
        xdmp:set($doc,
          cts:highlight(
            $doc,
            cts:word-query($text, "exact"),
            <span xmlns="http://www.w3.org/1999/xhtml"
              class="{ if (fn:count($ids) > 1) then "many" else "one" }"
              geonames-id="{ fn:string-join($ids, ",") }">{ $cts:text }</span>
          )
        )

    return $doc
};

declare function geo:geonames-summary($doc)
{
  let $spans := $doc//html:span[@geonames-id]
  (: construct a map of geonames-ids and the number of times they occur in the document :)
  let $id-count-map := map:map()
  let $_ :=
    for $span in $spans
    let $ids := fn:tokenize($span/fn:data(@geonames-id), ",")
    for $id in $ids
    return
      if (map:contains($id-count-map, $id)) then
        map:put($id-count-map, $id, map:get($id-count-map, $id) + 1)
      else
        map:put($id-count-map, $id, 1)

  (: get the inverse map, count to id :)
  let $count-id-map := -$id-count-map
  let $counts := map:keys($count-id-map)

  (: sort the counts from high to low so that we can show the results in count order :)
  let $counts :=
    for $count in $counts
    order by xs:integer($count) descending
    return $count

  (: construct a map of feature-code/name (aka feature-type) to the ids of that feature type :)
  let $feature-type-id-map := map:map()
  let $_ :=
    for $id in map:keys($id-count-map)
    let $feature-type := /gn:geoname[gn:id = $id]/fc:feature-code/fn:data(fc:name)
    let $feature-type :=
      if (fn:string-length($feature-type) = 0) then
        "NO FEATURE CODE NAME ?"
      else
        $feature-type
    return
      map:put($feature-type-id-map, $feature-type,
        ($id, map:get($feature-type-id-map, $feature-type)))

  return
    element summary {
      element id-counts {
        for $count in $counts
        let $ids := map:get($count-id-map, $count)
        for $id in $ids
        let $name := /gn:geoname[gn:id = $id]/gn:names/gn:name[@tag = "main"]/fn:string(.)
        return
          element geoname {
            element geonames-id { $id },
            element count { $count },
            /gn:geoname[gn:id = $id]
          }
      },
      element by-feature-type {
        for $feature-type in map:keys($feature-type-id-map)
        let $ids := map:get($feature-type-id-map, $feature-type)
        return
          element feature-type {
            element name { $feature-type },
            element geonames-ids {
              for $id in $ids
              return
                element geonames-id {
                  $id
                }
            }
          }
      }
    }

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
          attribute geonames-id { fn:string-join(($x/@geonames-id, $inner/@geonames-id), ",") },
          attribute class { "many" },
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