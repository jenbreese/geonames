xquery version "1.0-ml";
import module namespace alert = "http://marklogic.com/xdmp/alert" at "/MarkLogic/alert.xqy";

let $action := 
  alert:make-action(
    "geonames:log", 
    "log reverse query to errorLog.txt",
    xdmp:modules-database(),
    xdmp:modules-root(), 
    "/xqy/alerts/action/geonames-alert.xqy",
    <alert:options>put anything here</alert:options> 
  )
return alert:action-insert("geonames-alert-config", $action)