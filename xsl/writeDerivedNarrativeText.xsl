<!--
#  rightsdraw
#  Version: 2.0.1
#  Authors: L. Boch
#
#  Copyritght (C) 2012-2013 RAI – Radiotelevisione Italiana <cr_segreteria@rai.it>
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
<xsl:param name="startFrom">null</xsl:param>
<xsl:variable name="ontoIRI"><xsl:value-of select="/owl:Ontology/@ontologyIRI"/></xsl:variable>

<xsl:template match="/">
	<html><head></head><body><div style="position:relative;left:30px;width:650px;font-family:'Courier New';background-color:lightgrey">
	<xsl:choose>
		<xsl:when test="$startFrom = 'Contract'">
			<xsl:for-each select="owl:Ontology/owl:ClassAssertion[owl:Class/@IRI='urn:mpeg:mpeg21:mco:core:2012#Contract']">
				<xsl:variable name="mycontract"><xsl:value-of select="owl:NamedIndividual/@IRI"/></xsl:variable>
				<!-- must add check that this is the main contract and not a referenced one? -->
				<xsl:call-template name="WriteContract">
					<xsl:with-param name="contract"><xsl:value-of select="$mycontract"/></xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:when>
		<xsl:when test="$startFrom = 'Holdings'">
			<xsl:for-each select="owl:Ontology/owl:ClassAssertion[owl:Class/@IRI='http://purl.oclc.org/NET/mvco.owl#Permission']">
				<xsl:call-template name="WriteDeontic">
					<xsl:with-param name="deontic"><xsl:value-of select="owl:NamedIndividual/@IRI"/></xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>unsupported case</xsl:otherwise>
	</xsl:choose>
	</div> </body> </html>
</xsl:template>

