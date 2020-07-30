<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="*[@data-type='note']">
  <xsl:call-template name="wrapper">
    <xsl:with-param name="label">NOTE</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="*[@data-type='example']">
  <xsl:call-template name="wrapper">
    <xsl:with-param name="label">EXAMPLE</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="*[@data-type='exercise']">
  <xsl:call-template name="wrapper">
    <xsl:with-param name="label">EXERCISE</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="wrapper">
  <xsl:param name="label"/>

  <p><xsl:value-of select="$label"/></p>
  <hr/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  <hr/>
</xsl:template>

</xsl:stylesheet>