<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:gml="http://www.opengis.net/gml" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:geonet="http://www.fao.org/geonetwork" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns:ns1="http://www.loc.gov/zing/srw/" xmlns:ns2="http://ands.org.au/standards/rif-cs/registryObjects" xmlns="http://ands.org.au/standards/rif-cs/registryObjects">
	<!-- stylesheet to convert iso19139 in OAI-PMH ListRecords response to RIF-CS
-->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<!-- the originating source, need to be configured for each deployment-->
	<xsl:param name="origSource" select="'http://portal.auscope.org'"/>
	<!-- the registry object group, need to be configured for each deployment
-->
	<xsl:param name="group" select="'AuScope'"/>
	<!-- deployment specific link to user interface to retrieve collections, 
if this parameter value is empty, the url to the record in Geonetwork is formed to be the resource location

-->
	<xsl:param name="discoveryLink" select="'http://portal.auscope.org/gmap.html'"/>
	<!-- xsl:param name="discoveryLink" select="''"/-->
	<!-- Manually created RIF-CS activities  -->
	<xsl:variable name="activities" select="document('activities.xml')"/>
	<!-- Replace with your organisation ISIL code if Trove integration is required. Below is the ISIL code for AuScope -->
	<xsl:variable name="ISILCode" select="'AU-WS:AUS'"/>
	<!-- Trove party records from SRU request -->
	<xsl:variable name="parties" select="document('parties.xml')"/>
	<!-- Comment out the above and use this if there is no parties.xml 
    <xsl:variable name="parties"/> -->
	<!--xsl:template match="oai:metadata|oai:ListRecords|oai:record">
   	<xsl:apply-templates/>
</xsl:template-->
	<!--xsl:template match="oai:OAI-PMH">
	<xsl:element name="registryObjects">
		<xsl:attribute name="xsi:schemaLocation">
        	<xsl:text>http://ands.org.au/standards/iso2146/registryObjects http://services.ands.org.au/home/orca/schemata/registryObjects.xsd</xsl:text>
		</xsl:attribute>
		<xsl:apply-templates/>
	</xsl:element>
