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
	xmlns:owl="http://www.w3.org/2002/07/owl#">
<xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>
<xsl:param name="instance">null</xsl:param>
<xsl:param name="ind">null</xsl:param>
<xsl:variable name="class"><xsl:value-of select="substring-after(/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$ind]/owl:Class/@IRI,'#')"/></xsl:variable>
<xsl:variable name="ListOfActions">(Action),(ExploitIPRights),(CommunicationToThePublic),(Distribute),(PublicPerformance), (Duplicate),(Fixate),(Transform),(MakeCutAndEdit),(MakeExcerpt) </xsl:variable>
<xsl:variable name="ListOfResultsInActions">(Duplicate),(Fixate),(Transform),(MakeCutAndEdit),(MakeExcerpt) </xsl:variable>
<xsl:variable name="ListOfIPEntities">(IPEntity),(Instance),(Work),(Manifestation)</xsl:variable>
<xsl:variable name="ListOfActionRelated">(ActionDone),(ActionStarted)</xsl:variable>
<xsl:variable name="ListOfLimited">(Limited),(Run)</xsl:variable>
<xsl:variable name="ListOfFactComposition">(FactIntersection),(FactUnion)</xsl:variable>
<xsl:variable name="pclass">(<xsl:value-of select="$class"/>)</xsl:variable>
<!-- ************************************************************************* -->

<xsl:template match="/">
<html>
<head>
<link href="/rightsdraw2/css/mco.css" type="text/css" rel="stylesheet"/>
<script src="/rightsdraw2/js/CalendarPopup.js"></script><script>document.write(getCalendarStyles());</script>
<script src="/rightsdraw2/js/putrunproperties"></script>
</head>
<body>	
	<h3><xsl:value-of select="$class"/>:<xsl:value-of select="$ind"/></h3>
	<div id="md" style="float:left"> 
		<xsl:call-template name="drawdetails"/>
		<xsl:call-template name="showmd"/>
		<xsl:call-template name="addmd"/>
	 </div>
	<div id="rm" style="float:right"> 
		<xsl:call-template name="remove"/> 
		<xsl:call-template name="mergein"/> 
	</div>
	<div id="main" style="clear:both">
		<xsl:choose>
			<xsl:when test="$class='Contract'"><xsl:call-template name="contract"/></xsl:when>
			<xsl:when test="$class='User' or $class='Organization'"><xsl:call-template name="party"/></xsl:when>
			<xsl:when test="$class='Permission'"><xsl:call-template name="permission"/></xsl:when>
			<xsl:when test="$class='TextualClause'"><xsl:call-template name="textualclause"/></xsl:when>
			<xsl:when test="contains($ListOfActions,$pclass)"><xsl:call-template name="action"/></xsl:when>
			<xsl:when test="contains($ListOfIPEntities,$pclass)"><xsl:call-template name="ipentity"/></xsl:when>
			<xsl:when test="contains($ListOfActionRelated,$pclass)"><xsl:call-template name="actionrelated"/></xsl:when>
			<xsl:when test="contains($ListOfLimited,$pclass)"><xsl:call-template name="hasvalidity"/></xsl:when>
			<xsl:when test="contains($ListOfFactComposition,$pclass)"><xsl:call-template name="factcomposition"/></xsl:when>
		</xsl:choose>
	</div>
	
</body>
</html>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="inserthiddeninput">
	<xsl:element name="input">
		<xsl:attribute name="type">hidden</xsl:attribute>
		<xsl:attribute name="name">instance</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$instance"/></xsl:attribute>
	</xsl:element>
	<xsl:element name="input">
		<xsl:attribute name="type">hidden</xsl:attribute>
		<xsl:attribute name="name">handle</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$ind"/></xsl:attribute>
	</xsl:element>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="showmd">
<form action="showmd" method="get" target="mco_log">
	<xsl:call-template name="inserthiddeninput"/>
	<xsl:element name="input">
		<xsl:attribute name="type">submit</xsl:attribute>
		<!--xsl:attribute name="value">Show metadata of <xsl:value-of select="$class"/></xsl:attribute>
		-->
		<xsl:attribute name="value">Show metadata</xsl:attribute>
	</xsl:element>
</form>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="drawdetails">
<form action="drawdetails" method="get" target="mco_diagram">
	<xsl:call-template name="inserthiddeninput"/>
	<xsl:element name="input">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">Draw Details</xsl:attribute>
	</xsl:element>
	down <input type="radio" name="mode" value="down" checked="yes"/>
	around <input type="radio" name="mode" value="around"/>
