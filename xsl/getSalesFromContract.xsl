
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
<xsl:param name="maxloops">20</xsl:param>
<xsl:param name="contractiri">null</xsl:param>
<xsl:param name="avidentifier">null</xsl:param>
<xsl:param name="issueriri">null</xsl:param>
<xsl:param name="principaliri">null</xsl:param>

<!-- Find which permission match the stuff to be added -->
<!-- Contract, Permission, Issuer -->
<xsl:template match="/">

<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#issuedIn' and owl:NamedIndividual[position()=2]/@IRI=$contractiri]">
	<xsl:variable name="perm"><xsl:value-of select="owl:NamedIndividual[position()=1]/@IRI"/></xsl:variable>
	<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#issuedBy' and owl:NamedIndividual[position()=1]/@IRI=$perm and owl:NamedIndividual[position()=2]/@IRI=$issueriri]">
		<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#permitsAction' and owl:NamedIndividual[position()=1]/@IRI=$perm]">
			<xsl:variable name="action"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
			<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#actedBy' and owl:NamedIndividual[position()=1]/@IRI=$action and owl:NamedIndividual[position()=2]/@IRI=$principaliri]">
				<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#actedOver' and owl:NamedIndividual[position()=1]/@IRI=$action]">
					<xsl:variable name="ipentity"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
<!-- permits ipentity match not to be exact -->
					<xsl:for-each select="/owl:Ontology/owl:DataPropertyAssertion[owl:DataProperty/@IRI='urn:mpeg:mpeg21:2002:01-DII-NS#Identifier' and ( owl:NamedIndividual/@IRI=$ipentity and owl:Literal/text()=$avidentifier )]">
						<xsl:value-of select="$perm"/><xsl:text>
</xsl:text>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:for-each>
</xsl:for-each>

</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
