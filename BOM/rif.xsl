<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:gml="http://www.opengis.net/gml" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:geonet="http://www.fao.org/geonetwork" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns="http://ands.org.au/standards/rif-cs/registryObjects">
	<!-- stylesheet to convert iso19139 in OAI-PMH ListRecords response to RIF-CS
-->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<!-- the originating source, need to be configured for each deployment-->
	<xsl:param name="geonetworkHostServer" select="'http://services-test.auscope.org'"/>
	<!-- the registry object group, need to be configured for each deployment
-->
	<xsl:param name="group" select="'BOM'"/>
	<!-- deployment specific link to user interface to retrieve collections, 
if this parameter value is empty, the url to the record in Geonetwork is formed to be the resource location

-->
	<!--<xsl:param name="discoveryLink" select="'http://mapconnect.ga.gov.au/MapConnect/Geofabric/'"/>-->
	<!-- discoveryLink is not used - gmd:URL has been used as the electronic address -->
	<!-- <xsl:param name="discoveryLink" select="'http://www.bom.gov.au/'"/> -->
	<!-- xsl:param name="discoveryLink" select="''"/-->
	<xsl:param name="keyurl" select="'http://www.bom.gov.au/'"/>
	<!-- NLA Party created in ANDS datastore for BOM -->
	<xsl:param name="nlapartykey" select="'http://www.bom.gov.au'"/>
	<!-- Manually created RIF-CS activities  -->
	<xsl:variable name="activities" select="document('activities.xml')"/>
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
	<!-- RIFCS 1.2.0 -->
	<xsl:template match="gmd:MD_Metadata">
		<xsl:element name="registryObjects">
			<xsl:attribute name="xsi:schemaLocation"><xsl:text>http://ands.org.au/standards/rif-cs/registryObjects http://services.ands.org.au/documentation/rifcs/schema/registryObjects.xsd</xsl:text></xsl:attribute>
			<xsl:apply-templates select="." mode="collection"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="gmd:voice[not(@gco:nilReason)]">
		<xsl:if test="normalize-space(.)">
			<xsl:element name="physical">
				<xsl:element name="addressPart">
					<xsl:attribute name="type"><xsl:text>telephoneNumber</xsl:text></xsl:attribute>
					<xsl:value-of select="translate(translate(.,'+',''),' ','-')"/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:facsimile[not(@gco:nilReason)]">
		<xsl:if test="normalize-space(.)">
			<xsl:element name="physical">
				<xsl:element name="addressPart">
					<xsl:attribute name="type"><xsl:text>faxNumber</xsl:text></xsl:attribute>
					<xsl:value-of select="translate(translate(.,'+',''),' ','-')"/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:electronicMailAddress[not(@gco:nilReason)]">
		<xsl:if test="normalize-space(.)">
			<xsl:element name="electronic">
				<xsl:attribute name="type"><xsl:text>email</xsl:text></xsl:attribute>
				<xsl:element name="value">
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:URL[not(@gco:nilReason)]">
		<xsl:element name="electronic">
			<xsl:attribute name="type"><xsl:text>url</xsl:text></xsl:attribute>
			<xsl:element name="value">
				<xsl:value-of select="."/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="gml:timePosition[not(@gco:nilReason)]">
		<xsl:choose>
			<xsl:when test='contains(., "T")'>
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(., 'T00:00:00Z')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="gml:beginPosition[not(@gco:nilReason)]">
		<xsl:choose>
			<xsl:when test='contains(., "T")'>
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(., 'T00:00:00Z')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="gml:endPosition[not(@gco:nilReason)]">
		<xsl:choose>
			<xsl:when test='contains(., "T")'>
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(., 'T00:00:00Z')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="gmd:organisationName[not(@gco:nilReason)]">
		<xsl:if test="normalize-space(.)">
			<xsl:element name="addressPart">
				<xsl:attribute name="type"><xsl:text>locationDescriptor</xsl:text></xsl:attribute>
				<xsl:value-of select="."/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:deliveryPoint[not(@gco:nilReason)]">
		<xsl:if test="normalize-space(.)">
			<xsl:element name="addressPart">
				<xsl:attribute name="type"><xsl:text>addressLine</xsl:text></xsl:attribute>
				<xsl:value-of select="."/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:city[not(@gco:nilReason)]">
		<xsl:if test="normalize-space(.)">
			<xsl:element name="addressPart">
				<xsl:attribute name="type"><xsl:text>suburbOrPlaceOrLocality</xsl:text></xsl:attribute>
				<xsl:value-of select="."/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:administrativeArea[not(@gco:nilReason)]">
		<xsl:if test="normalize-space(.)">
			<xsl:element name="addressPart">
				<xsl:attribute name="type"><xsl:text>stateOrTerritory</xsl:text></xsl:attribute>
				<xsl:value-of select="."/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:postalCode[not(@gco:nilReason)]">
		<xsl:if test="normalize-space(.)">
			<xsl:element name="addressPart">
				<xsl:attribute name="type"><xsl:text>postCode</xsl:text></xsl:attribute>
				<xsl:value-of select="."/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:country[not(@gco:nilReason)]">
		<xsl:if test="normalize-space(.)">
			<xsl:element name="addressPart">
				<xsl:attribute name="type"><xsl:text>country</xsl:text></xsl:attribute>
				<xsl:value-of select="."/>
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
	<!-- mapping gmd:resourceConstraints/gmd:MD_LegalConstraints to RIF-CS description (type="rights")  -->
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
					<xsl:element name="description">
						<xsl:attribute name="type"><xsl:value-of select="$descriptionType"/></xsl:attribute>
						<xsl:value-of select="concat($codelist/entry[code = $codevalue]/label, ': ', $codelist/entry[code = $codevalue]/description)"/>
					</xsl:element>
				</xsl:when>
				<!--
				harvested metadata doesn't have codevalue, the accessConstrain is
				plain text - gmd:accessConstraints/gco:CharacterString
			-->
				<xsl:otherwise>
					<xsl:if test=".!='NONE'">
						<xsl:element name="description">
							<xsl:attribute name="type"><xsl:value-of select="$descriptionType"/></xsl:attribute>
							<xsl:value-of select="."/>
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
				<!-- useConstrains might have same values with accessConstraints resulting in duplicates in description (type="rights")
                      This is checking if the values aren't already in accessConstraints 
             -->
				<xsl:variable name="elcontent" select="concat($codelist/entry[code = $codevalue]/label, ': ', $codelist/entry[code = $codevalue]/description)"/>
				<xsl:variable name="accessConstraints">
					<xsl:apply-templates select="$legalConstraints/gmd:accessConstraints" mode="prebuilt_access_constraints"/>
				</xsl:variable>
				<xsl:if test="$accessConstraints!=$elcontent">
					<xsl:element name="description">
						<xsl:attribute name="type"><xsl:value-of select="$descriptionType"/></xsl:attribute>
						<xsl:value-of select="$elcontent"/>
					</xsl:element>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
		<!--
		manually created metadata from Geonetwork GUI may have
		otherConstraints
	-->
		<xsl:if test="$legalConstraints/gmd:otherConstraints[not(@gco:nilReason)]">
			<xsl:element name="description">
				<xsl:attribute name="type"><xsl:value-of select="$descriptionType"/></xsl:attribute>
				<xsl:apply-templates select="$legalConstraints/gmd:otherConstraints"/>
			</xsl:element>
		</xsl:if>
		<!--
		harvested metadata may have accessConstrain as NONE - gmd:accessConstraints/gco:CharacterString
	-->
		<xsl:if test="$legalConstraints/gmd:accessConstraints='NONE'">
			<xsl:element name="description">
				<xsl:attribute name="type"><xsl:value-of select="$descriptionType"/></xsl:attribute>
				<xsl:choose>
					<xsl:when test="$descriptionType='rights'">
						<xsl:value-of select="'There are no access constraints associated with this collection.'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'There are no access rights associated with this service.'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<!-- this it to compare built access constraints with use constraints to ensure no duplicates -->
	<xsl:template match="gmd:accessConstraints" mode="prebuilt_access_constraints">
		<xsl:variable name="codelist" select="document('../loc/en/codelists.xml')/codelists/codelist[@name = 'gmd:MD_RestrictionCode']"/>
		<xsl:variable name="codevalue" select="./gmd:MD_RestrictionCode/@codeListValue"/>
		<xsl:if test="normalize-space($codevalue)">
			<xsl:value-of select="concat($codelist/entry[code = $codevalue]/label, ': ', $codelist/entry[code = $codevalue]/description)"/>
		</xsl:if>
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
		<xsl:element name="description">
			<xsl:attribute name="type"><xsl:text>full</xsl:text></xsl:attribute>
			<xsl:value-of select="."/>
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
	<xsl:template match="gmd:MD_Metadata" mode="collection">
		<xsl:variable name="collection" select="gmd:identificationInfo/gmd:MD_DataIdentification and gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue!='service']"/>
		<!-- BOM is a metadata aggregator, the origSource should reflect the originating source for each data provider  -->
		<xsl:variable name="origSource">
			<xsl:choose>
				<xsl:when test="gmd:identificationInfo/gmd:MD_DataIdentification">
					<xsl:choose>
						<!-- for BOM SIM Catalog -->
						<xsl:when test="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine[1]/gmd:CI_OnlineResource/gmd:linkage/gmd:URL!=''">
							<xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine[1]/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- for BOM Geofabric -->
							<xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations[1]/srv:SV_OperationMetadata/srv:connectPoint[1]/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- second gmd:URL that use as link to general activities for BOM SIM Catalog product -->
		<xsl:variable name="ActivityOrigSource">
			<xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine[2]/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
		</xsl:variable>
		<!-- ************************************************************************************************************************************************** -->
		<!-- CREATE COLLECTION OBJECT -->
		<!-- ************************************************************************************************************************************************** -->
		<xsl:if test="gmd:identificationInfo/gmd:MD_DataIdentification!='' and gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue!='service']">
			<xsl:variable name="ge" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement"/>
			<xsl:variable name="te" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement"/>
			<xsl:variable name="ve" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:verticalElement"/>
			<!-- Rini: I'm not sure what these are for.. doesn't seem to be used
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
				<xsl:value-of	select="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition"/>
			</xsl:when>
			<xsl:when test="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition">
				<xsl:value-of select="$te[position()=last()]/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:end/gml:TimeInstant/gml:timePosition"/>
			</xsl:when>
		</xsl:choose>
	</xsl:variable> -->
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
					<!-- Add "bom.gov.au/" prefix to Dataset object key -->
					<xsl:value-of select="concat('bom.gov.au/', gmd:fileIdentifier)"/>
				</xsl:element>
				<xsl:element name="originatingSource">
					<xsl:value-of select="$origSource"/>
				</xsl:element>
				<xsl:element name="collection">
					<xsl:attribute name="type"><xsl:value-of select="'dataset'"/></xsl:attribute>
					<xsl:element name="identifier">
						<xsl:attribute name="type"><xsl:text>local</xsl:text></xsl:attribute>
						<xsl:value-of select="gmd:fileIdentifier"/>
					</xsl:element>
					<xsl:element name="name">
						<xsl:attribute name="type"><xsl:text>primary</xsl:text></xsl:attribute>
						<xsl:element name="namePart">
							<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title"/>
						</xsl:element>
					</xsl:element>
					<xsl:element name="location">
						<xsl:element name="address">
							<xsl:element name="electronic">
								<xsl:attribute name="type"><xsl:text>url</xsl:text></xsl:attribute>
								<xsl:element name="value">
									<xsl:variable name="bomcatalogurl">
										<xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine[1]/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
									</xsl:variable>
									<xsl:variable name="geofabricurl">
										<xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="not($bomcatalogurl='')">
											<xsl:value-of select="$bomcatalogurl"/>
										</xsl:when>
										<xsl:when test="not($geofabricurl='')">
											<xsl:value-of select="$geofabricurl"/>
										</xsl:when>
										<!-- all harvested csw records link to Geofabric portal -->
										<!-- <xsl:when test="not($discoveryLink='')">
									<xsl:value-of select="$discoveryLink"/>
								</xsl:when>									-->
										<!-- geonetwork metadata provides more details about the record -->
										<xsl:otherwise>
											<xsl:value-of select="concat($geonetworkHostServer,'/geonetwork/srv/en/metadata.show?uuid=',gmd:fileIdentifier)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					<xsl:if test="normalize-space($ge/gmd:EX_GeographicBoundingBox)">
						<xsl:element name="coverage">
							<xsl:apply-templates select="$ge/gmd:EX_GeographicBoundingBox"/>
							<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:description"/>
							<xsl:apply-templates select="$ge/gmd:EX_BoundingPolygon/gmd:polygon/gml:Polygon/gml:exterior/gml:LinearRing/gml:coordinates[text()!='']"/>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$te/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod">
						<!-- Rini: I removed the condition for $formattedFrom because it's the same as $from.. so it never worked! -->
						<xsl:if test="not($from='')">
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
					<!-- Check for invalid individual name 'Web Operations Manager' of Geoscience Australia -->
					<xsl:for-each-group select="descendant::gmd:CI_ResponsibleParty[gmd:individualName!='' and not(gmd:role/gmd:CI_RoleCode/@codeListValue='')]" group-by="gmd:individualName">
						<xsl:element name="relatedObject">
							<xsl:element name="key">
								<xsl:choose>
									<xsl:when test="current-grouping-key()='Web Operations Manager' or current-grouping-key()='Records Section'">
										<xsl:choose>
											<xsl:when test="./gmd:positionName">
												<xsl:value-of select="concat($keyurl,./gmd:positionName, ' - ', ./gmd:organisationName)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat($keyurl,current-grouping-key(), ' - ', ./gmd:organisationName)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat($keyurl,current-grouping-key())"/>
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
								<xsl:value-of select="concat($keyurl,current-grouping-key())"/>
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
					<!-- hardcoded link to NLA Party -->
					<xsl:element name="relatedObject">
						<xsl:element name="key">
							<xsl:value-of select="$nlapartykey"/>
						</xsl:element>
						<xsl:element name="relation">
							<xsl:attribute name="type"><xsl:text>isManagedBy</xsl:text></xsl:attribute>
						</xsl:element>
					</xsl:element>
					<!-- related activities -->
					<xsl:for-each select="$activities/registryObjects/registryObject">
						<xsl:variable name="registryObject" select="."/>
						<xsl:if test="./originatingSource!='' and (contains($origSource, ./originatingSource) or contains($ActivityOrigSource, ./originatingSource))">
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
					<xsl:element name="subject">
						<xsl:attribute name="type"><xsl:value-of select="'anzsrc-for'"/></xsl:attribute>
						<xsl:value-of select="'04'"/>
					</xsl:element>
					<!-- Rini: insert anzsrc codes from related activities -->
					<xsl:for-each select="$activities/registryObjects/registryObject">
						<xsl:for-each select="./activity/subject">
							<xsl:if test="./@type and ./@type='anzsrc-for'">
								<xsl:element name="subject">
									<xsl:attribute name="type"><xsl:value-of select="'anzsrc-for'"/></xsl:attribute>
									<xsl:value-of select="."/>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each>
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword"/>
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode"/>
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract"/>
					<xsl:choose>
						<xsl:when test="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints">
							<xsl:call-template name="legalConstraints">
								<xsl:with-param name="legalConstraints" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints"/>
								<xsl:with-param name="descriptionType" select="'rights'"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="description">
								<xsl:attribute name="type"><xsl:text>rights</xsl:text></xsl:attribute>
								<xsl:text>There are no access constraints associated with this collection.</xsl:text>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
					<!-- Capture DataQuality lineage into description of entity type Note -->
					<xsl:if test="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement/gco:CharacterString">
						<xsl:element name="description">
							<xsl:attribute name="type"><xsl:value-of select="'note'"/></xsl:attribute>
							<xsl:value-of select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement/gco:CharacterString"/>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		<!-- ************************************************************************************************************************************************** -->
		<!--	CREATE SERVICE OBJECT (base on gmd) -->
		<!-- ************************************************************************************************************************************************** -->
		<xsl:if test="gmd:identificationInfo/gmd:MD_DataIdentification and gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level/gmd:MD_ScopeCode[@codeListValue='service']">
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
					<xsl:value-of select="gmd:fileIdentifier"/>
				</xsl:element>
				<xsl:element name="originatingSource">
					<xsl:value-of select="$origSource"/>
				</xsl:element>
				<xsl:element name="service">
					<xsl:attribute name="type"><xsl:value-of select="'search-http'"/></xsl:attribute>
					<xsl:element name="identifier">
						<xsl:attribute name="type"><xsl:text>local</xsl:text></xsl:attribute>
						<xsl:value-of select="gmd:fileIdentifier"/>
					</xsl:element>
					<xsl:element name="name">
						<xsl:attribute name="type"><xsl:text>primary</xsl:text></xsl:attribute>
						<xsl:element name="namePart">
							<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title"/>
						</xsl:element>
					</xsl:element>
					<xsl:variable name="httpLinks">
						<xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions[1]/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[gmd:protocol='WWW:LINK-1.0-http--link']/gmd:linkage/gmd:URL"/>
					</xsl:variable>
					<xsl:variable name="wcsServiceLink">
						<xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions[1]/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[gmd:protocol='OGC:WCS-1.0.0-http-get-coverage']/gmd:linkage/gmd:URL"/>
					</xsl:variable>
					<xsl:variable name="wmsServiceLink">
						<xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions[1]/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[gmd:protocol='OGC:WMS-1.1.1-http-get-map']/gmd:linkage/gmd:URL"/>
					</xsl:variable>
					<xsl:if test="$httpLinks!='' and $wcsServiceLink='' and $wmsServiceLink=''">
						<xsl:element name="location">
							<xsl:element name="address">
								<xsl:element name="electronic">
									<xsl:attribute name="type"><xsl:text>url</xsl:text></xsl:attribute>
									<xsl:element name="value">
										<xsl:value-of select="$httpLinks[1]"/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$wcsServiceLink!=''">
						<xsl:element name="location">
							<xsl:element name="address">
								<xsl:element name="electronic">
									<xsl:attribute name="type"><xsl:text>url</xsl:text></xsl:attribute>
									<xsl:element name="value">
										<xsl:value-of select="$wcsServiceLink"/>
									</xsl:element>
								</xsl:element>
								<xsl:element name="electronic">
									<xsl:attribute name="type"><xsl:text>other</xsl:text></xsl:attribute>
									<xsl:element name="value">
										<xsl:value-of select="'WCS'"/>
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
										<xsl:value-of select="'1.0.0'"/>
									</xsl:element>
									<xsl:element name="arg">
										<xsl:attribute name="type"><xsl:text>string</xsl:text></xsl:attribute>
										<xsl:attribute name="required"><xsl:text>true</xsl:text></xsl:attribute>
										<xsl:attribute name="use"><xsl:text>keyValue</xsl:text></xsl:attribute>
										<xsl:value-of select="'version'"/>
									</xsl:element>
								</xsl:element>
								<xsl:element name="electronic">
									<xsl:attribute name="type"><xsl:text>other</xsl:text></xsl:attribute>
									<xsl:element name="value">
										<xsl:value-of select="'GetCapabilities'"/>
									</xsl:element>
									<xsl:element name="arg">
										<xsl:attribute name="type"><xsl:text>string</xsl:text></xsl:attribute>
										<xsl:attribute name="required"><xsl:text>true</xsl:text></xsl:attribute>
										<xsl:attribute name="use"><xsl:text>keyValue</xsl:text></xsl:attribute>
										<xsl:value-of select="'request'"/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="$wmsServiceLink!=''">
						<xsl:element name="location">
							<xsl:element name="address">
								<xsl:element name="electronic">
									<xsl:attribute name="type"><xsl:text>url</xsl:text></xsl:attribute>
									<xsl:element name="value">
										<xsl:value-of select="$wmsServiceLink"/>
									</xsl:element>
								</xsl:element>
								<xsl:element name="electronic">
									<xsl:attribute name="type"><xsl:text>other</xsl:text></xsl:attribute>
									<xsl:element name="value">
										<xsl:value-of select="'WMS'"/>
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
										<xsl:value-of select="'1.1.1'"/>
									</xsl:element>
									<xsl:element name="arg">
										<xsl:attribute name="type"><xsl:text>string</xsl:text></xsl:attribute>
										<xsl:attribute name="required"><xsl:text>true</xsl:text></xsl:attribute>
										<xsl:attribute name="use"><xsl:text>keyValue</xsl:text></xsl:attribute>
										<xsl:value-of select="'version'"/>
									</xsl:element>
								</xsl:element>
								<xsl:element name="electronic">
									<xsl:attribute name="type"><xsl:text>other</xsl:text></xsl:attribute>
									<xsl:element name="value">
										<xsl:value-of select="'GetCapabilities'"/>
									</xsl:element>
									<xsl:element name="arg">
										<xsl:attribute name="type"><xsl:text>string</xsl:text></xsl:attribute>
										<xsl:attribute name="required"><xsl:text>true</xsl:text></xsl:attribute>
										<xsl:attribute name="use"><xsl:text>keyValue</xsl:text></xsl:attribute>
										<xsl:value-of select="'request'"/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<xsl:if test="normalize-space($ge/gmd:EX_GeographicBoundingBox)">
						<xsl:element name="coverage">
							<xsl:apply-templates select="$ge/gmd:EX_GeographicBoundingBox"/>
							<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:description"/>
							<xsl:apply-templates select="$ge/gmd:EX_BoundingPolygon/gmd:polygon/gml:Polygon/gml:exterior/gml:LinearRing/gml:coordinates[text()!='']"/>
						</xsl:element>
					</xsl:if>
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
					<!-- Check for invalid individual name 'Web Operations Manager' of Geoscience Australia-->
					<xsl:for-each-group select="descendant::gmd:CI_ResponsibleParty[gmd:individualName!='' and not(gmd:role/gmd:CI_RoleCode/@codeListValue='')]" group-by="gmd:individualName">
						<xsl:element name="relatedObject">
							<xsl:element name="key">
								<xsl:choose>
									<xsl:when test="current-grouping-key()='Web Operations Manager' or current-grouping-key()='Records Section'">
										<xsl:choose>
											<xsl:when test="./gmd:positionName">
												<xsl:value-of select="concat($keyurl,./gmd:positionName, ' - ', ./gmd:organisationName)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat($keyurl,current-grouping-key(), ' - ', ./gmd:organisationName)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat($keyurl,current-grouping-key())"/>
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
								<xsl:value-of select="concat($keyurl,current-grouping-key())"/>
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
					<xsl:element name="subject">
						<xsl:attribute name="type"><xsl:value-of select="'anzsrc-for'"/></xsl:attribute>
						<xsl:value-of select="'04'"/>
					</xsl:element>
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword"/>
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode"/>
					<xsl:apply-templates select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract"/>
					<xsl:choose>
						<xsl:when test="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints">
							<xsl:call-template name="legalConstraints">
								<xsl:with-param name="legalConstraints" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints"/>
								<xsl:with-param name="descriptionType" select="'accessRights'"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="description">
								<xsl:attribute name="type"><xsl:text>accessRights</xsl:text></xsl:attribute>
								<xsl:text>There are no access rights associated with this service.</xsl:text>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		<!-- ************************************************************************************************************************************************** -->
		<!--	CREATE SERVICE OBJECT (base on srv) -->
		<!-- ************************************************************************************************************************************************** -->
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
					<xsl:element name="name">
						<xsl:attribute name="type"><xsl:text>primary</xsl:text></xsl:attribute>
						<xsl:element name="namePart">
							<xsl:apply-templates select="gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:title"/>
						</xsl:element>
					</xsl:element>
					<xsl:element name="location">
						<xsl:element name="address">
							<xsl:element name="electronic">
								<xsl:attribute name="type"><xsl:text>url</xsl:text></xsl:attribute>
								<xsl:element name="value">
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
									<xsl:choose>
										<xsl:when test="not($serviceUrl='')">
											<xsl:value-of select="$serviceUrl"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat($geonetworkHostServer,'/geonetwork/srv/en/metadata.show?uuid=',gmd:fileIdentifier)"/>
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
					<xsl:if test="normalize-space($ge/gmd:EX_GeographicBoundingBox)">
						<xsl:element name="coverage">
							<xsl:apply-templates select="$ge/gmd:EX_GeographicBoundingBox"/>
							<xsl:apply-templates select="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:extent/gmd:EX_Extent/gmd:description"/>
							<xsl:apply-templates select="$ge/gmd:EX_BoundingPolygon/gmd:polygon/gml:Polygon/gml:exterior/gml:LinearRing/gml:coordinates[text()!='']"/>
						</xsl:element>
					</xsl:if>
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
					<!-- Check for invalid individual name 'Web Operations Manager' of Geoscience Australia-->
					<xsl:for-each-group select="descendant::gmd:CI_ResponsibleParty[gmd:individualName!='' and not(gmd:role/gmd:CI_RoleCode/@codeListValue='')]" group-by="gmd:individualName">
						<xsl:element name="relatedObject">
							<xsl:element name="key">
								<xsl:choose>
									<xsl:when test="current-grouping-key()='Web Operations Manager' or current-grouping-key()='Records Section'">
										<xsl:choose>
											<xsl:when test="./gmd:positionName">
												<xsl:value-of select="concat($keyurl,./gmd:positionName, ' - ', ./gmd:organisationName)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat($keyurl,current-grouping-key(), ' - ', ./gmd:organisationName)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat($keyurl,current-grouping-key())"/>
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
								<xsl:value-of select="concat($keyurl,current-grouping-key())"/>
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
					<xsl:element name="subject">
						<xsl:attribute name="type"><xsl:value-of select="'anzsrc-for'"/></xsl:attribute>
						<xsl:value-of select="'04'"/>
					</xsl:element>
					<xsl:apply-templates select="gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword"/>
					<xsl:apply-templates select="gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode"/>
					<xsl:apply-templates select="gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:abstract"/>
					<xsl:choose>
						<xsl:when test="gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:resourceConstraints">
							<xsl:call-template name="legalConstraints">
								<xsl:with-param name="legalConstraints" select="gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints"/>
								<xsl:with-param name="descriptionType" select="'accessRights'"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="description">
								<xsl:attribute name="type"><xsl:text>accessRights</xsl:text></xsl:attribute>
								<xsl:text>There are no access rights associated with this service.</xsl:text>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		<!-- ************************************************************************************************************************************************** -->
		<!-- CREATE PARTY OBJECT -->
		<!-- ************************************************************************************************************************************************** -->
		<!-- Create all the associated party objects for individuals -->
		<!-- Check for invalid individual name 'Web Operations Manager' of Geoscience Australia-->
		<xsl:for-each-group select="descendant::gmd:CI_ResponsibleParty[gmd:individualName!='' and not(gmd:role/gmd:CI_RoleCode/@codeListValue='')]" group-by="gmd:individualName">
			<xsl:element name="registryObject">
				<xsl:attribute name="group"><xsl:value-of select="$group"/></xsl:attribute>
				<xsl:element name="key">
					<xsl:choose>
						<xsl:when test="current-grouping-key()='Web Operations Manager' or current-grouping-key()='Records Section'">
							<xsl:choose>
								<xsl:when test="./gmd:positionName">
									<xsl:value-of select="concat($keyurl,./gmd:positionName, ' - ', ./gmd:organisationName)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat($keyurl,current-grouping-key(), ' - ', ./gmd:organisationName)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($keyurl,current-grouping-key())"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<!-- to use standard party from ANDS database -->
				<!--<xsl:element name="key">
				<xsl:value-of select="concat($keyurl,$bomcontactkey)"/>
			</xsl:element>-->
				<xsl:element name="originatingSource">
					<xsl:value-of select="$origSource"/>
				</xsl:element>
				<xsl:element name="party">
					<!-- for bom sims catalog, use person, for geofabric, use group  -->
					<xsl:attribute name="type"><xsl:if test="$origSource!='' and $ActivityOrigSource!='' "><xsl:text>person</xsl:text></xsl:if><xsl:if test="$origSource!='' and $ActivityOrigSource='' "><xsl:text>group</xsl:text></xsl:if></xsl:attribute>
					<xsl:element name="name">
						<xsl:attribute name="type"><xsl:text>primary</xsl:text></xsl:attribute>
						<xsl:element name="namePart">
							<xsl:choose>
								<xsl:when test="current-grouping-key()='Web Operations Manager' or current-grouping-key()='Records Section'">
									<xsl:choose>
										<xsl:when test="./gmd:positionName">
											<xsl:value-of select="concat(./gmd:positionName, ' - ', ./gmd:organisationName)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat(current-grouping-key(), ' - ', ./gmd:organisationName)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="current-grouping-key()"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
						<!-- to use standard party from ANDS database -->
						<!--<xsl:element name="namePart">
						<xsl:value-of select="'Bureau of Meteorology'"/>
					</xsl:element>	-->
					</xsl:element>
					<!-- to normalise parties within a single record we need to group them, obtain the fragment for each party with the most information, and at the same time cope with rubbish data. In the end the only way to cope is to ensure at least an organisation name, city, phone or fax exists (sigh)
