This repository will download and load the geonames.org gazetteer data into MarkLogic and set up an endpoint for simple geo entity extraction and enrichment. 

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

