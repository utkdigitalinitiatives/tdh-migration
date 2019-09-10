<?xml version="1.0"?>
<xsl:stylesheet xmlns:edate="http://exslt.org/dates-and-times"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:cob="http://canofbees.org/xslt/"
  xmlns:file="http://expath.org/ns/file"
  xmlns:saxon="http://saxon.sf.net/"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="tei edate cob file saxon xs" version="2.0">
  
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  
  <xsl:include href="pb-proc.xsl"/>
  
  <xsl:variable name="current-file" select="substring-before(file:name(base-uri(.)), '.xml')" as="xs:string"/>
  <xsl:variable name="file-prefix" select="cob:ssbm($current-file, '[0-9]')" as="xs:string"/>
  <xsl:variable name="output-path" select="'../../migrated-data/tei-p5/'" as="xs:string"/>
  
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@href">
    <xsl:for-each select="document(.,/)">
      <xsl:result-document href="{concat($output-path, $file-prefix, '/', $current-file, '.xml')}">
      
      </xsl:result-document>  
    </xsl:for-each>
  </xsl:template>
  
  
  
</xsl:stylesheet>