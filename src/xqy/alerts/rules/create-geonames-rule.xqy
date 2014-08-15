xquery version "1.0-ml";
import module namespace alert = "http://marklogic.com/xdmp/alert" at "/MarkLogic/alert.xqy";

let $rule := 
  alert:make-rule(
    "BlueGutCreek", 
    "hello world rule",
    0, (: equivalent to xdmp:user(xdmp:get-current-user()) :)
    cts:query(
      <cts:word-query xmlns:cts="http://marklogic.com/cts">
        <cts:text xml:lang="en">Blue Gut Creek</cts:text>
      </cts:word-query>
    ),
    "geonames:log",
    <alert:options/> 
  )
return alert:rule-insert("geonames-alert-config", $rule)