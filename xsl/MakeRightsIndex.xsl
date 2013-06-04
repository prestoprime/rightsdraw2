
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

<!--	xmlns:ri="http://www.crit.rai.it/prestoprime/rights/rightsindex"
-->

<xsl:stylesheet version="1.0" 
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ri="http://www.crit.rai.it/prestoprime/rights/rightsindex"
	xmlns="http://www.crit.rai.it/prestoprime/rights/rightsindex">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
<xsl:param name="ppavro">ppavro.owl</xsl:param>
<!--xsl:param name="countrycodes">http://www.ebu.ch/metadata/cs/ebu_Iso3166CountryCodeCS.xml</xsl:param-->
<xsl:param name="countrycodes">ebu_Iso3166CountryCodeCS.xml</xsl:param>
<xsl:param name="languagecodes">ebu_Iso639_1LanguageCodeCS.xml</xsl:param>
<xsl:param name="instanceid">null</xsl:param>
<xsl:param name="indexfile">null</xsl:param>

<xsl:variable name="allterritories">
	<xsl:for-each select="document($countrycodes)/ClassificationScheme/Term">
		<xsl:text>#</xsl:text><xsl:value-of select="@termID"/><xsl:text>;</xsl:text>
	</xsl:for-each>
</xsl:variable>
<xsl:variable name="alllanguages">
	<xsl:for-each select="document($languagecodes)/ClassificationScheme/Term">
		<xsl:text>#</xsl:text><xsl:value-of select="@termID"/><xsl:text>;</xsl:text>
	</xsl:for-each>
</xsl:variable>
<xsl:variable name="minafterdate">0</xsl:variable>
<xsl:variable name="maxbeforedate">99999999</xsl:variable>

<xsl:template match="/">
<xsl:choose>
	<xsl:when test="$indexfile = 'null'">
		<xsl:element name="RightsInstance">
			<!--xsl:attribute name="xmlns">http://www.crit.rai.it/prestoprime/rights/rightsindex</xsl:attribute-->
			<xsl:if test="$instanceid != 'null'">
				<xsl:attribute name="id"><xsl:value-of select="$instanceid"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="owl:Ontology" />
		</xsl:element>
	</xsl:when>
	<xsl:otherwise>
		<xsl:element name="RightsIndex" namespace="http://www.crit.rai.it/prestoprime/rights/rightsindex">
			<!--xsl:attribute name="xmlns">http://www.crit.rai.it/prestoprime/rights/rightsindex</xsl:attribute-->
			<xsl:apply-templates select="document($indexfile)/ri:RightsIndex/ri:RightsInstance[@id != $instanceid]"/>
			<xsl:element name="RightsInstance">
				<xsl:if test="$instanceid != 'null'">
					<xsl:attribute name="id"><xsl:value-of select="$instanceid"/></xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="owl:Ontology" />
			</xsl:element>
		</xsl:element>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="RightsInstancasse">
	ALOHA
</xsl:template>

<xsl:template match="owl:Ontology">
	<xsl:apply-templates select="owl:ClassAssertion[substring-after(owl:Class/@IRI,'#')='Permission']" />
</xsl:template>

