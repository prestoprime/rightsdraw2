
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
	xmlns:ri="http://www.crit.rai.it/prestoprime/rights/rightsindex"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" indent="yes" omit-xml-declaration="yes"/>
<xsl:param name="ppavro">ppavro.owl</xsl:param>
<xsl:param name="querydoc">null</xsl:param>
<xsl:param name="querycache">null</xsl:param>
<!--xsl:param name="countrycodes">http://www.ebu.ch/metadata/cs/ebu_Iso3166CountryCodeCS.xml</xsl:param-->
<xsl:param name="countrycodes">ebu_Iso3166CountryCodeCS.xml</xsl:param>
<xsl:param name="languagecodes">ebu_Iso639_1LanguageCodeCS.xml</xsl:param>
<xsl:param name="disablecontexts">false</xsl:param>
<xsl:variable name="query">
	<xsl:choose>
		<xsl:when test="$querydoc != 'null'"><xsl:apply-templates select="document($querydoc)/owl:Ontology" /></xsl:when>
		<xsl:when test="$querycache != 'null'"><xsl:value-of select="$querycache"/></xsl:when>
		<xsl:otherwise>NOQUERY</xsl:otherwise>
	</xsl:choose>
</xsl:variable>
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
<xsl:text>
</xsl:text>
query: <xsl:value-of select="$query"/>
going on:
	<xsl:apply-templates select="//ri:RightsInstance" />
</xsl:template>


<xsl:template match="ri:RightsInstance">
	<xsl:variable name="instance">
		<xsl:value-of select="@id"/>
	</xsl:variable>
	<xsl:for-each select="ri:Record">
		<xsl:variable name="owneritemcontext"><xsl:if test="ri:Owner"><xsl:value-of select="ri:Owner/text()"/>; </xsl:if><xsl:value-of select="ri:AVname/text()"/>; <xsl:value-of select="ri:Identifier/text()"/>; </xsl:variable>
		<xsl:variable name="match">
			<xsl:variable name="temporalcontextmatch">
				<xsl:call-template name="comparetemporal">
					<xsl:with-param name="target"><xsl:value-of select="ri:Pdetails/text()"/></xsl:with-param>
					<xsl:with-param name="qlist"><xsl:value-of select="$query"/></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$temporalcontextmatch='false'">false</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="compare">
						<xsl:with-param name="target"><xsl:value-of select="$owneritemcontext"/><xsl:value-of select="ri:Pdetails/text()"/></xsl:with-param>
						<xsl:with-param name="qlist"><xsl:value-of select="$query"/></xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
<xsl:text>
</xsl:text>
<xsl:value-of select="$match"/>|<xsl:value-of select="$instance"/>|<xsl:value-of select="ri:Identifier"/>|<xsl:value-of select="ri:AVname"/>|<xsl:value-of select="ri:Pname"/>|<xsl:value-of select="ri:Pdetails"/>|<xsl:value-of select="$owneritemcontext"/>
	</xsl:for-each>
</xsl:template>

<!-- ************************************************************************ -->

<xsl:template match="owl:Ontology">
	<xsl:apply-templates select="owl:ClassAssertion[substring-after(owl:Class/@IRI,'#')='Permission']" />
</xsl:template>

<!-- ************************************************************************ -->

<xsl:template match="owl:ClassAssertion">
<xsl:variable name="ind"><xsl:value-of select="substring-after(owl:NamedIndividual/@IRI,'#')"/></xsl:variable>
<xsl:variable name="class"><xsl:value-of select="substring-after(owl:Class/@IRI,'#')"/></xsl:variable>
<!--xsl:value-of select="substring-after(owl:Class/@IRI,'#')"/>:<xsl:value-of select="substring-after(owl:NamedIndividual/@IRI,'#')"/-->
<xsl:choose>
	<xsl:when test="$class = 'Permission'">
		<xsl:call-template name="getOwnerItemContext">
			<xsl:with-param name="permid"><xsl:value-of select="$ind"/></xsl:with-param>
		</xsl:call-template>
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
<xsl:text>
</xsl:text>
</xsl:template>

<!-- ************************************************************************ -->

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
		<xsl:if test="$disablecontexts = 'false'">
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
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="instances">
		<!--
		<xsl:for-each select="../owl:ObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='permitsAction']">
			<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
			<xsl:for-each select="../owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$aname and substring-after(owl:ObjectProperty/@IRI,'#')='actedOver']">
				<xsl:variable name="iname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
				<xsl:value-of select="$iname"/><xsl:text>;</xsl:text>
			</xsl:for-each>
		</xsl:for-each>
		-->
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

<!-- ************************************************************************ -->

