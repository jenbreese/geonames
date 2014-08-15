<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xdmp="http://makrlogic.com/xdmp"
  xmlns="http://geonames.org/admin2Code"
  xpath-default-namespace="http://geonames.org/admin2Code"
  exclude-result-prefixes="fn xdmp">

  <xsl:output method="xml" indent="yes" />

  <xsl:template match="/admin2">
    <admin2>
      <country-code><xsl:value-of select="fn:tokenize(//admin2-code/text(), '\.')[1]" /></country-code>
      <admin1-code><xsl:value-of  select="fn:tokenize(//admin2-code/text(), '\.')[2]" /></admin1-code> 
      <admin2-code><xsl:value-of select="fn:tokenize(//admin2-code/text(), '\.')[3]" /></admin2-code>
      <name tag="main"><xsl:value-of select="name/text()" /></name>
      <name tag="ascii"><xsl:value-of select="asciiname/text()" /></name>
      <xsl:copy-of select="geonamesid" />
    </admin2>
  </xsl:template>

</xsl:stylesheet>
