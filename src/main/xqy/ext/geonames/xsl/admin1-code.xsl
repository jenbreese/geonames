<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xdmp="http://makrlogic.com/xdmp"
  xmlns="http://geonames.org/admin1Code"
  xpath-default-namespace="http://geonames.org/admin1Code"
  exclude-result-prefixes="fn xdmp">

  <xsl:output method="xml" indent="yes" />

  <xsl:template match="/admin1Code">
    <admin1-code>
      <code><xsl:copy-of select="admin1_code/text()" /></code>
      <country-code><xsl:value-of select="fn:tokenize(//admin1_code/text(),'\.')[1]" /></country-code>
      <code-id><xsl:value-of select="fn:tokenize(//admin1_code/text(), '\.')[2]" /></code-id>
      <name tag="main"><xsl:value-of select="name/text()" /></name>
      <name tag="ascii"><xsl:value-of select="asciiname/text()" /></name>
      <xsl:copy-of select="geonamesid" />
    </admin1-code>
  </xsl:template>

</xsl:stylesheet>
