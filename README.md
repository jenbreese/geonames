MarkLogic Geonames
==========

### Prerequisites
--------
1. [MarkLogic](http://developer.marklogic.com/products)
2. [JDK 1.7](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html) 
3. [Gradle 2.0](http://www.gradle.org/downloads)
4. [MarkLogic Content Pump](http://developer.marklogic.com/products)
4. ml-java project

### Instructions
1. gradle mlInstallApp
2. gradle mlConfigureApp

Make sure to remove any CPF domains from the geonames-content database

DOWNLOADING/LOADING GEONAMES
All data is downloaded into a directory called data/.
headers.sh is used to put the the tab delimited header on the country files that are downloaded.  By default they are not included.  

1) ./load-geonames-meta.sh
This will download and load all the geonames metadata into MarkLogic: countryCodes, admin codes, feature codes

2) ./download-geonames.sh [2 character ISO Country Code | all]
Examples: 
./download-geonames.sh SC  
Downloads the geonames for Seychelles (a small data set)

./download-geonames.sh FR
Downloads and Loads the geonames for France

./download-geonames.sh all
Downloads every country

3) ./load-geonames.sh [2 character ISO Country Code | all]
Examples:
./load-geonames.sh SC 
Loads the Seychellles geonames dataset into MarkLogic via mlcp

./load-geonames.sh all
Loads all countries into MarkLogic


API: http://<HOST>:8010/v1/resources/api
geo-enrich: http://<host>:8010/v1/resources/geo-enrich

Example: http://<host>:8010/v1/resources/geo-enrich?rs:text=I%20live%20in%20Paris%20and%20Normandy&rs:country-code=FR
