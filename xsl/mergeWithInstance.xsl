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
	xmlns:xml="http://www.w3.org/XML/1998/namespace"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" >

<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<xsl:param name="extinstance">null</xsl:param>
<xsl:variable name="inputDoc"><xsl:value-of select="/"/></xsl:variable>

<xsl:template match="/">
	<xsl:apply-templates select="owl:Ontology" />
</xsl:template>

<xsl:template match="owl:Ontology">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:apply-templates select="owl:Prefix" />
		<xsl:apply-templates select="owl:Import" />
		<xsl:apply-templates select="owl:Declaration" />
		<xsl:variable name="ilist">
			<xsl:for-each select="/owl:Ontology/owl:Declaration/owl:NamedIndividual">
				<xsl:value-of select="@IRI"/>;
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="document($extinstance)/owl:Ontology/owl:Declaration">
			<xsl:variable name="iri"><xsl:value-of select="owl:NamedIndividual/@IRI"/>;</xsl:variable>
			<xsl:if test="contains($ilist,$iri)=false">
				<xsl:apply-templates select="."/>
			</xsl:if>
		</xsl:for-each>
		<!--xsl:apply-templates select="document($extinstance)/owl:Ontology/owl:Declaration" /-->
		<xsl:apply-templates select="owl:ClassAssertion" />
		<xsl:variable name="clist">
			<xsl:for-each select="/owl:Ontology/owl:ClassAssertion/owl:NamedIndividual">
				<xsl:value-of select="@IRI"/>;
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="document($extinstance)/owl:Ontology/owl:ClassAssertion">
			<xsl:variable name="iri"><xsl:value-of select="owl:NamedIndividual/@IRI"/>;</xsl:variable>
			<xsl:if test="contains($clist,$iri)=false">
				<xsl:apply-templates select="."/>
			</xsl:if>
		</xsl:for-each>
		<!--xsl:apply-templates select="document($extinstance)/owl:Ontology/owl:ClassAssertion" /-->
		<xsl:apply-templates select="owl:ObjectPropertyAssertion" />
		<xsl:variable name="oplist">
			<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion">
				(<xsl:value-of select="substring-after(owl:ObjectProperty/@IRI,'#')"/>,<xsl:value-of select="owl:NamedIndividual[position()=1]/@IRI"/>,<xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/>);
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="document($extinstance)/owl:Ontology/owl:ObjectPropertyAssertion">
			<xsl:variable name="iri">
				(<xsl:value-of select="substring-after(owl:ObjectProperty/@IRI,'#')"/>,<xsl:value-of select="owl:NamedIndividual[position()=1]/@IRI"/>,<xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/>);
			</xsl:variable>
			<xsl:if test="contains($oplist,$iri)=false">
				<xsl:apply-templates select="."/>
			</xsl:if>
		</xsl:for-each>
		<!--xsl:apply-templates select="document($extinstance)/owl:Ontology/owl:ObjectPropertyAssertion" /-->
		<xsl:apply-templates select="owl:NegativeObjectPropertyAssertion" />
		<xsl:variable name="noplist">
			<xsl:for-each select="/owl:Ontology/owl:NegativeObjectPropertyAssertion">
				(<xsl:value-of select="substring-after(owl:ObjectProperty/@IRI,'#')"/>,<xsl:value-of select="owl:NamedIndividual[position()=1]/@IRI"/>,<xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/>);
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="document($extinstance)/owl:Ontology/owl:NegativeObjectPropertyAssertion">
			<xsl:variable name="iri">
				(<xsl:value-of select="substring-after(owl:ObjectProperty/@IRI,'#')"/>,<xsl:value-of select="owl:NamedIndividual[position()=1]/@IRI"/>,<xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/>);
			</xsl:variable>
			<xsl:if test="contains($noplist,$iri)=false">
				<xsl:apply-templates select="."/>
			</xsl:if>
		</xsl:for-each>
		<!--xsl:apply-templates select="document($extinstance)/owl:Ontology/owl:NegativeObjectPropertyAssertion" /-->
		<xsl:apply-templates select="owl:DataPropertyAssertion" />
		<xsl:variable name="dplist">
			<xsl:for-each select="/owl:Ontology/owl:DataPropertyAssertion">
				(<xsl:value-of select="substring-after(owl:DataProperty/@IRI,'#')"/>,<xsl:value-of select="owl:NamedIndividual/@IRI"/>,<xsl:value-of select="owl:Literal/text()"/>);
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="document($extinstance)/owl:Ontology/owl:DataPropertyAssertion">
			<xsl:variable name="iri">
				(<xsl:value-of select="substring-after(owl:DataProperty/@IRI,'#')"/>,<xsl:value-of select="owl:NamedIndividual/@IRI"/>,<xsl:value-of select="owl:Literal/text()"/>);
			</xsl:variable>
			<xsl:if test="contains($dplist,$iri)=false">
				<xsl:apply-templates select="."/>
			</xsl:if>
		</xsl:for-each>
		<!--xsl:apply-templates select="document($extinstance)/owl:Ontology/owl:DataPropertyAssertion" /-->
		<xsl:apply-templates select="owl:NegativeDataPropertyAssertion" />
		<xsl:variable name="ndplist">
			<xsl:for-each select="/owl:Ontology/owl:NegativeDataPropertyAssertion">
				(<xsl:value-of select="substring-after(owl:DataProperty/@IRI,'#')"/>,<xsl:value-of select="owl:NamedIndividual/@IRI"/>,<xsl:value-of select="owl:Literal/text()"/>);
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="document($extinstance)/owl:Ontology/owl:NegativeDataPropertyAssertion">
			<xsl:variable name="iri">
				(<xsl:value-of select="substring-after(owl:DataProperty/@IRI,'#')"/>,<xsl:value-of select="owl:NamedIndividual/@IRI"/>,<xsl:value-of select="owl:Literal/text()"/>);
			</xsl:variable>
			<xsl:if test="contains($ndplist,$iri)=false">
				<xsl:apply-templates select="."/>
			</xsl:if>
		</xsl:for-each>
		<!--xsl:apply-templates select="document($extinstance)/owl:Ontology/owl:NegativeDataPropertyAssertion" /-->
		<xsl:apply-templates select="owl:AnnotationAssertion" />
		<xsl:variable name="aalist">
			<xsl:for-each select="/owl:Ontology/owl:AnnotationAssertion">
				(<xsl:value-of select="owl:AnnotationProperty/@IRI"/>,<xsl:value-of select="owl:IRI/text()"/>,<xsl:value-of select="owl:Literal/text()"/>);
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="document($extinstance)/owl:Ontology/owl:AnnotationAssertion">
			<xsl:variable name="iri">
				(<xsl:value-of select="owl:AnnotationProperty/@IRI"/>,<xsl:value-of select="owl:IRI/text()"/>,<xsl:value-of select="owl:Literal/text()"/>);
			</xsl:variable>
			<xsl:if test="contains($aalist,$iri)=false">
				<xsl:apply-templates select="."/>
			</xsl:if>
		</xsl:for-each>
		<!--xsl:apply-templates select="document($extinstance)/owl:Ontology/owl:AnnotationAssertion" /-->
	</xsl:copy>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
