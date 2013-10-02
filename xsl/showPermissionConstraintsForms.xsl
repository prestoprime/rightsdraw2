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
<xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>
<xsl:param name="instance">null</xsl:param>
<xsl:param name="permissions">null</xsl:param>
<xsl:param name="kp">null</xsl:param>


<xsl:template match="/">
	<xsl:choose>
		<xsl:when test="$permissions != 'null' and $permissions != ''">
			<xsl:apply-templates select="owl:Ontology" />
		</xsl:when>
		<xsl:otherwise>
<div class="no">
		<hr style="margin:2px"/>
		<div class="redbox"></div>
		<div style="float:left;margin-left:8px"><b><xsl:value-of select="$kp"/> NO</b></div>
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
				<xsl:attribute name="value">Add <xsl:value-of select="$kp"/></xsl:attribute>
			</xsl:element>
		</form>
	</div>
</div>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="owl:Ontology">
	<xsl:element name="div">
		<xsl:attribute name="class">yes</xsl:attribute>
		<xsl:attribute name="style">clear:left;</xsl:attribute>
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
	</xsl:element>
	<xsl:call-template name="showPermissionContext"> 
		<xsl:with-param name="permission"> <xsl:value-of select="substring-before($permissions,';')"/></xsl:with-param> 
		<xsl:with-param name="tail"><xsl:value-of select="substring-after($permissions,'; ')"/></xsl:with-param> 
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
		</div>
		<div style="float:right;text-align:right">
			<form action="../mco/writederivedtext" method="get" target="showPermissionConstraints">
				<xsl:element name="input">
					<xsl:attribute name="name">instance</xsl:attribute>
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$instance"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="input">
					<xsl:attribute name="name">handle</xsl:attribute>
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$permission"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="input">
					<xsl:attribute name="type">submit</xsl:attribute>
					<xsl:attribute name="value">Derived Text</xsl:attribute>
				</xsl:element>
			</form>
		</div>
		<div style="float:right;text-align:right">
			<form action="showpermissionconstraints" method="get" target="showPermissionConstraints">
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
					<xsl:attribute name="name">kp</xsl:attribute>
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$kp"/></xsl:attribute>
				</xsl:element>
				<xsl:element name="input">
					<xsl:attribute name="type">submit</xsl:attribute>
					<xsl:attribute name="value">Constraints</xsl:attribute>
				</xsl:element>
			</form>
		</div>
	</div>
	<xsl:call-template name="checkRelatedActionFacts">
		<xsl:with-param name="permid"><xsl:value-of select="$permission"/></xsl:with-param>
	</xsl:call-template>
	<xsl:if test="$tail != ''">
		<xsl:call-template name="showPermissionContext">
			<xsl:with-param name="permission"><xsl:value-of select="substring-before($tail,';')"/></xsl:with-param>
			<xsl:with-param name="tail"><xsl:value-of select="substring-after($tail,'; ')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!-- ************************************************************-->
<xsl:template name="checkRelatedActionFacts">
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

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
