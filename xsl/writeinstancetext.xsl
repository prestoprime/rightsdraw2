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
<xsl:param name="repoinstance">null</xsl:param>
<xsl:variable name="instance"><xsl:value-of select="/owl:Ontology/@ontologyIRI"/></xsl:variable>
<xsl:variable name="image"><xsl:value-of select="$repoinstance"/>.png</xsl:variable>

<xsl:template match="/">
	<xsl:apply-templates select="owl:Ontology" />
</xsl:template>

<xsl:template match="owl:Ontology">
<h4>Derived text for: <xsl:value-of select="$instance"/></h4>
<xsl:apply-templates select="owl:ClassAssertion[substring-after(owl:Class/@IRI,'#')='Permission']" />
</xsl:template>

<xsl:template match="owl:ClassAssertion">
<xsl:variable name="ind"><xsl:value-of select="substring-after(owl:NamedIndividual/@IRI,'#')"/></xsl:variable>
<xsl:variable name="class"><xsl:value-of select="substring-after(owl:Class/@IRI,'#')"/></xsl:variable>

<xsl:choose>
	<xsl:when test="$class = 'Permission'">
This is <xsl:value-of select="$class"/>: <b><xsl:value-of select="$ind"/></b>.
The following actions are permitted:
		<ul>
		<xsl:apply-templates select="../owl:ObjectPropertyAssertion[substring-after(owl:ObjectProperty/@IRI,'#')='permitsAction' and substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$ind]"/>
		</ul>
provided that the following Facts hold:
		<ul>
		<xsl:apply-templates select="../owl:ObjectPropertyAssertion[substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired' and substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$ind]"/>
		</ul>
		<!--ul>
		<xsl:apply-templates select="../owl:NegativeObjectPropertyAssertion[substring-after(owl:ObjectProperty/@IRI,'#')='hasRequired' and substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$ind]"/>
		</ul-->
	</xsl:when>
	<xsl:when test="$class = 'FactIntersection'">
<li><p>Case: <b><xsl:value-of select="$ind"/></b> - 
It is required that all of the following Facts hold:
<ul>
		<xsl:apply-templates select="../owl:ObjectPropertyAssertion[substring-after(owl:ObjectProperty/@IRI,'#')='hasFact' and substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$ind]"/>
</ul>
</p></li>
	</xsl:when>
	<xsl:when test="$class = 'FactUnion'">
<li><p>
It is required that at least one of the following Facts holds:
<ol>
		<xsl:apply-templates select="../owl:ObjectPropertyAssertion[substring-after(owl:ObjectProperty/@IRI,'#')='hasFact' and substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$ind]"/>
</ol>
</p></li>
	</xsl:when>
	<xsl:when test="$class = 'CommunicationToThePublic' or $class = 'PublicPerformance' or $class = 'Transform' or $class = 'Duplicate' or $class = 'Fixate' or $class = 'AudiovisualDistribute' or $class = 'ExploitIPRights' or $class = 'MakeCutAndEdit' or $class = 'MakeExcerpt'">
	<li><p><b><xsl:value-of select="$class"/></b> - when acted on the following items:<ul>
		<xsl:apply-templates select="../owl:ObjectPropertyAssertion[substring-after(owl:ObjectProperty/@IRI,'#')='actedOver' and substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$ind]"/>
	</ul>
	</p></li>
	</xsl:when>
	<xsl:when test="$class = 'Instance' or $class = 'IPEntity'">
	<li><p><b><xsl:value-of select="$ind"/></b> - which is the resource identified with <b>
	<xsl:value-of select="../owl:DataPropertyAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=$ind]/owl:Literal/text()"/></b>
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Linear'">
	<li><p>The delivery modality is <b><xsl:value-of select="$class"/></b>, that is the simultaneous delivery of audiovisual contents by a media service provider to many end users, on the basis of a programme schedule.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Broadcasting'">
	<li><p>The delivery modality is <b><xsl:value-of select="$class"/></b>, that is the Linear delivery of audiovisual content via BroadcastDeliveryTechnology.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Simultaneous'">
	<li><p>The delivery modality is <b><xsl:value-of select="$class"/></b>, that is any delivery of the audiovisual content simultaneously and unmodified with respect to the television broadcast of the same content.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'RTSimultaneous'">
	<li><p>The delivery modality is <b><xsl:value-of select="$class"/></b>, that is the Simultaneous delivery of the content via BroadcastDeliveryTechnology.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Simulcasting'">
	<li><p>The delivery modality is <b><xsl:value-of select="$class"/></b>, that is the Simultaneous delivery of the content via Internet or MobileTelecommunicationTechnology.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'TimeShifting'">
	<li><p>The delivery modality is <b><xsl:value-of select="$class"/></b>, that is the delivery of the same audiovisual content by multiple regularly time-staggered trasmissions.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Webcasting'">
	<li><p>The delivery modality is <b><xsl:value-of select="$class"/></b>, that is the delivery of audio-visual contents by streaming modality via Internet.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'NonLinear'">
	<li><p>The delivery modality is <b><xsl:value-of select="$class"/></b>, that is the delivery of audiovisual contents by a media service provider
