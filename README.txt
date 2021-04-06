The rif.patch and associated rif.xsl and activities.xml are used to enable the RIF-CS capability on Geonetwork 2.10.1.
The rif-party.xsl and parties.xml are only required for the party records integration with Trove (details in step 3 below).

1. Apply rif.patch to Geonetwork 2.10.1 source (https://github.com/geonetwork/core-geonetwork/tree/2.10.1).

2. Copy activities.xml and rif.xsl to web/src/main/webapp/WEB-INF/data/config/schema_plugins/iso19139/convert. 

3. For party records integration with Trove:

- Replace ISILCode variable value in both rif.xsl and rif-party.xsl with your organisation's ISIL code. The default value is 'AU-WS:AUS' for AuScope. 

- Copy rif-party.xsl to web/src/main/webapp/WEB-INF/data/config/schema_plugins/iso19139/convert

- Edit web/src/main/webapp/WEB-INF/config-oai-prefixes.xml and add the following entry:
<schema prefix="rif-party" nsUrl="http://ands.org.au/standards/rif-cs/registryObjects" schemaLocation="http://services.ands.org.au/documentation/rifcs/1.3/schema/registryObjects.xsd"/>

- Provide Trove with the OAIPMH URL to harvest the party records with metadataPrefix=rif-party. E.g. for Auscope Portal, this is: http://portal.auscope.org/geonetwork/srv/en/oaipmh?verb=ListRecords&metadataPrefix=rif-party

- Once the party records are available in Trove, issue SRU request with your ISIL code and save the result into parties.xml. For Auscope Portal, this is: http://www.nla.gov.au/apps/srw/search/peopleaustralia?query=oai.set+%3D+%22AU-WS:AUS%22&version=1.1&operation=searchRetrieve&recordSchema=http%3A%2F%2Fands.org.au%2Fstandards%2Frif-cs%2FregistryObjects&maximumRecords=100&startRecord=1&resultSetTTL=300&recordPacking=xml&recordXPath=&sortKeys=

You would need to adjust the maximumRecords in the above request if you have more than 100 records. 

- Copy parties.xml to web/src/main/webapp/WEB-INF/data/config/schema_plugins/iso19139/convert. 

- The next time ANDS harvests the party records, they will be updated with Trove identifiers.

More information: https://www.seegrid.csiro.au/wiki/Infosrvices/AndsTroveIntegration

4. To use mysql on Linux with Geonetwork 2.10.1, apply mysql.patch.

5. To use HTML5 GUI, apply wfsharvest.patch.

6. Build source and deploy to server

7. Post-deployment configuration