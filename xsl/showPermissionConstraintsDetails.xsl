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

<html>
<head>
<link href="/rightsdraw2/css/mkr.css" type="text/css" rel="stylesheet"/>
<script src="/rightsdraw2/js/CalendarPopup.js"></script><script>document.write(getCalendarStyles());</script>
<script src="/rightsdraw2/js/jquery.js"></script>
<script>
-->


<xsl:stylesheet version="1.0" 
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>
<xsl:param name="instance">null</xsl:param>
<xsl:param name="permission">null</xsl:param>
<xsl:param name="kp">null</xsl:param>
<xsl:param name="mkr">null</xsl:param>

<xsl:variable name="minafterdate">0</xsl:variable>
<xsl:variable name="maxbeforedate">99999999</xsl:variable>

<xsl:template match="/">
<html>
	<head>
		<link href="/rightsdraw2/css/mkr.css" type="text/css" rel="stylesheet"/>
		<script src="/rightsdraw2/js/CalendarPopup.js"></script><script>document.write(getCalendarStyles());</script>
		<script src="/rightsdraw2/js/jquery.js"></script>
		<script src="/rightsdraw2/js/showhidefields.js"></script>
	</head>
	<body>
	<xsl:choose>
		<xsl:when test="$permission != 'null' and $permission != ''">
			<xsl:apply-templates select="owl:Ontology" />
		</xsl:when>
	</xsl:choose>
	</body>
</html>
</xsl:template>

<xsl:template match="owl:Ontology">
	<xsl:if test="$kp != 'null'">
		<div class="yes" style="clear:left;width:674px;">
			<hr style="margin:2px"/>
			<div class="greenbox"></div>
			<div style="float:left;margin-left:8px"><b><xsl:value-of select="$kp"/> YES</b></div>
			<div style="float:right;text-align:right">
				<form action="showform" method="get" target="addkpform">
					<xsl:element name="input">
						<xsl:attribute name="name">instance</xsl:attribute>
						<xsl:attribute name="type">hidden</xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="$instance"/></xsl:attribute>
					</xsl:element>
					<input type="hidden" name="form" value="mkr-addkpr-form.html"/>
					<xsl:element name="input">
						<xsl:attribute name="name">kp</xsl:attribute>
						<xsl:attribute name="type">hidden</xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="$kp"/></xsl:attribute>
					</xsl:element>
					<xsl:element name="input">
						<xsl:attribute name="type">submit</xsl:attribute>
						<xsl:attribute name="value">Add New <!--xsl:value-of select="$kp"/--></xsl:attribute>
					</xsl:element>
				</form>
			</div>
		</div>
	</xsl:if>
	<xsl:if test="$mkr != 'null'">
		<xsl:variable name="matchingkp">
			<xsl:for-each select="document($mkr)/mkr/kp/permissions">
				<xsl:if test="contains(text(),$permission)">, <xsl:value-of select="../name/text()"/></xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test="$matchingkp != ''">
			<div class="yes" style="clear:left;width:674px;">
				<hr style="margin:2px"/>
				<div class="greenbox"></div>
				<div style="float:left;margin-left:8px"><b><xsl:value-of select="substring-after($matchingkp,',')"/></b></div>
			</div>
		</xsl:if>
	</xsl:if>
	<xsl:call-template name="showPermissionContext"> 
		<!-- expected one permission, however it would work with a list of permissions as well -->
		<xsl:with-param name="permission">
			<xsl:variable name="tmp"><xsl:value-of select="substring-before($permission,';')"/></xsl:variable>
			<xsl:choose>
				<xsl:when test="$tmp=''"><xsl:value-of select="$permission"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="substring-before($permission,';')"/></xsl:otherwise>
			</xsl:choose>
		</xsl:with-param>
		 <xsl:with-param name="tail"><xsl:value-of select="substring-after($permission,'; ')"/></xsl:with-param> 
	</xsl:call-template>
</xsl:template>
	
