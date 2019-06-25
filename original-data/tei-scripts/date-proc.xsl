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

    <xsl:analyze-string select="$date" regex="(\d{{4}})-(\d{{2}})-(\d{{2}})">
      <xsl:matching-substring>
        <xsl:variable name="year" select="if (regex-group(1) = '0000') then '' else regex-group(1)"/>
        <xsl:variable name="month" select="if (regex-group(2) = '00') then '' else regex-group(2)"/>
        <xsl:variable name="day" select="if (regex-group(3)= '00') then '' else regex-group(3)"/>
        <xsl:value-of
            select="concat(
              if ($year = '') then '-' else concat($year, '-'),
              if ($month = '') then '-' else concat($month, '-'),
              if ($day = '') then '' else $day
            )"/>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="concat(., '-non-matching-substring')"/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>


</xsl:stylesheet>