<xsl:template match="owl:ClassAssertion">
<xsl:variable name="ind"><xsl:value-of select="substring-after(owl:NamedIndividual/@IRI,'#')"/></xsl:variable>
<xsl:variable name="class"><xsl:value-of select="substring-after(owl:Class/@IRI,'#')"/></xsl:variable>
<!--xsl:value-of select="substring-after(owl:Class/@IRI,'#')"/>:<xsl:value-of select="substring-after(owl:NamedIndividual/@IRI,'#')"/-->
<xsl:choose>
	<xsl:when test="$class = 'Permission'">
		<xsl:call-template name="getRecords">
			<xsl:with-param name="permid"><xsl:value-of select="$ind"/></xsl:with-param>
		</xsl:call-template>
	</xsl:when>
	<xsl:when test="$class = 'FactIntersection'">
	</xsl:when>
	<xsl:when test="$class = 'FactUnion'">
	</xsl:when>
	<xsl:when test="$class = 'CommunicationToThePublic' or $class = 'PublicPerformance' or $class = 'Transform' or $class = 'Duplicate' or $class = 'Fixate' or $class = 'Distribute' or $class = 'ExploitIPRights' or $class = 'MakeCutAndEdit' or $class = 'MakeExcerpt'">
	</xsl:when>
	<xsl:when test="$class = 'Instance' or $class = 'IPEntity'">
	</xsl:when>
	<xsl:otherwise>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="getRecords">
	<xsl:param name="permid"/>
	<xsl:variable name="facts">
		<xsl:call-template name="getFacts">
			<xsl:with-param name="permid"><xsl:value-of select="$permid"/></xsl:with-param>
			<xsl:with-param name="factdim">#Means</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="getFacts">
			<xsl:with-param name="permid"><xsl:value-of select="$permid"/></xsl:with-param>
			<xsl:with-param name="factdim">#DeliveryModality</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="getFacts">
			<xsl:with-param name="permid"><xsl:value-of select="$permid"/></xsl:with-param>
			<xsl:with-param name="factdim">#ServiceAccessPolicy</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="getFacts">
			<xsl:with-param name="permid"><xsl:value-of select="$permid"/></xsl:with-param>
			<xsl:with-param name="factdim">#AccessPolicy</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="getFacts">
			<xsl:with-param name="permid"><xsl:value-of select="$permid"/></xsl:with-param>
			<xsl:with-param name="factdim">#Device</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="getFacts">
			<xsl:with-param name="permid"><xsl:value-of select="$permid"/></xsl:with-param>
			<xsl:with-param name="factdim">#UserTimeAccess</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="getTemporalContext">
			<xsl:with-param name="permid"><xsl:value-of select="$permid"/></xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="getSpatialContext">
			<xsl:with-param name="permid"><xsl:value-of select="$permid"/></xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="getLanguageContext">
			<xsl:with-param name="permid"><xsl:value-of select="$permid"/></xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="getRunContext">
			<xsl:with-param name="permid"><xsl:value-of select="$permid"/></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="instances">
		<xsl:for-each select="../owl:ObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='permitsAction']">
			<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
			<xsl:for-each select="../owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$aname and substring-after(owl:ObjectProperty/@IRI,'#')='actedOver']">
				<xsl:variable name="iname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
				<!--try xsl:value-of select="$iname"/><xsl:text>; </xsl:text-->
				<xsl:value-of select="$iname"/><xsl:text>;</xsl:text>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$instances = ''">
			<xsl:for-each select="../owl:ObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='permitsAction']">
				<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
				<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
				<xsl:text>#</xsl:text><xsl:value-of select="substring-after($aclass,'#')"/><xsl:text>; </xsl:text>
				<xsl:call-template name="getSubClasses">
					<xsl:with-param name="class">#<xsl:value-of select="substring-after($aclass,'#')"/></xsl:with-param>
					<xsl:with-param name="dir" select="1"/>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:value-of select="$facts"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="getInstances">
				<xsl:with-param name="instances"><xsl:value-of select="$instances"/></xsl:with-param>
				<xsl:with-param name="permid"><xsl:value-of select="$permid"/></xsl:with-param>
				<xsl:with-param name="facts"><xsl:value-of select="$facts"/></xsl:with-param>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
<xsl:text>
</xsl:text>
</xsl:template>

