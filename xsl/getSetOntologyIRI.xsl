<!--
#  rightsdraw
#  Version: 2.0.1
#  Authors: L. Boch
#
#  Copyritght (C) 2012-2013 RAI – Radiotelevisione Italiana <cr_segreteria@rai.it>
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
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:xml="http://www.w3.org/XML/1998/namespace"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" >

<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
<xsl:param name="setIRI">null</xsl:param>
<xsl:param name="afterPrefix"/>
<xsl:variable name="iriAfterPrefix"><xsl:value-of select="substring-after(owl:Ontology/@ontologyIRI,$afterPrefix)"/></xsl:variable>

<xsl:template match="/">
	<xsl:choose>
		<xsl:when test="$setIRI = 'null' and $iriAfterPrefix != ''">
			<xsl:value-of select="$iriAfterPrefix"/>
		</xsl:when>
		<xsl:when test="$setIRI = 'null' and $iriAfterPrefix = ''"></xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="@*|node()" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="owl:Ontology">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:apply-templates select="@*|node()" />
	</xsl:copy>
</xsl:template>

<xsl:template match="@ontologyIRI">
		<xsl:attribute name="ontologyIRI"><xsl:value-of select="$setIRI"/></xsl:attribute>
		<xsl:attribute name="xml:base"><xsl:value-of select="$setIRI"/></xsl:attribute>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
