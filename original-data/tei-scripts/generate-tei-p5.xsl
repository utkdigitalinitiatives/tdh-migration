<?xml version="1.0"?>
<xsl:stylesheet xmlns:edate="http://exslt.org/dates-and-times"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:cob="http://canofbees.org/xslt/"
  xmlns:file="http://expath.org/ns/file"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="tei edate cob file xs" version="2.0">
  
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  
  <xsl:include href="p4top5.xsl"/>
  <xsl:include href="pb-proc.xsl"/>
  <xsl:include href="date-proc.xsl"/>
  
  <xsl:variable name="current-file" select="substring-before(file:name(base-uri(.)), '.xml')" as="xs:string"/>
  <xsl:variable name="file-prefix" select="cob:ssbm($current-file, '[0-9]')" as="xs:string"/>
  <xsl:variable name="output-path" select="'../../migrated-data/tei-p5/'"/>
  
  
  
</xsl:stylesheet>