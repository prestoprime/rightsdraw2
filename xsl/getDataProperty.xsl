
<!--
#  rightsdraw
#  Version: 2.0.1
#  Authors: L. Boch
#
#  Copyright (C) 2010-2013 RAI - Radiotelevisione Italiana <cr_segreteria@rai.it>
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

<xsl:output method="text" indent="yes" omit-xml-declaration="yes"/>

<xsl:param name="key">null</xsl:param>
<xsl:param name="owner">null</xsl:param>
<xsl:param name="negative">no</xsl:param>

<xsl:template match="/">
	<xsl:choose>
		<xsl:when test="$key != 'null' and $negative = 'no'">
<xsl:for-each select="owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$owner and owl:DataProperty/@IRI=$key]">
	<xsl:value-of select="owl:Literal/text()"/>
</xsl:for-each>
		</xsl:when>
		<xsl:when test="$key != 'null' and $negative = 'yes'">
<xsl:for-each select="owl:Ontology/owl:NegativeDataPropertyAssertion[owl:NamedIndividual/@IRI=$owner and owl:DataProperty/@IRI=$key]">
	<xsl:value-of select="owl:Literal/text()"/>
</xsl:for-each>
		</xsl:when>
		<xsl:when test="$key = 'null' and $negative = 'no'">
<xsl:for-each select="owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$owner]">
	<xsl:value-of select="owl:DataProperty/@IRI"/>	
</xsl:for-each>
		</xsl:when>
		<xsl:when test="$key = 'null' and $negative = 'yes'">
<xsl:for-each select="owl:Ontology/owl:NegativeDataPropertyAssertion[owl:NamedIndividual/@IRI=$owner]">
	<xsl:value-of select="owl:DataProperty/@IRI"/>	
</xsl:for-each>
		</xsl:when>
		<xsl:otherwise/>
	</xsl:choose>
</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
