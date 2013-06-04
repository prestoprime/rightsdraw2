
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
<xsl:param name="class">null</xsl:param>
<xsl:param name="ind">null</xsl:param>
<xsl:param name="md">null</xsl:param>
<xsl:param name="mdexact">false</xsl:param>
<xsl:param name="key">null</xsl:param>
<xsl:param name="value">null</xsl:param>
<xsl:param name="valueexact">false</xsl:param>
<xsl:param name="obj">null</xsl:param>
<xsl:param name="objtype">domain</xsl:param>
<xsl:param name="negative">false</xsl:param>
<xsl:variable name="neg">
	<xsl:choose>
		<xsl:when test="$negative = 'no' or $negative = 'off' or $negative = 'false' or $negative = '0'">false</xsl:when>
		<xsl:otherwise>true</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:template match="/">
	<xsl:apply-templates select="owl:Ontology" />
</xsl:template>

<xsl:template match="owl:Ontology">
	<xsl:variable name="classmatch">
		<xsl:choose>
			<xsl:when test="$ind != 'null' or $class != 'null'">
				<xsl:apply-templates select="owl:ClassAssertion" />
			</xsl:when>
			<xsl:otherwise>true</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="datamatch">
		<xsl:choose>
			<xsl:when test="$key != 'null' or $value != 'null'">
				<xsl:apply-templates select="owl:DataPropertyAssertion" />
			</xsl:when>
			<xsl:otherwise>true</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="mdmatch">
		<xsl:choose>
			<xsl:when test="$md != 'null'">
				<xsl:apply-templates select="owl:AnnotationAssertion" />
			</xsl:when>
			<xsl:otherwise>true</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="objmatch">
		<xsl:choose>
			<xsl:when test="$obj != 'null'">
				<xsl:apply-templates select="owl:ObjectPropertyAssertion" />
				<xsl:apply-templates select="owl:NegativeObjectPropertyAssertion" />
			</xsl:when>
			<xsl:otherwise>true</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="contains($classmatch,'true') and contains($datamatch,'true') and contains($mdmatch,'true') and contains($objmatch,'true')">true</xsl:when>
		<xsl:otherwise>false</xsl:otherwise>
	</xsl:choose>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="owl:ClassAssertion">
	<xsl:if test="($ind='null' or owl:NamedIndividual/@IRI=$ind) and ($class='null' or owl:Class/@IRI=$class)">true</xsl:if>
</xsl:template>

<xsl:template match="owl:ObjectPropertyAssertion">
	<xsl:if test="$neg = 'false' and $obj != 'null' and ($ind != 'null' or $class != 'null')">
		<xsl:variable name="targetind">
			<xsl:choose>
				<xsl:when test="$objtype='domain'">
					<xsl:value-of select="owl:NamedIndividual[position()=1]/@IRI"/>
				</xsl:when>
				<xsl:when test="$objtype='range'">
					<xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="owl:NamedIndividual[position()=1]/@IRI"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="targetclass">
			<xsl:value-of select="../owl:ClassAssertion[owl:NamedIndividual/@IRI=$targetind]/owl:Class/@IRI"/>
		</xsl:variable>
		<xsl:if test="owl:ObjectProperty/@IRI=$obj and ( $targetind = $ind or $targetclass = $class )">true</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="owl:NegativeObjectPropertyAssertion">
	<xsl:if test="$neg = 'true' and $obj != 'null' and ($ind != 'null' or $class != 'null')">
		<xsl:variable name="targetind">
			<xsl:choose>
				<xsl:when test="$objtype='domain'">
					<xsl:value-of select="owl:NamedIndividual[position()=1]/@IRI"/>
				</xsl:when>
				<xsl:when test="$objtype='range'">
					<xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="owl:NamedIndividual[position()=1]/@IRI"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="targetclass">
			<xsl:value-of select="../owl:ClassAssertion[owl:NamedIndividual/@IRI=$targetind]/owl:Class/@IRI"/>
		</xsl:variable>
		<xsl:if test="owl:ObjectProperty/@IRI=$obj and ( $targetind = $ind or $targetclass = $class )">true</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="owl:DataPropertyAssertion">
	<xsl:variable name="owner"><xsl:value-of select="owl:NamedIndividual/@IRI"/></xsl:variable>
	<xsl:if test="($key='null' or owl:DataProperty/@IRI=$key ) and ($owner=$ind or $ind='null')">
		<xsl:if test="$value = 'null' or ( $valueexact='true' and owl:Literal/text()=$value ) or contains(owl:Literal/text(),$value)">
			<xsl:choose>
				<xsl:when test="$class='null'">true</xsl:when>
				<xsl:when test="../owl:ClassAssertion[owl:NamedIndividual/@IRI=$owner]/owl:Class/@IRI=$class">true</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="owl:AnnotationAssertion">
	<!-- no check on AnnotationProperty, although it would be possible 
		reason: no input expected, might change in future version
	-->
	<xsl:variable name="owner"><xsl:value-of select="owl:IRI/text()"/></xsl:variable>
	<xsl:if test="$owner=$ind or $ind='null'">
		<xsl:if test="$md = 'null' or ( $mdexact='true' and owl:Literal/text()=$md ) or contains(owl:Literal/text(),$md)">
			<xsl:choose>
				<xsl:when test="$class='null'">true</xsl:when>
				<xsl:when test="../owl:ClassAssertion[owl:NamedIndividual/@IRI=$owner]/owl:Class/@IRI=$class">true</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
