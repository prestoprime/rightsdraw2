
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
<xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>
<xsl:param name="instance">null</xsl:param>
<xsl:param name="handle">null</xsl:param>

<xsl:template match="/">
<html>
	<head></head>
	<body>
		<h4><xsl:value-of select="substring-after(owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$handle]/owl:Class/@IRI,'#')"/>: "<xsl:value-of select="$handle"/>"</h4>
		<xsl:apply-templates select="owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$handle and substring-after(owl:DataProperty/@IRI,'#')='TextVersion']" />
	</body>
</html>
</xsl:template>

<!-- ************************************************************-->

<xsl:template match="owl:DataPropertyAssertion">
<div style="float:left">
	<pre>
<xsl:value-of select="owl:Literal/text()"/>
	</pre>
</div>
<div style="float:right">
		<form action="removedataproperty" method="get">
			<input type="submit" value="Remove Text Version"/>
	<xsl:element name="input">
		<xsl:attribute name="type">hidden</xsl:attribute>
		<xsl:attribute name="name">instance</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$instance"/></xsl:attribute>
	</xsl:element>
	<xsl:element name="input">
		<xsl:attribute name="type">hidden</xsl:attribute>
		<xsl:attribute name="name">handle</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$handle"/></xsl:attribute>
	</xsl:element>
	<xsl:element name="input">
		<xsl:attribute name="type">hidden</xsl:attribute>
		<xsl:attribute name="name">key</xsl:attribute>
		<xsl:attribute name="value">TextVersion</xsl:attribute>
	</xsl:element>
		</form>
</div>
</xsl:template>

<!-- ************************************************************-->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