</form>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="addmd">
<form action="addmd" method="get" target="mco_log">
	<xsl:call-template name="inserthiddeninput"/>
	<xsl:element name="input">
		<xsl:attribute name="type">submit</xsl:attribute>
		<!--xsl:attribute name="value">Add metadata to <xsl:value-of select="$class"/></xsl:attribute>
		-->
		<xsl:attribute name="value">Add metadata</xsl:attribute>
	</xsl:element><br/>
	<select name="mdkey">
		<option value="http://purl.org/dc/elements/1.1/contributor">dc:contributor</option>
		<option value="http://purl.org/dc/elements/1.1/coverage">dc:coverage</option>
		<option value="http://purl.org/dc/elements/1.1/creator">dc:creator</option>
		<option value="http://purl.org/dc/elements/1.1/date">dc:date</option>
		<option value="http://purl.org/dc/elements/1.1/description">dc:description</option>
		<option value="http://purl.org/dc/elements/1.1/format">dc:format</option>
		<option value="http://purl.org/dc/elements/1.1/identifier">dc:identifier</option>
		<option value="http://purl.org/dc/elements/1.1/language">dc:language</option>
		<option value="http://purl.org/dc/elements/1.1/publisher">dc:publisher</option>
		<option value="http://purl.org/dc/elements/1.1/relation">dc:relation</option>
		<option value="http://purl.org/dc/elements/1.1/rights">dc:rights</option>
		<option value="http://purl.org/dc/elements/1.1/source">dc:source</option>
		<option value="http://purl.org/dc/elements/1.1/subject">dc:subject</option>
		<option value="http://purl.org/dc/elements/1.1/title">dc:title</option>
		<option value="http://purl.org/dc/elements/1.1/type">dc:type</option>
	</select>
	<input type="text" size="16" name="mdvalue"/>
</form>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="remove">
<form action="remove" method="get">
	<xsl:call-template name="inserthiddeninput"/>
	<xsl:element name="input">
		<xsl:attribute name="type">submit</xsl:attribute>
		<!--xsl:attribute name="value">Remove <xsl:value-of select="$class"/></xsl:attribute>
		-->
		<xsl:attribute name="value">Remove</xsl:attribute>
	</xsl:element>
</form>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="mergein">
<form action="mergein" method="get" target="mco_log">
	<xsl:call-template name="inserthiddeninput"/>
	<xsl:element name="input">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">Merge in with</xsl:attribute>
	</xsl:element>
	<select name="mergetarget">
		<option>null</option>
		<xsl:call-template name="SameClassOptions"/>
	</select>
</form>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="SameClassOptions">
	<xsl:for-each select="/owl:Ontology/owl:ClassAssertion[substring-after(owl:Class/@IRI,'#')=$class]/owl:NamedIndividual">
		<xsl:if test="@IRI != $ind">
			<option><xsl:value-of select="@IRI"/></option>
		</xsl:if>
	</xsl:for-each>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="actionrelated">
<div name="actionrelated" style="float:left">
	<xsl:choose>
		<xsl:when test="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI = $ind and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#withDelay'] and /owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI = $ind and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#hasValidity']">
		</xsl:when>
		<xsl:otherwise>
			<form name="pform" action="adddataproperty" method="get" target="mco_log">
				<xsl:call-template name="inserthiddeninput"/>
				<input type="submit" value="Delay/Validity"/>
				<select name="key">
					<option value="urn:mpeg:mpeg21:mco:ipre:2012#withDelay">WithDelay</option>
					<option value="urn:mpeg:mpeg21:mco:ipre:2012#hasValidity">HasValidity</option>
				</select>
				<input type="text" name="value" size="8"/>
				<a href="#" onclick="window.open('/rightsdraw2/durationFormValue.html','','top=100,left=300,width=400,height=400,scrollbars')">set duration</a>
			</form>
		</xsl:otherwise>
	</xsl:choose>
</div>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="hasvalidity">
<div name="hasvalidity" style="float:left">
	<xsl:choose>
		<xsl:when test="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI = $ind and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#hasValidity']">
		</xsl:when>
		<xsl:otherwise>
			<form name="pform" action="adddataproperty" method="get" target="mco_log">
				<xsl:call-template name="inserthiddeninput"/>
				<input type="submit" value="Validity"/>
				<input type="hidden" name="key" value="urn:mpeg:mpeg21:mco:ipre:2012#hasValidity"/>
				<input type="text" name="value" size="8"/>
				<a href="#" onclick="window.open('/rightsdraw2/durationFormValue.html','','top=100,left=300,width=400,height=400,scrollbars')">set duration</a>
			</form>
		</xsl:otherwise>
	</xsl:choose>
</div>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="ipentity">
<div name="relatedidentifier" style="float:left">
	<xsl:choose>
		<xsl:when test="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI = $ind and owl:DataProperty/@IRI='urn:mpeg:mpeg21:2002:01-DII-NS#Identifier']">
		</xsl:when>
		<xsl:otherwise>
			<form action="adddataproperty" method="get" target="mco_log">
				<xsl:call-template name="inserthiddeninput"/>
				<input type="submit" value="Add Identifier"/>
				<input type="hidden" name="key" value="urn:mpeg:mpeg21:2002:01-DII-NS#Identifier"/>
				<input type="text" name="value" size="8"/>
			</form>
		</xsl:otherwise>
	</xsl:choose>