-->
					<xsl:for-each select="current-group()">
						<xsl:sort select="count(gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/child::*) + count(gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/child::*)" data-type="number" order="descending"/>
						<xsl:choose>
							<xsl:when test="position()=1">
								<xsl:if test="gmd:organisationName[not(@gco:nilReason)] or gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city[not(@gco:nilReason)] or gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone[gmd:voice[not(@gco:nilReason)] or gmd:fax[not(@gco:nilReason)]]">
									<xsl:element name="location">
										<xsl:element name="address">
											<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice"/>
											<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:facsimile"/>
											<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress"/>
											<xsl:element name="physical">
												<xsl:attribute name="type"><xsl:text>streetAddress</xsl:text></xsl:attribute>
												<xsl:apply-templates select="gmd:organisationName"/>
												<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:deliveryPoint"/>
												<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city"/>
												<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:administrativeArea[not(@gco:nilReason)]"/>
												<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode[not(@gco:nilReason)]"/>
												<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:country"/>
											</xsl:element>
										</xsl:element>
									</xsl:element>
								</xsl:if>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
					<!--<xsl:element name="relatedObject">
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
				</xsl:element>-->
					<!-- related activity -->
					<xsl:for-each select="$activities/registryObjects/registryObject">
						<xsl:variable name="registryObject" select="."/>
						<xsl:if test="./originatingSource!='' and (contains($origSource, ./originatingSource) or contains($ActivityOrigSource, ./originatingSource) )">
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
		</xsl:for-each-group>
		<!-- Create all the associated party objects for organisations -->
		<xsl:for-each-group select="descendant::gmd:CI_ResponsibleParty[gmd:organisationName!='' and gmd:individualName='' and not(gmd:role/gmd:CI_RoleCode/@codeListValue='')]" group-by="gmd:organisationName">
			<xsl:element name="registryObject">
				<xsl:attribute name="group"><xsl:value-of select="$group"/></xsl:attribute>
				<xsl:element name="key">
					<xsl:value-of select="concat($keyurl,current-grouping-key())"/>
				</xsl:element>
				<xsl:element name="originatingSource">
					<xsl:value-of select="$origSource"/>
				</xsl:element>
				<xsl:element name="party">
					<xsl:attribute name="type"><xsl:text>group</xsl:text></xsl:attribute>
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
						<xsl:choose>
							<xsl:when test="position()=1">
								<xsl:if test="gmd:organisationName[not(@gco:nilReason)] or gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city or gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone[gmd:voice or gmd:fax]">
									<xsl:element name="location">
										<xsl:element name="address">
											<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice"/>
											<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:facsimile"/>
											<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress"/>
											<xsl:element name="physical">
												<xsl:attribute name="type"><xsl:text>streetAddress</xsl:text></xsl:attribute>
												<xsl:apply-templates select="gmd:organisationName"/>
												<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:deliveryPoint"/>
												<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city"/>
												<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:administrativeArea[not(@gco:nilReason)]"/>
												<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode[not(@gco:nilReason)]"/>
												<xsl:apply-templates select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:country"/>
											</xsl:element>
										</xsl:element>
									</xsl:element>
								</xsl:if>
							</xsl:when>
						</xsl:choose>
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
						<xsl:if test="./originatingSource!='' and (contains($origSource, ./originatingSource) or contains($ActivityOrigSource, ./originatingSource))">
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
		</xsl:for-each-group>
		<!-- ************************************************************************************************************************************************** -->
		<!-- CREATE ACTIVITY OBJECT (create Activity record for Collection) -->
		<!-- ************************************************************************************************************************************************** -->
		<xsl:if test="$collection">
			<xsl:for-each select="$activities/registryObjects/registryObject">
				<xsl:variable name="registryObject" select="."/>
				<xsl:if test="./originatingSource!='' and (contains($origSource, ./originatingSource) or contains($ActivityOrigSource, ./originatingSource))">
					<xsl:element name="registryObject">
						<xsl:attribute name="group"><xsl:value-of select="$group"/></xsl:attribute>
						<xsl:element name="key">
							<xsl:value-of select="$registryObject/key"/>
						</xsl:element>
						<xsl:element name="originatingSource">
							<!--<xsl:value-of select="$origSource" />-->
							<!-- for bom sims catalog, use $ActivityOrigSource  -->
							<xsl:if test="$origSource!='' and $ActivityOrigSource!='' ">
								<xsl:value-of select="$ActivityOrigSource"/>
							</xsl:if>
							<xsl:if test="$origSource!='' and $ActivityOrigSource='' ">
								<xsl:value-of select="$origSource"/>
							</xsl:if>
						</xsl:element>
						<xsl:element name="activity">
							<xsl:attribute name="type"><xsl:value-of select="$registryObject/activity/@type"/></xsl:attribute>
							<xsl:element name="name">
								<xsl:attribute name="type"><xsl:value-of select="'primary'"/></xsl:attribute>
								<xsl:element name="namePart">
									<xsl:attribute name="type"><xsl:value-of select="'text'"/></xsl:attribute>
									<xsl:value-of select="$registryObject/activity/name/namePart"/>
								</xsl:element>
							</xsl:element>
							<xsl:element name="location">
								<xsl:element name="address">
									<xsl:element name="electronic">
										<xsl:attribute name="type"><xsl:value-of select="'url'"/></xsl:attribute>
										<xsl:element name="value">
											<xsl:value-of select="$registryObject/activity/location/address/electronic"/>
										</xsl:element>
									</xsl:element>
								</xsl:element>
							</xsl:element>
							<xsl:for-each select="$registryObject/activity/relatedObject">
								<xsl:element name="relatedObject">
									<xsl:element name="key">
										<xsl:value-of select="./key"/>
									</xsl:element>
									<xsl:element name="relation">
										<xsl:attribute name="type"><xsl:value-of select="./relation/@type"/></xsl:attribute>
										<xsl:value-of select="./relation"/>
									</xsl:element>
								</xsl:element>
							</xsl:for-each>
							<!-- anzsrc-for code 04 - Earth Sciences -->
							<xsl:element name="subject">
								<xsl:attribute name="type"><xsl:value-of select="'anzsrc-for'"/></xsl:attribute>
								<xsl:value-of select="'04'"/>
							</xsl:element>
							<xsl:for-each select="$registryObject/activity/subject">
								<xsl:element name="subject">
									<xsl:choose>
										<xsl:when test="./@type='local' or not(./@type) or ./@type=''">
											<!-- default subject type is 'local' with xml:lang='en'-->
											<xsl:attribute name="type"><xsl:value-of select="'local'"/></xsl:attribute>
											<xsl:attribute name="xml:lang"><xsl:value-of select="'en'"/></xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="type"><xsl:value-of select="./@type"/></xsl:attribute>
											<!-- no xml:lang unless specified -->
											<xsl:if test="./@xml:lang">
												<xsl:attribute name="xml:lang"><xsl:value-of select="./@xml:lang"/></xsl:attribute>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:value-of select="."/>
								</xsl:element>
							</xsl:for-each>
							<xsl:element name="description">
								<xsl:attribute name="type"><xsl:value-of select="'full'"/></xsl:attribute>
								<xsl:value-of select="$registryObject/activity/description"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
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
</xsl:stylesheet>