for the view at the moment chosen by the end user and at his individual request on the basis of a catalogue of programmes selected by the media service provider.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Restricted'">
	<li><p>The service access policy is <b><xsl:value-of select="$class"/></b>, that is the service is provided only to customers who have obtained an approval by the service provider. 
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Open'">
	<li><p>The service access policy is <b><xsl:value-of select="$class"/></b>, that is the service is provided to all consumers without the need for approval by the service provider. This condition is independent from the policy of access that could be free of charge or pay.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Limited'">
	<li><p>The user time access is <b><xsl:value-of select="$class"/></b>, that is limited availability over time of the content for the access by the end user (e.g rental).
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Unlimited'">
	<li><p>The user time access is <b><xsl:value-of select="$class"/></b>, that is unlimited availability over time of the content for the access by the end user.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'FreeOfCharge'">
	<li><p>The access policy is <b><xsl:value-of select="$class"/></b>, that is no payment is required for access, within the execution of the action.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Pay'">
	<li><p>The access policy is <b><xsl:value-of select="$class"/></b>, that is a payment in any form is required for access, within the execution of the action.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'PayPerView'">
	<li><p>The access policy is <b><xsl:value-of select="$class"/></b>, that is the execution of the action requires a payment by the final user on a per-exhibition basis.  Audio-visual contents are delivered at a time scheduled by the service provider, by continuous exhibition.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Subscription'">
	<li><p>The access policy is <b><xsl:value-of select="$class"/></b>, that is the execution of the action requires a payment of a subscription fee by the final user. Audio-visual contents are streamed or downloaded.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Run'">
	<li><p>The exploitation is constrained to  <b><xsl:value-of select="$class"/></b>, that is the action can be executed at most
	<xsl:value-of select="../owl:DataPropertyAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=$ind]/owl:Literal/text()"/>
	times.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Language'">
	<li><p>The exploitation is constrained to  <b><xsl:value-of select="$class"/></b>, that is the IP language of IP-Entity object of the action must be 
	<xsl:value-of select="../owl:DataPropertyAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=$ind]/owl:Literal/text()"/>
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'SpatialContext'">
	<li><p>The exploitation is constrained to  <b><xsl:value-of select="$class"/></b>, that is the action can be executed only within the territory identified by the following country codes: 
	<xsl:value-of select="../owl:DataPropertyAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=$ind]/owl:Literal/text()"/>
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'TemporalContext'">
	<li><p>The exploitation is constrained to  <b><xsl:value-of select="$class"/></b>, that is the action can be executed only within the time period identified as follows:<br/>
	<xsl:variable name="ad"><xsl:value-of select="../owl:DataPropertyAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=$ind and substring-after(owl:DataProperty/@IRI,'#')='afterDate']/owl:Literal/text()"/></xsl:variable>
	<xsl:variable name="bd"><xsl:value-of select="../owl:DataPropertyAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=$ind and substring-after(owl:DataProperty/@IRI,'#')='beforeDate']/owl:Literal/text()"/></xsl:variable>
	<xsl:if test="$ad != ''">
		after: <xsl:value-of select="$ad"/>
		<br/>
	</xsl:if>
	<xsl:if test="$bd != ''">
		before: <xsl:value-of select="$bd"/>
	</xsl:if>
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'BroadcastTechnology'">
	<li><p>The technology used for the transmission of audiovisual content to end users is restricted to  <b><xsl:value-of select="$class"/></b>, that is the means are restricted to a point-to-multipoint technology.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'MobileTechnology'">
	<li><p>The technology used for the transmission of audiovisual content to end users is restricted to  <b><xsl:value-of select="$class"/></b>, that is the means are restricted to any technology which enables reception while the user is in motion for viewing a MobileDevice.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Internet'">
	<li><p>The technology used for the transmission of audiovisual content to end users is restricted to  <b><xsl:value-of select="$class"/></b>, that is the means are restricted to TCP/IP software protocols or any equivalent protocol.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Radio'">
	<li><p>The technology used for the transmission of audiovisual content to end users is restricted to  <b><xsl:value-of select="$class"/></b>, that is the means are restricted to Radio.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Videogram'">
	<li><p>The technology used for the transmission of audiovisual content to end users is restricted to  <b><xsl:value-of select="$class"/></b>, that is the means are restricted to any form of videocassettes, cartridges, tape, video discs, laser discs, any form of DVD, DVD ROM, internet access ready DVDs, CDi, CD-ROM, UMD, VCD or any other format.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Cable'">
	<li><p>The specific technology used for the transmission of audiovisual content to end users is restricted to  <b><xsl:value-of select="$class"/></b>, that is the means are restricted to any BroadcastTechnology which makes use of co-axial and/or fibre optic cable for direct reception by a TelevisionSet. It does not include DSL or other Internet or Ip-based networks.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'IPNetwork'">
	<li><p>The specific technology used for the transmission of audiovisual content to end users is restricted to  <b><xsl:value-of select="$class"/></b>, that is the means are restricted to any BroadcastTechnology which makes use of a DSL (including ADSL) or Ip-based network, excluding Internet.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Satellite'">
	<li><p>The specific technology used for the transmission of audiovisual content to end users is restricted to  <b><xsl:value-of select="$class"/></b>, that is the means are restricted to any BroadcastTechnology which makes use of a geostationary satellite system.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Terrestrial'">
	<li><p>The specific technology used for the transmission of audiovisual content to end users is restricted to  <b><xsl:value-of select="$class"/></b>, that is the means are restricted to any BroadcastTechnology which makes use of a terrestrial television transmitter.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'Computer'">
	<li><p>The device is restricted to  <b><xsl:value-of select="$class"/></b> equipment.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'MobileDevice'">
	<li><p>The device is restricted to  <b><xsl:value-of select="$class"/></b>, that is any portable equipment capable of receiving transmissions while the user is in motion, made by means of a MobileTechnology. 
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'MobileBroadcastDevice'">
	<li><p>The device is restricted to  <b><xsl:value-of select="$class"/></b>, that is any MobileDevice capable of receiving transmissions by means of MobileBroadcastTechnology.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'MobileTelecommunicationDevice'">
	<li><p>The device is restricted to  <b><xsl:value-of select="$class"/></b>, that is any MobileDevice capable of receiving transmissions by means of MobileTelecommunicationTechnology.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'StorageDevice'">
	<li><p>The device is restricted to  <b><xsl:value-of select="$class"/></b>, that is any device with storage capabilities, allowing the user to keep and reuse the content saved locally.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'TelevisionDevice'">
	<li><p>The device is restricted to  <b><xsl:value-of select="$class"/></b>, that is any equipment with television functionalities.
	</p>
	</li>
	</xsl:when>
	<xsl:when test="$class = 'TelevisionSet'">
	<li><p>The device is restricted to  <b><xsl:value-of select="$class"/></b>, that is any TelevisionDevice, excluding MobileBroadcastDevice.
	</p>
	</li>
	</xsl:when>
	<xsl:otherwise>