</div>
	<xsl:call-template name="definepermission"/>
</xsl:template>
<!-- ************************************************************-->

<xsl:template name="contract">
<div id="contractaddparty" style="float:left">
	<form action="addobj" method="get" target="mco_log">
		<xsl:call-template name="inserthiddeninput"/>
		<input type="hidden" name="obj" value="urn:mpeg:mpeg21:mco:core:2012#hasParty"/>
		<input type="submit" value="Add Party"/>
		<select name="class">
			<option value="urn:mpeg:mpeg21:mco:core:2012#Organization">mco-core:Organization</option>
			<option value="http://purl.oclc.org/NET/mvco.owl#User">mvco:User</option>
		</select><br/>
		<input type="text" name="ind" size="8"/>
	</form>
</div>	
<div id="contractincludeparty" style="float:left">
</div>	
<div id="contractdate" style="float:right">
	<form id="contractdateform" action="addmd" method="get" target="mco_log">
		<script id="jscal1x">var cal1x = new CalendarPopup(); </script>
		<xsl:call-template name="inserthiddeninput"/>
		<input type="hidden" name="mdkey" value="http://purl.org/dc/elements/1.1/date"/>
		<input type="submit" value="Add Contract Date"/><br/>
		<input type="text" size="8" name="mdvalue"/><br/>
		<a HREF="#" onClick="cal1x.select(document.forms['contractdateform'].mdvalue,'anchor1x','yyyy-MM-dd'); return false;" TITLE="cal1x.select(document.forms['contractdateform'].mdvalue,'anchor1x','yyyy-MM-dd'); return false;" NAME="anchor1x" ID="anchor1x"><small>format: YYYY-MM-DD</small></a>
	</form>
</div>	
<div style="clear:both"></div>
<div name="contractadddeontic" style="float:left">
	<form action="adddeontic" method="get" target="mco_log">
		<xsl:call-template name="inserthiddeninput"/>
		<input type="submit" value="Add Deontic Expression"/><br/>
		<select name="class">
			<option value="http://purl.oclc.org/NET/mvco.owl#Permission">mvco:Permission</option>
			<option value="urn:mpeg:mpeg21:mco:core:2012#Obligation">mco-core:Obligation</option>
			<option value="urn:mpeg:mpeg21:mco:core:2012#Prohibition">mco-core:Prohibition</option>
		</select>	
	</form>
</div>	
<!--div id="contractaddtextualclause" style="float:right">
	<form action="addtextualclause" method="post" ENCTYPE="multipart/form-data" target="mco_log">
		<xsl:call-template name="inserthiddeninput"/>
		<input type="submit" value="Add Textual Clause"/><br/>
		<textarea name="clausetext" rows="3" cols="18"/>
	</form>
</div-->	
<div name="contracttextversion" style="clear:right">
	<xsl:choose>
		<xsl:when test="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI = $ind and substring-after(owl:DataProperty/@IRI,'#')='TextVersion']">
		<div style="float:left">
			<form action="showtextversion" method="get" target="mco_log">
				<xsl:call-template name="inserthiddeninput"/>
				<input type="submit" value="Show Text Version"/>
			</form>
		</div>
		<div style="float:left">
			<form action="removedataproperty" method="get" target="mco_log">
				<xsl:call-template name="inserthiddeninput"/>
				<input type="hidden" name="key" value="TextVersion"/>
				<input type="submit" value="Remove Text Version"/>
			</form>
		</div>
		</xsl:when>
		<xsl:otherwise>
<form action="loadtextversion" method="post" ENCTYPE="multipart/form-data" target="mco_log">
	<xsl:call-template name="inserthiddeninput"/>
	<input type="submit" value="Load Text Version"/>
	<input type="file" name="contracttextversion" size="8"/>
</form>
		</xsl:otherwise>
	</xsl:choose>
</div>	
<div name="signedby" style="float:right">
	<form action="addobj" method="get" target="mco_log">
		<xsl:call-template name="inserthiddeninput"/>
		<input type="hidden" name="obj" value="urn:mpeg:mpeg21:mco:core:2012#isSignedBy"/>
		<input type="hidden" name="class" value="http://purl.oclc.org/NET/mvco.owl#User"/>
		<input type="submit" value="isSignedBy"/>
		<select name="ind"><xsl:call-template name="insertsignedby"/></select>
		<!--input type="text" name="ind" size="8"/-->
	</form>
</div>	
</xsl:template>

<!-- ************************************************************-->
<xsl:template name="textualclause">
	<pre>
<xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$ind and substring-after(owl:DataProperty/@IRI,'#')='Text']/owl:Literal/text()"/>
	</pre>
</xsl:template>
<!-- ************************************************************-->
<xsl:template name="party">
<div name="partyaddress" style="float:left">
	<xsl:choose>
		<xsl:when test="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI = $ind and substring-after(owl:DataProperty/@IRI,'#')='Address']"> </xsl:when>
		<xsl:otherwise>
			<form action="adddataproperty" method="get" target="mco_log">
				<xsl:call-template name="inserthiddeninput"/>
				<input type="submit" value="Add Address"/>
				<input type="hidden" name="key" value="urn:mpeg:mpeg21:mco:core:2012#Address"/>
				<textarea name="value" rows="3" cols="18"/>
			</form>
		</xsl:otherwise>
	</xsl:choose>
</div>	
<xsl:if test="$class = 'Organization'">
	<div id="signatory" style="float:right">
		<form action="addobj" method="get" target="mco_log">
			<xsl:call-template name="inserthiddeninput"/>
			<input type="hidden" name="obj" value="urn:mpeg:mpeg21:mco:core:2012#hasSignatory"/>
			<input type="hidden" name="class" value="http://purl.oclc.org/NET/mvco.owl#User"/>
			<input type="submit" value="Add Signatory"/>
			<input type="text" name="ind" size="8"/>
		</form>
	</div>	
</xsl:if>
<!-- TODO insert Signature check iris-->
<div name="signature" style="float:right">
	<xsl:choose>
		<xsl:when test="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI = $ind and substring-after(owl:DataProperty/@IRI,'#')='Signature']"> SIGNED </xsl:when>
		<xsl:otherwise>
			<xsl:if test="$class = 'User'">
				Add Signature
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</div>
</xsl:template>
<!-- ************************************************************-->
<xsl:template name="selectindividual">
	<xsl:param name="classname"/>
	<xsl:param name="fieldname">ind</xsl:param>
	<small>
	<xsl:text disable-output-escaping="yes">&lt;a href="#" onclick="window.open('selectindividual?instance=</xsl:text><xsl:value-of select="$instance"/><xsl:text disable-output-escaping="yes">&amp;fieldname=</xsl:text><xsl:value-of select="$fieldname"/><xsl:text disable-output-escaping="yes">&amp;classname=</xsl:text><xsl:value-of select="$classname"/><xsl:text disable-output-escaping="yes">','','top=100,left=300,width=400,height=400,scrollbars')"&gt;</xsl:text><xsl:value-of select="$classname"/><xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>
	</small>
</xsl:template>
<!-- ************************************************************-->
<xsl:template name="action">
<xsl:choose>
	<!--doesn't check position of named individual, which should be 1 by itself -->
	<xsl:when test="/owl:Ontology/owl:ObjectPropertyAssertion[owl:NamedIndividual/@IRI = $ind and substring-after(owl:ObjectProperty/@IRI,'#')='actedBy']"></xsl:when>
	<xsl:otherwise>
<div name="actedby" style="float:left">
	<form action="addobj" method="get" target="mco_log" id="pform" name="pform">
		<xsl:call-template name="inserthiddeninput"/>
		<div style="float:left">
			<input type="submit" value="Acted by"/>
		</div>
		<div style="float:left">
		<input type="hidden" name="obj" value="http://purl.oclc.org/NET/mvco.owl#actedBy"/>
		<input type="hidden" name="class" value="urn:mpeg:mepg21:mco:core:2012#Organization"/>
		<input type="text" name="ind" size="10"/><br/>
		<!--<select name="ind">
			<xsl:call-template name="insertparties"/>
		</select>-->
		<xsl:call-template name="selectindividual">
			<xsl:with-param name="classname">Organization</xsl:with-param>
		</xsl:call-template>,
		<xsl:call-template name="selectindividual">
			<xsl:with-param name="classname">User</xsl:with-param>
		</xsl:call-template>
		</div>
	</form>
</div>	
	</xsl:otherwise>
</xsl:choose>
<xsl:choose>
	<!--doesn't check position of named individual, which should be 1 by itself -->
	<xsl:when test="/owl:Ontology/owl:ObjectPropertyAssertion[owl:NamedIndividual/@IRI = $ind and substring-after(owl:ObjectProperty/@IRI,'#')='actedOver']"></xsl:when>
	<xsl:otherwise>
<div name="actedover" style="float:right">
	<form action="addobj" method="get" target="mco_log">
		<xsl:call-template name="inserthiddeninput"/>
		<input type="submit" value="Acted Over IPEntity"/>
		<input type="hidden" name="obj" value="http://purl.oclc.org/NET/mvco.owl#actedOver"/>
		<input type="hidden" name="class" value="http://purl.oclc.org/NET/mvco.owl#IPEntity"/>
		<input name="ind" type="text" size="12"/>
	</form>
