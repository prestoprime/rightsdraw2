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
	xmlns:mets="http://www.loc.gov/METS/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xml="http://www.w3.org/XML/1998/namespace"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" >

<xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>

<xsl:template match="/">
<html><head></head><body>
<h3>Dublin Core elements in Mets descriptive metadata section</h3>
	<xsl:apply-templates select="/mets:mets/mets:dmdSec/mets:mdWrap[@MDTYPE='DC']/mets:xmlData/dc:record" />
</body></html>
<xsl:text>
</xsl:text>
</xsl:template>
<xsl:template match="dc:record">
	<h4><xsl:value-of select="name(.)"/></h4>
	<xsl:for-each select="*">
		<p><xsl:value-of select="name(.)"/><br/><b><xsl:value-of select="./text()"/></b></p>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>

