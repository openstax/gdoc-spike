<!-- XSLT to change links to be relative -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="@href">
  <xsl:attribute name="href">
    <xsl:call-template name="link-rewriter"/>
  </xsl:attribute>
</xsl:template>

<!-- <xsl:template match="@src">
  <xsl:attribute name="src">
    <xsl:call-template name="link-rewriter"/>
  </xsl:attribute>
</xsl:template> -->

<xsl:template name="link-rewriter">
  <xsl:choose>
    <xsl:when test="starts-with(., '#')">
      <!-- <xsl:message>skipping <xsl:value-of select="."/></xsl:message> -->
      <xsl:value-of select="."/>
    </xsl:when>
    <xsl:when test="starts-with(., 'https://archive.cnx.org')">
      <xsl:variable name="len" select="string-length(.)"/>
      <xsl:variable name="new" select="substring(., 25, $len - 1)"/>
      <xsl:message>converting1 <xsl:value-of select="."/> to <xsl:value-of select="$new"/></xsl:message>
      <xsl:text>https://cnx.org/</xsl:text>
      <xsl:value-of select="$new"/>
    </xsl:when>
    <xsl:when test="starts-with(., './')">
      <xsl:variable name="len" select="string-length(.)"/>
      <xsl:variable name="new" select="substring(., 3, $len - 1)"/>
      <!-- <xsl:message>converting1 <xsl:value-of select="."/> to <xsl:value-of select="$new"/></xsl:message> -->
      <xsl:text>https://cnx.org/contents/</xsl:text>
      <xsl:value-of select="$new"/>
    </xsl:when>

    <xsl:when test="starts-with(., 'http')">
      <!-- <xsl:message>skipping <xsl:value-of select="."/></xsl:message> -->
      <xsl:value-of select="."/>
    </xsl:when>
    <xsl:otherwise>
      <!-- <xsl:message>converting2 <xsl:value-of select="."/></xsl:message> -->
      <xsl:text>https://cnx.org/contents/</xsl:text>
      <xsl:value-of select="."/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

</xsl:stylesheet>