<xsl:template name="getOwnerItemContext">
	<xsl:param name="permid"/>
	<xsl:for-each select="../owl:ObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$permid and substring-after(owl:ObjectProperty/@IRI,'#')='permitsAction']">
		<xsl:variable name="aname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<xsl:for-each select="../owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$aname and substring-after(owl:ObjectProperty/@IRI,'#')='actedBy']">
			<xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/><xsl:text>; </xsl:text>
		</xsl:for-each>
		<xsl:for-each select="../owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$aname and substring-after(owl:ObjectProperty/@IRI,'#')='actedOver']">
			<xsl:variable name="iname"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
			<xsl:variable name="relid"><xsl:value-of select="../owl:DataPropertyAssertion[substring-after(owl:DataProperty/@IRI,'#')='Identifier' and owl:NamedIndividual/@IRI=$iname]/owl:Literal/text()"/></xsl:variable>
			<xsl:value-of select="$iname"/><xsl:text>; </xsl:text>
			<xsl:if test="$relid != ''"><xsl:value-of select="$relid"/><xsl:text>; </xsl:text></xsl:if>
		</xsl:for-each>
	</xsl:for-each>
</xsl:template>

<!-- ************************************************************************ -->

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
<xsl:text>
</xsl:text>
	<xsl:choose>
		<xsl:when test="$query = 'NOQUERY'">
<xsl:value-of select="$irelid"/>|<xsl:value-of select="$iname"/>|<xsl:value-of select="$permid"/>|<xsl:value-of select="$actions"/> <xsl:value-of select="$facts"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="match">
				<xsl:call-template name="compare">
					<xsl:with-param name="target"><xsl:value-of select="$actions"/> <xsl:value-of select="$facts"/></xsl:with-param>
					<xsl:with-param name="qlist"><xsl:value-of select="$query"/></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
<xsl:value-of select="$match"/>|<xsl:value-of select="$irelid"/>|<xsl:value-of select="$iname"/>|<xsl:value-of select="$permid"/>|<xsl:value-of select="$actions"/> <xsl:value-of select="$facts"/>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="$tail != ''">
		<xsl:call-template name="getInstances">
			<xsl:with-param name="instances"><xsl:value-of select="$tail"/></xsl:with-param>
			<xsl:with-param name="permid"><xsl:value-of select="$permid"/></xsl:with-param>
			<xsl:with-param name="facts"><xsl:value-of select="$facts"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!-- ************************************************************************ -->

<xsl:template name="comparetemporal">
	<xsl:param name="target"/>
	<xsl:param name="qlist"/>
	<xsl:variable name="qafter"><xsl:value-of select="substring-before(substring-after($qlist,'#TemporalContext.afterDate='),';')"/></xsl:variable>
	<xsl:variable name="qbefore"><xsl:value-of select="substring-before(substring-after($qlist,'#TemporalContext.beforeDate='),';')"/></xsl:variable>
	<xsl:variable name="tafter"><xsl:value-of select="substring-before(substring-after($target,'#TemporalContext.afterDate='),';')"/></xsl:variable>
	<xsl:variable name="tbefore"><xsl:value-of select="substring-before(substring-after($target,'#TemporalContext.beforeDate='),';')"/></xsl:variable>
	<xsl:choose>
		<xsl:when test="$qafter &lt; $tafter">false</xsl:when>
		<xsl:when test="$qbefore &gt; $tbefore">false</xsl:when>
		<xsl:when test="$qbefore &lt; $qafter">false</xsl:when>
		<xsl:otherwise>
			<!-- check the target negative intervals -->
			<xsl:call-template name="comparenegativetemporal">
				<xsl:with-param name="target"><xsl:value-of select="$target"/></xsl:with-param>
				<xsl:with-param name="qafter"><xsl:value-of select="$qafter"/></xsl:with-param>
				<xsl:with-param name="qbefore"><xsl:value-of select="$qbefore"/></xsl:with-param>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- ************************************************************************ -->

<xsl:template name="comparenegativetemporal">
	<xsl:param name="target"/>
	<xsl:param name="qafter"/>
	<xsl:param name="qbefore"/>
