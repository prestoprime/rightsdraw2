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
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xml="http://www.w3.org/XML/1998/namespace"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:rqr="http://www.prestoprime.eu/xsd/rightsquery"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" >

<xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>
<xsl:param name="dipservice">null</xsl:param>
<xsl:param name="owlquerypic">null</xsl:param>

<xsl:template match="/">
<html><body>	
<center>
	<xsl:apply-templates select="rqr:Results" />
</center>
</body></html>
</xsl:template>
<xsl:template match="rqr:Results">
<table border="0" width="99%" cellspacing="0" cellpadding="2">
<tr><td colspan="2"><h4>Items matching with your query</h4></td>
		<td>
<div>
<xsl:element name="iframe">
	<xsl:attribute name="src"><xsl:value-of select="$owlquerypic"/></xsl:attribute>
	<!--xsl:attribute name="scrolling">auto</xsl:attribute>
	-->
	<xsl:attribute name="height">144</xsl:attribute>
</xsl:element>
</div>
		</td>
		<td>
<xsl:element name="input">
	<xsl:attribute name="type">button</xsl:attribute>
	<xsl:attribute name="value">Graph</xsl:attribute>
	<xsl:attribute name="onClick">javascript:window.open('<xsl:value-of select="$owlquerypic"/>','RightsGraph','width=960,height=800,scrollbars=yes');</xsl:attribute>
</xsl:element>
		</td>
</tr>
<tr><td colspan="6"><hr/></td></tr>
	<xsl:choose>
		<xsl:when test="rqr:Failure">
	<tr><td colspan="5">
			<h4>Query Failure</h4>
			<p>
			<xsl:value-of select="rqr:Failure/text()"/>
			</p>
	</td></tr>
		</xsl:when>
		<xsl:otherwise>
			<h4>Found <xsl:value-of select="count(rqr:Row)"/> items matching your query</h4>
	<xsl:apply-templates select="rqr:Row" />
		</xsl:otherwise>
	</xsl:choose>
</table>
</xsl:template>
<xsl:template match="rqr:Row">
	<tr>
		<td>
<xsl:element name="img">
	<xsl:attribute name="src"><xsl:value-of select="@icon"/></xsl:attribute>
	<xsl:attribute name="height">144</xsl:attribute>
	<!--xsl:attribute name="onClick">javascript:window.open('<xsl:value-of select="$dipservice"/>/access/dip/<xsl:value-of select="@eeIdentifier"/>/preview/player','AV Access','width=372,height=300,scrollbars=no');</xsl:attribute>
		echo '<div style="float:left"><form method="get" target="query_log" action="p4/getvideoplayer"><input type="submit" value="View"><input type="hidden" name="dipid" value="'$aipid'"></form></div>'
	-->
	<xsl:attribute name="onClick">javascript:window.open('p4/getvideoplayer?dipid=<xsl:value-of select="@eeIdentifier"/>','AV Access','width=372,height=300,scrollbars=no');</xsl:attribute>
</xsl:element>
		</td>
		<td width="20%">
		<p> <small><xsl:value-of select="@eeIdentifier"/></small></p>
		<p><b>
	<xsl:value-of select="substring-before(./text(),'###')"/>
		</b></p>
		<p>
	<xsl:value-of select="substring(substring-after(./text(),'###'),1,70)"/>
	<xsl:if test="string-length(substring-after(./text(),'###')) &gt; 70">...</xsl:if>
		</p>
		</td>
		<td>
<div>
<xsl:element name="iframe">
	<xsl:attribute name="src"><xsl:value-of select="@rightsgraph"/></xsl:attribute>
	<!--xsl:attribute name="scrolling">auto</xsl:attribute>
	-->
	<xsl:attribute name="height">144</xsl:attribute>
</xsl:element>
</div>
		</td>
		<td>
<xsl:element name="input">
	<xsl:attribute name="type">button</xsl:attribute>
	<xsl:attribute name="value">Graph</xsl:attribute>
	<xsl:attribute name="onClick">javascript:window.open('<xsl:value-of select="@rightsgraph"/>','RightsGraph','width=960,height=800,scrollbars=yes');</xsl:attribute>
</xsl:element>
		</td>
		<td>
	<form action="p4/showbasicmets" target="query_log" method="get" style="margin:0px">
		<input type="submit" value="Info"/>
		<xsl:element name="input">
			<xsl:attribute name="type">hidden</xsl:attribute>
			<xsl:attribute name="name">identifier</xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="@eeIdentifier"/></xsl:attribute>
		</xsl:element>
	</form>
		</td>
		<td>
	<form action="../mco/import" method="get" style="margin:0px">
		<input type="submit" value="Import"/>
		<xsl:element name="input">
			<xsl:attribute name="type">hidden</xsl:attribute>
			<xsl:attribute name="name">identifier</xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="@eeIdentifier"/></xsl:attribute>
		</xsl:element>
	</form>
		</td>
	</tr>
</xsl:template>

</xsl:stylesheet>