</xsl:template-->
	<xsl:template match="root">
		<xsl:apply-templates/>
	</xsl:template>
	<!-- RIFCS 1.3 -->
	<xsl:template match="gmd:MD_Metadata">
		<xsl:element name="registryObjects">
			<xsl:attribute name="xsi:schemaLocation"><xsl:text>http://ands.org.au/standards/rif-cs/registryObjects http://services.ands.org.au/documentation/rifcs/schema/registryObjects.xsd</xsl:text></xsl:attribute>
			<xsl:apply-templates select="." mode="collection"/>
		</xsl:element>
	</xsl:template>
		<xsl:template match="gmd:voice[not(@gco:nilReason)]">
	    <xsl:variable name="voice" select="./gco:CharacterString"/>
		<xsl:if test="normalize-space($voice)">
			<xsl:element name="physical">
				<xsl:element name="addressPart">
					<xsl:attribute name="type"><xsl:text>telephoneNumber</xsl:text></xsl:attribute>
					<xsl:value-of select="translate(translate($voice,'+',''),' ','-')"/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:facsimile[not(@gco:nilReason)]">
	    <xsl:variable name="facsimile" select="./gco:CharacterString"/>
		<xsl:if test="normalize-space($facsimile)">
			<xsl:element name="physical">
				<xsl:element name="addressPart">
					<xsl:attribute name="type"><xsl:text>faxNumber</xsl:text></xsl:attribute>
					<xsl:value-of select="translate(translate($facsimile,'+',''),' ','-')"/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:electronicMailAddress[not(@gco:nilReason)]">
        <xsl:variable name="email" select="./gco:CharacterString"/>
		<xsl:if test="normalize-space($email)">
			<xsl:element name="electronic">
				<xsl:attribute name="type"><xsl:text>email</xsl:text></xsl:attribute>
				<xsl:element name="value">
					<xsl:value-of select="$email"/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:organisationName[not(@gco:nilReason)]">
	    <xsl:variable name="organisationName" select="./gco:CharacterString"/>
		<xsl:if test="normalize-space($organisationName)">
			<xsl:element name="addressPart">
				<xsl:attribute name="type"><xsl:text>locationDescriptor</xsl:text></xsl:attribute>
				<xsl:value-of select="$organisationName"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:deliveryPoint[not(@gco:nilReason)]">
	    <xsl:variable name="deliveryPoint" select="./gco:CharacterString"/>
		<xsl:if test="normalize-space($deliveryPoint)">
			<xsl:element name="addressPart">
				<xsl:attribute name="type"><xsl:text>addressLine</xsl:text></xsl:attribute>
				<xsl:value-of select="$deliveryPoint"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:city[not(@gco:nilReason)]">
	    <xsl:variable name="city" select="./gco:CharacterString"/>
		<xsl:if test="normalize-space($city)">
			<xsl:element name="addressPart">
				<xsl:attribute name="type"><xsl:text>suburbOrPlaceOrLocality</xsl:text></xsl:attribute>
				<xsl:value-of select="$city"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:administrativeArea[not(@gco:nilReason)]">
	    <xsl:variable name="adminArea" select="./gco:CharacterString"/>
		<xsl:if test="normalize-space($adminArea)">
			<xsl:element name="addressPart">
				<xsl:attribute name="type"><xsl:text>stateOrTerritory</xsl:text></xsl:attribute>
				<xsl:value-of select="$adminArea"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:postalCode[not(@gco:nilReason)]">
	    <xsl:variable name="postalCode" select="./gco:CharacterString"/>
		<xsl:if test="normalize-space($postalCode)">
			<xsl:element name="addressPart">
				<xsl:attribute name="type"><xsl:text>postCode</xsl:text></xsl:attribute>
				<xsl:value-of select="$postalCode"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:country[not(@gco:nilReason)]">
	    <xsl:variable name="country" select="./gco:CharacterString"/>
		<xsl:if test="normalize-space($country)">
			<xsl:element name="addressPart">
				<xsl:attribute name="type"><xsl:text>country</xsl:text></xsl:attribute>
				<xsl:value-of select="$country"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:title">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="gmd:EX_GeographicBoundingBox">
		<xsl:if test="normalize-space(.)">
			<xsl:element name="spatial">
				<xsl:attribute name="type"><xsl:text>iso19139dcmiBox</xsl:text></xsl:attribute>
				<xsl:value-of select="concat('northlimit=',gmd:northBoundLatitude/gco:Decimal,'; southlimit=',gmd:southBoundLatitude/gco:Decimal,'; westlimit=',gmd:westBoundLongitude/gco:Decimal,'; eastLimit=',gmd:eastBoundLongitude/gco:Decimal)"/>
				<xsl:apply-templates select="../gmd:verticalElement"/>
				<xsl:text>; projection=WGS84</xsl:text>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:verticalElement">
		<xsl:value-of select="concat('; uplimit=',gmd:EX_VerticalExtent/gmd:maximumValue/gco:Real,'; downlimit=',gmd:EX_VerticalExtent/gmd:minimumValue/gco:Real)"/>
	</xsl:template>
	<xsl:template match="gmd:description[not(@gco:nilReason)]">
		<xsl:element name="spatial">
			<xsl:attribute name="type"><xsl:text>text</xsl:text></xsl:attribute>
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="gml:coordinates">
		<xsl:element name="spatial">
			<xsl:attribute name="type"><xsl:text>gmlKmlPolyCoords</xsl:text></xsl:attribute>
			<xsl:call-template name="gmlToKml">
				<xsl:with-param name="coords" select="."/>
			</xsl:call-template>
		</xsl:element>
	</xsl:template>
	<xsl:template match="gmd:keyword">
		<xsl:call-template name="splitSubject">
			<xsl:with-param name="string" select="."/>
		</xsl:call-template>
	</xsl:template>
	<!-- mapping gmd:resourceConstraints/gmd:MD_LegalConstraints to RIF-CS rights  -->
	<xsl:template name="legalConstraints">
		<xsl:param name="legalConstraints"/>
		<xsl:param name="descriptionType"/>
		<xsl:variable name="codelist" select="document('../loc/en/codelists.xml')/codelists/codelist[@name = 'gmd:MD_RestrictionCode']"/>
		<xsl:for-each select="$legalConstraints/gmd:accessConstraints">
			<xsl:variable name="codevalue" select="./gmd:MD_RestrictionCode/@codeListValue"/>
			<xsl:choose>
				<!--
				manually created metadata from Geonetwork GUI has codevalue -
				gmd:MD_RestrictionCode/@codeListValue
			-->
				<xsl:when test="normalize-space($codevalue)">
					<xsl:element name="rights">
						<xsl:call-template name="createRights">
							<xsl:with-param name="descriptionType" select="$descriptionType"/>
							<xsl:with-param name="rightsValue" select="concat($codelist/entry[code = $codevalue]/label, ': ', $codelist/entry[code = $codevalue]/description)"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:when>
				<!--
				harvested metadata doesn't have codevalue, the accessConstrain is
				plain text - gmd:accessConstraints/gco:CharacterString
			-->
				<xsl:otherwise>
					<xsl:if test=".!='NONE'">
						<xsl:element name="rights">
							<xsl:call-template name="createRights">
								<xsl:with-param name="descriptionType" select="$descriptionType"/>
								<xsl:with-param name="rightsValue" select="."/>
							</xsl:call-template>
						</xsl:element>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<!--
		manually created metadata from Geonetwork GUI may have
		useConstraints
	-->
		<xsl:for-each select="$legalConstraints/gmd:useConstraints">
			<xsl:variable name="codevalue" select="./gmd:MD_RestrictionCode/@codeListValue"/>
			<xsl:if test="normalize-space($codevalue)">
				<xsl:element name="rights">
					<xsl:call-template name="createRights">
						<xsl:with-param name="descriptionType" select="$descriptionType"/>
						<xsl:with-param name="rightsValue" select="concat($codelist/entry[code = $codevalue]/label, ': ', $codelist/entry[code = $codevalue]/description)"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		<!--
		manually created metadata from Geonetwork GUI may have
		otherConstraints
	-->
		<xsl:if test="$legalConstraints/gmd:otherConstraints[not(@gco:nilReason)]">
			<xsl:element name="rights">
				<xsl:call-template name="createRights">
					<xsl:with-param name="descriptionType" select="$descriptionType"/>
					<xsl:with-param name="rightsValue" select="$legalConstraints/gmd:otherConstraints"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
		<!--
		harvested metadata may have accessConstrain as NONE - gmd:accessConstraints/gco:CharacterString
	-->
		<xsl:if test="$legalConstraints/gmd:accessConstraints='NONE'">
			<xsl:element name="rights">
				<xsl:choose>
					<xsl:when test="$descriptionType='rights'">
						<xsl:element name="rightsStatement">
							<xsl:value-of select="'There are no access constraints associated with this collection.'"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="accessRights">
							<xsl:value-of select="'There are no access rights associated with this service.'"/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<!-- Create either rightsStatement or accessRights -->
	<xsl:template name="createRights">
		<xsl:param name="descriptionType"/>
		<xsl:param name="rightsValue"/>
		<xsl:choose>
			<xsl:when test="$descriptionType='accessRights'">
				<xsl:element name="accessRights">
					<xsl:value-of select="$rightsValue"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="rightsStatement">
					<xsl:value-of select="$rightsValue"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- concat multiple otherConstraint into one string  -->
	<xsl:template match="gmd:otherConstraints">
		<xsl:param name="position" select="0"/>
		<xsl:param name="combined" select="''"/>
		<xsl:variable name="size" select="count(.)"/>
		<xsl:variable name="currentPosition" select="$position + 1"/>
		<xsl:variable name="newCombined" select="concat($combined, ' ', .[$currentPosition])"/>
		<xsl:choose>
			<xsl:when test="$position &lt;= $size">
				<xsl:apply-templates select=".">
					<xsl:with-param name="position" select="$currentPosition"/>
					<xsl:with-param name="combined" select="$newCombined"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$newCombined"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="gmd:MD_TopicCategoryCode">
		<xsl:if test="normalize-space(.)">
			<xsl:element name="subject">
				<xsl:attribute name="type"><xsl:text>local</xsl:text></xsl:attribute>
				<xsl:value-of select="."/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:abstract">
		<xsl:param name="title"/>
		<xsl:element name="description">
			<xsl:attribute name="type"><xsl:text>brief</xsl:text></xsl:attribute>
			<xsl:choose>
				<xsl:when test=".!=''">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$title"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template match="srv:containsOperations">
		<xsl:element name="electronic">
			<xsl:attribute name="type"><xsl:text>other</xsl:text></xsl:attribute>
			<xsl:element name="value">
				<xsl:value-of select="srv:SV_OperationMetadata/srv:operationName"/>
			</xsl:element>
			<xsl:element name="arg">
				<xsl:attribute name="type"><xsl:text>string</xsl:text></xsl:attribute>
				<xsl:attribute name="required"><xsl:text>true</xsl:text></xsl:attribute>
				<xsl:attribute name="use"><xsl:text>keyValue</xsl:text></xsl:attribute>
				<xsl:value-of select="'request'"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="srv:coupledResource">
		<xsl:param name="serviceType"/>
		<xsl:param name="serviceVersion"/>
		<xsl:element name="electronic">
			<xsl:attribute name="type"><xsl:text>other</xsl:text></xsl:attribute>
			<xsl:element name="value">
				<xsl:value-of select="srv:SV_CoupledResource/gco:ScopedName"/>
			</xsl:element>
			<xsl:element name="arg">
				<xsl:attribute name="type"><xsl:text>string</xsl:text></xsl:attribute>
				<xsl:attribute name="required"><xsl:text>true</xsl:text></xsl:attribute>
				<xsl:attribute name="use"><xsl:text>keyValue</xsl:text></xsl:attribute>
				<xsl:choose>
					<xsl:when test="$serviceType='WFS' or $serviceType='wfs'">
						<xsl:value-of select="'typeName'"/>
					</xsl:when>
					<xsl:when test="$serviceType='WMS' or $serviceType='wms'">
						<xsl:value-of select="'layers'"/>
					</xsl:when>
					<xsl:when test="$serviceType='WCS' or $serviceType='wcs'">
						<xsl:if test="$serviceVersion='1.0.0'">
							<xsl:value-of select="'coverage'"/>
						</xsl:if>
						<xsl:if test="$serviceVersion='1.1.0'">
							<xsl:value-of select="'identifier'"/>
						</xsl:if>
					</xsl:when>
				</xsl:choose>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- For service and collection records, add relatedInfo to relevant OGC standard -->
	<xsl:template name="addRelatedInfo">
		<xsl:param name="url"/>
		<xsl:choose>
			<xsl:when test="contains($url, '/wfs')">
				<xsl:element name="relatedInfo">
					<xsl:attribute name="type"><xsl:text>reuseInformation</xsl:text></xsl:attribute>
					<xsl:element name="identifier">
						<xsl:attribute name="type"><xsl:text>uri</xsl:text></xsl:attribute>
						<xsl:value-of select="'http://www.opengeospatial.org/standards/wfs'"/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:when test="contains($url, '/wms')">
				<xsl:element name="relatedInfo">
					<xsl:attribute name="type"><xsl:text>reuseInformation</xsl:text></xsl:attribute>
					<xsl:element name="identifier">
						<xsl:attribute name="type"><xsl:text>uri</xsl:text></xsl:attribute>
						<xsl:value-of select="'http://www.opengeospatial.org/standards/wms'"/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:when test="contains($url, '/wcs')">
				<xsl:element name="relatedInfo">
					<xsl:attribute name="type"><xsl:text>reuseInformation</xsl:text></xsl:attribute>
					<xsl:element name="identifier">
						<xsl:attribute name="type"><xsl:text>uri</xsl:text></xsl:attribute>
						<xsl:value-of select="'http://www.opengeospatial.org/standards/wcs'"/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:when test="contains($url, '/csw')">
				<xsl:element name="relatedInfo">
					<xsl:attribute name="type"><xsl:text>reuseInformation</xsl:text></xsl:attribute>
					<xsl:element name="identifier">
						<xsl:attribute name="type"><xsl:text>uri</xsl:text></xsl:attribute>
						<xsl:value-of select="'http://www.opengeospatial.org/standards/specifications/catalog'"/>
					</xsl:element>
				</xsl:element>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- For service and collection records, make sure location points to getCapabilities -->
	<xsl:template name="buildGetCapabilities">
		<xsl:param name="baseURL"/>
		<xsl:choose>
			<xsl:when test="ends-with($baseURL, '?')">
				<xsl:choose>
					<xsl:when test="ends-with($baseURL, '/wms')">
						<xsl:value-of select="concat($baseURL, 'service=WMS&amp;request=GetCapabilities')"/>
					</xsl:when>
					<xsl:when test="ends-with($baseURL, '/wfs')">
						<xsl:value-of select="concat($baseURL, 'service=WFS&amp;request=GetCapabilities')"/>
					</xsl:when>
					<xsl:when test="ends-with($baseURL, '/wcs')">
						<xsl:value-of select="concat($baseURL, 'service=WCS&amp;request=GetCapabilities')"/>
					</xsl:when>
					<xsl:when test="ends-with($baseURL, '/csw')">
						<xsl:value-of select="concat($baseURL, 'service=CSW&amp;request=GetCapabilities')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$baseURL"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="ends-with($baseURL, '&amp;')">
				<xsl:choose>
					<xsl:when test="contains($baseURL, '/wms')">
						<xsl:value-of select="concat($baseURL, 'service=WMS&amp;request=GetCapabilities')"/>
					</xsl:when>
					<xsl:when test="contains($baseURL, '/wfs')">
						<xsl:value-of select="concat($baseURL, 'service=WFS&amp;request=GetCapabilities')"/>
					</xsl:when>
					<xsl:when test="contains($baseURL, '/wcs')">
						<xsl:value-of select="concat($baseURL, 'service=WCS&amp;request=GetCapabilities')"/>
					</xsl:when>
					<xsl:when test="contains($baseURL, '/csw')">
						<xsl:value-of select="concat($baseURL, 'service=CSW&amp;request=GetCapabilities')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$baseURL"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="ends-with($baseURL, '/wfs')">
				<xsl:value-of select="concat($baseURL, '?service=WFS&amp;request=GetCapabilities')"/>
			</xsl:when>
			<xsl:when test="ends-with($baseURL, '/wms')">
				<xsl:value-of select="concat($baseURL, '?service=WMS&amp;request=GetCapabilities')"/>
			</xsl:when>
			<xsl:when test="ends-with($baseURL, '/wcs')">
				<xsl:value-of select="concat($baseURL, '?service=WCS&amp;request=GetCapabilities')"/>
			</xsl:when>
			<xsl:when test="ends-with($baseURL, '/csw')">
				<xsl:value-of select="concat($baseURL, '?service=CSW&amp;request=GetCapabilities')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$baseURL"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Insert Trove identifier into party records -->
	<xsl:template name="insertTroveId">
		<xsl:param name="key"/>
		<xsl:for-each select="$parties/ns1:searchRetrieveResponse/ns1:records/ns1:record">
			<xsl:variable name="party" select="./ns1:recordData/ns2:registryObjects/ns2:registryObject/ns2:party"/>
			<xsl:variable name="localId" select="$party/ns2:identifier[@type=$ISILCode]"/>
			<!-- There are 2 "AU-WS:AUS" entries - 1 is local key, the other is search key in RDA 
           e.g.   <identifier type="AU-WS:AUS">http://services.ands.org.au/home/orca/rda/view.php?key=http://portal.auscope.org/Primary Industries and Resources SA (PIRSA)</identifier>
					<identifier type="AU-WS:AUS">http://portal.auscope.org/Primary Industries and Resources SA (PIRSA)</identifier>-->
			<xsl:if test="$localId!=''">
				<xsl:for-each select="$localId">
					<xsl:if test="$key=.">
						<xsl:variable name="troveId" select="$party/ns2:identifier[@type='AU-ANL:PEAU']"/>
						<xsl:if test="$troveId!=''">
							<xsl:element name="identifier">
								<xsl:attribute name="type"><xsl:text>AU-ANL:PEAU</xsl:text></xsl:attribute>
								<xsl:value-of select="$troveId"/>
							</xsl:element>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="gmd:MD_Metadata" mode="collection">
		<xsl:variable name="collectionUrl">
			<xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions[1]/gmd:MD_DigitalTransferOptions/gmd:onLine[1]/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
		</xsl:variable>
		<xsl:variable name="collection" select="gmd:identificationInfo/gmd:MD_DataIdentification"/>
		<!--
	CREATE COLLECTION OBJECT