<xsl:template name="WriteContract">
	<xsl:param name="contract">null</xsl:param>
	<div>
		<!--h1>Contract: [<xsl:value-of select="$ontoIRI"/><xsl:value-of select="$contract"/>]</h1>
		-->
		<h1>MCO Contract: [<xsl:value-of select="$contract"/>]</h1>
		<!--h2>Metadata</h2-->
		<p>TITLE: <xsl:value-of disable-output-escaping="yes" select="/owl:Ontology/owl:AnnotationAssertion[owl:IRI=$contract and owl:AnnotationProperty/@IRI='http://purl.org/dc/elements/1.1/title']/owl:Literal/text()"/></p>
		<p>DATE: <xsl:value-of select="/owl:Ontology/owl:AnnotationAssertion[owl:IRI=$contract and owl:AnnotationProperty/@IRI='http://purl.org/dc/elements/1.1/date']/owl:Literal/text()"/></p>
		<p>IDENTIFIER: <xsl:value-of disable-output-escaping="yes" select="/owl:Ontology/owl:AnnotationAssertion[owl:IRI=$contract and owl:AnnotationProperty/@IRI='http://purl.org/dc/elements/1.1/identifier']/owl:Literal/text()"/></p>
		<h2>Parties</h2>
		<p> The present agreement is between:</p>
		<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#hasParty' and owl:NamedIndividual[position()=1]/@IRI=$contract]">
			<xsl:variable name="myparty"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
			<xsl:call-template name="WriteParty">
				<xsl:with-param name="party"><xsl:value-of select="$myparty"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<h2>Relationships with other Contracts</h2>
		<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[(owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#cancels' or owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#isAmendmentOf' or owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#prevailsOver' or owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#supersedes') and owl:NamedIndividual[position()=1]/@IRI=$contract]">
			<xsl:call-template name="WriteContractRef">
				<xsl:with-param name="contract"><xsl:value-of select="$contract"/></xsl:with-param>
				<xsl:with-param name="refcontract"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:with-param>
				<xsl:with-param name="reftype"><xsl:value-of select="substring-after(owl:ObjectProperty/@IRI,'#')"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<h2>Object(s) of this agreement</h2>
		<xsl:call-template name="WriteContractObjects">
			<xsl:with-param name="contract"><xsl:value-of select="$contract"/></xsl:with-param>
		</xsl:call-template>
		<h2>Agreed Deontics</h2>
		<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#issuedIn' and owl:NamedIndividual[position()=2]/@IRI=$contract]">
			<xsl:call-template name="WriteDeontic">
				<xsl:with-param name="deontic"><xsl:value-of select="owl:NamedIndividual[position()=1]/@IRI"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<h2>Signatories</h2>
		<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#isSignedBy' and owl:NamedIndividual[position()=1]/@IRI=$contract]">
			<xsl:variable name="mysignatory"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
			<xsl:call-template name="WriteSignatory">
				<xsl:with-param name="signatory"><xsl:value-of select="$mysignatory"/></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<hr/>
		<h3>Original narrative version</h3>
		<pre>
		<xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#TextVersion' and owl:NamedIndividual/@IRI=$contract]/owl:Literal/text()"/>
		</pre>
	</div>
</xsl:template>
<!-- ******************************************************* -->
<xsl:template name="WriteDeontic">
	<xsl:param name="deontic">null</xsl:param>
	<h3><xsl:value-of select="substring-after(/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$deontic]/owl:Class/@IRI,'#')"/>: <xsl:value-of select="$deontic"/> </h3>
	<xsl:choose>
		<xsl:when test="/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$deontic]/owl:Class/@IRI='http://purl.oclc.org/NET/mvco.owl#Permission'">
			<xsl:variable name="sublicense">
				<xsl:variable name="flag"><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$deontic and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#hasSublicenseRight']/owl:Literal/text()"/></xsl:variable>
				<xsl:choose>
					<xsl:when test="$flag='false'">without right of sublicense</xsl:when>
					<xsl:otherwise>with right of sublicense</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="exclusivity">
				<xsl:variable name="flag"><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$deontic and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#isExclusive']/owl:Literal/text()"/></xsl:variable>
				<xsl:choose>
					<xsl:when test="$flag='true'">on an exclusive basis</xsl:when>
					<xsl:otherwise>without exclusivity</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="usepercent">
				<xsl:variable name="percent"><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$deontic and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#hasUsePercentage']/owl:Literal/text()"/></xsl:variable>
				<xsl:choose>
					<xsl:when test="$percent!='100' and $percent != ''">the <xsl:value-of select="$percent"/>% of use and exploitation</xsl:when>
					<xsl:otherwise>the 100% (one hundred per cent) of use and exploitation</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="inpercent">
				<xsl:variable name="percent"><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$deontic and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#hasIncomePercentage']/owl:Literal/text()"/></xsl:variable>
				<xsl:choose>
					<xsl:when test="$percent!='100' and $percent != ''">the <xsl:value-of select="$percent"/>% of income receipts.</xsl:when>
					<xsl:otherwise>the 100% (one hundred per cent) of income receipts</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>


			<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#permitsAction' and owl:NamedIndividual[position()=1]/@IRI=$deontic]">
				<xsl:variable name="myaction"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>

<p>Grants to <b><xsl:value-of select="substring-after(/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#actedBy' and owl:NamedIndividual[position()=1]/@IRI=$myaction]/owl:NamedIndividual[position()=2]/@IRI,'#')"/></b>, <xsl:value-of select="$exclusivity"/>, <xsl:value-of select="$sublicense"/>, <xsl:value-of select="$usepercent"/>, and <xsl:value-of select="$inpercent"/> the permission to:</p>

				<li><b><xsl:value-of select="substring-after(/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$myaction]/owl:Class/@IRI,'#')"/></b>
				(<xsl:value-of select="$myaction"/>) - acted on:
				<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#actedOver' and owl:NamedIndividual[position()=1]/@IRI=$myaction]">
					<xsl:variable name="myitem"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
					<!--xsl:value-of select="/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$myitem]/owl:Class/@IRI"/-->
					<b><xsl:value-of select="substring-after($myitem,'#')"/></b>, which is the resource identified by: <b><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$myitem and owl:DataProperty/@IRI='urn:mpeg:mpeg21:2002:01-DII-NS#Identifier']/owl:Literal/text()"/></b>,
				</xsl:for-each>
				</li>
			</xsl:for-each>
		</xsl:when>
		<xsl:when test="/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$deontic]/owl:Class/@IRI='urn:mpeg:mpeg21:mco:core:2012#Prohibition'">
		</xsl:when>
		<xsl:when test="/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$deontic]/owl:Class/@IRI='urn:mpeg:mpeg21:mco:core:2012#Obligation'">
		</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
	<p>provided that all of the following Facts hold:</p>
	<ul>
	<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#hasRequired' and owl:NamedIndividual[position()=1]/@IRI=$deontic]">
		<xsl:variable name="myfact"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<li>
			<xsl:call-template name="WriteFact">
				<xsl:with-param name="fact"><xsl:value-of select="$myfact"/></xsl:with-param>
				<xsl:with-param name="isnegative">no</xsl:with-param>
			</xsl:call-template>
		</li>
	</xsl:for-each>
	<xsl:for-each select="/owl:Ontology/owl:NegativeObjectPropertyAssertion[owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#hasRequired' and owl:NamedIndividual[position()=1]/@IRI=$deontic]">
		<xsl:variable name="myfact"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
		<li>
			<xsl:call-template name="WriteFact">
				<xsl:with-param name="fact"><xsl:value-of select="$myfact"/></xsl:with-param>
				<xsl:with-param name="isnegative">yes</xsl:with-param>
			</xsl:call-template>
		</li>
	</xsl:for-each>
	</ul>
</xsl:template>
<!-- ******************************************************* -->
<xsl:template name="WriteFact">
	<xsl:param name="fact">null</xsl:param>
	<xsl:param name="isnegative">null</xsl:param>
	<xsl:variable name="class"><xsl:value-of select="/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$fact]/owl:Class/@IRI"/></xsl:variable>
	<xsl:choose>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:core:2012#FactIntersection'">
			<!-- assuming, for the moment that Intersection is not negative -->
			<p>Case: <b><xsl:value-of select="$fact"/></b> - It is required that all of the following Facts hold:</p>
			<ul>
				<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#hasFact' and owl:NamedIndividual[position()=1]/@IRI=$fact]">
				<li>
					<xsl:call-template name="WriteFact">
						<xsl:with-param name="fact"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:with-param>
						<xsl:with-param name="isnegative">no</xsl:with-param>
					</xsl:call-template>
				</li>
				</xsl:for-each>
			</ul>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:core:2012#FactUnion'">
			<!-- assuming, for the moment that Union is not negative -->
			<p>Case: <b><xsl:value-of select="$ind"/></b> - It is required that at least one of the following Facts hold:</p>
			<ul>
				<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#hasFact' and owl:NamedIndividual[position()=1]/@IRI=$fact]">
				<li>
					<xsl:call-template name="WriteFact">
						<xsl:with-param name="fact"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:with-param>
						<xsl:with-param name="isnegative">no</xsl:with-param>
					</xsl:call-template>
				</li>
				</xsl:for-each>
			</ul>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:core:2012#FactNegation'">
			<!-- Provisional, not really expected -->
			<p>Case: <b><xsl:value-of select="$ind"/></b> - It is required that the following Fact is not true</p>
			<ul>
				<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#hasFact' and owl:NamedIndividual[position()=1]/@IRI=$fact]">
				<li>
					<xsl:call-template name="WriteFact">
						<xsl:with-param name="fact"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:with-param>
						<xsl:with-param name="isnegative">no</xsl:with-param>
					</xsl:call-template>
				</li>
				</xsl:for-each>
			</ul>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#FreeOfCharge'">
	<p>The access policy is <xsl:if test="$isnegative='yes'">NOT</xsl:if> <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is no payment is required for access, within the execution of the action. </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Pay'">
	<p>The access policy is  <xsl:if test="$isnegative='yes'">NOT</xsl:if> <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is a payment in any form is required for access, within the execution of the action. </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#PayPerView'">
	<p>The access policy is  <xsl:if test="$isnegative='yes'">NOT</xsl:if>  <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the execution of the action requires a payment by the final user on a per-exhibition basis.  Audio-visual contents are delivered at a time scheduled by the service provider, by continuous exhibition.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Subscription'">
	<p>The access policy is  <xsl:if test="$isnegative='yes'">NOT</xsl:if> <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the execution of the action requires a payment of a subscription fee by the final user. Audio-visual contents are streamed or downloaded. </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Restricted'">
	<p>The service access policy is  <xsl:if test="$isnegative='yes'">NOT</xsl:if> <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the service is provided only to customers who have obtained an approval by the service provider.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Open'">
	<p>The service access policy is  <xsl:if test="$isnegative='yes'">NOT</xsl:if> <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the service is provided to all consumers without the need for approval by the service provider. This condition is independent from the policy of access that could be free of charge or pay.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Linear'">
	<p>The delivery modality is <xsl:if test="$isnegative='yes'">NOT</xsl:if> <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the simultaneous delivery of audiovisual contents by a media service provider to many end users, on the basis of a programme schedule.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Broadcasting'">
	<p>The delivery modality is <xsl:if test="$isnegative='yes'">NOT</xsl:if> <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the Linear delivery of audiovisual content via BroadcastDeliveryTechnology.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Webcasting'">
		<p>The delivery modality is <xsl:if test="$isnegative='yes'">NOT</xsl:if>  <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the delivery of audio-visual contents by streaming modality via Internet. </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#NonLinear'">
	<p>The delivery modality is <xsl:if test="$isnegative='yes'">NOT</xsl:if> <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the delivery of audiovisual contents by a media service provider for the view at the moment chosen by the end user and at his individual request on the basis of a catalogue of programmes selected by the media service provider.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#OnDemandBasis'">
	<p>The delivery modality is <xsl:if test="$isnegative='yes'">NOT</xsl:if> <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the delivery of audiovisual contents by a media service provider for the view at the moment chosen by the end user and at his individual request on the basis of a catalogue of programmes selected by the media service provider, and in response to a user request.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#OnDemandDownload'">
	<p>The delivery modality is <xsl:if test="$isnegative='yes'">NOT</xsl:if> <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the delivery of audiovisual contents by a media service provider for the view at the moment chosen by the end user and at his individual request on the basis of a catalogue of programmes selected by the media service provider, in response to a user request, and is made of the reception of data to the user's system from a remote system for viewing for limited time or perpetuity.</p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#OnDemandStreaming'">
	<p>The delivery modality is <xsl:if test="$isnegative='yes'">NOT</xsl:if> <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the delivery of audiovisual contents by a media service provider for the view at the moment chosen by the end user and at his individual request on the basis of a catalogue of programmes selected by the media service provider, in response to a user request, and is made in streaming modality.</p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#BroadcastTechnology'">
	<p>The technology used for the transmission of audiovisual content to end users is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be   <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the means are restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be  a point-to-multipoint technology. </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#MobileBroadcastTechnology'">
	<p>The technology used for the transmission of audiovisual content to end users is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be   <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the means are restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be  a point-to-multipoint technology. </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#MobileTechnology'">
	<p>The technology used for the transmission of audiovisual content to end users is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the means are restricted  <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be any technology which enables reception while the user is in motion for viewing a MobileDevice.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#MobileBroadcastTechnology'">
	<p>The technology used for the transmission of audiovisual content to end users for fruition on portable device is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be   <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the means are restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be  a point-to-multipoint technology for portable devices. </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#MobileTelecommunicationTechnology'">
	<p>The technology used for the transmission of audiovisual content to end users for fruition on portable device is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be   <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the means are restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be  a point-to-point technology for portable devices. </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Internet'">
		<p>The technology used for the transmission of audiovisual content to end users is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be  <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the means are restricted  <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be TCP/IP software protocols or any equivalent protocol.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Radio'">
		<p>The technology used for the transmission of audiovisual content to end users is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the means are restricted  <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be Radio.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Videogram'">
	<p>The technology used for the transmission of audiovisual content to end users is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> be <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the means are restricted  <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be any form of videocassettes, cartridges, tape, video discs, laser discs, any form of DVD, DVD ROM, internet access ready DVDs, CDi, CD-ROM, UMD, VCD or any other format. </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Cable'">
	<p>The specific technology used for the transmission of audiovisual content to end users is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be  <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the means are restricted  <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be any BroadcastTechnology which makes use of co-axial and/or fibre optic cable for direct reception by a TelevisionSet. It does not include DSL or other Internet or Ip-based networks. </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#IPNetwork'">
	<p>The specific technology used for the transmission of audiovisual content to end users is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be  <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the means are restricted  <xsl:if test="$isnegative='yes'">NOT</xsl:if>  to be any BroadcastTechnology which makes use of a DSL (including ADSL) or Ip-based network, excluding Internet.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Satellite'">
	<p>The specific technology used for the transmission of audiovisual content to end users is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be  <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the means are restricted  <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be any BroadcastTechnology which makes use of a geostationary satellite system. </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Terrestrial'">
	<p>The specific technology used for the transmission of audiovisual content to end users is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the means are restricted  <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be any BroadcastTechnology which makes use of a terrestrial television transmitter.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Computer'">
	<p>The device is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be <b><xsl:value-of select="substring-after($class,'#')"/></b> equipment.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#MobileDevice'">
		<p>The device is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be  <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is any portable equipment capable of receiving transmissions while the user is in motion, made by means of a MobileTechnology.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#MobileBroadcastDevice'">
	<p>The device is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be  <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is any MobileDevice capable of receiving transmissions by means of MobileBroadcastTechnology.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#MobileTelecommunicationDevice'">
	<p>The device is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be  <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is any MobileDevice capable of receiving transmissions by means of MobileTelecommunicationTechnology.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#RobotDevice'">
	<p>The device is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is any equipment capable of performing automated tasks without human interaction. </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#StorageDevice'">
	<p>The device is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is any device with storage capabilities, allowing the user to keep and reuse the content saved locally.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#TelevisionDevice'">
	<p>The device is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if> to be <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is any equipment with television functionalities.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#TelevisionSet'">
	<p>The device is restricted <xsl:if test="$isnegative='yes'">NOT</xsl:if>  to be  <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is any TelevisionDevice, excluding MobileBroadcastDevice.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Limited'">
	<p>The user time access is  <xsl:if test="$isnegative='yes'">NOT</xsl:if>  <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is limited availability over time of the content for the access by the end user (e.g rental).  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Unlimited'">
	<p>The user time access is  <xsl:if test="$isnegative='yes'">NOT</xsl:if>  <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is unlimited availability over time of the content for the access by the end user.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Run'">
	<p>The exploitation is constrained to  <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the action can be executed at most <xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$fact and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#hasNumberOfRuns']/owl:Literal/text()"/> times.
			<xsl:variable name="runvalidity"><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$fact and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#hasValidity']/owl:Literal/text()"/></xsl:variable>
			<xsl:if test="$runvalidity != ''">
				It is agreed that a single run shall mean the execution of the action within the <xsl:value-of select="$runvalidity"/> validity time period.
				<xsl:variable name="runreps"><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$fact and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#hasNumberOfRepetitions']/owl:Literal/text()"/></xsl:variable>
				<xsl:if test="$runreps != ''">
				It is also agreed that a single run shall mean the execution of the action for not more than <xsl:value-of select="$runreps"/> repetitions within the validity time period.
				</xsl:if>
			</xsl:if>
		</p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#SpatialContext'">
			<xsl:variable name="territories"><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$fact and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#inCountry']/owl:Literal/text()"/></xsl:variable>
	<p>The exploitation is constrained to <xsl:if test="$isnegative='yes'">OUT OF</xsl:if> <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the action can<xsl:if test="$isnegative='yes'">NOT</xsl:if> be executed <xsl:if test="$isnegative!='yes'">only</xsl:if> within the territory identified by the following country codes: <xsl:value-of select="$territories"/> </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Language'">
			<xsl:variable name="languages"><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$fact and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#hasLanguage']/owl:Literal/text()"/></xsl:variable>
	<p>The exploitation is constrained to <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the language of IP-Entity object of the action must <xsl:if test="$isnegative='yes'">NOT</xsl:if> be within the following list of language codes: <xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$fact and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#hasLanguage']/owl:Literal/text()"/> </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#TemporalContext'">
			<xsl:variable name="ad"><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$fact and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#afterDate']/owl:Literal/text()"/></xsl:variable>
			<xsl:variable name="bd"><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$fact and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#beforeDate']/owl:Literal/text()"/></xsl:variable>
	<p>The exploitation is constrained to  <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the action can<xsl:if test="$isnegative='yes'">NOT</xsl:if> be executed  <xsl:if test="$isnegative!='yes'">only</xsl:if> within the time period identified as follows:<br/>
			<xsl:if test="$ad != ''"> after: <xsl:value-of select="$ad"/> <br/> </xsl:if>
			<xsl:if test="$bd != ''"> before: <xsl:value-of select="$bd"/> </xsl:if> </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#Length'">
	<p>The exploitation is constrained to  <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the maximum length, as duration of canonical play, of material resulting from the action is bounded to <xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$fact and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#hasMaxLength']/owl:Literal/text()"/>.  </p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:ipre:2012#IPEntityContext'">
			<xsl:variable name="partofipentitycontext"><xsl:value-of select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=1]/@IRI=$fact and owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#partOf']/owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
	<p>The exploitation is constraided to <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is <xsl:if test="$isnegative='yes'">NOT</xsl:if> to belong to the editorial context of <xsl:value-of select="$partofipentitycontext"/>.
	</p>
		</xsl:when>
		<xsl:when test="$class = 'urn:mpeg:mpeg21:mco:core:2012#ActionDone' or $class = 'urn:mpeg:mpeg21:mco:core:2012#ActionStarted'">
			<xsl:variable name="relatedaction"><xsl:value-of select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=2]/@IRI=$fact and owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#makesTrue']/owl:NamedIndividual[position()=1]/@IRI"/></xsl:variable>
			<xsl:variable name="relatedpermission"><xsl:value-of select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:NamedIndividual[position()=2]/@IRI=$relatedaction and owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#permitsAction']/owl:NamedIndividual[position()=1]/@IRI"/></xsl:variable>
			<xsl:variable name="validity"><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$fact and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#hasValidity']/owl:Literal/text()"/></xsl:variable>
			<xsl:variable name="delay"><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$fact and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:ipre:2012#withDelay']/owl:Literal/text()"/></xsl:variable>
	 <p>The exploitation is constrained to  <b><xsl:value-of select="substring-after($class,'#')"/></b>, that is the action <xsl:value-of select="$relatedaction"/> (permitted by <xsl:value-of select="$relatedpermission"/>) must <xsl:if test="$isnegative='yes'"> NOT </xsl:if>be <xsl:choose> <xsl:when test="$class = 'urn:mpeg:mpeg21:mco:core:2012#ActionDone'">accomplished</xsl:when> <xsl:when test="$class = 'urn:mpeg:mpeg21:mco:core:2012#ActionStarted'">started</xsl:when> <xsl:otherwise/> </xsl:choose> <xsl:if test="$delay!=''">, with a delay of <xsl:value-of select="$delay"/></xsl:if><xsl:if test="$validity!=''">, for the following <xsl:value-of select="$validity"/></xsl:if>. </p>
		</xsl:when>
		<xsl:otherwise> unsupported text conversion for <xsl:value-of select="substring-after($class,'#')"/> </xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- ******************************************************* -->
