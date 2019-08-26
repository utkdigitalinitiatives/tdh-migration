<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:cob="http://canofbees.org/xslt"
                exclude-result-prefixes="#all"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xpath-default-namespace="tei"
                version="2.0">

  <!--
    The migration data are full of oddly-used @cert attributes, most of which point to the appearance of
    physical/original document.

    This stylesheet aims to correct that by adding a <tagDecl> element to the teiHeader, providing static,
    per-document values for these descriptive attributes.
  -->

  <xsl:template name="create-tagsdecl">
    <tagsDecl partial="true">

    </tagsDecl>
  </xsl:template>

</xsl:stylesheet>