-->
		<xsl:if test="gmd:identificationInfo/gmd:MD_DataIdentification">
			<xsl:variable name="ge" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement"/>
			<xsl:variable name="te" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement"/>
			<xsl:variable name="ve" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:verticalElement"/>
			<xsl:variable name="formattedFrom">
				<xsl:choose>
					<xsl:when test="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition">
						<xsl:value-of select="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition"/>
					</xsl:when>
					<xsl:when test="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:begin/gml:TimeInstant/gml:timePosition">
						<xsl:value-of select="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:begin/gml:TimeInstant/gml:timePosition"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="formattedTo">
				<xsl:choose>
					<xsl:when test="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition">
						<xsl:value-of select="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition"/>
					</xsl:when>
					<xsl:when test="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition">
						<xsl:value-of select="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="from">
				<xsl:choose>
					<xsl:when test="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition">
						<xsl:value-of select="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition"/>
					</xsl:when>
					<xsl:when test="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:begin/gml:TimeInstant/gml:timePosition">
						<xsl:value-of select="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:begin/gml:TimeInstant/gml:timePosition"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="to">
				<xsl:choose>
					<xsl:when test="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition">
						<xsl:value-of select="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition"/>
					</xsl:when>
					<xsl:when test="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition">
						<xsl:value-of select="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:element name="registryObject">
				<xsl:attribute name="group"><xsl:value-of select="$group"/></xsl:attribute>
				<xsl:element name="key">
					<xsl:value-of select="gmd:fileIdentifier/gco:CharacterString"/>
				</xsl:element>
				<xsl:element name="originatingSource">
					<xsl:value-of select="$origSource"/>
				</xsl:element>
				<xsl:element name="collection">
					<xsl:attribute name="type"><xsl:value-of select="'dataset'"/></xsl:attribute>
					<xsl:variable name="title" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title"/>
					<xsl:element name="identifier">
						<xsl:attribute name="type"><xsl:text>local</xsl:text></xsl:attribute>
						<xsl:value-of select="gmd:fileIdentifier/gco:CharacterString"/>
					</xsl:element>
					<xsl:element name="name">
						<xsl:attribute name="type"><xsl:text>primary</xsl:text></xsl:attribute>
						<xsl:element name="namePart">
							<xsl:value-of select="$title"/>
						</xsl:element>
					</xsl:element>
					<xsl:element name="location">
						<xsl:element name="address">
							<xsl:element name="electronic">
								<xsl:attribute name="type"><xsl:text>url</xsl:text></xsl:attribute>
								<xsl:element name="value">
									<xsl:variable name="url">
										<xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions[1]/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage[following-sibling::gmd:description = 'Point of truth URL of this metadata record']/gmd:URL"/>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="not($url='')">
											<!-- source has some duplicates, odd, possibly automated data (CSIRO bluenet)