<xsl:template name="showPermissionContext">
	<xsl:param name="permission">null</xsl:param>
	<xsl:param name="tail">null</xsl:param>
		<hr style="margin:1px"/>
	<div class="yes"> 
		<div class="greenbox"></div>
		<div class="yes" style="float:left;width:200px;margin-left:40px">
			permission: <xsl:value-of select="$permission"/>
			<xsl:call-template name="getIssuedInContract">
				<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
			</xsl:call-template>
			<br/>
			<xsl:call-template name="getPercentages">
				<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
			</xsl:call-template>
		</div>
		<div class="yes" style="float:left;margin-right:10px">
			<xsl:call-template name="getExclusivityFlag">
				<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
			</xsl:call-template>
			<br/>
			<xsl:call-template name="getSublicenseFlag">
				<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
			</xsl:call-template>
		</div>
		<div class="yes" style="float:left;margin-right:10px">
			<xsl:call-template name="getIPEntityDetails">
				<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
			</xsl:call-template>
		</div>
		<div style="float:right">
			<xsl:element name="form">
				<xsl:attribute name="method">get</xsl:attribute>
				<xsl:attribute name="action">removekp</xsl:attribute>
				<!--xsl:attribute name="target"><xsl:value-of select="$kp"/></xsl:attribute-->
				<xsl:attribute name="target">mkr_log</xsl:attribute>
				<xsl:element name="input">
					<xsl:attribute name="name">instance</xsl:attribute>
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$instance"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="input">
					<xsl:attribute name="name">permission</xsl:attribute>
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$permission"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="input">
					<xsl:attribute name="type">submit</xsl:attribute>
					<xsl:attribute name="value">Remove <!--xsl:value-of select="$kp"/--> <xsl:value-of select="$permission"/></xsl:attribute>
				</xsl:element>
			</xsl:element>
		</div>
	</div>
	<xsl:call-template name="getRelatedPermissions">
		<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
	</xsl:call-template>
	<xsl:call-template name="getRelatedActionFacts">
		<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
	</xsl:call-template>
<div class="bgdetails">
<!--table border="0" cellspacing="0">
<tr>

	<td class="indent"></td>	
	<td class="temporal">	
	<xsl:call-template name="getTemporalContext">
		<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
	</xsl:call-template>
	</td>
	<td class="spatial">	
	<xsl:call-template name="getSpatialContext">
		<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
	</xsl:call-template>
	</td>
	<td class="languages">	
	<xsl:call-template name="getLanguageContext">
		<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
	</xsl:call-template>
	</td>
	<td class="runs">	
	<xsl:call-template name="getRunContext">
		<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
	</xsl:call-template>
	</td>
</tr>
</table-->
	<div class="even">
		<xsl:call-template name="getTemporalContext">
			<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
		</xsl:call-template>
	</div>
	<div class="odd">
		<xsl:call-template name="getSpatialContext">
			<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
		</xsl:call-template>
	</div>
	<div class="even">
		<xsl:call-template name="getLanguageContext">
			<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
		</xsl:call-template>
	</div>
	<div class="odd">
		<xsl:call-template name="getRunContext">
			<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
		</xsl:call-template>
	</div>
	<div class="even">
		<xsl:call-template name="getNetworkContext">
			<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
		</xsl:call-template>
	</div>
</div>
	<xsl:if test="$tail != ''">
		<xsl:call-template name="showPermissionContext">
			<xsl:with-param name="permission"><xsl:value-of select="substring-before($tail,';')"/></xsl:with-param>
			<xsl:with-param name="tail"><xsl:value-of select="substring-after($tail,'; ')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="getNetworkContext">
	<xsl:param name="permid"/>
	<xsl:variable name="whitelist">
	<xsl:for-each select="owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='NetworkContext'">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasChannel']/owl:Literal/text()"/>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="blacklist">
	<xsl:for-each select="owl:NegativeObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='NetworkContext'">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasChannel']/owl:Literal/text()"/>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<b>Network Context<br/></b>
	<xsl:choose>
		<xsl:when test="$whitelist != ''">
			Channels: <xsl:value-of select="$whitelist"/>
		</xsl:when>
		<xsl:otherwise>
			All channels
			<xsl:if test="$blacklist !=''">
				excepted: <xsl:value-of select="$blacklist"/>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- ************************************************************-->

<xsl:template name="getLanguageContext">
	<xsl:param name="permid"/>
	<xsl:variable name="whitelist">
	<xsl:for-each select="owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='Language'">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasLanguage']/owl:Literal/text()"/>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="blacklist">
	<xsl:for-each select="owl:NegativeObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='Language'">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasLanguage']/owl:Literal/text()"/>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<b>Languages<br/></b>
	<xsl:choose>
		<xsl:when test="$whitelist != ''">
			Languages: <xsl:value-of select="$whitelist"/>
		</xsl:when>
		<xsl:otherwise>
			All languages
			<xsl:if test="$blacklist !=''">
				excepted: <xsl:value-of select="$blacklist"/>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- ************************************************************-->

