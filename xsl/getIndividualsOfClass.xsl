
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
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" indent="yes" omit-xml-declaration="yes"/>
<xsl:param name="classname">null</xsl:param>
<xsl:param name="classiri">null</xsl:param>

<xsl:template match="/">
	<xsl:apply-templates select="owl:Ontology" />
</xsl:template>

<xsl:template match="owl:Ontology">
	<xsl:choose>
		<xsl:when test="$classiri != 'null'">
<xsl:apply-templates select="owl:ClassAssertion[owl:Class/@IRI=$classiri]" />
		</xsl:when>
		<xsl:otherwise>
<xsl:apply-templates select="owl:ClassAssertion[substring-after(owl:Class/@IRI,'#')=$classname]" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="owl:ClassAssertion">
	<xsl:value-of select="owl:NamedIndividual/@IRI"/><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
