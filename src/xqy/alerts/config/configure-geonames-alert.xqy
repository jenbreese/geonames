(: run this a user with the alert-admin role :)
xquery version "1.0-ml";
import module namespace alert = "http://marklogic.com/xdmp/alert" at "/MarkLogic/alert.xqy";

let $config := 
  alert:make-config(
      "geonames-alert-config",
      "Alerts for Geonames",
      "Alerting config for my app",
        <alert:options/> 
  )
return alert:config-insert($config)