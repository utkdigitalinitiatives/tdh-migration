<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- 
    Generate a catalog file for our oXygen-based transform. This helps alleviate some 
    of the slowness from a project-based transform. See https://www.oxygenxml.com/forum/topic15257.html
  -->
  
  <xsl:output method="xml"/>
  <!-- collection() to grab documents -->
  <xsl:variable name="current-path" select="static-base-uri()" as="xs:string"/>
  <xsl:variable name="tei-path" select="substring-before($current-path, 'tei-scripts')" as="xs:string"/>
  <xsl:variable name="docs" select="collection(concat($tei-path, 'tei/?select=*.xml;recurse=yes;on-error=warn'))"/>
  
  <xsl:template name="main">
    <xsl:result-document href="tei-catalog.xml" indent="yes">
      <catalog>
        <xsl:for-each select="$docs">
          <doc href="{concat('..', substring-after(document-uri(.), 'original-data'))}"/><xsl:value-of select="'&#10;'"/>
        </xsl:for-each>
      </catalog>
    </xsl:result-document>    
  </xsl:template>
</xsl:stylesheet>