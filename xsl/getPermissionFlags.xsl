
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
<xsl:param name="perm">null</xsl:param>

<xsl:variable name="isexclusive"><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$perm and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#isExclusive']/owl:Literal/text()"/></xsl:variable>
<xsl:variable name="hassublicense"><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$perm and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#hasSublicenseRight']/owl:Literal/text()"/></xsl:variable>

<xsl:template match="/">
	<xsl:choose>
		<xsl:when test="$isexclusive = '' or $isexclusive='false'">isexclusive:false</xsl:when>
		<xsl:otherwise>isexclusive:true</xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="$hassublicense='false'">hassublicense:false</xsl:when>
		<xsl:otherwise>hassublicense:true</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
