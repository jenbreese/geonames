xquery version "1.0-ml";

declare namespace alert = "http://marklogic.com/xdmp/alert";

declare variable $alert:config-uri as xs:string external;
declare variable $alert:doc as node() external;
declare variable $alert:rule as element(alert:rule) external;
declare variable $alert:action as element(alert:action) external;

xdmp:log("ALERT"), 
xdmp:log($alert:config-uri),
xdmp:log(fn:base-uri($alert:doc)),
xdmp:log(xdmp:quote($alert:doc)),
xdmp:log(xdmp:quote($alert:rule)),
xdmp:log(xdmp:quote($alert:action))