<xsl:template name="getInstances">
	<xsl:param name="instances"/>
	<xsl:param name="permid"/>
	<xsl:param name="facts"/>
	<xsl:variable name="iname"><xsl:value-of select="substring-before($instances,';')"/></xsl:variable>
	<xsl:variable name="irelid"><xsl:value-of select="../owl:DataPropertyAssertion[substring-after(owl:DataProperty/@IRI,'#')='Identifier' and owl:NamedIndividual/@IRI=$iname]/owl:Literal/text()"/></xsl:variable>
	<xsl:variable name="tail"><xsl:value-of select="substring-after($instances,'; ')"/></xsl:variable>
	<xsl:variable name="actions">
	<xsl:for-each select="../owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=2]/@IRI=$iname and substring-after(owl:ObjectProperty/@IRI,'#')='actedOver']">

		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=1]/@IRI"/></xsl:variable>
		<xsl:for-each select="../owl:ObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='permitsAction' and substring-after(owl:NamedIndividual[position()=2]/@IRI,'#')=substring-after($aname,'#')]">
			<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
			<xsl:text>#</xsl:text><xsl:value-of select="substring-after($aclass,'#')"/><xsl:text>; </xsl:text>
			<xsl:call-template name="getSubClasses">
				<xsl:with-param name="class">#<xsl:value-of select="substring-after($aclass,'#')"/></xsl:with-param>
				<xsl:with-param name="dir" select="1"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="owner">
	<!-- Given the permission, it finds first the action and returns the owner -->
	<xsl:for-each select="../owl:ObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='permitsAction']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:for-each select="../owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$aname and substring-after(owl:ObjectProperty/@IRI,'#')='actedBy']">
			<xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/>
		</xsl:for-each>
	</xsl:for-each>
	</xsl:variable>
<Record>
	<xsl:if test="$owner != ''">
		<Owner><xsl:value-of select="$owner"/></Owner>
	</xsl:if>
	<Identifier><xsl:value-of select="$irelid"/></Identifier>
	<AVname><xsl:value-of select="$iname"/></AVname>
	<Pname>#<xsl:value-of select="$permid"/></Pname> 
	<Pdetails><xsl:value-of select="$actions"/> <xsl:value-of select="$facts"/></Pdetails>
</Record>
	<xsl:if test="$tail != ''">
		<xsl:call-template name="getInstances">
			<xsl:with-param name="instances"><xsl:value-of select="$tail"/></xsl:with-param>
			<xsl:with-param name="permid"><xsl:value-of select="$permid"/></xsl:with-param>
			<xsl:with-param name="facts"><xsl:value-of select="$facts"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<xsl:template name="compare">
<!-- compare target rights with qlist. If any element of qlist doesn't find a match in target it returns false, otherwise it will return true when reaching the end of qlist-->
	<xsl:param name="target"/>
	<xsl:param name="qlist"/>
	<xsl:variable name="qitem"><xsl:value-of select="substring-before($qlist,';')"/>;</xsl:variable>
	<xsl:variable name="tail"><xsl:value-of select="substring-after($qlist,'; ')"/></xsl:variable>
	<xsl:variable name="qbeforedate"><xsl:value-of select="substring-after($qitem,'#TemporalContext.beforeDate=')"/></xsl:variable>
	<xsl:variable name="qafterdate"><xsl:value-of select="substring-after($qitem,'#TemporalContext.afterDate=')"/></xsl:variable>
	<xsl:variable name="qitemok">
		<xsl:choose>
			<xsl:when test="$qbeforedate != ''">
				<xsl:variable name="targetdate"><xsl:value-of select="substring-after($target,'#TemporalContext.beforeDate=')"/></xsl:variable>
				<xsl:choose>
					<xsl:when test="substring-before($qbeforedate,';') &lt;= substring-before($targetdate,';')">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$qafterdate != ''">
				<xsl:variable name="targetdate"><xsl:value-of select="substring-after($target,'#TemporalContext.afterDate=')"/></xsl:variable>
				<xsl:choose>
					<xsl:when test="substring-before($qafterdate,';') &gt;= substring-before($targetdate,';')">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="contains($target,$qitem)=false">false</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$qitemok='false'">false</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="$tail = ''">true</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="compare">
						<xsl:with-param name="target"><xsl:value-of select="$target"/></xsl:with-param>
						<xsl:with-param name="qlist"><xsl:value-of select="$tail"/></xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ************************************************************************ -->

