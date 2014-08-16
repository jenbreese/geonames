<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xdmp="http://makrlogic.com/xdmp"
  xmlns:cts="http://marklogic.com/cts"
  xmlns:gml="http://www.opengis.net/gml"
  xmlns="http://geonames.org"
  xpath-default-namespace="http://geonames.org"
  exclude-result-prefixes="fn xdmp cts">

  <xsl:output method="xml" indent="yes" />

  <xsl:param name="feature" />
  <xsl:param name="admin1-code" />
  <xsl:param name="admin2-code" />

  <xsl:template match="/feature">
    <geoname>
      <id><xsl:value-of select="geonameid/text()" /></id>
      <names>
        <name tag="main"><xsl:value-of select="name/text()" /></name>
        <name tag="ascii"><xsl:value-of select="asciiname/text()" /></name>
        <xsl:for-each select="fn:tokenize(//alternatenames/text(), ',')">
          <name tag="alternate"><xsl:value-of select="." /></name>
        </xsl:for-each>
      </names>
      <gml:Point srsDimension="2">
        <gml:pos><xsl:value-of select="latitude/text()" /><xsl:text> </xsl:text><xsl:value-of select="longitude/text()" /></gml:pos>
      </gml:Point>
      <xsl:copy-of select="$feature" />
      <xsl:copy-of select="country-code" />
      <xsl:copy-of select="cc2" />
      <xsl:choose>
        <xsl:when test="fn:not($admin1-code)">
          <admin1-code />       
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$admin1-code" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="fn:not($admin2-code)">
          <admin2-code />       
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$admin2-code" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:copy-of select="admin3-code" />
      <xsl:copy-of select="admin4-code" />
      <xsl:copy-of select="population" />
      <xsl:copy-of select="elevation" />
      <digital-elevation-model><xsl:value-of select="dem/text()" /></digital-elevation-model>
      <xsl:copy-of select="timezone" />
      <xsl:copy-of select="modification-date" />
      <cts:or-query>
      	<cts:word-query>
        	<cts:text><xsl:value-of select="name/text()" /></cts:text>
        	<cts:option>exact</cts:option>
      	</cts:word-query>
      	<!-- 
      	<xsl:for-each select="fn:tokenize(//alternatenames/text(), ',')">
          <cts:word-query>
          	<cts:text><xsl:value-of select="." /></cts:text>
          	<cts:option>exact</cts:option>
          </cts:word-query>
        </xsl:for-each>
        -->
      </cts:or-query>
    </geoname>
  </xsl:template>

</xsl:stylesheet>
