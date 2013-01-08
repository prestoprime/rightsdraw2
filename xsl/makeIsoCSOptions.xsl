
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
	xmlns:xml="http://www.w3.org/XML/1998/namespace"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>
<xsl:param name="form">pform</xsl:param>
<xsl:param name="element">territories</xsl:param>
<xsl:param name="columns">12</xsl:param>

<xsl:template match="/">
<html>
<head>
<script src="/rightsdraw2/js/putlabels.js"/>
<style>
div {
	background: #bfdfdf;
	float:left;
	fontsize: small;
	margin-top: 4px;
	margin-left: 4px;
} 
</style>
</head>
<body>
	<h4>Select your <xsl:value-of select="$element"/></h4>
<div style="background:white"> <form action="javascript:window.close()"><input type="submit" value="Close"/></form> </div>
<div style="background:white">
	<xsl:element name="form">
		<xsl:attribute name="action">javascript:setLabel('<xsl:value-of select="$form"/>','<xsl:value-of select="$element"/>','')</xsl:attribute>
		<input type="submit" value="Clear"/>
	</xsl:element>
</div>
<xsl:for-each select="ClassificationScheme/Term">
	<xsl:sort select="Name"/>
	<xsl:element name="div">
		<xsl:attribute name="id">#<xsl:value-of select="@termID"/>;</xsl:attribute>
		<xsl:if test="position() mod $columns = 1">
			<xsl:attribute name="style">clear:left;</xsl:attribute>
		</xsl:if>
		<xsl:element name="a">
			<xsl:attribute name="href">javascript:putLabel('<xsl:value-of select="$form"/>','<xsl:value-of select="$element"/>','#<xsl:value-of select="@termID"/>;')</xsl:attribute>
			<xsl:value-of select="Name/text()"/>
		</xsl:element>
	</xsl:element>
</xsl:for-each>
</body>
</html>
</xsl:template>

</xsl:stylesheet>