-->
											<xsl:value-of select="$url"/>
										</xsl:when>
										<xsl:when test="not($discoveryLink='')">
											<xsl:value-of select="$discoveryLink"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat($origSource,'/geonetwork/srv/en/metadata.show?uuid=',gmd:fileIdentifier)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					<xsl:for-each select="$ge">
						<xsl:variable name="bbox" select="gmd:EX_GeographicBoundingBox"/>
						<xsl:if test="normalize-space($bbox)">
							<xsl:element name="coverage">
								<xsl:apply-templates select="$bbox"/>
								<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:description"/>
								<xsl:apply-templates select="$bbox/gmd:polygon/gml:Polygon/gml:exterior/gml:LinearRing/gml:coordinates[text()!='']"/>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="$te/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod">
						<xsl:if test="not($from='') and $formattedFrom=''">
							<xsl:element name="coverage">
								<xsl:element name="temporal">
									<xsl:choose>
										<xsl:when test="$from = $to or $to=''">
											<xsl:text>Time period: </xsl:text>
											<xsl:value-of select="$from"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Time period: </xsl:text>
											<xsl:value-of select="concat($from, ' to ', $to)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:element>
						</xsl:if>
					</xsl:if>
					<!-- related individual parties generated here -->
					<!-- Check for invalid individual name 'Web Operations Manager' of Geoscience Australia
