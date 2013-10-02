
<!--
#  rightsdraw
#  Version: 2.0.2
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
<xsl:param name="wideclassiri">null</xsl:param>
<xsl:param name="narrowclassiri">null</xsl:param>
<xsl:variable name="ontologyiri"><xsl:value-of select="/owl:Ontology/@ontologyIRI"/></xsl:variable>
<xsl:variable name="mvcoprefix"><xsl:value-of select="/owl:Ontology/owl:Prefix[@name='mvco']/@IRI"/></xsl:variable>
<xsl:variable name="narrow">
	<xsl:choose>
		<xsl:when test="substring-before($narrowclassiri,'#')!=''">#<xsl:value-of select="substring-after($narrowclassiri,'#')"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="$narrowclassiri"/></xsl:otherwise>
	</xsl:choose>
</xsl:variable>
<xsl:variable name="wide">
	<xsl:choose>
		<xsl:when test="substring-before($wideclassiri,'#')!=''">#<xsl:value-of select="substring-after($wideclassiri,'#')"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="$wideclassiri"/></xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<!-- ************************************************************-->
<xsl:template match="/">
	<xsl:variable name="narrowuplist">
		<xsl:call-template name="getSubClasses">
			<xsl:with-param name="classstart" select="$narrow"/>
			<xsl:with-param name="classstop" select="$wide"/>
			<xsl:with-param name="continuelist" select="null"/>
			<xsl:with-param name="dir" select="2"/>
		</xsl:call-template>
	</xsl:variable>
<!--
	[<xsl:value-of select="$narrowclassiri"/>]
	[<xsl:value-of select="$wideclassiri"/>]
	[<xsl:value-of select="$narrowuplist"/>]
	[<xsl:value-of select="$mvcoprefix"/>]
	[<xsl:value-of select="$ontologyiri"/>]
-->
	<xsl:call-template name="getSubClasses">
		<xsl:with-param name="classstart" select="$wide"/>
		<xsl:with-param name="classstop" select="$narrow"/>
		<xsl:with-param name="continuelist" select="$narrowuplist"/>
		<xsl:with-param name="dir" select="1"/>
	</xsl:call-template>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="getSubClasses">
	<xsl:param name="classstart" select="null"/>
	<xsl:param name="classstop" select="null"/>
	<xsl:param name="continuelist" select="null"/>
	<xsl:param name="dir" select="1"/>
	<xsl:for-each select="/owl:Ontology/owl:SubClassOf[owl:Class/@IRI=$classstart or substring-after(owl:Class/@abbreviatedIRI,'mvco:')=substring-after($classstart,'#')]/owl:Class[position()=$dir]">
		<xsl:variable name="classiri">
			<xsl:choose>
				<xsl:when test="@IRI"><xsl:value-of select="@IRI"/></xsl:when>
				<xsl:otherwise>#<xsl:value-of select="substring-after(@abbreviatedIRI,'mvco:')"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$classiri != $classstart and $classiri != $classstop">
			<!--xsl:value-of select="$classiri"/><xsl:text>; </xsl:text>-->
			<xsl:choose>
				<xsl:when test="substring-before(@IRI,'#')!=''"><xsl:value-of select="@IRI"/></xsl:when>
				<xsl:when test="@IRI"><xsl:value-of select="$ontologyiri"/><xsl:value-of select="@IRI"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$mvcoprefix"/><xsl:value-of select="substring-after(@abbreviatedIRI,'mvco:')"/></xsl:otherwise>
			</xsl:choose><xsl:text>
</xsl:text>
			<xsl:if test="$continuelist='null' or contains($continuelist,$classiri)">
				<xsl:call-template name="getSubClasses">
					<xsl:with-param name="classstart" select="$classiri"/>
					<xsl:with-param name="classstop" select="$classstop"/>
					<xsl:with-param name="continuelist" select="$continuelist"/>
					<xsl:with-param name="dir" select="$dir"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:for-each>
</xsl:template>

<!-- ************************************************************-->


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