<!-- wip WIP cannot run -->
	<xsl:variable name="negtin"><xsl:value-of select="substring-before(substring-after($target,'#NegativeTemporalContext.In='),'Out=')"/></xsl:variable>
	<xsl:variable name="negtout"><xsl:value-of select="substring-before(substring-after(substring-after($target,'#NegativeTemporalContext.In='),'Out='),';')"/></xsl:variable>
	<xsl:variable name="tail"><xsl:value-of select="substring-after(substring-after($target,'#NegativeTemporalContext.In='),';')"/></xsl:variable>
	<xsl:variable name="nextnegtin"><xsl:value-of select="substring-after(substring-after($tail,'#NegativeTemporalContext.In='),';')"/></xsl:variable>
	<xsl:choose>
		<xsl:when test="$qbefore &gt; $negtin and $qafter &lt; $negtout">false</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="$nextnegtin = ''">true</xsl:when>
				<xsl:otherwise>
					<!-- check the remaining target negative intervals -->
					<xsl:call-template name="comparenegativetemporal">
						<xsl:with-param name="target"><xsl:value-of select="$tail"/></xsl:with-param>
						<xsl:with-param name="qafter"><xsl:value-of select="$qafter"/></xsl:with-param>
						<xsl:with-param name="qbefore"><xsl:value-of select="$qbefore"/></xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
<!-- wip WIP cannot run -->
</xsl:template>

<!-- ************************************************************************ -->
<xsl:template name="compareruncontext">
	<!-- numruns, val, numreps -->
	<xsl:param name="trun"/>
	<xsl:param name="qrun"/>
	<xsl:variable name="qnumruns"><xsl:value-of select="substring-before(substring-after($qrun,'numruns='),'.val=')"/></xsl:variable>
	<xsl:variable name="tnumruns"><xsl:value-of select="substring-before(substring-after($trun,'numruns='),'.val=')"/></xsl:variable>
	<xsl:choose>
		<xsl:when test="$tnumruns != 'unbounded' and $qnumruns != 'unbounded' and $tnumruns &lt; $qnumruns">false</xsl:when>
		<xsl:when test="$tnumruns != 'unbounded' and $qnumruns = 'unbounded'">false</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="qval"><xsl:value-of select="substring-before(substring-after($qrun,'val='),'.numreps=')"/></xsl:variable>
			<xsl:variable name="tval"><xsl:value-of select="substring-before(substring-after($trun,'val='),'.numreps=')"/></xsl:variable>
			<xsl:choose>
				<xsl:when test="$tval &lt; $qval">false</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="qnumreps"><xsl:value-of select="substring-after($qrun,'.numreps=')"/></xsl:variable>
					<xsl:variable name="tnumreps"><xsl:value-of select="substring-after($trun,'.numreps=')"/></xsl:variable>
					<xsl:choose>
						<xsl:when test="$tnumreps != 'unbounded' and $qnumreps != 'unbounded' and $tnumreps &lt; $qnumreps">false</xsl:when>
						<xsl:when test="$tnumreps != 'unbounded' and $qnumreps = 'unbounded'">false</xsl:when>
						<xsl:otherwise>true</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- ************************************************************************ -->

<xsl:template name="compare">
<!-- compare target rights with qlist. If any element of qlist doesn't find a match in target it returns false, otherwise it will return true when reaching the end of qlist-->
<!-- temporal context facts are ignored here as considered separately -->
	<xsl:param name="target"/>
	<xsl:param name="qlist"/>
	<xsl:variable name="qitem"><xsl:value-of select="substring-before($qlist,';')"/>;</xsl:variable>
	<xsl:variable name="tail"><xsl:value-of select="substring-after($qlist,'; ')"/></xsl:variable>
	<xsl:variable name="qitemok">
		<xsl:choose>
			<xsl:when test="substring-after($qitem,'#TemporalContext.')!= ''">true</xsl:when>
			<xsl:when test="substring-after($qitem,'#NegativeTemporalContext.')!= ''">true</xsl:when>
			<xsl:when test="substring-after($qitem,'#RunContext.')!= ''">
				<xsl:call-template name="compareruncontext">
					<xsl:with-param name="trun"><xsl:value-of select="substring-after($target,'#RunContext.')"/></xsl:with-param>
					<xsl:with-param name="qrun"><xsl:value-of select="substring-after($qitem,'#RunContext.')"/></xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="contains($target,$qitem)=false">false</xsl:when>
					<xsl:otherwise>true</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:choose>
		<!--xsl:when test="$qitemok='false'">false</xsl:when-->
		<xsl:when test="$qitemok!='true'"><xsl:value-of select="$qitemok"/></xsl:when>
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
					</xsl:choose	>
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
<!-- ************************************************************-->


<xsl:template match="owl:ObjectPropertyAssertion">
	<xsl:variable name="arc"><xsl:value-of select="substring-after(owl:ObjectProperty/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="first"><xsl:value-of select="substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="second"><xsl:value-of select="substring-after(owl:NamedIndividual[position()=2]/@IRI,'#')"/></xsl:variable>
	<xsl:value-of select="$arc"/>:<xsl:value-of select="$second"/> 
	<xsl:apply-templates select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=$second]" />
</xsl:template>
<!-- ************************************************************-->

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
