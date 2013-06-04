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
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
<xsl:param name="maxloops">20</xsl:param>
<xsl:param name="perm">null</xsl:param>
<xsl:param name="excludeActedOver">yes</xsl:param>
<xsl:param name="excludeActedBy">yes</xsl:param>

<xsl:variable name="ind2keep">
	(<xsl:value-of select="$perm"/>),
	<xsl:call-template name="findrelated">
		<xsl:with-param name="target"><xsl:value-of select="$perm"/></xsl:with-param>
		<xsl:with-param name="ind"><xsl:value-of select="$perm"/></xsl:with-param>
		<xsl:with-param name="loops"><xsl:value-of select="$maxloops"/></xsl:with-param>
	</xsl:call-template>
</xsl:variable>

<!-- excluded parties and textual clauses -->
<!-- should it excluse actedOver as well?  depends on rightscompare (now it doesn't support to have it, pls check) -->
<xsl:template name="findrelated">
	<xsl:param name="target"/>
	<xsl:param name="ind"/>
	<xsl:param name="loops"/>
	<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI!='urn:mpeg:mpeg21:mco:core:2012#hasParty' and owl:ObjectProperty/@IRI!='urn:mpeg:mpeg21:mco:core:2012#implements' and (owl:ObjectProperty/@IRI!='http://purl.oclc.org/NET/mvco.owl#actedBy' or $excludeActedBy!='yes') and owl:ObjectProperty/@IRI!='urn:mpeg:mpeg21:mco:core:2012#hasSignatory' and owl:ObjectProperty/@IRI!='urn:mpeg:mpeg21:mco:core:2012#isSignedBy' and owl:NamedIndividual[position()=1]/@IRI=$ind and (owl:ObjectProperty/@IRI!='http://purl.oclc.org/NET/mvco.owl#actedOver' or $excludeActedOver!='yes')]">
		<xsl:variable name="next"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		(<xsl:value-of select="$next"/>),
		<xsl:if test="$next!=$target and $loops &gt; 0">
			<xsl:call-template name="findrelated">
				<xsl:with-param name="target"><xsl:value-of select="$target"/></xsl:with-param>
				<xsl:with-param name="ind"><xsl:value-of select="$next"/></xsl:with-param>
				<xsl:with-param name="loops"><xsl:value-of select="$loops - 1"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:for-each>
	<xsl:for-each select="/owl:Ontology/owl:NegativeObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$ind]">
		<xsl:variable name="next"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		(<xsl:value-of select="$next"/>),
		<xsl:if test="$next!=$target and $loops &gt; 0">
			<xsl:call-template name="findrelated">
				<xsl:with-param name="target"><xsl:value-of select="$target"/></xsl:with-param>
				<xsl:with-param name="ind"><xsl:value-of select="$next"/></xsl:with-param>
				<xsl:with-param name="loops"><xsl:value-of select="$loops - 1"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template match="/">
	<xsl:apply-templates select="@*|node()" />
</xsl:template>

<xsl:template match="owl:ClassAssertion">
	<xsl:variable name="this">(<xsl:value-of select="owl:NamedIndividual/@IRI"/>)</xsl:variable>
	<xsl:if test="contains($ind2keep,$this)">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:if>
</xsl:template>

<xsl:template match="owl:Declaration">
	<xsl:variable name="this">(<xsl:value-of select="owl:NamedIndividual/@IRI"/>)</xsl:variable>
	<xsl:if test="contains($ind2keep,$this)">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:if>
</xsl:template>

<xsl:template match="owl:ObjectPropertyAssertion">
	<xsl:variable name="this">(<xsl:value-of select="owl:NamedIndividual[position()=1]/@IRI"/>)</xsl:variable>
	<xsl:if test="contains($ind2keep,$this) and owl:ObjectProperty/@IRI!='urn:mpeg:mpeg21:mco:core:2012#hasParty' and owl:ObjectProperty/@IRI!='urn:mpeg:mpeg21:mco:core:2012#implements' and (owl:ObjectProperty/@IRI!='http://purl.oclc.org/NET/mvco.owl#actedBy' or $excludeActedBy!='yes') and owl:ObjectProperty/@IRI!='urn:mpeg:mpeg21:mco:core:2012#hasSignatory' and owl:ObjectProperty/@IRI!='urn:mpeg:mpeg21:mco:core:2012#isSignedBy' and (owl:ObjectProperty/@IRI!='http://purl.oclc.org/NET/mvco.owl#actedOver' or $excludeActedOver!='yes')">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:if>
</xsl:template>
	
<xsl:template match="owl:NegativeObjectPropertyAssertion">
	<xsl:variable name="this">(<xsl:value-of select="owl:NamedIndividual[position()=1]/@IRI"/>)</xsl:variable>
	<xsl:if test="contains($ind2keep,$this)">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:if>
</xsl:template>

<!-- excluding narrative contract here -->
<xsl:template match="owl:DataPropertyAssertion">
	<xsl:variable name="this">(<xsl:value-of select="owl:NamedIndividual/@IRI"/>)</xsl:variable>
	<xsl:if test="contains($ind2keep,$this) and owl:DataProperty/@IRI!='urn:mpeg:mpeg21:mco:core:2012#TextVersion'">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:if>
</xsl:template>
	
<xsl:template match="owl:NegativeDataPropertyAssertion">
	<xsl:variable name="this">(<xsl:value-of select="owl:NamedIndividual/@IRI"/>)</xsl:variable>
	<xsl:if test="contains($ind2keep,$this)">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:if>
</xsl:template>

<xsl:template match="owl:AnnotationAssertion">
	<xsl:variable name="this">(<xsl:value-of select="owl:IRI/text()"/>)</xsl:variable>
	<xsl:if test="contains($ind2keep,$this)">
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
