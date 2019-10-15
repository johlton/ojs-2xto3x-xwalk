<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:ns2="http://www.w3.org/1999/xlink" xmlns:local="http://www.yoursite.org/namespace"
                xmlns="http://pkp.sfu.ca" version="1.0">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="article">
    <article>
      <xsl:apply-templates select="title | permissions | indexing/subject"/>
      <xsl:if test="count(author) !=0">
        <authors>
          <xsl:apply-templates select="author" />
        </authors>
      </xsl:if>
    </article>
  </xsl:template>

  <xsl:template match="title">
    <title>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates />
    </title>
  </xsl:template>

  <xsl:template match="author">
    <author>
      <xsl:copy-of select="@*" />
      <xsl:if test="string-length(firstname)">
        <givenname><xsl:value-of select="firstname" /></givenname>
      </xsl:if>
      <xsl:if test="string-length(lastname)">
        <familyname><xsl:value-of select="lastname" /></familyname>
      </xsl:if>
      <xsl:apply-templates select="affiliation | country | email" mode="copy"/>
    </author>
  </xsl:template>

  <xsl:template match="indexing/subject">
    <keywords>
      <xsl:copy-of select="@*" />
      <xsl:call-template name="keywords">
        <xsl:with-param name="subjectString" select="text()" />
      </xsl:call-template>
    </keywords>
  </xsl:template>

  <xsl:template name="keywords">
    <xsl:param name="subjectString" />
    <keyword>
      <xsl:choose>
        <xsl:when test="contains($subjectString, ';')">
          <xsl:value-of select="substring-before($subjectString, ';')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$subjectString" />
        </xsl:otherwise>
      </xsl:choose>
    </keyword>
    <xsl:if test="string-length(substring-after($subjectString, ';')) != 0">
      <xsl:call-template name="keywords">
        <xsl:with-param name="subjectString" select="substring-after($subjectString, ';')" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="license_url">
    <licenseUrl>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates />
    </licenseUrl>
  </xsl:template>

  <xsl:template match="copyright_holder">
    <copyrightHolder>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates />
    </copyrightHolder>
  </xsl:template>

    <xsl:template match="copyright_year">
    <copyrightYear>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates />
    </copyrightYear>
  </xsl:template>

  <xsl:template match="permissions">
      <xsl:apply-templates select="license_url | copyright_holder | *"/>
  </xsl:template>

  <xsl:template match="*" mode="copy">
    <xsl:element name="{name()}" namespace="http://pkp.sfu.ca">
      <xsl:copy-of select="@*" />
      <xsl:apply-templates select="node()" mode="copy" />
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>