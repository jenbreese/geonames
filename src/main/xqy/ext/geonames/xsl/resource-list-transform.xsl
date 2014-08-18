<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rapi="http://marklogic.com/rest-api"
  xmlns:xdmp="http://marklogic.com/xdmp" extension-element-prefixes="xdmp">

  <xsl:template match="/rapi:Config">
    <html xmlns="">
      <head>
        <meta charset="utf-8"></meta>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"></meta>
        <meta name="viewport" content="width=device-width, initial-scale=1"></meta>
        <title>Geonames API Documentation</title>
        <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"></link>
        <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css"></link>
      </head>
      <body class="container">
        <div class="page-header">
          <h1>Geonames API Documentation</h1>
        </div>
        <ul class="nav nav-pills">
          <li class="active">
            <a href="#services" data-toggle="tab">Services</a>
          </li>
          <li>
            <a href="#query" data-toggle="tab">Query Options</a>
          </li>
        </ul>
        <div class="tab-content">
          <xsl:apply-templates select="rapi:resources" />
        </div>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <script src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="rapi:query-options">
    <div class="tab-pane active" id="services" xmlns="">
      <div class="row">
        Query options coming soon here..
      </div>
    </div>
  </xsl:template>

  <xsl:template match="rapi:resources">
    <div class="tab-pane active" id="services" xmlns="">
      <div class="row">
        <div class="col-md-3">
          <div class="affix" role="complementary">
            <ul class="nav">
              <xsl:for-each select="rapi:resource">
                <xsl:sort select="rapi:title" />
                <li>
                  <a href="#resource-{position()}">
                    <xsl:value-of select="rapi:title" />
                  </a>
                </li>
              </xsl:for-each>
            </ul>
          </div>
        </div>
        <div class="col-md-9">
          <xsl:for-each select="rapi:resource">
            <xsl:sort select="rapi:title" />
            <div id="resource-{position()}" class="panel panel-default">
              <div class="panel-heading">
                <h3 class="panel-title">
                  <a data-toggle="collapse" href="#collapse-resource-{position()}">
                    <xsl:value-of select="rapi:title" />
                  </a>
                </h3>
              </div>
              <div id="collapse-resource-{position()}" class="panel-collapse collapse in">
                <div class="panel-body">
                  <xsl:copy-of select="xdmp:unquote(concat('&lt;div&gt;', rapi:description, '&lt;/div&gt;'))" />
                  <xsl:for-each select="rapi:methods/rapi:method">
                    <h3>
                      <xsl:value-of select="rapi:method-name" />
                    </h3>
                    <xsl:if test="rapi:parameter">
                      <table class="table table-hover">
                        <thead>
                          <tr>
                            <th>Name</th>
                            <th>Type</th>
                          </tr>
                        </thead>
                        <tbody>
                          <xsl:for-each select="rapi:parameter">
                            <tr>
                              <td>
                                <xsl:value-of select="rapi:parameter-name" />
                              </td>
                              <td>
                                <xsl:value-of select="rapi:parameter-type" />
                              </td>
                            </tr>
                          </xsl:for-each>
                        </tbody>
                      </table>
                    </xsl:if>
                  </xsl:for-each>
                </div>
              </div>
            </div>
          </xsl:for-each>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="SAMPLE">
    <rapi:resources xmlns:rapi="http://marklogic.com/rest-api">
      <rapi:resource>
        <rapi:name>links</rapi:name>
        <rapi:source-format>xquery</rapi:source-format>
        <rapi:description>Resource for managing objects</rapi:description>
        <rapi:title>links resource extension</rapi:title>
        <rapi:methods>
          <rapi:method>
            <rapi:method-name>get</rapi:method-name>
            <rapi:parameter>
              <rapi:parameter-name>objectId</rapi:parameter-name>
              <rapi:parameter-type>xs:string</rapi:parameter-type>
            </rapi:parameter>
          </rapi:method>
          <rapi:method>
            <rapi:method-name>post</rapi:method-name>
            <rapi:parameter>
              <rapi:parameter-name>toObjectId</rapi:parameter-name>
              <rapi:parameter-type>xs:string</rapi:parameter-type>
            </rapi:parameter>
            <rapi:parameter>
              <rapi:parameter-name>fromObjectId</rapi:parameter-name>
              <rapi:parameter-type>xs:string</rapi:parameter-type>
            </rapi:parameter>
          </rapi:method>
        </rapi:methods>
        <rapi:resource-source>/v1/resources/links</rapi:resource-source>
      </rapi:resource>
    </rapi:resources>
  </xsl:template>
</xsl:stylesheet>