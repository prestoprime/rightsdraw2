
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
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:xml="http://www.w3.org/XML/1998/namespace"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" >

<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<xsl:param name="key">null</xsl:param>
<xsl:param name="owner">null</xsl:param>
<xsl:param name="value">null</xsl:param>

<xsl:template match="/">
	<xsl:apply-templates select="@*|node()" />
</xsl:template>


<xsl:template match="owl:DataPropertyAssertion">
	<xsl:variable name="okey"><xsl:value-of select="substring-after(owl:DataProperty/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="oowner"><xsl:value-of select="owl:NamedIndividual/@IRI"/></xsl:variable>
	<xsl:variable name="ovalue"><xsl:value-of select="owl:Literal/text()"/></xsl:variable>
	<xsl:if test="$key != $okey or $owner != $oowner or ( $value != $ovalue and $value != 'null')">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:if>
<!--blockquote>
	<xsl:value-of select="$owner"/>
	<xsl:value-of select="$key"/>
	<xsl:value-of select="$value"/>
	<xsl:value-of select="$oowner"/>
	<xsl:value-of select="$okey"/>
	<xsl:value-of select="$ovalue"/>
</blockquote-->
</xsl:template>

<xsl:template match="owl:NegativeDataPropertyAssertion">
	<xsl:variable name="okey"><xsl:value-of select="substring-after(owl:DataProperty/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="oowner"><xsl:value-of select="owl:NamedIndividual/@IRI"/></xsl:variable>
	<xsl:variable name="ovalue"><xsl:value-of select="owl:Literal/text()"/></xsl:variable>
	<xsl:if test="$key != $okey or $owner != $oowner or ( $value != $ovalue and $value != 'null')">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:if>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