</div>	
	</xsl:otherwise>
</xsl:choose>
<xsl:choose>
	<!--doesn't check position of named individual, which should be 1 by itself -->
	<xsl:when test="/owl:Ontology/owl:ObjectPropertyAssertion[owl:NamedIndividual/@IRI = $ind and owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#makesTrue']"></xsl:when>
	<xsl:otherwise>
<div name="actedover" style="clear:left">
	<form action="addobj" method="get" target="mco_log">
		<xsl:call-template name="inserthiddeninput"/>
		<input type="submit" value="Makes True"/>
		<input type="hidden" name="obj" value="urn:mpeg:mpeg21:mco:core:2012#makesTrue"/>
		<select name="ind">
			<xsl:call-template name="insertactionrelated"/>
		</select>
	</form>
</div>	
	</xsl:otherwise>
</xsl:choose>
<xsl:if test="contains($ListOfResultsInActions,$pclass)">
	<xsl:choose>
	<!--doesn't check position of named individual, which should be 1 by itself -->
		<xsl:when test="/owl:Ontology/owl:ObjectPropertyAssertion[owl:NamedIndividual/@IRI = $ind and substring-after(owl:ObjectProperty/@IRI,'#')='resultsIn']"></xsl:when>
		<xsl:otherwise>
<div name="resultsIn" style="clear:left">
	<form action="addobj" method="get" target="mco_log">
		<xsl:call-template name="inserthiddeninput"/>
		<input type="submit" value="Results In"/>
		<input type="hidden" name="obj" value="http://purl.oclc.org/NET/mvco.owl#resultsIn"/>
		<input type="hidden" name="class" value="http://purl.oclc.org/NET/mvco.owl#IPEntity"/>
		<input name="ind" type="text" size="12"/>
	</form>
</div>	
		</xsl:otherwise>
	</xsl:choose>
</xsl:if>
</xsl:template>
<!-- ************************************************************-->
<xsl:template name="permission">
<xsl:choose>
	<!--doesn't check position of named individual, which should be 1 by itself -->
	<xsl:when test="/owl:Ontology/owl:ObjectPropertyAssertion[owl:NamedIndividual/@IRI = $ind and substring-after(owl:ObjectProperty/@IRI,'#')='issuedBy']"></xsl:when>
	<xsl:otherwise>
<div name="issuedby" style="float:right">
	<form action="addobj" method="get" target="mco_log">
		<xsl:call-template name="inserthiddeninput"/>
		<input type="submit" value="Issued by"/>
		<input type="hidden" name="obj" value="http://purl.oclc.org/NET/mvco.owl#issuedBy"/>
		<select name="ind">
			<xsl:call-template name="insertparties"/>
		</select>
	</form>
</div>	
	</xsl:otherwise>
</xsl:choose>
<xsl:choose>
	<!--doesn't check position of named individual, which should be 1 by itself -->
	<xsl:when test="/owl:Ontology/owl:ObjectPropertyAssertion[owl:NamedIndividual/@IRI = $ind and substring-after(owl:ObjectProperty/@IRI,'#')='issuedIn']"></xsl:when>
	<xsl:otherwise>
<div name="issuedin" style="float:left">
	<form action="addobj" method="get" target="mco_log">
		<xsl:call-template name="inserthiddeninput"/>
		<div style="float:left">
			<input type="submit" value="Issued in Contract"/>
		</div>
		<div style="float:left">
			<input type="hidden" name="obj" value="urn:mpeg:mpeg21:mco:core:2012#issuedIn"/>
			<input type="hidden" name="class" value="urn:mpeg:mpeg21:mco:core:2012#Contract"/>
			<input name="ind" type="text" size="10"/><br/>
			<xsl:call-template name="selectindividual">
				<xsl:with-param name="classname">Contract</xsl:with-param>
			</xsl:call-template>
		</div>
	</form>
</div>	
	</xsl:otherwise>
</xsl:choose>
<xsl:choose>
	<!--doesn't check position of named individual, which should be 1 by itself -->
	<xsl:when test="/owl:Ontology/owl:ObjectPropertyAssertion[owl:NamedIndividual/@IRI = $ind and substring-after(owl:ObjectProperty/@IRI,'#')='permitsAction']">
<!--div name="implements" style="float:left">
	<form action="addobj" method="get" target="mco_log">
		<xsl:call-template name="inserthiddeninput"/>
		<input type="submit" value="Implements"/>
		<input type="hidden" name="obj" value="urn:mpeg:mpeg21:mco:core:2012#implements"/>
		<select name="ind">
			<xsl:call-template name="inserttextualclauses"/>
		</select>
	</form>