unsupported text conversion for <xsl:value-of select="$class"/>
	</xsl:otherwise>
</xsl:choose>
<!--xsl:apply-templates select="../owl:ObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$ind]"/>
<xsl:apply-templates select="../owl:NegativeObjectPropertyAssertion[substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')=$ind]"/>
<xsl:apply-templates select="../owl:DataPropertyAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=$ind]"/-->
</xsl:template>

<xsl:template match="owl:ObjectPropertyAssertion">
	<xsl:variable name="arc"><xsl:value-of select="substring-after(owl:ObjectProperty/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="first"><xsl:value-of select="substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="second"><xsl:value-of select="substring-after(owl:NamedIndividual[position()=2]/@IRI,'#')"/></xsl:variable>
	<xsl:apply-templates select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=$second]" />
</xsl:template>

<xsl:template match="owl:NegativeObjectPropertyAssertion">
	<xsl:variable name="arc"><xsl:value-of select="substring-after(owl:ObjectProperty/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="first"><xsl:value-of select="substring-after(owl:NamedIndividual[position()=1]/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="second"><xsl:value-of select="substring-after(owl:NamedIndividual[position()=2]/@IRI,'#')"/></xsl:variable>
	<xsl:apply-templates select="../owl:ClassAssertion[substring-after(owl:NamedIndividual/@IRI,'#')=$second]" />
</xsl:template>

<xsl:template match="owl:DataPropertyAssertion">
	<xsl:variable name="key"><xsl:value-of select="substring-after(owl:DataProperty/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="value"><xsl:value-of select="owl:Literal/text()"/></xsl:variable>
	<xsl:variable name="owner"><xsl:value-of select="substring-after(owl:NamedIndividual/@IRI,'#')"/></xsl:variable>
	<xsl:variable name="label">label="<xsl:value-of select="$key"/>=<xsl:value-of select="$value"/>"</xsl:variable>
<xsl:if test="$key != '' and $value != ''">
	<xsl:value-of select="$value"/>
</xsl:if>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
