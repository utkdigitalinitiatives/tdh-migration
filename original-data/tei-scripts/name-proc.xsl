<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:cob="http://canofbees.org/xslt/"
  xmlns:file="http://expath.org/ns/file"
  exclude-result-prefixes="cob file xs"
  version="2.0">
  
  <xsl:variable name="remediated" select="doc('./remediated-tdh-names.xml')"/>
  <xsl:variable name="curr-file" select="substring-before(file:name(base-uri(.)), '.xml')" as="xs:string"/>
  
  <xsl:template name="name-proc">
    <xsl:variable name="record" select="$remediated/csv/record[lower-case(headeridentifier) = $curr-file]"/>
        
    <xsl:for-each select="$record/creator.0 | $record/creator.1 | $record/creator.2 | $record/creator.3 | $record/dc_creator | $record/dc.creator1 | $record/dc.creator2 | $record/dc.creator3 | $record/dc.creator4 | $record/dc.creator5 | $record/dc.creator6 | $record/dc.creator7 | $record/dc.creator8">
      <xsl:variable name="curr-node" select="if (name(.)[matches(., 'dc_creator')]) then 'dc.creator' else name(.)"/>
      <term xmlns="http://www.tei-c.org/ns/1.0">
        <name>
          <xsl:if test="following-sibling::*[name(.) = concat($curr-node, '_URI')]">
            <xsl:attribute name="ref" select="following-sibling::*[name(.) = concat($curr-node, '_URI')]"/>
          </xsl:if>
          <xsl:if test="following-sibling::*[name(.) = concat($curr-node, '_role1_Term')]">
            <xsl:attribute name="role" select="concat(
                following-sibling::*[name(.) = concat($curr-node, '_role1_Term')],
                ' ',
                following-sibling::*[name(.) = concat($curr-node, '_role1_Term_URI')]
              )"/>
          </xsl:if>
          <xsl:value-of select="."/>
        </name>
      </term>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>