<xsl:template name="getFacts">
<!-- Returns all facts under factdim which are "allowed" by permission permid
	if permid doesn't require anything then all fact under the factdim hierarchy will be given (white list)
	if permid requires explicitly facts only those required and ther hierarchies will be given
	if permid prohibits explicitly facts (NegativeObject Property) all the prohibited facts and their hierarchies (blacklist) will be removed from the whitelist 
  -->
	<xsl:param name="permid"/>
	<xsl:param name="factdim"/>
<xsl:value-of select="$factdim"/><xsl:text>; </xsl:text>	
	<xsl:variable name="facts">
		<xsl:call-template name="getSubClasses">
			<xsl:with-param name="class"><xsl:value-of select="$factdim"/></xsl:with-param>
			<xsl:with-param name="dir" select="1"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="whitelist">
	<xsl:for-each select="../owl:ObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:variable name="theclass">#<xsl:value-of select="substring-after($aclass,'#')"/>;</xsl:variable>
		<xsl:if test="contains($facts,$theclass)">
			<xsl:choose>
				<xsl:when test="contains($aname,'UNION_')">#<xsl:value-of select="substring-after($aclass,'#')"/><xsl:text>; </xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>#INTERSECTION_</xsl:text><xsl:value-of select="substring-after($aclass,'#')"/><xsl:text>; </xsl:text></xsl:otherwise>
				<!--
				<xsl:otherwise><xsl:text>#</xsl:text><xsl:value-of select="substring-after($aclass,'#')"/><xsl:text>; </xsl:text></xsl:otherwise>
				-->
			</xsl:choose>
			<xsl:call-template name="getSubClasses">
				<xsl:with-param name="class"><xsl:value-of select="substring-before($theclass,';')"/></xsl:with-param>
				<xsl:with-param name="dir" select="1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="blacklist">
	<xsl:for-each select="../owl:NegativeObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:variable name="theclass">#<xsl:value-of select="substring-after($aclass,'#')"/>;</xsl:variable>
		<xsl:if test="contains($facts,$theclass)">
			<xsl:value-of select="$theclass"/><xsl:text> </xsl:text>
			<xsl:call-template name="getSubClasses">
				<xsl:with-param name="class"><xsl:value-of select="substring-before($theclass,';')"/></xsl:with-param>
				<xsl:with-param name="dir" select="1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$whitelist != ''">
			<xsl:call-template name="setlist">
				<xsl:with-param name="yeslist">
					<xsl:call-template name="intersectionlist">
						<xsl:with-param name="inlist"><xsl:value-of select="$whitelist"/></xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
				<!--
				<xsl:with-param name="yeslist">
					<xsl:value-of select="$whitelist"/>
				</xsl:with-param>
				-->
				<xsl:with-param name="nolist"><xsl:text> </xsl:text><xsl:value-of select="$blacklist"/></xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="setlist">
				<xsl:with-param name="yeslist"><xsl:value-of select="$facts"/></xsl:with-param>
				<xsl:with-param name="nolist"><xsl:text> </xsl:text><xsl:value-of select="$blacklist"/></xsl:with-param>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="getLanguageContext">
	<xsl:param name="permid"/>
	<xsl:variable name="whitelist">
	<xsl:for-each select="../owl:ObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:variable name="theclass">#<xsl:value-of select="substring-after($aclass,'#')"/>;</xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='Language'">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasLanguage']/owl:Literal/text()"/>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="blacklist">
	<xsl:for-each select="../owl:NegativeObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:variable name="theclass">#<xsl:value-of select="substring-after($aclass,'#')"/>;</xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='Language'">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasLanguage']/owl:Literal/text()"/>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$whitelist != ''">
			<xsl:call-template name="setlist">
				<xsl:with-param name="yeslist"><xsl:value-of select="$whitelist"/></xsl:with-param>
				<xsl:with-param name="nolist"><xsl:value-of select="$blacklist"/> </xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="setlist">
				<xsl:with-param name="yeslist"><xsl:value-of select="$alllanguages"/></xsl:with-param>
				<xsl:with-param name="nolist"><xsl:value-of select="$blacklist"/> </xsl:with-param>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- ************************************************************-->