</div-->	
<div style="clear:both"/>
<div name="implements" style="float:left">
	<form action="addtextualclause" method="post" ENCTYPE="multipart/form-data" target="mco_log">
		<xsl:call-template name="inserthiddeninput"/>
		<input type="submit" value="Implements Textual Clause"/><br/>
		<textarea name="clausetext" rows="3" cols="18"/>
	</form>
</div>	
	<xsl:call-template name="addfacts"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:call-template name="definepermission"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>
<!-- ************************************************************-->
<xsl:template name="factcomposition">
	<xsl:call-template name="addfacts"/>
</xsl:template>
<!-- ************************************************************-->
<xsl:template name="insertactionrelated">
	<xsl:for-each select="/owl:Ontology/owl:ClassAssertion[owl:Class/@IRI='urn:mpeg:mpeg21:mco:core:2012#ActionStarted']">
		<xsl:element name="option"><xsl:attribute name="value"><xsl:value-of select="owl:NamedIndividual/@IRI"/></xsl:attribute>ActionStarted: <xsl:value-of select="owl:NamedIndividual/@IRI"/></xsl:element>
	</xsl:for-each>
	<xsl:for-each select="/owl:Ontology/owl:ClassAssertion[owl:Class/@IRI='urn:mpeg:mpeg21:mco:core:2012#ActionDone']">
		<xsl:element name="option"><xsl:attribute name="value"><xsl:value-of select="owl:NamedIndividual/@IRI"/></xsl:attribute>ActionDone: <xsl:value-of select="owl:NamedIndividual/@IRI"/></xsl:element>
	</xsl:for-each>
</xsl:template>
<!-- ************************************************************-->
<xsl:template name="insertparties">
	<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[substring-after(owl:ObjectProperty/@IRI,'#')='hasParty']">
		<option><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></option>
	</xsl:for-each>
</xsl:template>
<!-- ************************************************************-->
<xsl:template name="insertsignedby">
	<!--xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[substring-after(owl:ObjectProperty/@IRI,'#')='hasParty']">
		<xsl:variable name="party"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:if test="substring-after(/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$party]/owl:Class/@IRI,'#')='User'">
			<option><xsl:value-of select="$party"/></option>
		</xsl:if>
	</xsl:for-each-->
	<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[substring-after(owl:ObjectProperty/@IRI,'#')='hasSignatory']">
		<option><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></option>
	</xsl:for-each>
</xsl:template>
<!-- ************************************************************-->
<xsl:template name="inserttextualclauses">
	<xsl:for-each select="/owl:Ontology/owl:ClassAssertion[owl:Class/@IRI='urn:mpeg:mpeg21:mco:core:2012#TextualClause']">
		<option><xsl:value-of select="owl:NamedIndividual/@IRI"/></option>
	</xsl:for-each>
</xsl:template>
<!-- ************************************************************-->

<xsl:template name="AccessPolicyOptions">
<optgroup label="AccessPolicy">
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#FreeOfCharge">Free of Charge</option>
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#Pay">Pay</option>
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#PayPerView">Pay: PayPerView</option>
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#Subscription">Pay: Subscription</option>
</optgroup>
</xsl:template>
<!-- ************************************************************************* -->
<xsl:template name="ServiceAccessPolicyOptions">
<optgroup label="ServiceAccessPolicy">
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#Open">Open</option>
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#Restricted">Restricted</option>
</optgroup>
</xsl:template>
<!-- ************************************************************************* -->
<xsl:template name="DeliveryModalityOptions">
<optgroup label="DeliveryModality">
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#Linear">Linear</option>
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#NonLinear">Non Linear</option>
	<optgroup label="DeliveryModality: Linear">
		<option value="urn:mpeg:mpeg21:mco:ipre:2012#Broadcasting">Broadcasting</option>
		<option value="urn:mpeg:mpeg21:mco:ipre:2012#Webcasting">Webcasting</option>
	</optgroup>
	<optgroup label="DeliveryModality: Non Linear">
		<option value="urn:mpeg:mpeg21:mco:ipre:2012#OnDemandBasis">OnDemand Basis</option>
		<option value="urn:mpeg:mpeg21:mco:ipre:2012#OnDemandDownload">OnDemand Basis: Download</option>
		<option value="urn:mpeg:mpeg21:mco:ipre:2012#OnDemandStreaming">OnDemand Streaming</option>
	</optgroup>
</optgroup>
</xsl:template>
<!-- ************************************************************************* -->
<xsl:template name="MeansOptions">
<optgroup label="Means">
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#BroadcastTechnology">Broadcast Technology</option>
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#MobileTechnology">Mobile Technology</option>
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#Internet">Internet</option>
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#Radio">Radio</option>
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#Videogram">Videogram</option>
	<optgroup label="Means: Broadcast Technology">
		<option value="urn:mpeg:mpeg21:mco:ipre:2012#Cable">Cable</option>
		<option value="urn:mpeg:mpeg21:mco:ipre:2012#IPNetwork">IPNetwork</option>
		<option value="urn:mpeg:mpeg21:mco:ipre:2012#Satellite">Satellite</option>
		<option value="urn:mpeg:mpeg21:mco:ipre:2012#Terrestrial">Terrestrial</option>
	</optgroup>