<xsl:template name="getSpatialContext">
	<xsl:param name="permid"/>
	<xsl:variable name="whitelist">
	<xsl:for-each select="owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='SpatialContext'">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='inCountry']/owl:Literal/text()"/>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="blacklist">
	<xsl:for-each select="owl:NegativeObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='SpatialContext'">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='inCountry']/owl:Literal/text()"/>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<b>Territories <br/></b>
	<xsl:choose>
		<xsl:when test="$whitelist != ''">
			Countries: <xsl:value-of select="$whitelist"/>
		</xsl:when>
		<xsl:otherwise>
			All countries
			<xsl:if test="$blacklist !=''">
				excepted: <xsl:value-of select="$blacklist"/>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- ************************************************************-->

<xsl:template name="getTemporalContext">
	<xsl:param name="permid"/>
	<xsl:variable name="mytemporalcontext">
	<xsl:for-each select="owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='TemporalContext'">
			<xsl:variable name="beforedate">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='beforeDate']/owl:Literal/text()"/>
			</xsl:variable>
			<xsl:variable name="afterdate">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='afterDate']/owl:Literal/text()"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$afterdate != ''">
					after date: <xsl:value-of select="$afterdate"/>;
				 </xsl:when>
				<xsl:otherwise> </xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$beforedate != ''">
					before date:<xsl:value-of select="$beforedate"/>; 
				</xsl:when>
				<xsl:otherwise> </xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="mynegativetemporalcontext">
	<xsl:for-each select="owl:NegativeObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='TemporalContext'">
			<xsl:variable name="beforedate">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='beforeDate']/owl:Literal/text()"/>
			</xsl:variable>
			<xsl:variable name="afterdate">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='afterDate']/owl:Literal/text()"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$afterdate != ''">
					after date: <xsl:value-of select="$afterdate"/>; 
				</xsl:when>
				<xsl:otherwise> </xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$beforedate != ''">
					before date:<xsl:value-of select="$beforedate"/>; 
				</xsl:when>
				<xsl:otherwise> </xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<b>Temporal Context <br/> </b>
	<xsl:choose>
		<xsl:when test="$mytemporalcontext !=''">
			<xsl:value-of select="$mytemporalcontext"/>
			<xsl:if test="$mynegativetemporalcontext !=''">
				except<br/> <xsl:value-of select="$mynegativetemporalcontext"/>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>any time
			<xsl:if test="$mynegativetemporalcontext !=''">
				out of interval <xsl:value-of select="$mynegativetemporalcontext"/>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ************************************************************-->
<xsl:template name="getRunContext">
	<xsl:param name="permid"/>
	<xsl:variable name="myruncontext">
	<xsl:for-each select="owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='Run'">
			<xsl:variable name="numruns">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasNumberOfRuns']/owl:Literal/text()"/>
			</xsl:variable>
			<xsl:variable name="runvalidity">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasValidity']/owl:Literal/text()"/>
			</xsl:variable>
			<xsl:variable name="numreps">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasNumberOfRepetitions']/owl:Literal/text()"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$numruns != ''">runs: <xsl:value-of select="$numruns"/>; 
					<xsl:choose>
						<xsl:when test="$runvalidity != ''">run validity: <xsl:value-of select="$runvalidity"/>; 
							<xsl:choose>
								<xsl:when test="$numreps != ''">repetitions : <xsl:value-of select="$numreps"/>; </xsl:when>
								<xsl:otherwise>unbounded repetitions</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise> </xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>unspecified runs</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<b>Runs Context <br/></b>
	<xsl:choose>
		<xsl:when test="$myruncontext=''">runs unbounded </xsl:when>
		<xsl:otherwise><xsl:value-of select="$myruncontext"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="getRelatedActionFacts">
	<xsl:param name="permid"/>
	<xsl:for-each select="owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='ActionDone' or substring-after($aclass,'#')='ActionStarted'">
			<xsl:variable name="withdelay">
				<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='withDelay']/owl:Literal/text()"/>
			</xsl:variable>
			<xsl:variable name="hasvalidity">
				<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasValidity']/owl:Literal/text()"/>
			</xsl:variable>
			<xsl:variable name="actionmakingtrue">
				<xsl:value-of select="../owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=2]/@IRI=$aname and substring-after(owl:ObjectProperty/@IRI,'#')='makesTrue']/owl:NamedIndividual[position()=1]/@IRI"/>
			</xsl:variable>
			<xsl:variable name="relatedpermission">
				<xsl:value-of select="../owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=2]/@IRI=$actionmakingtrue and substring-after(owl:ObjectProperty/@IRI,'#')='permitsAction']/owl:NamedIndividual[position()=1]/@IRI"/>
			</xsl:variable>