<xsl:template name="getRunContext">
	<!-- WIP not to be used yet-->
	<xsl:param name="permid"/>
	<xsl:variable name="runcontext">
	<xsl:for-each select="../owl:ObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:variable name="theclass">#<xsl:value-of select="substring-after($aclass,'#')"/>;</xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='Run'">#RunContext.numruns=<xsl:choose>
				<xsl:when test="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasNumberOfRuns']">
					<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasNumberOfRuns']/owl:Literal/text()"/>.val=<xsl:choose>
						<xsl:when test="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasValidity']">
							<xsl:call-template name="iso-duration-to-minutes">
								<xsl:with-param name="duration">
							<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasValidity']/owl:Literal/text()"/>
								</xsl:with-param>
							</xsl:call-template>.numreps=<xsl:choose>
								<xsl:when test="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasNumberOfRepetitions']">
									<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='hasNumberOfRepetitions']/owl:Literal/text()"/>
								</xsl:when>
								<xsl:otherwise>unbounded</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>0.numreps=na</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>unbounded.val=na.numreps=na</xsl:otherwise>
			</xsl:choose><xsl:text>; </xsl:text>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<!-- in index default context must be written also if not given explicitly -->
	<xsl:choose>
		<xsl:when test="$runcontext != ''"><xsl:value-of select="$runcontext"/></xsl:when>
		<xsl:otherwise>#RunContext.numruns=unbounded.val=na.numreps=na; </xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- ************************************************************-->

<xsl:template name="getSpatialContext">
	<xsl:param name="permid"/>
	<xsl:variable name="whitelist">
	<xsl:for-each select="../owl:ObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:variable name="theclass">#<xsl:value-of select="substring-after($aclass,'#')"/>;</xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='SpatialContext'">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='inCountry']/owl:Literal/text()"/>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="blacklist">
	<xsl:for-each select="../owl:NegativeObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:variable name="theclass">#<xsl:value-of select="substring-after($aclass,'#')"/>;</xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='SpatialContext'">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='inCountry']/owl:Literal/text()"/>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$whitelist != ''">
			<xsl:call-template name="setlist">
				<xsl:with-param name="yeslist"><xsl:value-of select="$whitelist"/></xsl:with-param>
				<xsl:with-param name="nolist"><xsl:value-of select="$blacklist"/> </xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="setlist">
				<xsl:with-param name="yeslist"><xsl:value-of select="$allterritories"/></xsl:with-param>
				<xsl:with-param name="nolist"><xsl:value-of select="$blacklist"/> </xsl:with-param>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- ************************************************************-->

<xsl:template name="getTemporalContext">
	<xsl:param name="permid"/>
	<xsl:variable name="mytemporalcontext">
	<xsl:for-each select="../owl:ObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:variable name="theclass">#<xsl:value-of select="substring-after($aclass,'#')"/>;</xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='TemporalContext'">
			<xsl:variable name="beforedate">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='beforeDate']/owl:Literal/text()"/>
			</xsl:variable>
			<xsl:variable name="afterdate">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='afterDate']/owl:Literal/text()"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$beforedate != ''">#TemporalContext.beforeDate=<xsl:value-of select="$beforedate"/>; </xsl:when>
				<xsl:otherwise>#TemporalContext.beforeDate=<xsl:value-of select="$maxbeforedate"/>; </xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$afterdate != ''">#TemporalContext.afterDate=<xsl:value-of select="$afterdate"/>; </xsl:when>
				<xsl:otherwise>#TemporalContext.afterDate=<xsl:value-of select="$minafterdate"/>; </xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:for-each>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$mytemporalcontext=''">#TemporalContext.beforeDate=<xsl:value-of select="$maxbeforedate"/>; #TemporalContext.afterDate=<xsl:value-of select="$minafterdate"/>; </xsl:when>
		<xsl:otherwise><xsl:value-of select="$mytemporalcontext"/></xsl:otherwise>
	</xsl:choose>
	<xsl:for-each select="../owl:NegativeObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:variable name="aclass"><xsl:value-of select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=substring-after($aname,'#')]/owl:Class/@IRI"/></xsl:variable>
		<xsl:variable name="theclass">#<xsl:value-of select="substring-after($aclass,'#')"/>;</xsl:variable>
		<xsl:if test="substring-after($aclass,'#')='TemporalContext'">
			<xsl:variable name="beforedate">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='beforeDate']/owl:Literal/text()"/>
			</xsl:variable>
			<xsl:variable name="afterdate">
			<xsl:value-of select="../owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$aname and substring-after(owl:DataProperty/@IRI,'#')='afterDate']/owl:Literal/text()"/>
			</xsl:variable>
			<xsl:variable name="negtout">
				<xsl:choose>
					<xsl:when test="$beforedate != ''"><xsl:value-of select="$beforedate"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$maxbeforedate"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="negtin">
				<xsl:choose>
					<xsl:when test="$afterdate != ''"><xsl:value-of select="$afterdate"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$minafterdate"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="$negtin &lt; $negtout">#NegativeTemporalContext.In=<xsl:value-of select="$negtin"/>Out=<xsl:value-of select="$negtout"/>; </xsl:if>
		</xsl:if>
	</xsl:for-each>
