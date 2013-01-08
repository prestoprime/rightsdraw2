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
N#
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
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method="text" indent="yes" omit-xml-declaration="yes"/>
<xsl:param name="colors"/>
<xsl:param name="mcoformurl"/>
<xsl:param name="omitdata"/>
<xsl:param name="datanamepos"/>

<xsl:template match="/">
	<xsl:apply-templates select="owl:Ontology" />
</xsl:template>

<xsl:template match="owl:Ontology">
 	digraph G {
<xsl:apply-templates select="owl:ClassAssertion" />
<xsl:apply-templates select="owl:ObjectPropertyAssertion" />
<xsl:apply-templates select="owl:DataPropertyAssertion" />
<xsl:apply-templates select="owl:NegativeObjectPropertyAssertion" />
	}
</xsl:template>

<xsl:template match="owl:ClassAssertion">
<xsl:variable name="class"><xsl:value-of select="substring-after(owl:Class/@IRI,'#')"/></xsl:variable>
<xsl:variable name="whiteclasscolor">white</xsl:variable>
<xsl:variable name="classcolor">
	<xsl:choose>
		<xsl:when test="$colors = 'on'">
			<xsl:choose>
				<xsl:when test="$class = 'Action' or $class = 'CommunicationToThePublic' or $class = 'PublicPerformance' or $class = 'Transform' or $class = 'Duplicate' or $class = 'Fixate' or $class = 'Distribute' or $class = 'ExploitIPRights' or $class = 'MakeCutAndEdit' or $class = 'MakeExcerpt'">"#ffaaff"</xsl:when>
				<xsl:when test="$class = 'Contract'">"#f0f0fd"</xsl:when>
				<xsl:when test="$class = 'Permission'">"#aaffaa"</xsl:when>
				<xsl:when test="$class = 'IPEntity'">cyan</xsl:when>
				<xsl:when test="$class = 'User'">orange</xsl:when>
				<xsl:when test="$class = 'Organization'">orange</xsl:when>
				<xsl:when test="$class = 'FactUnion' or $class = 'FactIntersection'">yellow</xsl:when>
				<xsl:otherwise>"#ffffaa"</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>white</xsl:otherwise>
	</xsl:choose>
</xsl:variable>
<xsl:variable name="indhref">
	<xsl:call-template name="urlencode">
		<xsl:with-param name="inputurl">
			<xsl:value-of select="owl:NamedIndividual/@IRI"/>
		</xsl:with-param>
	</xsl:call-template>
</xsl:variable>
<xsl:variable name="indiri"> 
	<xsl:call-template name="writeindiri">
		<xsl:with-param name="inputiri"> 
			<xsl:value-of select="owl:NamedIndividual/@IRI"/>
		</xsl:with-param>
	</xsl:call-template>
</xsl:variable>

<xsl:text>		</xsl:text>"<xsl:value-of select="$indiri"/>" [style=filled,fillcolor=<xsl:value-of select="$classcolor"/>,label="<xsl:value-of select="substring-after(owl:Class/@IRI,'#')"/>\n<xsl:value-of select="$indiri"/>",href="<xsl:value-of select="$mcoformurl"/>&amp;ind=<xsl:value-of select="$indhref"/>"];
</xsl:template>

<xsl:template match="owl:ObjectPropertyAssertion">
	<xsl:variable name="arc"><xsl:value-of select="substring-after(owl:ObjectProperty/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="first">
		<xsl:call-template name="writeindiri">
			<xsl:with-param name="inputiri"> 
				<xsl:value-of select="owl:NamedIndividual[position()=1]/@IRI"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="second">
		<xsl:call-template name="writeindiri">
			<xsl:with-param name="inputiri"> 
				<xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
<xsl:text>		</xsl:text>"<xsl:value-of select="$first"/>"->"<xsl:value-of select="$second"/>" [label="<xsl:value-of select="$arc"/>"];
</xsl:template>

<xsl:template match="owl:NegativeObjectPropertyAssertion">
	<xsl:variable name="arc"><xsl:value-of select="substring-after(owl:ObjectProperty/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="first">
		<xsl:call-template name="writeindiri">
			<xsl:with-param name="inputiri"> 
				<xsl:value-of select="owl:NamedIndividual[position()=1]/@IRI"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="second">
		<xsl:call-template name="writeindiri">
			<xsl:with-param name="inputiri"> 
				<xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
