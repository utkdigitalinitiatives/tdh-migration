<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:cob="http://canofbees.org/xslt/"
                exclude-result-prefixes="xs"
                version="2.0">

  <xsl:output encoding="UTF-8"/>

  <!--
    Returns either a) a correctly formatted TEI date value or b) the original @when value
    with '-non-matching-string' appended to the value.

    The vast majority of our dates follow a regular pattern, but some break from it (e.g.
    00-00-0000, 0000-08-027, or 0000-04/05-00. Fix those by hand.
  -->

  <xsl:function name="cob:date-proc" as="item()*">
    <xsl:param name="date" as="xs:string"/>

    <xsl:analyze-string select="$date" regex="^(\d{{4}})-(\d{{2}})-(\d{{2}})$">
      <xsl:matching-substring>
        <xsl:variable name="year" select="if (regex-group(1) = '0000') then '' else regex-group(1)"/>
        <xsl:variable name="month" select="if (regex-group(2) = '00') then '' else regex-group(2)"/>
        <xsl:variable name="day" select="if (regex-group(3)= '00') then '' else regex-group(3)"/>
        <xsl:choose>
          <!-- e.g. 0000-00-00 = [n.d.] -->
          <xsl:when test="$year = '' and $month = '' and $day = ''">
            <xsl:value-of select="'[n.d.]'"/>
          </xsl:when>
          <!-- e.g. 1795-00-00 = 1795 (YYYY) -->
          <xsl:when test="$year != '' and $month = '' and $day = ''">
            <xsl:value-of select="$year"/>
          </xsl:when>
          <!-- e.g. 1795-05-00 = 1795-05 (YYYY-MM) -->
          <xsl:when test="$year != '' and $month != '' and $day = ''">
            <xsl:value-of select="concat($year, '-', $month)"/>
          </xsl:when>
          <!-- e.g. 0000-05-00 = -\-05 (-\-MM) -->
          <xsl:when test="$year = '' and $month != '' and $day = ''">
            <xsl:value-of select="concat('--', $month)"/>
          </xsl:when>
          <!-- e.g. 1795-05-01 = 1795-05-01 (YYYY-MM-DD) -->
          <xsl:when test="$year != '' and $month != '' and $day != ''">
            <xsl:value-of select="concat($year, '-', $month, '-', $day)"/>
          </xsl:when>
          <!-- e.g. 0000-05-01 = -\-05-01 (-\-MM-DD) -->
          <xsl:when test="$year = '' and $month != '' and $day != ''">
            <xsl:value-of select="concat('--', $month, '-', $day)"/>
          </xsl:when>
          <!-- e.g. 0000-00-01 = -\-\-01 (-\-\-DD) -->
          <xsl:when test="$year = '' and $month = '' and $day != ''">
            <xsl:value-of select="concat('---', $day)"/>
          </xsl:when>
        </xsl:choose>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="concat(., '-non-matching-substring')"/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>


</xsl:stylesheet>