</optgroup>
</xsl:template>
<!-- ************************************************************************* -->
<xsl:template name="DeviceOptions">
<optgroup label="Device">
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#Computer">Computer</option>
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#MobileDevice">Mobile Device</option>
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#MobileBroadcastDevice">Mobile Broadcast Device</option>
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#MobileTelecommunicationDevice">Mobile Telecommunication Device</option>
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#StorageDevice">Storage Device</option>
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#TelevisionDevice">Television Device</option>
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#TelevisionSet">Television Set</option>
</optgroup>
</xsl:template>
<!-- ************************************************************************* -->
<xsl:template name="UserTimeAccessOptions">
<optgroup label="UserTimeAccess">
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#Limited">Limited</option>
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#Unlimited">Unlimited</option>
</optgroup>
</xsl:template>
<!-- ************************************************************************* -->
<xsl:template name="RelatedActionOptions">
<optgroup label="RelatedAction">
	<option value="urn:mpeg:mpeg21:mco:core:2012#ActionDone">Done</option>
	<option value="urn:mpeg:mpeg21:mco:core:2012#ActionStarted">Started</option>
</optgroup>
</xsl:template>
<!-- ************************************************************************* -->
<xsl:template name="ActionOptions">
<optgroup label="Actions">
	<option value="urn:mpeg:mpeg21:mco:ipre:2012#ExploitIPRights">ExploitIPRights</option>
	<optgroup label="Exploit IP Rights">
		<option value="urn:mpeg:mpeg21:mco:ipre:2012#CommunicationToThePublic">CommunicationToThePublic</option>
		<option value="http://purl.oclc.org/NET/mvco.owl#Distribute">Distribute</option>
		<option value="urn:mpeg:mpeg21:mco:ipre:2012#PublicPerformance">PublicPerformance</option>
		<option value="urn:mpeg:mpeg21:mco:ipre:2012#Duplicate">Duplicate</option>
		<option value="urn:mpeg:mpeg21:mco:ipre:2012#Fixate">Fixate</option>
		<option value="urn:mpeg:mpeg21:mco:ipre:2012#Transform">Transform</option>
	</optgroup>
	<optgroup label="Transform">
		<option value="urn:mpeg:mpeg21:mco:ipre:2012#MakeCutAndEdit">MakeCutAndEdit</option>
		<option value="urn:mpeg:mpeg21:mco:ipre:2012#MakeExcerpt">MakeExcerpt</option>
	</optgroup>
</optgroup>
</xsl:template>
<!-- ************************************************************************* -->
<xsl:template name="definepermission">
<div name="definepermission" style="float:left;background:#f0f0f0">
	<form id="pform" action="definepermission" method="get" target="mco_log">
		<script id="jscal1x">var cal1x = new CalendarPopup(); </script>
		<xsl:call-template name="inserthiddeninput"/>
		<input type="submit" value="Define Permission to"/>
		<select name="permittedaction">
			<xsl:call-template name="ActionOptions"/>
		</select> 
		<br/>
		exclusive: <input type="checkbox"  name="isexclusive"/>
		sublicense: <input type="checkbox" checked="checked" name="hassublicense"/>
		<br/>
		<xsl:call-template name="factsform"/>
	</form>
</div>	
</xsl:template>
<!-- ************************************************************************* -->
<xsl:template name="addfacts">
<div name="addfacts" style="float:left;background:#f0f0f0">
	<form id="pform" action="addfacts" method="get" target="mco_log">
		<script id="jscal1x">var cal1x = new CalendarPopup(); </script>
		<xsl:call-template name="inserthiddeninput"/>
		<input type="submit" value="Add Other Conditions"/>
		<br/>
		<xsl:call-template name="factsform"/>
	</form>
