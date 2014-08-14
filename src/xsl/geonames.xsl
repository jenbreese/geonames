<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xdmp="http://makrlogic.com/xdmp"
  xmlns:gml="http://www.opengis.net/gml"
  xmlns="http://geonames.org"
  xpath-default-namespace="http://geonames.org"
  exclude-result-prefixes="fn xdmp">

  <xsl:output method="xml" indent="yes" />

  <xsl:param name="feature" />

  <xsl:template match="/feature">
    <geoname>
      <xsl:copy-of select="geonameid" />
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
      <xsl:copy-of select="countrycode" />
      <xsl:copy-of select="cc2" />
      <xsl:copy-of select="admin1-code" />
      <xsl:copy-of select="admin2-code" />
      <xsl:copy-of select="admin3-code" />
      <xsl:copy-of select="admin4-code" />
      <xsl:copy-of select="population" />
      <xsl:copy-of select="elevation" />
      <digital-elevation-model><xsl:value-of select="dem/text()" /></digital-elevation-model>
      <xsl:copy-of select="timezone" />
      <xsl:copy-of select="modification-date" />
    </geoname>
  </xsl:template>

</xsl:stylesheet>