-->
					<xsl:for-each-group select="descendant::gmd:CI_ResponsibleParty[gmd:individualName/gco:CharacterString!='' and not(gmd:role/gmd:CI_RoleCode/@codeListValue='')]" group-by="gmd:individualName/gco:CharacterString">
						<xsl:element name="relatedObject">
							<xsl:element name="key">
								<xsl:choose>
									<xsl:when test="current-grouping-key()='Web Operations Manager'">
										<xsl:value-of select="concat(current-grouping-key(), ' - ', ./gmd:organisationName)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="current-grouping-key()"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
							<xsl:for-each-group select="gmd:role" group-by="gmd:CI_RoleCode/@codeListValue">
								<xsl:variable name="code">
									<xsl:value-of select="current-grouping-key()"/>
								</xsl:variable>
								<xsl:variable name="codelist">
									<xsl:value-of select="substring-after(gmd:CI_RoleCode/@codeList, '#')"/>
								</xsl:variable>
								<xsl:variable name="url">
									<xsl:value-of select="substring-before(gmd:CI_RoleCode/@codeList, '#')"/>
								</xsl:variable>
								<xsl:element name="relation">
									<xsl:attribute name="type"><xsl:value-of select="$code"/></xsl:attribute>
								</xsl:element>
							</xsl:for-each-group>
						</xsl:element>
						<!-- related activities generated here -->
						<xsl:for-each select="$activities/registryObjects/registryObject">
							<xsl:variable name="registryObject" select="."/>
							<xsl:if test="./identifier!='' and contains($collectionUrl, ./identifier)">
								<xsl:element name="relatedObject">
									<xsl:element name="key">
										<xsl:value-of select="$registryObject/key"/>
									</xsl:element>
									<xsl:element name="relation">
										<xsl:attribute name="type"><xsl:text>hasAssociationWith</xsl:text></xsl:attribute>
									</xsl:element>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each-group>
					<!-- related organisational parties generated here -->
					<!-- Check for invalid individual name 'Web Operations Manager' of Geoscience Australia
-->
					<xsl:for-each-group select="descendant::gmd:CI_ResponsibleParty[gmd:organisationName/gco:CharacterString!='' and gmd:individualName/gco:CharacterString='' and not(gmd:role/gmd:CI_RoleCode/@codeListValue='')]" group-by="gmd:organisationName">
						<xsl:element name="relatedObject">
							<xsl:element name="key">
								<xsl:value-of select="current-grouping-key()"/>
							</xsl:element>
							<xsl:for-each-group select="gmd:role" group-by="gmd:CI_RoleCode/@codeListValue">
								<xsl:variable name="code">
									<xsl:value-of select="current-grouping-key()"/>
								</xsl:variable>
								<xsl:element name="relation">
									<xsl:attribute name="type"><xsl:value-of select="$code"/></xsl:attribute>
								</xsl:element>
							</xsl:for-each-group>
						</xsl:element>
						<xsl:for-each select="$activities/registryObjects/registryObject">
							<xsl:variable name="registryObject" select="."/>
							<xsl:if test="./identifier!='' and contains($collectionUrl, ./identifier)">
								<xsl:element name="relatedObject">
									<xsl:element name="key">
										<xsl:value-of select="$registryObject/key"/>
									</xsl:element>
									<xsl:element name="relation">
										<xsl:attribute name="type"><xsl:text>hasAssociationWith</xsl:text></xsl:attribute>
									</xsl:element>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each-group>
					<!-- related services -->
					<xsl:choose>
						<xsl:when test="contains($origSource, '/wfs')">
							<xsl:element name="relatedObject">
								<xsl:element name="key">
									<xsl:value-of select="'http://portal.auscope.org/WFS'"/>
								</xsl:element>
								<xsl:element name="relation">
									<xsl:attribute name="type"><xsl:text>hasAssociationWith</xsl:text></xsl:attribute>
								</xsl:element>
							</xsl:element>
							<!-- Add relatedInfo to relevant OGC service -->
							<xsl:call-template name="addRelatedInfo">
								<xsl:with-param name="url" select="$origSource"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="contains($origSource, '/wms')">
							<xsl:element name="relatedObject">
								<xsl:element name="key">
									<xsl:value-of select="'http://portal.auscope.org/WMS'"/>
								</xsl:element>
								<xsl:element name="relation">
									<xsl:attribute name="type"><xsl:text>hasAssociationWith</xsl:text></xsl:attribute>
								</xsl:element>
							</xsl:element>
							<!-- Add relatedInfo to relevant OGC service -->
							<xsl:call-template name="addRelatedInfo">
								<xsl:with-param name="url" select="$origSource"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="contains($origSource, '/wcs')">
							<xsl:element name="relatedObject">
								<xsl:element name="key">
									<xsl:value-of select="'http://portal.auscope.org/WCS'"/>
								</xsl:element>
								<xsl:element name="relation">
									<xsl:attribute name="type"><xsl:text>hasAssociationWith</xsl:text></xsl:attribute>
								</xsl:element>
							</xsl:element>
							<!-- Add relatedInfo to relevant OGC service -->
							<xsl:call-template name="addRelatedInfo">
								<xsl:with-param name="url" select="$origSource"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="contains($origSource, '/csw')">
							<xsl:element name="relatedObject">
								<xsl:element name="key">
									<xsl:value-of select="'http://portal.auscope.org/CSW'"/>
								</xsl:element>
								<xsl:element name="relation">
									<xsl:attribute name="type"><xsl:text>hasAssociationWith</xsl:text></xsl:attribute>
								</xsl:element>
							</xsl:element>
							<!-- Add relatedInfo to relevant OGC service -->
							<xsl:call-template name="addRelatedInfo">
								<xsl:with-param name="url" select="$origSource"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword"/>
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode"/>
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract">
						<xsl:with-param name="title" select="$title"/>
					</xsl:apply-templates>
					<xsl:choose>
						<xsl:when test="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints">
							<xsl:call-template name="legalConstraints">
								<xsl:with-param name="legalConstraints" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints"/>
								<xsl:with-param name="descriptionType" select="'rights'"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="rights">
								<xsl:element name="rightsStatement">
									<xsl:text>There are no access constraints associated with this collection.</xsl:text>
								</xsl:element>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		<!--
	CREATE SERVICE OBJECT
