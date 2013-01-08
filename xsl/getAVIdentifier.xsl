
<!--
#  rightsdraw
#  Version: 2.0.1
#  Authors: L. Boch
#
#  Copyritght (C) 2012-2013 RAI - Radiotelevisione Italiana <cr_segreteria@rai.it>
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
<xsl:output method="text" indent="yes" omit-xml-declaration="yes"/>
<xsl:param name="showIPEntityIRI">false</xsl:param>
<xsl:param name="showIDsuffix">false</xsl:param>
<xsl:variable name="owliri"><xsl:value-of select="/owl:Ontology/@ontologyIRI"/></xsl:variable>

<xsl:template match="/">
	<xsl:apply-templates select="owl:Ontology/owl:ClassAssertion[substring-after(owl:Class/@IRI,'#')='IPEntity']" />
</xsl:template>

<xsl:template match="owl:ClassAssertion">
	<xsl:variable name="ind"><xsl:value-of select="owl:NamedIndividual/@IRI"/></xsl:variable>
	<xsl:apply-templates select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$ind]" />
</xsl:template>

<xsl:template match="owl:DataPropertyAssertion">
	<xsl:if test="owl:DataProperty/@IRI='urn:mpeg:mpeg21:2002:01-DII-NS#Identifier'">
		<xsl:variable name="dummy"><xsl:value-of select="substring-before(owl:Literal/text(),'#')"/></xsl:variable>
		<xsl:if test="$showIPEntityIRI = 'true'">
			<xsl:value-of select="concat(owl:NamedIndividual/@IRI,' ')"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$showIDsuffix = 'true' or $dummy = ''">
				<xsl:value-of select="owl:Literal/text()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$dummy"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>
</xsl:text>
	</xsl:if>
</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