<xsl:text>		</xsl:text>"<xsl:value-of select="$first"/>"->"<xsl:value-of select="$second"/>" [label="<xsl:value-of select="$arc"/>", color=red, fontcolor=red, arrowhead=tee, arrowtail=invodot];
</xsl:template>

<xsl:template match="owl:DataPropertyAssertion">
	<xsl:variable name="key"><xsl:value-of select="substring-after(owl:DataProperty/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="pkey">(<xsl:value-of select="$key"/>)</xsl:variable>
	<xsl:variable name="value">
		<xsl:choose>
			<xsl:when test="contains($omitdata,$pkey)">[omitted]</xsl:when>
			<xsl:otherwise><xsl:value-of select="owl:Literal/text()"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="owner">
		<xsl:call-template name="writeindiri">
			<xsl:with-param name="inputiri"> 
				<xsl:value-of select="owl:NamedIndividual/@IRI"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="label">label="<xsl:value-of select="$key"/>=\n<xsl:value-of select="$value"/>"</xsl:variable>
	<xsl:variable name="boxid"><xsl:value-of select="$owner"/>_<xsl:value-of select="$key"/></xsl:variable>
<xsl:if test="$key != '' and $value != ''">
	<xsl:choose>
		<xsl:when test="$datanamepos = 'edge'">
<xsl:text>		</xsl:text>"<xsl:value-of select="$boxid"/>" [shape=box,style=filled,fillcolor=lightgrey,label="<xsl:value-of select="$value"/>"];
<xsl:text>		</xsl:text>"<xsl:value-of select="$owner"/>"->"<xsl:value-of select="$boxid"/>" [dir=none,label="<xsl:value-of select="$key"/>"];
		</xsl:when>
		<xsl:otherwise>
<xsl:text>		</xsl:text>"<xsl:value-of select="$boxid"/>" [shape=box,style=filled,fillcolor=lightgrey,<xsl:value-of select="$label"/>];
<xsl:text>		</xsl:text>"<xsl:value-of select="$owner"/>"->"<xsl:value-of select="$boxid"/>" [dir=none];
		</xsl:otherwise>
	</xsl:choose>
</xsl:if>
</xsl:template>

<!--************************************** -->
<xsl:template name="writeindiri">
	<xsl:param name="inputiri"/>
	<xsl:choose>
		<xsl:when test="substring-before($inputiri,'#') = '' and substring-after($inputiri,'#') != ''"><xsl:value-of select="substring-after($inputiri,'#')"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="$inputiri"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!--************************************** -->
<xsl:template name="urlencode">
	<xsl:param name="inputurl"/>
	<xsl:variable name="a">
		<xsl:call-template name="cleanurlfrom">
			<xsl:with-param name="url"><xsl:value-of select="$inputurl"/></xsl:with-param>
			<xsl:with-param name="from">#</xsl:with-param>
			<xsl:with-param name="to">%23</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="b">
		<xsl:call-template name="cleanurlfrom">
			<xsl:with-param name="url"><xsl:value-of select="$a"/></xsl:with-param>
			<xsl:with-param name="from">:</xsl:with-param>
			<xsl:with-param name="to">%3A</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="c">
		<xsl:call-template name="cleanurlfrom">
			<xsl:with-param name="url"><xsl:value-of select="$b"/></xsl:with-param>
			<xsl:with-param name="from">:</xsl:with-param>
			<xsl:with-param name="to">%3A</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:value-of select="$c"/>
</xsl:template>
<!--************************************** -->
<xsl:template name="cleanurlfrom">
	<!-- remove only first occurence -->
	<xsl:param name="url"/>
	<xsl:param name="from"/>
	<xsl:param name="to"/>
	<xsl:choose>
		<xsl:when test="substring-after($url,$from)=''">
			<xsl:value-of select="$url"/>
		</xsl:when>
		<xsl:otherwise><xsl:value-of select="substring-before($url,$from)"/><xsl:value-of select="$to"/><xsl:value-of select="substring-after($url,$from)"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!--************************************** -->
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