-->
		<xsl:if test="gmd:identificationInfo/srv:SV_ServiceIdentification">
			<xsl:variable name="ge" select="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:geographicElement"/>
			<xsl:variable name="te" select="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:temporalElement"/>
			<xsl:variable name="ve" select="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:verticalElement"/>
			<xsl:variable name="formattedFrom">
				<xsl:choose>
					<xsl:when test="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition">
						<xsl:value-of select="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition"/>
					</xsl:when>
					<xsl:when test="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:begin/gml:TimeInstant/gml:timePosition">
						<xsl:value-of select="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:begin/gml:TimeInstant/gml:timePosition"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="formattedTo">
				<xsl:choose>
					<xsl:when test="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition">
						<xsl:value-of select="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition"/>
					</xsl:when>
					<xsl:when test="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition">
						<xsl:value-of select="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="from">
				<xsl:choose>
					<xsl:when test="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition">
						<xsl:value-of select="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition"/>
					</xsl:when>
					<xsl:when test="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:begin/gml:TimeInstant/gml:timePosition">
						<xsl:value-of select="$te[1]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:begin/gml:TimeInstant/gml:timePosition"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="to">
				<xsl:choose>
					<xsl:when test="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition">
						<xsl:value-of select="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition"/>
					</xsl:when>
					<xsl:when test="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition">
						<xsl:value-of select="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:element name="registryObject">
				<xsl:attribute name="group"><xsl:value-of select="$group"/></xsl:attribute>
				<xsl:element name="key">
					<xsl:value-of select="gmd:fileIdentifier"/>
				</xsl:element>
				<xsl:element name="originatingSource">
					<xsl:value-of select="$origSource"/>
				</xsl:element>
				<xsl:element name="service">
					<xsl:attribute name="type"><xsl:value-of select="'search-http'"/></xsl:attribute>
					<xsl:variable name="title" select="gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:title"/>
					<xsl:element name="name">
						<xsl:attribute name="type"><xsl:text>primary</xsl:text></xsl:attribute>
						<xsl:element name="namePart">
							<xsl:value-of select="$title"/>
						</xsl:element>
					</xsl:element>
					<xsl:variable name="connectPoint" select="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations[1]/srv:SV_OperationMetadata/srv:connectPoint[1]/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
					<xsl:variable name="serviceUrl">
						<xsl:choose>
							<xsl:when test="$connectPoint=''">
								<xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions[1]/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$connectPoint"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:element name="location">
						<xsl:element name="address">
							<xsl:element name="electronic">
								<xsl:attribute name="type"><xsl:text>url</xsl:text></xsl:attribute>
								<xsl:element name="value">
									<xsl:choose>
										<xsl:when test="not($serviceUrl='')">
											<xsl:value-of select="$serviceUrl"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat($origSource,'/geonetwork/srv/en/metadata.show?uuid=',gmd:fileIdentifier)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:element>
							<xsl:element name="electronic">
								<xsl:attribute name="type"><xsl:text>other</xsl:text></xsl:attribute>
								<xsl:element name="value">
									<!-- OGC:WFS or OGC:WMS -->
									<xsl:value-of select="substring-after(gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType,':')"/>
								</xsl:element>
								<xsl:element name="arg">
									<xsl:attribute name="type"><xsl:text>string</xsl:text></xsl:attribute>
									<xsl:attribute name="required"><xsl:text>true</xsl:text></xsl:attribute>
									<xsl:attribute name="use"><xsl:text>keyValue</xsl:text></xsl:attribute>
									<xsl:value-of select="'service'"/>
								</xsl:element>
							</xsl:element>
							<xsl:element name="electronic">
								<xsl:attribute name="type"><xsl:text>other</xsl:text></xsl:attribute>
								<xsl:element name="value">
									<xsl:value-of select="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceTypeVersion"/>
								</xsl:element>
								<xsl:element name="arg">
									<xsl:attribute name="type"><xsl:text>string</xsl:text></xsl:attribute>
									<xsl:attribute name="required"><xsl:text>true</xsl:text></xsl:attribute>
									<xsl:attribute name="use"><xsl:text>keyValue</xsl:text></xsl:attribute>
									<xsl:value-of select="'version'"/>
								</xsl:element>
							</xsl:element>
							<xsl:apply-templates select="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations"/>
							<xsl:apply-templates select="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:coupledResource">
								<xsl:with-param name="serviceType" select="substring-after(gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType,':')"/>
								<xsl:with-param name="serviceVersion" select="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceTypeVersion"/>
							</xsl:apply-templates>
						</xsl:element>
					</xsl:element>
					<xsl:if test="not($serviceUrl='')">
						<xsl:call-template name="addRelatedInfo">
							<xsl:with-param name="url" select="$serviceUrl"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:for-each select="$ge">
						<xsl:variable name="bbox" select="./gmd:EX_GeographicBoundingBox"/>
						<xsl:if test="normalize-space($bbox)">
							<xsl:element name="coverage">
								<xsl:apply-templates select="$bbox"/>
								<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:description"/>
								<xsl:apply-templates select="$bbox/gmd:polygon/gml:Polygon/gml:exterior/gml:LinearRing/gml:coordinates[text()!='']"/>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="$te/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod">
						<xsl:if test="not($from='') and $formattedFrom=''">
							<xsl:element name="coverage">
								<xsl:element name="temporal">
									<xsl:choose>
										<xsl:when test="$from = $to or $to=''">
											<xsl:text>Time period: </xsl:text>
											<xsl:value-of select="$from"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Time period: </xsl:text>
											<xsl:value-of select="concat($from, ' to ', $to)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:element>
						</xsl:if>
					</xsl:if>
					<!-- related individual parties generated here -->
					<xsl:for-each-group select="descendant::gmd:CI_ResponsibleParty[gmd:individualName!='' and not(gmd:role/gmd:CI_RoleCode/@codeListValue='')]" group-by="gmd:individualName">
						<xsl:element name="relatedObject">
							<xsl:element name="key">
								<xsl:choose>
									<xsl:when test="current-grouping-key()='Web Operations Manager'">
										<xsl:value-of select="concat(current-grouping-key(), ' - ', ./gmd:organisationName)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="current-grouping-key()"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
							<xsl:for-each-group select="gmd:role" group-by="gmd:CI_RoleCode/@codeListValue">
								<xsl:variable name="code">
									<xsl:value-of select="current-grouping-key()"/>
								</xsl:variable>
								<xsl:variable name="codelist">
									<xsl:value-of select="substring-after(gmd:CI_RoleCode/@codeList, '#')"/>
								</xsl:variable>
								<xsl:variable name="url">
									<xsl:value-of select="substring-before(gmd:CI_RoleCode/@codeList, '#')"/>
								</xsl:variable>
								<xsl:element name="relation">
									<xsl:attribute name="type"><xsl:value-of select="$code"/></xsl:attribute>
								</xsl:element>
							</xsl:for-each-group>
						</xsl:element>
					</xsl:for-each-group>
					<!-- related organisational parties generated here -->
					<xsl:for-each-group select="descendant::gmd:CI_ResponsibleParty[gmd:organisationName!='' and gmd:individualName='' and not(gmd:role/gmd:CI_RoleCode/@codeListValue='')]" group-by="gmd:organisationName">
						<xsl:element name="relatedObject">
							<xsl:element name="key">
								<xsl:value-of select="current-grouping-key()"/>
							</xsl:element>
							<xsl:for-each-group select="gmd:role" group-by="gmd:CI_RoleCode/@codeListValue">
								<xsl:variable name="code">
									<xsl:value-of select="current-grouping-key()"/>
								</xsl:variable>
								<xsl:element name="relation">
									<xsl:attribute name="type"><xsl:value-of select="$code"/></xsl:attribute>
								</xsl:element>
							</xsl:for-each-group>
						</xsl:element>
					</xsl:for-each-group>
					<xsl:apply-templates select="gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword"/>
					<xsl:apply-templates select="gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode"/>
					<xsl:apply-templates select="gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:abstract">
						<xsl:with-param name="title" select="$title"/>
					</xsl:apply-templates>
					<xsl:choose>
						<xsl:when test="gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:resourceConstraints">
							<xsl:call-template name="legalConstraints">
								<xsl:with-param name="legalConstraints" select="gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints"/>
								<xsl:with-param name="descriptionType" select="'accessRights'"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="rights">
								<xsl:element name="accessRights">
									<xsl:text>There are no access rights associated with this service.</xsl:text>
								</xsl:element>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		<!-- Create all the associated party objects for individuals -->
		<!-- Check for invalid individual name 'Web Operations Manager' of Geoscience Australia
