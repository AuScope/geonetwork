<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:gml="http://www.opengis.net/gml" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:geonet="http://www.fao.org/geonetwork" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns:ns1="http://www.loc.gov/zing/srw/" xmlns:ns2="http://ands.org.au/standards/rif-cs/registryObjects" xmlns="http://ands.org.au/standards/rif-cs/registryObjects">
	<!-- stylesheet to convert iso19139 in OAI-PMH ListRecords response to RIF-CS
-->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="group" select="'AuScope'"/>
	<!-- Manually created RIF-CS activities  -->
	<xsl:variable name="activities" select="document('activities.xml')"/>
	<!-- Replace with your organisation ISIL code if Trove integration is required. Below is the ISIL code for AuScope -->
	<xsl:variable name="ISILCode" select="'AU-WS:AUS'"/>	
	<!-- Trove party records from SRU request -->
	<xsl:variable name="parties" select="document('parties.xml')"/>
	<!-- Comment out the above and use this if there is no parties.xml 
        <xsl:variable name="parties"/> -->
    <xsl:template match="root">
		<xsl:apply-templates/>
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
	<xsl:template name="buildName">
		<xsl:param name="title"/>
		<xsl:param name="first"/>
		<xsl:param name="middle"/>
		<xsl:param name="last"/>
		<xsl:element name="namePart">
			<xsl:attribute name="type"><xsl:text>family</xsl:text></xsl:attribute>
			<xsl:value-of select="$last"/>
		</xsl:element>
		<xsl:if test="$first!=''">
			<xsl:element name="namePart">
				<xsl:attribute name="type"><xsl:text>given</xsl:text></xsl:attribute>
				<xsl:value-of select="$first"/>
			</xsl:element>
		</xsl:if>
		<xsl:if test="$middle!=''">
			<xsl:element name="namePart">
				<xsl:attribute name="type"><xsl:text>initial</xsl:text></xsl:attribute>
				<xsl:value-of select="$middle"/>
			</xsl:element>
		</xsl:if>
		<xsl:if test="$title!=''">
			<xsl:element name="namePart">
				<xsl:attribute name="type"><xsl:text>title</xsl:text></xsl:attribute>
				<xsl:value-of select="$title"/>
			</xsl:element>
		</xsl:if>
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
	<xsl:template name="insertOriginatingSource">
	    <xsl:param name="origSource"/>
	    <xsl:element name="originatingSource">
		    <xsl:choose>
				<xsl:when test="$origSource!=''">
			        <xsl:value-of select="$origSource"/>
			    </xsl:when>
			    <xsl:otherwise><xsl:value-of select="'http://portal.auscope.org'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="buildNameWithSeparator">
		<xsl:param name="separator"/>
		<xsl:param name="name"/>
		<xsl:variable name="nameTokens" select="tokenize($name, $separator)"/>
		<xsl:variable name="tokenSize" select="count($nameTokens)"/>
		<xsl:element name="name">
			<xsl:attribute name="type"><xsl:text>primary</xsl:text></xsl:attribute>
			<xsl:choose>
				<xsl:when test="$separator=' '">
					<xsl:variable name="last" select="$nameTokens[$tokenSize]"/>
					<xsl:choose>
						<!-- Check for titles -->
						<xsl:when test="upper-case($nameTokens[1])='DR'">
							<xsl:choose>
								<xsl:when test="$tokenSize>3">
									<xsl:call-template name="buildName">
										<xsl:with-param name="title" select="$nameTokens[1]"/>
										<xsl:with-param name="first" select="$nameTokens[2]"/>
										<xsl:with-param name="middle" select="$nameTokens[3]"/>
										<xsl:with-param name="last" select="$last"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$tokenSize>2">
									<xsl:call-template name="buildName">
										<xsl:with-param name="title" select="$nameTokens[1]"/>
										<xsl:with-param name="first" select="$nameTokens[2]"/>
										<xsl:with-param name="last" select="$last"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="buildName">
										<xsl:with-param name="title" select="$nameTokens[1]"/>
										<xsl:with-param name="last" select="$last"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<!-- No titles -->
							<xsl:choose>
								<xsl:when test="$tokenSize>2">
									<xsl:call-template name="buildName">
										<xsl:with-param name="first" select="$nameTokens[1]"/>
										<xsl:with-param name="middle" select="$nameTokens[2]"/>
										<xsl:with-param name="last" select="$last"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$tokenSize>1">
									<xsl:call-template name="buildName">
										<xsl:with-param name="first" select="$nameTokens[1]"/>
										<xsl:with-param name="last" select="$last"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="buildName">
										<xsl:with-param name="first" select="$nameTokens[1]"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!-- Comma separator, a bit different. No titles and there could be multiple names -->
				<xsl:otherwise>
					<xsl:call-template name="buildName">
						<xsl:with-param name="last" select="$nameTokens[1]"/>
						<xsl:with-param name="first" select="$nameTokens[2]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="insertIndividualParty">
		<xsl:param name="individual"/>
		<xsl:param name="origSource"/>
		<xsl:variable name="individualName" select="$individual/gmd:individualName/gco:CharacterString"/>
		<xsl:element name="registryObjects">
			<xsl:attribute name="xsi:schemaLocation"><xsl:text>http://ands.org.au/standards/rif-cs/registryObjects http://services.ands.org.au/documentation/rifcs/schema/registryObjects.xsd</xsl:text></xsl:attribute>
			<xsl:element name="registryObject">
				<xsl:attribute name="group"><xsl:value-of select="$group"/></xsl:attribute>
				<xsl:element name="key">
					<xsl:value-of select="concat('http://portal.auscope.org/', $individualName)"/>
				</xsl:element>
				<xsl:call-template name="insertOriginatingSource">
					<xsl:with-param name="origSource" select="$origSource"/>
				</xsl:call-template>
				<xsl:element name="party">
					<xsl:attribute name="type"><xsl:text>person</xsl:text></xsl:attribute>
					<!-- Insert Trove identifier -->
					<xsl:if test="$parties!=''">
						<xsl:call-template name="insertTroveId">
							<xsl:with-param name="key" select="concat('http://portal.auscope.org/', $individualName)"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="contains($individualName, ',')">
							<xsl:call-template name="buildNameWithSeparator">
								<xsl:with-param name="name" select="$individualName"/>
								<xsl:with-param name="separator" select="',|\sAnd|AND|and\s'"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<!-- if there's no comma, separate by space -->
							<xsl:call-template name="buildNameWithSeparator">
								<xsl:with-param name="name" select="$individualName"/>
								<xsl:with-param name="separator" select="' '"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="$individual/gmd:organisationName[not(@gco:nilReason)] or $individual/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city or $individual/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone[gmd:voice or gmd:fax]">
						<xsl:element name="location">
							<xsl:element name="address">
								<xsl:apply-templates select="$individual/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice"/>
								<xsl:apply-templates select="$individual/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:facsimile"/>
								<xsl:apply-templates select="$individual/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress"/>
								<xsl:if test="$individual/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address">
									<xsl:element name="physical">
										<xsl:attribute name="type"><xsl:text>streetAddress</xsl:text></xsl:attribute>
										<xsl:apply-templates select="$individual/gmd:organisationName"/>
										<xsl:apply-templates select="$individual/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:deliveryPoint"/>
										<xsl:apply-templates select="$individual/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city"/>
										<xsl:apply-templates select="$individual/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:administrativeArea[not(@gco:nilReason)]"/>
										<xsl:apply-templates select="$individual/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode[not(@gco:nilReason)]"/>
										<xsl:apply-templates select="$individual/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:country"/>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:element>
					</xsl:if>
					<!-- related activity -->
					<xsl:for-each select="$activities/registryObjects/registryObject">
						<xsl:variable name="registryObject" select="." />
						<xsl:if test="./originatingSource!='' and contains($origSource, ./originatingSource)">
							<xsl:element name="relatedObject">
								<xsl:element name="key">
									<xsl:value-of select="$registryObject/key" />
								</xsl:element>
								<xsl:element name="relation">
									<xsl:attribute name="type"><xsl:text>pointOfContact</xsl:text></xsl:attribute>
								</xsl:element>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template name="insertOrganisations">
		<xsl:param name="organisations"/>
		<xsl:param name="origSource"/>
		<xsl:variable name="organisation" select="$organisations[1]/gmd:organisationName/gco:CharacterString"/>
		<xsl:if test="$organisation != ''">
			<xsl:element name="registryObjects">
				<xsl:attribute name="xsi:schemaLocation"><xsl:text>http://ands.org.au/standards/rif-cs/registryObjects http://services.ands.org.au/documentation/rifcs/schema/registryObjects.xsd</xsl:text></xsl:attribute>
				<xsl:element name="registryObject">
					<xsl:attribute name="group"><xsl:value-of
						select="$group" /></xsl:attribute>
					<xsl:element name="key">
						<xsl:value-of select="concat('http://portal.auscope.org/', $organisation)" />
					</xsl:element>
					<xsl:call-template name="insertOriginatingSource">
				        <xsl:with-param name="origSource" select="$origSource"/>
				    </xsl:call-template>			
					<xsl:element name="party">
						<xsl:attribute name="type"><xsl:text>group</xsl:text></xsl:attribute>
						<!-- Insert Trove identifier -->
						<xsl:if test="$parties!=''">
							<xsl:call-template name="insertTroveId">
								<xsl:with-param name="key"
									select="concat('http://portal.auscope.org/', $organisation)" />
							</xsl:call-template>
						</xsl:if>
						<xsl:element name="name">
							<xsl:attribute name="type"><xsl:text>primary</xsl:text></xsl:attribute>
							<xsl:element name="namePart">
								<xsl:value-of select="$organisation" />
							</xsl:element>
						</xsl:element>
						<!-- to normalise parties within a single record we need to group them, 
							obtain the fragment for each party with the most information, and at the 
							same time cope with rubbish data. In the end the only way to cope is to ensure 
							at least an organisation name, city, phone or fax exists (sigh) -->
						<xsl:for-each select="$organisations">
							<xsl:sort
								select="count(gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/child::*) + count(gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/child::*)"
								data-type="number" order="descending" />
							<xsl:choose>
								<xsl:when test="position()=1">
									<xsl:if
										test="gmd:organisationName[not(@gco:nilReason)] or gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city or gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone[gmd:voice or gmd:fax]">
										<xsl:element name="location">
											<xsl:element name="address">
												<xsl:apply-templates
													select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice" />
												<xsl:apply-templates
													select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:facsimile" />
												<xsl:apply-templates
													select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress" />
												<xsl:element name="physical">
													<xsl:attribute name="type"><xsl:text>streetAddress</xsl:text></xsl:attribute>
													<xsl:apply-templates select="gmd:organisationName" />
													<xsl:apply-templates
														select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:deliveryPoint" />
													<xsl:apply-templates
														select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city" />
													<xsl:apply-templates
														select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:administrativeArea[not(@gco:nilReason)]" />
													<xsl:apply-templates
														select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode[not(@gco:nilReason)]" />
													<xsl:apply-templates
														select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:country" />
												</xsl:element>
											</xsl:element>
										</xsl:element>
									</xsl:if>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
						<!-- related activity -->
						<xsl:for-each select="$activities/registryObjects/registryObject">
							<xsl:variable name="registryObject" select="." />
							<xsl:if
								test="./originatingSource!='' and contains($origSource, ./originatingSource)">
								<xsl:element name="relatedObject">
									<xsl:element name="key">
										<xsl:value-of select="$registryObject/key" />
									</xsl:element>
									<xsl:element name="relation">
										<xsl:attribute name="type"><xsl:text>pointOfContact</xsl:text></xsl:attribute>
									</xsl:element>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="gmd:MD_Metadata" >
		<!-- AuScope is a metadata aggregator, the origSource should reflect the originating source for each data provider  -->
		<xsl:variable name="origSource">
			<xsl:choose>
				<xsl:when test="gmd:identificationInfo/gmd:MD_DataIdentification">
					<xsl:choose>
						<xsl:when test="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions[1]/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[gmd:protocol='WWW:LINK-1.0-http--link']/gmd:linkage/gmd:URL!=''">
							<xsl:variable name="httpLinks" select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions[1]/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource[gmd:protocol='WWW:LINK-1.0-http--link']/gmd:linkage/gmd:URL"/>
							<!-- using the first http link as the originating source for manually created metadata -->
							<xsl:value-of select="$httpLinks[1]/*"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions[1]/gmd:MD_DigitalTransferOptions/gmd:onLine[1]/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations[1]/srv:SV_OperationMetadata/srv:connectPoint[1]/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- Check for invalid individual name 'Web Operations Manager' of Geoscience Australia -->
		<xsl:variable name="individual" select="descendant::gmd:pointOfContact[1]/gmd:CI_ResponsibleParty[gmd:individualName/gco:CharacterString!='' and not(contains(gmd:individualName/gco:CharacterString, 'Web ')) and gmd:individualName/gco:CharacterString!='Records Section' and not(gmd:role/gmd:CI_RoleCode/@codeListValue='')]"/>
		<xsl:variable name="individualName" select="$individual/gmd:individualName/gco:CharacterString"/>
		<xsl:choose>
			<xsl:when test="$individualName != ''">
				<!-- Create all the associated party objects for individuals -->
				<xsl:call-template name="insertIndividualParty">
					<xsl:with-param name="individual" select="$individual"/>
					<xsl:with-param name="origSource" select="$origSource"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="contact" select="descendant::gmd:contact[1]/gmd:CI_ResponsibleParty[gmd:individualName/gco:CharacterString!='' and not(contains(gmd:individualName/gco:CharacterString, 'Web ')) and gmd:individualName/gco:CharacterString!='Records Section' and not(gmd:role/gmd:CI_RoleCode/@codeListValue='')]"/>
				<xsl:variable name="contactName" select="$contact/gmd:individualName/gco:CharacterString"/>
				<xsl:choose>
					<xsl:when test="$contactName != ''">
						<!-- Create all the associated party objects for individuals -->
						<xsl:call-template name="insertIndividualParty">
							<xsl:with-param name="individual" select="$contact"/>
							<xsl:with-param name="origSource" select="$origSource"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<!-- Create all the associated party objects for organisations -->
						<xsl:call-template name="insertOrganisations">
							<xsl:with-param name="organisations" select="descendant::gmd:CI_ResponsibleParty[gmd:organisationName/gco:CharacterString!='' ]"/>
							<xsl:with-param name="origSource" select="$origSource"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="node()"/>
</xsl:stylesheet>