</div>	
</xsl:template>
<!-- ************************************************************************* -->
<xsl:template name="factsform">
		<div name="conditions" style="float:left">
			<table border="0">
				<tr><td>Conditions</td><td style="color:#ff0000;font-size:8pt;text-align:center">negative<br/>flag</td></tr>
				<tr><td>
					<select name="accesspolicy">
						<option value="null">AccessPolicy: any</option>
						<xsl:call-template name="AccessPolicyOptions"/>
					</select>
				</td><td>
					<input type="checkbox" name="negativeaccesspolicy" selected="false"/>
				</td></tr>
				<tr><td>
					<select name="serviceaccesspolicy">
						<option value="null">ServiceAccessPolicy: any</option>
						<xsl:call-template name="ServiceAccessPolicyOptions"/>
					</select>
				</td><td>
					<input type="checkbox" name="negativeserviceaccesspolicy" selected="false"/>
				</td></tr>
				<tr><td>
					<select name="deliverymodality">
						<option value="null">DeliveryModality: any</option>
						<xsl:call-template name="DeliveryModalityOptions"/>
					</select>
				</td><td>
					<input type="checkbox" name="negativedeliverymodality" selected="false"/>
				</td></tr>
				<tr><td>
					<select name="means">
						<option value="null">Means: any</option>
						<xsl:call-template name="MeansOptions"/>
					</select>
				</td><td>
					<input type="checkbox" name="negativemeans" selected="false"/>
				</td></tr>
				<tr><td>
					<select name="device">
						<option value="null">Device: any</option>
						<xsl:call-template name="DeviceOptions"/>
					</select>
				</td><td>
					<input type="checkbox" name="negativedevice" selected="false"/>
				</td></tr>
				<tr><td>
					<select name="usertimeaccess">
						<option value="null">UserTimeAccess: any</option>
						<xsl:call-template name="UserTimeAccessOptions"/>
					</select>
				</td><td>
					<input type="checkbox" name="negativeusertimeaccess" selected="false"/>
				</td></tr>
				<tr><td>
					<select name="relatedaction">
						<option value="null">RelatedAction: none</option>
						<xsl:call-template name="RelatedActionOptions"/>
					</select>
				</td><td>
					<input type="checkbox" name="negativerelatedaction" selected="false"/>
				</td></tr>
			</table>
		</div>
		<div name="constraints" style="float:left">
			<table border="0">
				<tr><td colspan="2">Conditions</td><td style="color:#ff0000;font-size:8pt;text-align:center">negative<br/>flag</td></tr>
				<tr><td><a HREF="#" onClick="cal1x.select(document.forms['pform'].afterdate,'anchor1x','yyyyMMdd'); return false;" TITLE="cal1x.select(document.forms['pform'].afterdate,'anchor1x','yyyyMMdd'); return false;" NAME="anchor1x" ID="anchor1x">after</a></td><td><input type="text" size="8" value="null" name="afterdate"/> </td><td><input type="checkbox" name="negativetemporalcontext" selected="false"/></td></tr>
				<!--tr><td colspan="2"><a HREF="#" onClick="cal1x.select(document.forms['pform'].afterdate,'anchor1x','yyyyMMdd'); return false;" TITLE="cal1x.select(document.forms['pform'].afterdate,'anchor1x','yyyyMMdd'); return false;" NAME="anchor1x" ID="anchor1x"><small>format: YYYYMMDD</small></a></td></tr>
				-->
				<tr><td><a HREF="#" onClick="cal1x.select(document.forms['pform'].beforedate,'anchor1x','yyyyMMdd'); return false;" TITLE="cal1x.select(document.forms['pform'].beforedate,'anchor1x','yyyyMMdd'); return false;" NAME="anchor1x" ID="anchor1x">before</a></td><td><input type="text" size="8" value="null" name="beforedate"/> </td></tr>
				<!--tr><td colspan="2"><a HREF="#" onClick="cal1x.select(document.forms['pform'].beforedate,'anchor1x','yyyyMMdd'); return false;" TITLE="cal1x.select(document.forms['pform'].beforedate,'anchor1x','yyyyMMdd'); return false;" NAME="anchor1x" ID="anchor1x"><small>format: YYYYMMDD</small></a></td></tr>
				-->
				<tr><td><a href="#" onclick="window.open('/rightsdraw2/territoriesOptions.html','','top=100,left=300,width=400,height=400,scrollbars')">country codes</a></td><td><input type="text" size="8" value="null" name="territories"/> </td><td><input type="checkbox" name="negativespatialcontext" selected="false"/></td></tr>
				<!-- tr><td colspan="2"><small>e.g. #XX;#XY;#XZ;</small></td></tr-->
				<tr><td><a href="#" onclick="window.open('/rightsdraw2/languagesOptions.html','','top=100,left=300,width=400,height=400,scrollbars')">language codes</a></td><td><input type="text" size="8" value="null" name="languages"/></td><td><input type="checkbox" name="negativelanguages" selected="false"/></td></tr>
				<!-- tr><td colspan="2"><small>e.g. #xx;#xy;#xz;</small></td></tr-->
				<tr><td>number of runs</td><td><input type="text" size="4" value="null" name="numruns"/></td><td><a href="javascript:decrun('pform','numruns')">-</a> / <a href="javascript:incrun('pform','numruns')">+</a> </td></tr>
				<tr><td><a href="#" onclick="window.open('/rightsdraw2/durationForm.html','','top=100,left=300,width=400,height=400,scrollbars')">run validity</a></td><td><input type="text" size="8" value="null" name="runduration"/> </td></tr>
			</table>
		</div>
</xsl:template>
<!-- ************************************************************************* -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>

