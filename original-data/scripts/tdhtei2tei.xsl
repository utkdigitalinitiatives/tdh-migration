<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <!-- identity transform & fixes for TDH tei -->
    <!-- attempt #1 -->
    <xsl:output method="xml" indent="yes" encoding="UTF-8"
        doctype-system="http://diglib.lib.utk.edu/dlc/standards/dtds/teixlite.dtd"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="pb">
        <xsl:element name="pb">
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="n">
                <xsl:value-of select="@n"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