<xsl:template name="WriteContractRef">
	<xsl:param name="contract">null</xsl:param>
	<xsl:param name="refcontract">null</xsl:param>
	<xsl:param name="reftype">null</xsl:param>
	<h3>
		<xsl:value-of select="$contract"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$reftype"/> 
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring-after(/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$refcontract]/owl:Class/@IRI,'#')"/> 
		<xsl:text> </xsl:text>
		<xsl:value-of select="$refcontract"/> 
	</h3>
	<blockquote>
	<p>TITLE: <xsl:value-of select="owl:AnnotationAssertion[owl:IRI=$refcontract and owl:AnnotationProperty/@IRI='http://purl.org/dc/elements/1.1/title']/owl:Literal/text()"/></p>
	<p>DATE: <xsl:value-of select="owl:AnnotationAssertion[owl:IRI=$refcontract and owl:AnnotationProperty/@IRI='http://purl.org/dc/elements/1.1/date']/owl:Literal/text()"/></p>
	<p>IDENTIFIER: <xsl:value-of select="owl:AnnotationAssertion[owl:IRI=$refcontract and owl:AnnotationProperty/@IRI='http://purl.org/dc/elements/1.1/identifier']/owl:Literal/text()"/></p>
	<p>between: [
	<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#hasParty' and owl:NamedIndividual[position()=1]/@IRI=$contract]">
		<xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/>,
	</xsl:for-each>]
	</p>
	</blockquote>