-->
		<xsl:for-each-group select="descendant::gmd:CI_ResponsibleParty[gmd:individualName/gco:CharacterString!='' and not(gmd:role/gmd:CI_RoleCode/@codeListValue='')]" group-by="gmd:individualName/gco:CharacterString">
			<xsl:element name="registryObject">
				<xsl:attribute name="group"><xsl:value-of select="$group"/></xsl:attribute>
				<xsl:element name="key">
					<xsl:choose>
						<xsl:when test="current-grouping-key()='Web Operations Manager'">
							<xsl:value-of select="concat(current-grouping-key(), ' - ', ./gmd:organisationName)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="current-grouping-key()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<xsl:element name="originatingSource">
					<xsl:value-of select="$origSource"/>
				</xsl:element>
				<xsl:element name="party">
					<xsl:choose>
						<xsl:when test="current-grouping-key()='Web Operations Manager' or current-grouping-key()='Records Section'">
							<xsl:attribute name="type"><xsl:text>administrativePosition</xsl:text></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="type"><xsl:text>person</xsl:text></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<!-- Insert Trove identifier for person type -->
					<xsl:if test="current-grouping-key()!='Web Operations Manager' and current-grouping-key()!='Records Section' and $parties!=''">
						<xsl:call-template name="insertTroveId">
							<xsl:with-param name="key" select="concat('http://portal.auscope.org/',current-grouping-key())"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:element name="name">
						<xsl:attribute name="type"><xsl:text>primary</xsl:text></xsl:attribute>
						<xsl:element name="namePart">
							<xsl:choose>
								<xsl:when test="current-grouping-key()='Web Operations Manager'">
									<xsl:value-of select="concat(current-grouping-key(), ' - ', ./gmd:organisationName)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="current-grouping-key()"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
					</xsl:element>
					<!-- to normalise parties within a single record we need to group them, obtain the fragment for each party with the most information, and at the same time cope with rubbish data. In the end the only way to cope is to ensure at least an organisation name, city, phone or fax exists (sigh)
-->
					<xsl:for-each select="current-group()">
						<xsl:sort select="count(gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/child::*) + count(gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/child::*)" data-type="number" order="descending"/>
                       <xsl:if test="gmd:organisationName[not(@gco:nilReason)] or gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city or gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone[gmd:voice or gmd:fax]">
						<xsl:element name="location">
							<xsl:element name="address">
								<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice"/>
								<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:facsimile"/>
								<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress"/>
								<xsl:if test="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/child::*">
									<xsl:element name="physical">
										<xsl:attribute name="type"><xsl:text>streetAddress</xsl:text></xsl:attribute>
										<xsl:apply-templates select="gmd:organisationName"/>
										<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:deliveryPoint"/>
										<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city"/>
										<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:administrativeArea[not(@gco:nilReason)]"/>
										<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode[not(@gco:nilReason)]"/>
										<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:country"/>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:element>
						</xsl:if>
					</xsl:for-each>
					<!-- xsl:element name="relatedObject">
					<xsl:element name="key">
						<xsl:value-of select="ancestor::gmd:MD_Metadata/gmd:fileIdentifier"/>
					</xsl:element>	

					<xsl:for-each-group select="gmd:role" group-by="gmd:CI_RoleCode/@codeListValue">
						<xsl:variable name="code">
							<xsl:value-of select="current-grouping-key()"/>
						</xsl:variable>
						
						<xsl:element name="relation">
							<xsl:attribute name="type">
								<xsl:value-of select="$code"/>
							</xsl:attribute>
						</xsl:element>	
					</xsl:for-each-group>
				</xsl:element-->
					<!-- related activity -->
					<xsl:for-each select="$activities/registryObjects/registryObject">
						<xsl:variable name="registryObject" select="."/>
						<xsl:if test="./identifier!='' and contains($collectionUrl, ./identifier)">
							<xsl:element name="relatedObject">
								<xsl:element name="key">
									<xsl:value-of select="$registryObject/key"/>
								</xsl:element>
								<xsl:element name="relation">
									<xsl:attribute name="type"><xsl:text>pointOfContact</xsl:text></xsl:attribute>
								</xsl:element>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
			<!-- only created Activity record for Collection -->
			<xsl:if test="$collection">
				<xsl:for-each select="$activities/registryObjects/registryObject">
					<xsl:variable name="registryObject" select="."/>
					<xsl:if test="./identifier!='' and contains($collectionUrl, ./identifier)">
						<xsl:apply-templates select="$registryObject" mode="copyAndChangeNS"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each-group>
		<!-- Create all the associated party objects for organisations -->
		<!-- Check for invalid individual name 'Web Operations Manager' of Geoscience Australia