<div class="bgdetails" style="height:50px">
	<div class="yellowbox"></div>
	<div style="float:left; margin:0 50px">
		 <div style="float:left">Only when action permitted by </div>
		<div style="float:left; margin: 0 10px">
	<form action="showpermissionconstraints" method="get" target="showPermissionConstraints">
		<xsl:element name="input">
			<xsl:attribute name="name">instance</xsl:attribute>
			<xsl:attribute name="type">hidden</xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="$instance"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="input">
			<xsl:attribute name="name">permission</xsl:attribute>
			<xsl:attribute name="type">hidden</xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="$relatedpermission"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="input">
			<xsl:attribute name="type">submit</xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="$relatedpermission"/></xsl:attribute>
		</xsl:element>
	</form>
		</div>
		<div style="float:left;"><b> is <xsl:value-of select="substring-after($aclass,'#Action')"/></b></div>
		<div style="clear:both;margin: 0 20px">
			<xsl:choose>
				<xsl:when test="$withdelay != ''"> with a delay of: <xsl:value-of select="$withdelay"/> </xsl:when>
				<xsl:otherwise> </xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$hasvalidity != ''"> ; with validity:<xsl:value-of select="$hasvalidity"/> </xsl:when>
				<xsl:otherwise> </xsl:otherwise>
			</xsl:choose>
		</div>
	</div>
</div>
		</xsl:if>
	</xsl:for-each>
	<xsl:for-each select="owl:NegativeObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='ActionDone' or substring-after($aclass,'#')='ActionStarted'">
			<xsl:variable name="withdelay">
				<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='withDelay']/owl:Literal/text()"/>
			</xsl:variable>
			<xsl:variable name="hasvalidity">
				<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasValidity']/owl:Literal/text()"/>
			</xsl:variable>
			<xsl:variable name="actionmakingtrue">
				<xsl:value-of select="../owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=2]/@IRI=$aname and substring-after(owl:ObjectProperty/@IRI,'#')='makesTrue']/owl:NamedIndividual[position()=1]/@IRI"/>
			</xsl:variable>
			<xsl:variable name="relatedpermission">
				<xsl:value-of select="../owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=2]/@IRI=$actionmakingtrue and substring-after(owl:ObjectProperty/@IRI,'#')='permitsAction']/owl:NamedIndividual[position()=1]/@IRI"/>
			</xsl:variable>
<div class="bgdetails" style="height:50px">
	<div class="yellowbox"></div>
	<div style="float:left; margin:0 50px">
		 <div style="float:left">Excepted when action permitted by </div>
		<div style="float:left; margin: 0 10px">
	<form action="showpermissionconstraints" method="get" target="showPermissionConstraints">
		<xsl:element name="input">
			<xsl:attribute name="name">instance</xsl:attribute>
			<xsl:attribute name="type">hidden</xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="$instance"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="input">
			<xsl:attribute name="name">permission</xsl:attribute>
			<xsl:attribute name="type">hidden</xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="$relatedpermission"/></xsl:attribute>
		</xsl:element>
		<xsl:element name="input">
			<xsl:attribute name="type">submit</xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="$relatedpermission"/></xsl:attribute>
		</xsl:element>
	</form>
		</div>
		<div style="float:left;"><b> is <xsl:value-of select="substring-after($aclass,'#Action')"/></b></div>
		<div style="clear:both;margin: 0 20px">
			<xsl:choose>
				<xsl:when test="$withdelay != ''"> with a delay of: <xsl:value-of select="$withdelay"/> </xsl:when>
				<xsl:otherwise> </xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$hasvalidity != ''">  with validity:<xsl:value-of select="$hasvalidity"/> </xsl:when>
				<xsl:otherwise> </xsl:otherwise>
			</xsl:choose>
		</div>
	</div>
