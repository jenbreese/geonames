MarkLogic Geonames
==========
The MarkLogic geonames project is a simple location extractor and enrichment service that uses MarkLogic and the [geonames](www.geonames.org) gazetteer.  

### Prerequisites
--------
1. [MarkLogic](http://developer.marklogic.com/products)
2. [JDK 1.7](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html) 
3. [Gradle 2.0](http://www.gradle.org/downloads)
4. [MarkLogic Content Pump](http://developer.marklogic.com/products)
5. ml-java project
6. Linux (tested with CentOS 6)

### Instructions
1. ./ml-java/gradle publish
2. ./geonames/gradle mlInstallApp
3. ./geonames/gradle mlConfigureApp
4. Remove any CPF domains from the geonames-content database

### Downloading Geonames

The geonames data is downloaded into a directory called data/.  The geonames metadata needs to be downloaded and loaded first before downloading any of the country data.  There is a script called headers.sh that is used to put the the tab delimited header on the country files that are downloaded.  

1) ./load-geonames-meta.sh
* This will download and load all the geonames metadata into MarkLogic: countryCodes, admin codes, feature codes

2) ./download-geonames.sh [2 character ISO Country Code | all]
> ./download-geonames.sh SC  
 * Downloads the geonames for Seychelles (a small data set)

> ./download-geonames.sh FR
 * Downloads and Loads the geonames for France

> ./download-geonames.sh all
 * Downloads every country

### Loading Geonames into MarkLogic

./load-geonames.sh [2 character ISO Country Code | all]
> ./load-geonames.sh SC 
 * Loads the Seychellles geonames dataset into MarkLogic via mlcp

> ./load-geonames.sh all
 * Loads all countries into MarkLogic

### API
* Geonames API - http://<HOST>:8010/v1/resources/api
* geo-enrich - http://<host>:8010/v1/resources/geo-enrich
  * http://<host>:8010/v1/resources/geo-enrich?rs:text=I%20live%20in%20Paris%20and%20Normandy&rs:country-code=FR