-->
		<xsl:for-each-group select="descendant::gmd:CI_ResponsibleParty[gmd:organisationName/gco:CharacterString!='' and gmd:individualName/gco:CharacterString='' and not(gmd:role/gmd:CI_RoleCode/@codeListValue='')]" group-by="gmd:organisationName">
			<xsl:element name="registryObject">
				<xsl:attribute name="group"><xsl:value-of select="$group"/></xsl:attribute>
				<xsl:element name="key">
					<xsl:value-of select="current-grouping-key()"/>
				</xsl:element>
				<xsl:element name="originatingSource">
					<xsl:value-of select="$origSource"/>
				</xsl:element>
				<xsl:element name="party">
					<xsl:attribute name="type"><xsl:text>group</xsl:text></xsl:attribute>
					<!-- Insert Trove identifier -->
					<xsl:if test="$parties!=''">
						<xsl:call-template name="insertTroveId">
							<xsl:with-param name="key" select="concat('http://portal.auscope.org/',current-grouping-key())"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:element name="name">
						<xsl:attribute name="type"><xsl:text>primary</xsl:text></xsl:attribute>
						<xsl:element name="namePart">
							<xsl:value-of select="current-grouping-key()"/>
						</xsl:element>
					</xsl:element>
					<!-- to normalise parties within a single record we need to group them, obtain the fragment for each party with the most information, and at the same time cope with rubbish data. In the end the only way to cope is to ensure at least an organisation name, city, phone or fax exists (sigh)
-->
					<xsl:for-each select="current-group()">
						<xsl:sort select="count(gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/child::*) + count(gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/child::*)" data-type="number" order="descending"/>
						<xsl:if test="gmd:organisationName[not(@gco:nilReason)] or gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city or gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone[gmd:voice or gmd:fax]">
						<xsl:element name="location">
							<xsl:element name="address">
								<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice"/>
								<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:facsimile"/>
								<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress"/>
								<xsl:if test="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/child::*">
									<xsl:element name="physical">
										<xsl:attribute name="type"><xsl:text>streetAddress</xsl:text></xsl:attribute>
										<xsl:apply-templates select="gmd:organisationName"/>
										<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:deliveryPoint"/>
										<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city"/>
										<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:administrativeArea[not(@gco:nilReason)]"/>
										<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode[not(@gco:nilReason)]"/>
										<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:country"/>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:element>
						</xsl:if>
					</xsl:for-each>
					<!-- xsl:element name="relatedObject">
					<xsl:element name="key">
						<xsl:value-of select="ancestor::gmd:MD_Metadata/gmd:fileIdentifier"/>
					</xsl:element>	

					<xsl:for-each-group select="gmd:role" group-by="gmd:CI_RoleCode/@codeListValue">
						<xsl:variable name="code">
							<xsl:value-of select="current-grouping-key()"/>
						</xsl:variable>
						
						<xsl:element name="relation">
							<xsl:attribute name="type">
								<xsl:value-of select="$code"/>
							</xsl:attribute>
						</xsl:element>	
					</xsl:for-each-group>
				</xsl:element-->
					<!-- related activity -->
					<xsl:for-each select="$activities/registryObjects/registryObject">
						<xsl:variable name="registryObject" select="."/>
						<xsl:if test="./identifier!='' and contains($collectionUrl, ./identifier)">
							<xsl:element name="relatedObject">
								<xsl:element name="key">
									<xsl:value-of select="$registryObject/key"/>
								</xsl:element>
								<xsl:element name="relation">
									<xsl:attribute name="type"><xsl:text>pointOfContact</xsl:text></xsl:attribute>
								</xsl:element>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
			<!-- only created Activity record for Collection -->
			<xsl:if test="$collection">
				<xsl:for-each select="$activities/registryObjects/registryObject">
					<xsl:variable name="registryObject" select="."/>
					<xsl:if test="./identifier!='' and contains($collectionUrl, ./identifier)">
						<xsl:apply-templates select="$registryObject" mode="copyAndChangeNS"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each-group>
	</xsl:template>
	<xsl:template match="node()"/>
	<xsl:template name="splitSubject">
		<xsl:param name="string"/>
		<xsl:param name="separator" select="', '"/>
		<xsl:choose>
			<xsl:when test="contains($string, $separator)">
				<xsl:if test="not(starts-with($string, $separator))">
					<xsl:element name="subject">
						<xsl:attribute name="type"><xsl:text>local</xsl:text></xsl:attribute>
						<xsl:value-of select="substring-before($string, $separator)"/>
					</xsl:element>
				</xsl:if>
				<xsl:call-template name="splitSubject">
					<xsl:with-param name="string" select="substring-after($string,$separator)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="normalize-space($string)">
					<xsl:element name="subject">
						<xsl:attribute name="type"><xsl:text>local</xsl:text></xsl:attribute>
						<xsl:value-of select="$string"/>
					</xsl:element>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="gmlToKml">
		<xsl:param name="coords"/>
		<xsl:for-each select="tokenize($coords, ', ')">
			<xsl:choose>
				<xsl:when test="position()=last()">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:when test="position() mod 2 = 0">
					<xsl:value-of select="."/>
					<xsl:text> </xsl:text>
				</xsl:when>
				<xsl:when test="position() mod 2 = 1">
					<xsl:value-of select="."/>
					<xsl:text>,</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	  <xsl:template match="*" mode="copyAndChangeNS">
    <!-- create a new element with the same local name as the matched element
          but in the rif-cs namespace. 
    -->
    <xsl:element name="{local-name()}" namespace="http://ands.org.au/standards/rif-cs/registryObjects">
      <!-- copy all the attributes from the matched element -->
      <xsl:copy-of select="@*"/>
      <!-- apply templates on the same mode on the matched element content 
            to get its content copied and the same namespace change applied on 
            eventual elements that may be in the currently matched element.
      -->
      <xsl:apply-templates select="node()" mode="copyAndChangeNS"/>
    </xsl:element>
  </xsl:template> 
</xsl:stylesheet>