</xsl:template>
<!-- ******************************************************* -->
<xsl:template name="WriteContractObjects">
	<xsl:param name="contract">null</xsl:param>
	<xsl:variable name="myobjects">
	<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#issuedIn' and owl:NamedIndividual[position()=2]/@IRI=$contract]">
		<xsl:variable name="mydeontic"><xsl:value-of select="owl:NamedIndividual[position()=1]/@IRI"/></xsl:variable>
		<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[(owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#forbidsAction' or owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#obligatesAction' or owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#permitsAction') and owl:NamedIndividual[position()=1]/@IRI=$mydeontic]">
			<xsl:variable name="myaction"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:variable>
			<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='http://purl.oclc.org/NET/mvco.owl#actedOver' and owl:NamedIndividual[position()=1]/@IRI=$myaction]">
				(<xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/>),
			</xsl:for-each>
		</xsl:for-each>
	</xsl:for-each>
	</xsl:variable>
	<xsl:call-template name="WriteDistinctObjects">
		<xsl:with-param name="list"><xsl:value-of select="$myobjects"/></xsl:with-param>
	</xsl:call-template>
</xsl:template>
<!-- ******************************************************* -->
<xsl:template name="WriteDistinctObjects">
	<xsl:param name="list">null</xsl:param>
	<xsl:if test="$list != ''">
		<xsl:variable name="target">(<xsl:value-of select="substring-before(substring-after($list,'('),'),')"/>),</xsl:variable>
		<xsl:variable name="tail"><xsl:value-of select="substring-after($list,'),')"/></xsl:variable>
		<xsl:if test="$target !='(),' and contains($tail,$target)=false">
			<xsl:call-template name="WriteObjectDetails">
				<xsl:with-param name="objectiri"><xsl:value-of select="substring-before(substring-after($target,'('),'),')"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:call-template name="WriteDistinctObjects">
			<xsl:with-param name="list"><xsl:value-of select="$tail"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
</xsl:template>
<!-- ******************************************************* -->
<xsl:template name="WriteObjectDetails">
	<xsl:param name="objectiri">null</xsl:param>
	<h3><xsl:value-of select="substring-after(/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$objectiri]/owl:Class/@IRI,'#')"/>: <xsl:value-of select="substring-after($objectiri,'#')"/> </h3>
	<h4>Identifier: [<xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$objectiri and owl:DataProperty/@IRI='urn:mpeg:mpeg21:2002:01-DII-NS#Identifier']/owl:Literal/text()"/>]</h4>
	<xsl:call-template name="WriteMetadata">
		<xsl:with-param name="ind"><xsl:value-of select="$objectiri"/></xsl:with-param>
	</xsl:call-template>
</xsl:template>
<!-- ******************************************************* -->
<xsl:template name="WriteParty">
	<xsl:param name="party">null</xsl:param>
	<h3><!--xsl:value-of select="/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$party]/owl:Class/@IRI"/--> <xsl:value-of select="substring-after($party,'#')"/> </h3>
	<xsl:call-template name="WriteMetadata">
		<xsl:with-param name="ind"><xsl:value-of select="$party"/></xsl:with-param>
	</xsl:call-template>
	<xsl:if test="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$party and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#Address']">
		<p>Address: <xsl:value-of disable-output-escaping="yes" select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$party and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#Address']/owl:Literal/text()"/></p>
	</xsl:if>
	<xsl:for-each select="/owl:Ontology/owl:ObjectPropertyAssertion[owl:ObjectProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#hasSignatory' and owl:NamedIndividual[position()=1]/@IRI=$party]">
		<p>Represented by: </p>
		<blockquote>
			<xsl:call-template name="WriteParty"><!-- using same template -->
				<xsl:with-param name="party"><xsl:value-of select="owl:NamedIndividual[position()=2]/@IRI"/></xsl:with-param>
			</xsl:call-template>
		</blockquote>
	</xsl:for-each>
</xsl:template>
<!-- ******************************************************* -->
<xsl:template name="WriteSignatory">
	<xsl:param name="signatory">null</xsl:param>
	<h3><!--xsl:value-of select="/owl:Ontology/owl:ClassAssertion[owl:NamedIndividual/@IRI=$signatory]/owl:Class/@IRI"/--> <xsl:value-of select="substring-after($signatory,'#')"/> </h3>
	<xsl:if test="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$signatory and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#Signature']">
		<h4>Signature</h4>
		<pre><xsl:value-of select="/owl:Ontology/owl:DataPropertyAssertion[owl:NamedIndividual/@IRI=$signatory and owl:DataProperty/@IRI='urn:mpeg:mpeg21:mco:core:2012#Signature']/owl:Literal/text()"/></pre>
	</xsl:if>
</xsl:template>
<!-- ******************************************************* -->
<xsl:template name="WriteMetadata">
	<xsl:param name="ind">null</xsl:param>
	<xsl:for-each select="/owl:Ontology/owl:AnnotationAssertion[owl:IRI=$ind]">
		<p>
		<xsl:choose>
			<xsl:when test="substring-after(owl:AnnotationProperty/@IRI,'http://purl.org/dc/elements/1.1/') != ''">
				<xsl:value-of select="substring-after(owl:AnnotationProperty/@IRI,'http://purl.org/dc/elements/1.1/')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="owl:AnnotationProperty/@IRI"/>
			</xsl:otherwise>
		</xsl:choose>: <xsl:value-of disable-output-escaping="yes" select="owl:Literal/text()"/>
		</p>
	</xsl:for-each>
</xsl:template>
<!-- ******************************************************* -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