</div>
		</xsl:if>
	</xsl:for-each>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="getRelatedPermissions">
	<xsl:param name="permid"/>
	<xsl:for-each select="owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='permitsAction']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:for-each select="../owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$aname and substring-after(owl:ObjectProperty/@IRI,'#')='makesTrue']">
			<xsl:variable name="actionrelatedfact">
				<xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/>
			</xsl:variable>
			<xsl:if test="$actionrelatedfact != ''">
				<xsl:variable name="positiverelatedpermission">
					<xsl:value-of select="../owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=2]/@IRI=$actionrelatedfact and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']/owl:NamedIndividual[position()=1]/@IRI"/>
				</xsl:variable>
				<xsl:variable name="negativerelatedpermission">
					<xsl:value-of select="../owl:NegativeObjectPropertyAssertion[owl:NamedIndividual[position()=2]/@IRI=$actionrelatedfact and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']/owl:NamedIndividual[position()=1]/@IRI"/>
				</xsl:variable>
				<xsl:variable name="relatedpermission">
					<xsl:value-of select="$positiverelatedpermission"/>
					<xsl:value-of select="$negativerelatedpermission"/>
				</xsl:variable>
				<xsl:variable name="what">
					<xsl:choose>
						<xsl:when test="$positiverelatedpermission != ''">
							supports
						</xsl:when>
						<xsl:when test="$negativerelatedpermission != ''">
							constraints
						</xsl:when>
						<xsl:otherwise>has unknown property with</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
	<div class="bgdetails">
		<div  style="float:left;margin:0 50px;"> also <xsl:value-of select="$what"/> permission: <xsl:value-of select="$relatedpermission"/> </div> 
		<form action="showpermissionconstraints" method="get" target="showPermissionConstraints">
			<xsl:element name="input">
				<xsl:attribute name="name">instance</xsl:attribute>
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="$instance"/></xsl:attribute>
			</xsl:element>
			<xsl:element name="input">
				<xsl:attribute name="name">permission</xsl:attribute>
				<xsl:attribute name="type">hidden</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="$relatedpermission"/></xsl:attribute>
			</xsl:element>
			<input type="submit" value="See"></input>
		</form>
		</div>	 
			</xsl:if>
		</xsl:for-each>
	</xsl:for-each>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="getPercentages">
	<xsl:param name="permid"/>
	<xsl:variable name="use">
		<xsl:value-of select="owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$permid and substring-after(owl:DataProperty/@IRI,'#')='hasUsePercentage']/owl:Literal/text()"/>
	</xsl:variable>
	<xsl:variable name="income">
		<xsl:value-of select="owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$permid and substring-after(owl:DataProperty/@IRI,'#')='hasIncomePercentage']/owl:Literal/text()"/>
	</xsl:variable>
	<xsl:if test="$use != ''">use: <xsl:value-of select="$use"/>% </xsl:if>
	<xsl:if test="$income != ''">income: <xsl:value-of select="$income"/>% </xsl:if>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="getExclusivityFlag">
	<xsl:param name="permid"/>
	<xsl:variable name="myexclusivityflag">
		<xsl:value-of select="owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$permid and substring-after(owl:DataProperty/@IRI,'#')='isExclusive']/owl:Literal/text()"/>
	</xsl:variable>exclusivity:
	<xsl:choose>
		<xsl:when test="$myexclusivityflag=''"> false</xsl:when>
		<xsl:otherwise> <xsl:value-of select="$myexclusivityflag"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="getSublicenseFlag">
	<xsl:param name="permid"/>
	<xsl:variable name="mysublicenseflag">
		<xsl:value-of select="owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$permid and substring-after(owl:DataProperty/@IRI,'#')='hasSublicenseRight']/owl:Literal/text()"/>
	</xsl:variable>sublicense:
	<xsl:choose>
		<xsl:when test="$mysublicenseflag=''"> true</xsl:when>
		<xsl:otherwise> <xsl:value-of select="$mysublicenseflag"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="getIssuedInContract">
	<xsl:param name="permid"/>
	<xsl:variable name="mycontract">
		<xsl:for-each select="owl:ObjectPropertyAssertion[owl:NamedIndividual/@IRI=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='issuedIn']">
			<xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$mycontract=''"></xsl:when>
		<xsl:otherwise><br/>issued in <xsl:value-of select="$mycontract"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="getIPEntityDetails">
	<xsl:param name="permid"/>
	<div class="actedon">ciccio</div>
	<div class="ipdetails">
	<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:NamedIndividual/@IRI=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='permitsAction']">
		<xsl:variable name="myaction">
			<xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/>
		</xsl:variable>
		<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:NamedIndividual/@IRI=$myaction and substring-after(owl:ObjectProperty/@IRI,'#')='actedOver']">
			<xsl:variable name="myipentity">
				<xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/>
			</xsl:variable>
			<xsl:for-each select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$myipentity and substring-after(owl:DataProperty/@IRI,'#')='Identifier']">
				<xsl:variable name="myidentifier">
					<xsl:value-of select="owl:Literal"/>
				</xsl:variable>
				 <xsl:value-of select="$myipentity"/><br/><xsl:value-of select="$myidentifier"/><br/>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:for-each>
	</div>
</xsl:template>

<!-- ************************************************************-->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
