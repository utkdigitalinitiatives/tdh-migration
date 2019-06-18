<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml"/>
    <!-- collection() to grab documents -->
    <xsl:variable name="docs" select="collection('file:///usr/home/bridger/Documents/tdh-test/all-tdh/?select=*.xml;recurse=yes;on-error=warn')"/>
    
    <xsl:template name="main">
        <xsl:result-document href="tdh-catalog.xml" indent="yes">
            <catalog>
                <xsl:for-each select="$docs">
                    <doc href="{substring-after(document-uri(.), 'tdh-test/')}"/><xsl:value-of select="'&#10;'"/>
                </xsl:for-each>
            </catalog>
        </xsl:result-document>    
    </xsl:template>
</xsl:stylesheet>