</xsl:template>

<!-- ************************************************************-->
<xsl:template name="intersectionlist">
	<!-- the output is the inlist with intersections cleaned -->
	<xsl:param name="inlist" select="null"/>
	<xsl:param name="intersectionflag" select="false"/>
	<xsl:param name="intersectionlist" select="null"/>
	<xsl:variable name="item"><xsl:value-of select="substring-before($inlist,';')"/>;</xsl:variable>
	<xsl:variable name="itemtarget"><xsl:value-of select="substring-after($item,'INTERSECTION_')"/></xsl:variable>
	<xsl:choose>
		<xsl:when test="$item != ';'">
			<xsl:if test="$itemtarget = ''"><xsl:value-of select="$item"/><xsl:text></xsl:text></xsl:if>
			<xsl:variable name="tail"><xsl:value-of select="substring-after($inlist,';')"/></xsl:variable>
			<xsl:call-template name="intersectionlist">
				<xsl:with-param name="inlist"><xsl:value-of select="$tail"/></xsl:with-param>
				<xsl:with-param name="intersectionlist">
					<xsl:value-of select="$intersectionlist"/>
					<xsl:if test="$itemtarget != ''"><xsl:if test="$intersectionlist != 'null'">_</xsl:if><xsl:value-of select="substring-before($itemtarget,';')"/></xsl:if>
				</xsl:with-param>
				<xsl:with-param name="intersectionflag">
					<xsl:if test="$itemtarget != '' and $intersectionlist != 'null'">true</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:if test="$intersectionlist != 'null' and $intersectionlist != ''">#<xsl:if test="$intersectionflag = 'true'">INTERSECTION_</xsl:if><xsl:value-of select="$intersectionlist"/>;<xsl:text></xsl:text></xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- ************************************************************-->

<xsl:template name="setlist">
	<!-- the output is the yeslist without members of nolist -->
	<xsl:param name="yeslist" select="null"/>
	<xsl:param name="nolist" select="null"/>
	<xsl:variable name="item"><xsl:value-of select="substring-before($yeslist,';')"/>;</xsl:variable>
	<xsl:if test="$item != ';'">
		<xsl:variable name="tail"><xsl:value-of select="substring-after($yeslist,';')"/></xsl:variable>
		<xsl:if test="contains($nolist,$item)=false">
			<xsl:value-of select="$item"/><xsl:text> </xsl:text>
		</xsl:if>
		<xsl:call-template name="setlist">
			<xsl:with-param name="yeslist"><xsl:value-of select="$tail"/></xsl:with-param>
			<xsl:with-param name="nolist"><xsl:value-of select="$nolist"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!-- ************************************************************-->

