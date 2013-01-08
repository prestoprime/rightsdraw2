
<!--
#  rightsdraw
#  Version: 2.0.1
#  Authors: L. Boch
#
#  Copyright (C) 2010-2012 RAI – Radiotelevisione Italiana <cr_segreteria@rai.it>
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
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xml="http://www.w3.org/XML/1998/namespace"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" >

<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<xsl:variable name="present">no</xsl:variable>
<xsl:param name="obj">null</xsl:param>
<xsl:param name="one">null</xsl:param>
<xsl:param name="twoname">null</xsl:param>
<xsl:param name="twoclass">null</xsl:param>
<xsl:param name="negative">no</xsl:param>
<xsl:variable name="irione"><xsl:value-of select="$one"/></xsl:variable>
<xsl:variable name="iritwoname"><xsl:value-of select="$twoname"/></xsl:variable>

<xsl:template match="/">
	<xsl:apply-templates select="owl:Ontology" />
</xsl:template>

<xsl:template match="owl:Ontology">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:apply-templates select="owl:Prefix" />
		<xsl:apply-templates select="owl:Import" />
		<xsl:apply-templates select="owl:Declaration" />
		<xsl:choose>
			<xsl:when test="owl:Declaration/owl:NamedIndividual/@IRI = $iritwoname"></xsl:when>
			<xsl:otherwise>
				<xsl:element name="Declaration" namespace="http://www.w3.org/2002/07/owl#">
					<xsl:element name="NamedIndividual" namespace="http://www.w3.org/2002/07/owl#">
						<xsl:attribute name="IRI"><xsl:value-of select="$iritwoname"/></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="owl:ClassAssertion" />
		<xsl:choose>
			<xsl:when test="owl:ClassAssertion/owl:NamedIndividual/@IRI = $iritwoname and owl:ClassAssertion/owl:Class/@IRI = $twoclass"></xsl:when>
			<xsl:when test="owl:ClassAssertion/owl:NamedIndividual/@IRI = $iritwoname"></xsl:when>
			<xsl:otherwise>
				<xsl:element name="ClassAssertion" namespace="http://www.w3.org/2002/07/owl#">
					<xsl:element name="Class" namespace="http://www.w3.org/2002/07/owl#">
						<xsl:attribute name="IRI"><xsl:value-of select="$twoclass"/></xsl:attribute>
					</xsl:element>
					<xsl:element name="NamedIndividual" namespace="http://www.w3.org/2002/07/owl#">
						<xsl:attribute name="IRI"><xsl:value-of select="$iritwoname"/></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="owl:ObjectPropertyAssertion" />
		<xsl:apply-templates select="owl:NegativeObjectPropertyAssertion" />
		<xsl:apply-templates select="owl:DataPropertyAssertion" />
		<xsl:apply-templates select="owl:NegativeDataPropertyAssertion" />
		<xsl:apply-templates select="owl:AnnotationAssertion" />
	</xsl:copy>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
