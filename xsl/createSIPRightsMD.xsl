<!--
#  rightsdraw
#  Version: 2.0.1
#  Authors: L. Boch
#
#  Copyright (C) 2010-2012 RAI - Radiotelevisione Italiana <cr_segreteria@rai.it>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
-->



<xsl:stylesheet version="1.0" 
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<xsl:param name="account">null</xsl:param>
<xsl:param name="created">null</xsl:param>
<xsl:variable name="ipentity"><xsl:value-of select="owl:Ontology/owl:ClassAssertion[substring-after(owl:Class/@IRI,'#')='IPEntity']/owl:NamedIndividual/@IRI"/></xsl:variable>


<xsl:template match="/">
<mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:acl="http://eu.prestoprime/xsd/acl">
	<xsl:attribute name="LABEL">pPRIME SIP</xsl:attribute>
	<xsl:attribute name="OBJID"><xsl:value-of select="concat($account,'_',$created)"/></xsl:attribute>
	<metsHdr>
		<xsl:attribute name="CREATEDATE"><xsl:value-of select="$created"/></xsl:attribute>
		<agent ROLE="CREATOR"><name><xsl:value-of select="$account"/></name></agent>
	</metsHdr>
	<dmdSec ID="d001">
		<mdWrap MDTYPE="DC">
			<xmlData>
				<dc:record>
	<dc:identifier><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$ipentity and owl:DataProperty/@IRI='urn:mpeg:mpeg21:2002:01-DII-NS#Identifier']/owl:Literal/text()"/></dc:identifier>
	<dc:title><xsl:value-of select="/owl:Ontology/owl:AnnotationAssertion[owl:IRI=$ipentity and owl:AnnotationProperty/@IRI='http://purl.org/dc/elements/1.1/title']/owl:Literal/text()"/></dc:title>
	<dc:description><xsl:value-of select="/owl:Ontology/owl:AnnotationAssertion[owl:IRI=$ipentity and owl:AnnotationProperty/@IRI='http://purl.org/dc/elements/1.1/description']/owl:Literal/text()"/></dc:description>
				</dc:record>
			</xmlData>
		</mdWrap>
	</dmdSec>
	<amdSec ID="a001">
		<xsl:element name="rightsMD">
			<xsl:attribute name="ID">pprights</xsl:attribute>
			<xsl:attribute name="CREATEDATE"><xsl:value-of select="$created"/></xsl:attribute>
			<xsl:element name="mdWrap">
				<xsl:attribute name="MDTYPE">OTHER</xsl:attribute>
				<xsl:attribute name="OTHERMDTYPE">PPAVRO</xsl:attribute>
				<xsl:attribute name="LABEL">PPRIGHTS</xsl:attribute>
				<xmlData>
					<xsl:apply-templates select="owl:Ontology"/>
				</xmlData>
			</xsl:element>
		</xsl:element>
	</amdSec>
	<structMap  LABEL="PPRIME-AV"><div/></structMap>
</mets>
</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
