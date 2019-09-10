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
    $returns = an xs:item()
  -->
  <xsl:function name="cob:pb-proc" as="item()*">
    <xsl:param name="number" as="xs:integer"/>
    <xsl:param name="file-name" as="xs:string"/>
    <xsl:param name="image-path" as="xs:string"/>
    
    <!-- note: we'll hope/assume that @n is correct in terms of position -->
    <xsl:variable name="file-prefix" select="cob:ssbm($file-name, '[0-9]')"/>
    <xsl:variable name="image-list" as="item()*">
      <xsl:for-each select="file:list(concat($image-path, $file-prefix, '/', $file-name, '/figures/'))">
        <xsl:sort select="." order="ascending"/>
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:sequence select="$image-list[position() = $number]"/>    
  </xsl:function>
  
  <!-- 
    A function to extract digits from pb/@n. 
    
    $number = an xs:string
    $returns = an xs:item()
  -->
  <xsl:function name="cob:num-proc" as="xs:integer">
    <xsl:param name="number" as="xs:string"/>
    
    <xsl:analyze-string select="string($number)" regex="^(.*)\[(\d{{1,}})\](.*)$" >
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(2)"/>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:analyze-string select="normalize-space(.)" regex="^(\d{{1,}})(.*)$">
          <xsl:matching-substring>
            <xsl:value-of select="regex-group(1)"/>
          </xsl:matching-substring>
        </xsl:analyze-string>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>
  
  <!-- 
    Thank you, Ms. Walmsley! 
    Borrowed from http://www.xsltfuctions.com/xsl/functx_substring-before-match.html
  -->
  <xsl:function name="cob:ssbm" as="xs:string">
    <xsl:param name="arg" as="xs:string"/>
    <xsl:param name="regex" as="xs:string"/>
    
    <xsl:sequence select="tokenize($arg, $regex)[1]"/>
  </xsl:function>
</xsl:stylesheet>