<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:cob="http://canofbees.org/xslt/"
  xmlns:file="http://expath.org/ns/file"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <xsl:output method="xml"/>

  <!--
    Take @n from a pb, and the current file name. Generate some comprehensible values
    for our attributes from these.
    
    $number = pb/@n
    $file-name = the current TEI filename, processed; e.g. 'ch001'
    $image-path = the file path to where the test images are being kept
  -->
  
  <xsl:function name="cob:pb-proc" as="item()*">
    <xsl:param name="number" as="xs:string"/>
    <xsl:param name="file-name" as="xs:string"/>
    <xsl:param name="image-path" as="xs:string"/>
    <!--
      TODO param for sequence of available images?
      TODO function for cleaning up @n values
    -->
    
    <xsl:variable name="num-proc" select="substring-before(substring-after($number, '['), ']')"/>    
    
  </xsl:function>
  
  <xsl:function name="cob:num-proc" as="item()*">
    <xsl:param name="number" as="xs:string"/>
    
    <!--<xsl:analyze-string select="$number" regex="[(\d{{1,}})]([[:alnum:]\s+])"></xsl:analyze-string>-->
  </xsl:function>
</xsl:stylesheet>