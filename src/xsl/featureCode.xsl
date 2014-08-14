<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xdmp="http://makrlogic.com/xdmp"
  xmlns="http://geonames.org/featureCodes"
  xpath-default-namespace="http://geonames.org/featureCodes"
  exclude-result-prefixes="fn xdmp">

  <xsl:output method="xml" indent="yes" />

  <xsl:template match="/feature-code">
    <feature-code>
      <feature-class><xsl:value-of select="fn:tokenize(/feature-code/feature-code/text(), '\.')[1]" /></feature-class>
      <feature-code><xsl:value-of select="fn:tokenize(/feature-code/feature-code/text(), '\.')[2]" /></feature-code>
      <xsl:copy-of select="name" />
      <xsl:copy-of select="description" />
    </feature-code>
  </xsl:template>

</xsl:stylesheet>
