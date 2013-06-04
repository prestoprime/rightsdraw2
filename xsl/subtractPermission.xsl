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
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" indent="yes" omit-xml-declaration="yes"/>
<!-- sure-of-->
<xsl:param name="minuend">null</xsl:param>
<xsl:param name="subtrahend">null</xsl:param>
<xsl:param name="subtrahenddoc">null</xsl:param>
<!-- this param is used to avoid infinite loops. Just check is high enough for your contexts -->
<!-- doubts-->

<!-- This stylesheet only works on Permissions. For supporting other deontic expressions other work will be required -->

<xsl:variable name="minuendfacts">MinuendFacts: <xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$minuend and owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#hasRequired']"> <xsl:variable name="ind"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable> {<xsl:value-of select="/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$ind]/owl:Class/@IRI"/> <xsl:for-each select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$ind]">(<xsl:value-of select="owl:DataProperty/@IRI"/>=<xsl:value-of select="owl:Literal/text()"/>),</xsl:for-each>},</xsl:for-each><xsl:for-each select="/owl:Ontology/owl:NegativeObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$minuend and owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#hasRequired']"><xsl:variable name="ind"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>{NOT <xsl:value-of select="/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$ind]/owl:Class/@IRI"/><xsl:for-each select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$ind]">(<xsl:value-of select="owl:DataProperty/@IRI"/>=<xsl:value-of select="owl:Literal/text()"/>),</xsl:for-each>},</xsl:for-each></xsl:variable>

<xsl:variable name="minuendaction"><xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$minuend and owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#permitsAction']"><xsl:variable name="ind"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable><xsl:value-of select="/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$ind]/owl:Class/@IRI"/></xsl:for-each></xsl:variable>

<xsl:variable name="subtrahendaction"><xsl:for-each select="document($subtrahenddoc)/owl:Ontology/owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$subtrahend and owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#permitsAction']"><xsl:variable name="ind"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable><xsl:value-of select="document($subtrahenddoc)/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$ind]/owl:Class/@IRI"/></xsl:for-each></xsl:variable>

<xsl:template match="/">
	<xsl:value-of select="$minuendfacts"/>
<xsl:text>
</xsl:text>
	<xsl:if test="$minuendaction!=$subtrahendaction">ActionMismatch:<xsl:text>	</xsl:text><xsl:value-of select="$minuendaction"/><xsl:text>      </xsl:text><xsl:value-of select="$subtrahendaction"/><xsl:text>
</xsl:text> 
	</xsl:if>
	<xsl:for-each select="document($subtrahenddoc)/owl:Ontology/owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$subtrahend and owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#hasRequired']">
		<xsl:variable name="ind"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="fact">{<xsl:value-of select="document($subtrahenddoc)/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$ind]/owl:Class/@IRI"/><xsl:for-each select="document($subtrahenddoc)/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$ind]">(<xsl:value-of select="owl:DataProperty/@IRI"/>=<xsl:value-of select="owl:Literal/text()"/>),</xsl:for-each>}</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($minuendfacts,$fact)"> </xsl:when>
			<xsl:otherwise>
Fact:<xsl:text>	</xsl:text><xsl:value-of select="document($subtrahenddoc)/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$ind]/owl:Class/@IRI"/><xsl:text>	</xsl:text><xsl:value-of select="$ind"/><xsl:text>
</xsl:text>			<xsl:for-each select="document($subtrahenddoc)/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$ind]">
DataPropertyOf<xsl:value-of select="$ind"/><xsl:text>	</xsl:text><xsl:value-of select="owl:DataProperty/@IRI"/><xsl:text>	</xsl:text><xsl:value-of select="owl:Literal/text()"/><xsl:text>
</xsl:text> 
				</xsl:for-each> 
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	<xsl:for-each select="document($subtrahenddoc)/owl:Ontology/owl:NegativeObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$subtrahend and owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#hasRequired']">
		<xsl:variable name="ind"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="fact">{NOT <xsl:value-of select="document($subtrahenddoc)/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$ind]/owl:Class/@IRI"/><xsl:for-each select="document($subtrahenddoc)/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$ind]">(<xsl:value-of select="owl:DataProperty/@IRI"/>=<xsl:value-of select="owl:Literal/text()"/>),</xsl:for-each>}</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($minuendfacts,$fact)"> </xsl:when>
			<xsl:otherwise>
NegativeFact:<xsl:text>	</xsl:text><xsl:value-of select="document($subtrahenddoc)/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$ind]/owl:Class/@IRI"/><xsl:text>	</xsl:text><xsl:value-of select="$ind"/><xsl:text>
</xsl:text>
				<xsl:for-each select="document($subtrahenddoc)/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$ind]">
DataPropertyOf<xsl:value-of select="$ind"/><xsl:text>	</xsl:text><xsl:value-of select="owl:DataProperty/@IRI"/><xsl:text>	</xsl:text><xsl:value-of select="owl:Literal/text()"/><xsl:text>
</xsl:text>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