<xsl:template name="getSubClasses">
	<xsl:param name="class" select="null"/>
	<xsl:param name="dir" select="1"/>
	<xsl:for-each select="document($ppavro)/owl:Ontology/owl:SubClassOf[owl:Class/@IRI=$class]/owl:Class[position()=$dir]">
		<!--xsl:variable name="classiri"><xsl:value-of select="@IRI"/><xsl:value-of select="@abbreviatedIRI"/></xsl:variable>
		-->
		<xsl:variable name="classiri">
			<xsl:choose>
				<xsl:when test="@IRI"><xsl:value-of select="@IRI"/></xsl:when>
				<xsl:otherwise>#<xsl:value-of select="substring-after(@abbreviatedIRI,'mvco:')"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$classiri != $class">
			<xsl:value-of select="$classiri"/><xsl:text>; </xsl:text>
			<xsl:call-template name="getSubClasses">
				<xsl:with-param name="class" select="$classiri"/>
				<xsl:with-param name="dir" select="$dir"/>
			</xsl:call-template>
		</xsl:if>
</xsl:for-each>
</xsl:template>


<xsl:template match="owl:ObjectPropertyAssertion">
	<xsl:variable name="arc"><xsl:value-of select="substring-after(owl:ObjectProperty/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="first"><xsl:value-of select="substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="second"><xsl:value-of select="substring-after(owl:NamedIndividual[position()=2]/@IRI,'#')"/></xsl:variable>
	<xsl:value-of select="$arc"/>:<xsl:value-of select="$second"/> 
	<xsl:apply-templates select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=$second]" />
</xsl:template>

<xsl:template match="owl:DataPropertyAssertion">
	<xsl:variable name="key"><xsl:value-of select="substring-after(owl:DataProperty/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="value"><xsl:value-of select="owl:Literal/text()"/></xsl:variable>
	<xsl:variable name="owner"><xsl:value-of select="substring-after(owl:NamedIndividual/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="label">label="<xsl:value-of select="$key"/>=<xsl:value-of select="$value"/>"</xsl:variable>
<xsl:if test="$key != '' and $value != ''">
		<xsl:value-of select="$owner"/>:<xsl:value-of select="$key"/>=<xsl:value-of select="$value"/>
</xsl:if>
</xsl:template>

<!-- ************************************************************-->
<!--xsl:template name="ms-to-iso-duration">
        <xsl:param name="duration"/>
        <xsl:variable name="numframes" select="floor($duration * $framerate div 1000)"/>
        <xsl:variable name="numsecs" select = "floor($numframes div $framerate)"/>
        <xsl:variable name="nummins" select = "floor($numsecs div 60)"/>
        <xsl:variable name="numhours" select = "floor($nummins div 60)"/>
        <xsl:variable name="numdays" select = "floor($numhours div 24)"/>P<xsl:value-of select="$numdays"/>DT<xsl:value-of select="$numhours mod 24"/>H<xsl:value-of select="$nummins mod 60"/>M<xsl:value-of select="$numsecs mod 60"/>S<xsl:value-of select="$numframes mod $framerate"/>N<xsl:value-of select="$framerate"/>F</xsl:template>
-->
<!-- ************************************************************-->
<xsl:template name="iso-duration-to-minutes">
	<!-- BUGS:
		- in case of missing field it will fail
		- month is averaged to 30 days  (which is reasonable but...)
		- year is averaged to 365 days (which almost correct :-)) 
	-->
    <xsl:param name="duration"/>
    <xsl:variable name="nummins" select = "substring-before(substring-after($duration,'H'),'M')"/>
    <xsl:variable name="numhours" select = "substring-after(substring-before($duration,'H'),'DT')*60"/>
    <xsl:variable name="numdays" select = "substring-after(substring-before($duration,'DT'),'M')*24*60"/>
    <xsl:variable name="nummonths" select = "substring-after(substring-before($duration,'M'),'Y')*30*24*60"/>
    <xsl:variable name="numyears" select = "substring-after(substring-before($duration,'Y'),'P')*365*24*60"/>
    <xsl:value-of select="number($nummins + $numhours + $numdays + $nummonths + $numyears)"/>
</xsl:template>
<!-- ************************************************************-->
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
