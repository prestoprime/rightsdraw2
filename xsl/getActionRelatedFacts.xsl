
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
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" indent="yes" omit-xml-declaration="yes"/>
<!-- Although the parameter is named permission, it could be a FactComposition as well (e.g. FactIntersection)-->
<xsl:param name="permission">null</xsl:param>


<xsl:template match="/">
	<xsl:apply-templates select="owl:Ontology" />
</xsl:template>

<xsl:template match="owl:Ontology">
	<xsl:apply-templates select="owl:ObjectPropertyAssertion[substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired' or substring-after(owl:ObjectProperty/@IRI,'#')='hasFact']" />
</xsl:template>


<xsl:template match="owl:ObjectPropertyAssertion">
	<xsl:if test="owl:NamedIndividual[position()=1]/@IRI = $permission or $permission='null'">
		<xsl:variable name="ind"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="count"><xsl:value-of select="count(../owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=2]/@IRI=$ind and substring-after(owl:ObjectProperty/@IRI,'#')!='makesTrue'])"/></xsl:variable>
		<xsl:if test="$count = 1">
			<xsl:apply-templates select="../owl:ClassAssertion[owl:NamedIndividual/@IRI=$ind]"/>
		</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="owl:ClassAssertion">
	<xsl:if test="substring-after(owl:Class/@IRI,'#')='ActionStarted' or substring-after(owl:Class/@IRI,'#')='ActionDone'">
		<xsl:value-of select="owl:NamedIndividual/@IRI"/><xsl:text>
</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
