<?xml version="1.0"?>
<xsl:stylesheet xmlns:edate="http://exslt.org/dates-and-times"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:cob="http://canofbees.org/xslt/"
  xmlns:file="http://expath.org/ns/file"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="tei edate cob file xs" version="2.0">
  <!-- 
       
       P4 to P5 converter 
       
       Sebastian Rahtz <sebastian.rahtz@oucs.ox.ac.uk>
       
       $Date: 2007-11-01 16:33:34 +0000 (Thu, 01 Nov 2007) $  $Id: p4top5.xsl 3927 2007-11-01 16:33:34Z rahtz $
       
       Copyright 2007 TEI Consortium
       
       Permission is hereby granted, free of charge, to any person obtaining
       a copy of this software and any associated documentation gfiles (the
       ``Software''), to deal in the Software without restriction, including
       without limitation the rights to use, copy, modify, merge, publish,
       distribute, sublicense, and/or sell copies of the Software, and to
       permit persons to whom the Software is furnished to do so, subject to
       the following conditions:
       
       The above copyright notice and this permission notice shall be included
       in all copies or substantial portions of the Software.


       Changes
       1. xsl:stylesheet @version from v1.0 to v2.0
       2. add xsl:output @indent='yes'
       3. add xsl:includes
         a. date-proc.xsl
       4. add a template for tei:add[@cert]
       5. add a template for tei:availability
       6. commented out today variable
       7. process name/@* appropriately
       8. process gap/@* appropriately
       9. ignore @cert values
       10. update pav.xml//@type='financial valuation' to 'valuation'; there are methods for
             handling this inside TEI (see https://tei-c.org/release/doc/tei-p5-doc/en/html/USE.html#MDMDAL)
             but I think that's beyond scope here.
       11.          
           
  -->
  
  <!-- 
    2. invalid date/@when; e.g. sl279, date/@when='1834-06-31'
    3. fix table element in pav.xml (hand edit)
    7. div/@type parsing :<
    
  -->
  
  <xsl:include href="date-proc.xsl"/>
  <!--<xsl:include href="tags-decl.xsl"/>-->
  <xsl:include href="pb-proc.xsl"/>
  <xsl:include href="name-proc.xsl"/>

  <xsl:output method="xml" encoding="UTF-8" indent="yes" cdata-section-elements="tei:eg"
    omit-xml-declaration="yes"/>

  <xsl:strip-space elements="*"/>

  <xsl:variable name="processor">
    <xsl:value-of select="system-property('xsl:vendor')"/>
  </xsl:variable>
  
  <!-- path to images on your local system -->
  <xsl:param name="image-path" select="''"/>
  <xsl:variable name="file-name" select="substring-before(file:name(base-uri(.)), '.xml')" as="xs:string"/>
  
  <!--
  <xsl:variable name="today">
    <xsl:choose>
      <xsl:when test="contains($processor, 'Saxonica')">
        <xsl:value-of select="current-date()"/>
      </xsl:when>
      <!-\-
      <xsl:when test="function-available('edate:date-time')">
        <xsl:value-of select="edate:date-time()"/>
      </xsl:when>
      <xsl:when test="contains($processor, 'SAXON')">
        <xsl:value-of select="Date:toString(Date:new())" xmlns:Date="/java.util.Date"/>
      </xsl:when>
      -\->
      <xsl:otherwise>0000-00-00</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  -->

  <xsl:variable name="uc">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="lc">abcdefghijklmnopqrstuvwxyz</xsl:variable>

  <xsl:template match="*">
    <xsl:choose>
      <xsl:when test="namespace-uri() = ''">
        <xsl:element namespace="http://www.tei-c.org/ns/1.0" name="{local-name(.)}">
          <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="@* | processing-instruction() | comment()">
    <xsl:copy/>
  </xsl:template>


  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>


  <!-- change of name, or replaced by another element -->
  <xsl:template match="teiCorpus.2">
    <teiCorpus xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
    </teiCorpus>
  </xsl:template>

  <xsl:template match="witness/@sigil">
    <xsl:attribute name="xml:id">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="witList">
    <listWit xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
    </listWit>
  </xsl:template>


  <xsl:template match="TEI.2">
    <xsl:processing-instruction name="xml-model">
      <xsl:text>href="http://diglib.lib.utk.edu/dlc/standards/tei/tei_lite_di_v4.rng"</xsl:text>
      <xsl:text> </xsl:text>
      <xsl:text>type="application/xml"</xsl:text>
      <xsl:text> </xsl:text>
      <xsl:text>schematypens="http://relaxng.org/ns/structure/1.0"</xsl:text>
    </xsl:processing-instruction>
    <xsl:text>&#10;</xsl:text>
    <TEI xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
    </TEI>
  </xsl:template>

  <xsl:template match="xref">
    <xsl:element namespace="http://www.tei-c.org/ns/1.0" name="ref">
      <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
    </xsl:element>
  </xsl:template>


  <xsl:template match="xptr">
    <xsl:element namespace="http://www.tei-c.org/ns/1.0" name="ptr">
      <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
    </xsl:element>
  </xsl:template>


  <xsl:template match="figure[@url]">
    <figure xmlns="http://www.tei-c.org/ns/1.0">
      <graphic xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:copy-of select="@*"/>
      </graphic>
      <xsl:apply-templates/>
    </figure>
  </xsl:template>


  <xsl:template match="figure/@url"/>

  <xsl:template match="figure/@entity"/>

  <xsl:template match="figure[@entity]">
    <figure xmlns="http://www.tei-c.org/ns/1.0">
      <graphic xmlns="http://www.tei-c.org/ns/1.0" url="{unparsed-entity-uri(@entity)}">
        <xsl:apply-templates select="@*"/>
      </graphic>
      <xsl:apply-templates/>
    </figure>
  </xsl:template>

  <xsl:template match="event">
    <incident xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="@* | * | text() | comment() | processing-instruction()"/>
    </incident>
  </xsl:template>

  <xsl:template match="state">
    <refState xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="@* | * | text() | comment() | processing-instruction()"/>
    </refState>
  </xsl:template>


  <!-- lost elements -->
  <xsl:template match="dateRange">
    <date xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
    </date>
  </xsl:template>


  <xsl:template match="dateRange/@from">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="dateRange/@to">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="language">
    <xsl:element namespace="http://www.tei-c.org/ns/1.0" name="language">
      <xsl:if test="@id">
        <xsl:attribute name="ident">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="* | processing-instruction() | comment() | text()"/>
    </xsl:element>
  </xsl:template>

  <!-- attributes lost -->
  <!-- dropped from TEI. Added as new change records later -->
  <xsl:template match="@date.created"/>

  <xsl:template match="@date.updated"/>
  
  <!-- ignore @cert attributes throughout -->
  <xsl:template match="@cert"/>

  <!-- dropped from TEI. No replacement -->
  <xsl:template match="refsDecl/@doctype"/>

  <!-- attributes changed name -->

  <xsl:template match="date/@value">
    <xsl:variable name="date-check" select="cob:date-proc(.)"/>
    <xsl:choose>
      <!-- tests to address oddities in date/@values -->
      <xsl:when test="$date-check = 'undated'"/>
      <xsl:when test="$date-check = '[n.d.]'"/>
      <xsl:when test="starts-with($date-check, '0030')"/>
      <xsl:when test="$date-check = ''"/>
      <xsl:otherwise>
        <xsl:attribute name="when">
          <xsl:value-of select="$date-check"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="@url">
    <xsl:attribute name="target">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>


  <xsl:template match="@doc">
    <xsl:attribute name="target">
      <xsl:value-of select="unparsed-entity-uri(.)"/>
    </xsl:attribute>
  </xsl:template>


  <xsl:template match="@id">
    <xsl:choose>
      <xsl:when test="parent::lang">
        <xsl:attribute name="ident">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="xml:id">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="@lang">
    <xsl:attribute name="xml:lang">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>


  <xsl:template match="change/@date"/>

  <!-- dropping this attribute -->
  <xsl:template match="date/@certainty"/>
  
  <!-- all pointing attributes preceded by # -->

  <xsl:template match="variantEncoding/@location">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template
    match="@ana | @active | @adj | @adjFrom | @adjTo | @children | @children | @class | @code | @code | @copyOf | @corresp | @decls | @domains | @end | @exclude | @fVal | @feats | @follow | @from | @hand | @inst | @langKey | @location | @mergedin | @new | @next | @old | @origin | @otherLangs | @parent | @passive | @perf | @prev | @render | @resp | @sameAs | @scheme | @script | @select | @since | @start | @synch | @target | @targetEnd | @to | @to | @value | @value | @who | @wit">
    <xsl:attribute name="{name(.)}">
      <xsl:call-template name="splitter">
        <xsl:with-param name="val">
          <xsl:value-of select="."/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:attribute>
  </xsl:template>


  <xsl:template name="splitter">
    <xsl:param name="val"/>
    <xsl:choose>
      <xsl:when test="contains($val, ' ')">
        <xsl:text>#</xsl:text>
        <xsl:value-of select="substring-before($val, ' ')"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="splitter">
          <xsl:with-param name="val">
            <xsl:value-of select="substring-after($val, ' ')"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="$val"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- fool around with selected elements -->


  <!-- imprint is no longer allowed inside bibl -->
  <xsl:template match="bibl/imprint">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="editionStmt/editor">
    <respStmt xmlns="http://www.tei-c.org/ns/1.0">
      <resp>
        <xsl:value-of select="@role"/>
      </resp>
      <name>
        <xsl:apply-templates/>
      </name>
    </respStmt>
  </xsl:template>

  <!-- header -->

  <xsl:template match="teiHeader">
    <teiHeader xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="@* | * | comment() | processing-instruction()"/>

      <xsl:if test="not(revisionDesc) and (@date.created or @date.updated)">
        <revisionDesc xmlns="http://www.tei-c.org/ns/1.0">
          <xsl:if test="@date.updated">
            <change xmlns="http://www.tei-c.org/ns/1.0">> <label>updated</label>
              <date xmlns="http://www.tei-c.org/ns/1.0">
                <xsl:value-of select="@date.updated"/>
              </date>
              <label xmlns="http://www.tei-c.org/ns/1.0">Date edited</label>
            </change>
          </xsl:if>
          <xsl:if test="@date.created">
            <change xmlns="http://www.tei-c.org/ns/1.0">
              <label>created</label>
              <date xmlns="http://www.tei-c.org/ns/1.0">
                <xsl:value-of select="@date.created"/>
              </date>
              <label xmlns="http://www.tei-c.org/ns/1.0">Date created</label>
            </change>
          </xsl:if>
        </revisionDesc>
      </xsl:if>
      <!--
	  <change when="{$today}"  xmlns="http://www.tei-c.org/ns/1.0">Converted to TEI P5 XML by p4top5.xsl
	  written by Sebastian
	  Rahtz at Oxford University Computing Services.</change>
	  </revisionDesc>
	  </xsl:if>
      -->
      <!-- drop classDecl -->
      <xsl:apply-templates select="classDecl"/>
    </teiHeader>
  </xsl:template>

  <!-- ignore classDecl node -->
  <xsl:template match="classDecl"/>
  
  <!-- update keywords[@scheme='LCSH']/list/item to keywords/terms -->
  <xsl:template match="keywords[@scheme='LCSH'] | keywords[parent::textClass]">
    <keywords xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:call-template name="list-proc"/>
      <xsl:call-template name="name-proc"/>
    </keywords>
  </xsl:template>
  
  <xsl:template name="list-proc">
    <xsl:for-each select="list[@type='simple']/item | list[parent::keywords]/item">
      <term xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="."/>
      </term>
    </xsl:for-each>
    
  </xsl:template>

  <xsl:template match="revisionDesc">
    <revisionDesc xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="@* | * | comment() | processing-instruction()"/>
    </revisionDesc>
  </xsl:template>

  <xsl:template match="publicationStmt">
    <publicationStmt xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="@* | * | comment() | processing-instruction()"/>
      <!--
	  <availability xmlns="http://www.tei-c.org/ns/1.0">
	  <p xmlns="http://www.tei-c.org/ns/1.0">Licensed under <ptr xmlns="http://www.tei-c.org/ns/1.0" target="http://creativecommons.org/licenses/by-sa/2.0/uk/"/></p>
	  </availability>
      -->
    </publicationStmt>
  </xsl:template>
  
  <xsl:template match="availability">
    <availability xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:attribute name="status" select="'restricted'"/>
      <xsl:apply-templates/>
    </availability>
  </xsl:template>

  <!-- space does not have @extent any more -->
  <xsl:template match="space/@extent">
    <xsl:attribute name="quantity">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <!-- tagsDecl has a compulsory namespace child now -->
  <xsl:template match="tagsDecl">
    <xsl:if test="*">
      <tagsDecl xmlns="http://www.tei-c.org/ns/1.0">
        <namespace name="http://www.tei-c.org/ns/1.0">
          <xsl:apply-templates select="* | comment() | processing-instruction"/>
        </namespace>
      </tagsDecl>
    </xsl:if>
  </xsl:template>

  <!-- orgTitle inside orgName? redundant -->
  <xsl:template match="orgName/orgTitle">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- no need for empty <p> in sourceDesc -->
  <xsl:template match="sourceDesc/p[string-length(.) = 0]"/>

  <!-- start creating the new choice element -->
  <xsl:template match="corr[@sic]">
    <choice xmlns="http://www.tei-c.org/ns/1.0">
      <corr xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="text()"/>
      </corr>
      <sic xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="@sic"/>
      </sic>
    </choice>
  </xsl:template>

  <xsl:template match="sic[@corr]">
    <choice xmlns="http://www.tei-c.org/ns/1.0">
      <sic xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="text()"/>
      </sic>
      <corr xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="@corr"/>
      </corr>
    </choice>
  </xsl:template>

  <xsl:template match="abbr[@expan]">
    <choice xmlns="http://www.tei-c.org/ns/1.0">
      <abbr xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="text()"/>
      </abbr>
      <expan xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="@expan"/>
      </expan>
    </choice>
  </xsl:template>
  
  <xsl:template match="abbr[@type][not(@expan)]">
    <choice xmlns="http://www.tei-c.org/ns/1.0">
      <abbr xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="text()"/>
      </abbr>
      <expan xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="@type"/>
      </expan>
    </choice>
  </xsl:template>

  <xsl:template match="expan[@abbr]">
    <choice xmlns="http://www.tei-c.org/ns/1.0">
      <expan xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="text()"/>
      </expan>
      <abbr xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="@abbr"/>
      </abbr>
    </choice>
  </xsl:template>

  <xsl:template match="orig[@reg]">
    <choice xmlns="http://www.tei-c.org/ns/1.0">
      <orig xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="text()"/>
      </orig>
      <reg xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="@reg"/>
      </reg>
    </choice>
  </xsl:template>

  <!-- special consideration for <change> element -->
  <xsl:template match="change">
    <change xmlns="http://www.tei-c.org/ns/1.0">

      <xsl:apply-templates select="date"/>

      <xsl:if test="respStmt/resp">
        <label>
          <xsl:value-of select="respStmt/resp/text()"/>
        </label>
      </xsl:if>
      <xsl:for-each select="respStmt/name">
        <name xmlns="http://www.tei-c.org/ns/1.0">
          <xsl:apply-templates select="@* | * | comment() | processing-instruction() | text()"/>
        </name>
      </xsl:for-each>
      <xsl:for-each select="item">
        <xsl:apply-templates select="@* | * | comment() | processing-instruction() | text()"/>
      </xsl:for-each>
    </change>
  </xsl:template>


  <xsl:template match="respStmt[resp]">
    <respStmt xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:choose>
        <xsl:when test="resp/name">
          <resp xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:value-of select="resp/text()"/>
          </resp>
          <xsl:for-each select="resp/name">
            <name xmlns="http://www.tei-c.org/ns/1.0">
              <xsl:apply-templates/>
            </name>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
          <name xmlns="http://www.tei-c.org/ns/1.0"> </name>
        </xsl:otherwise>
      </xsl:choose>
    </respStmt>
  </xsl:template>

  <xsl:template match="q/@direct"/>

  <xsl:template match="q">
    <q xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="@* | * | comment() | processing-instruction() | text()"/>
    </q>
  </xsl:template>
  
  <xsl:template match="text[parent::q]">
    <floatingText xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="@* | * | comment() | processing-instruction() | text()"/>
    </floatingText>
  </xsl:template>
  
  <xsl:template match="pb">
    <xsl:variable name="number" select="if (@n) then cob:num-proc(@n) else (count(preceding::pb) + 1)"/>
    <xsl:variable name="facN" select="cob:pb-proc($number, $file-name, $image-path)"/>
    <pb xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:attribute name="n" select="$number"/>
      <xsl:if test="$facN != ''">
        <xsl:attribute name="facs" select="$facN"/>
      </xsl:if>
    </pb>
  </xsl:template>
  
  <!-- 
      Add gap processing. What we have here is... frequently, in the source data, 
      gap/@reason indicates the *why* (P5's gap/@agent), and gap/@desc
      indicates *what* is missing (when it is used at all).
      
      Here we will drop @desc, and pull the @reason value into a new 
        @agent attribute.
  -->
  <xsl:template match="gap">
    <gap xmlns="http://www.tei-c.org/ns/1.0">
      <!-- 
        simplifying this a bit: 
        * if the there is an @reason that will map to @agent='damage'
        * if there is a @desc it will map into an <unclear> element
        * if there is an @rend, ignore it
      -->
      <xsl:if test="@reason"><xsl:attribute name="agent" select="'damage'"/></xsl:if>
    </gap>
    <xsl:if test="@desc">
      <unclear xmlns="http://www.tei-c.org/ns/1.0"><xsl:value-of select="@desc"/></unclear>
    </xsl:if>
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <!--
    Add name processing. What we have here is... frequently, in the source data,
    name/@type with multiple values ('place person') and/or name/@reg ('R. J.'), which indicates
    a regularization of a name. 
  -->    
  <!-- new output should look something like <name type="person"><reg>R. J.</reg></name>; e.g. -->
  <xsl:template match="name">
    <name xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:choose>
        <!-- ignore @type when there is more than 1 value in it -->
        <xsl:when test="count(tokenize(@type)) &gt; 1"/>
        <!-- add/keep the @type value when there is 1 value present -->
        <xsl:when test="count(tokenize(@type)) eq 1">
          <xsl:attribute name="type" select="@type"/>
        </xsl:when>
      </xsl:choose>
      
      <xsl:call-template name="reg-proc"/>
      <xsl:apply-templates select="node()"/>
    </name>
  </xsl:template>
  
  <!-- add a reg element if there is an @reg on a name -->
  <xsl:template name="reg-proc">
    <xsl:if test="@reg">
      <xsl:text> </xsl:text>
      <reg xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="@reg"/>
      </reg>
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>
  
  <!-- ignore @rend on name -->
  <xsl:template match="name/@rend"/>
  
  <!-- if we are reading the P4 with a DTD,
       we need to avoid copying the default values
       of attributes -->

  <xsl:template match="@targOrder">
    <xsl:if test="not(translate(., $uc, $lc) = 'u')">
      <xsl:attribute name="targOrder">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>


  <xsl:template match="@opt">
    <xsl:if test="not(translate(., $uc, $lc) = 'n')">
      <xsl:attribute name="opt">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>


  <xsl:template match="@to">
    <xsl:if test="not(translate(., $uc, $lc) = 'ditto')">
      <xsl:attribute name="to">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>


  <xsl:template match="@default">
    <xsl:choose>
      <xsl:when test="translate(., $uc, $lc) = 'no'"/>
      <xsl:otherwise>
        <xsl:attribute name="default">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="@part">
    <xsl:if test="not(translate(., $uc, $lc) = 'n')">
      <xsl:attribute name="part">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>


  <xsl:template match="@full">
    <xsl:if test="not(translate(., $uc, $lc) = 'yes')">
      <xsl:attribute name="full">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>


  <xsl:template match="@from">
    <xsl:if test="not(translate(., $uc, $lc) = 'root')">
      <xsl:attribute name="from">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>


  <xsl:template match="@status">
    <xsl:choose>
      <xsl:when test="parent::teiHeader">
        <xsl:if test="not(translate(., $uc, $lc) = 'new')">
          <xsl:attribute name="status">
            <xsl:value-of select="."/>
          </xsl:attribute>
        </xsl:if>
      </xsl:when>
      <xsl:when test="parent::del">
        <xsl:if test="not(translate(., $uc, $lc) = 'unremarkable')">
          <xsl:attribute name="status">
            <xsl:value-of select="."/>
          </xsl:attribute>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="status">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="@place">
    <xsl:if test="not(translate(., $uc, $lc) = 'unspecified')">
      <xsl:attribute name="place">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>


  <xsl:template match="@sample">
    <xsl:if test="not(translate(., $uc, $lc) = 'complete')">
      <xsl:attribute name="sample">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>


  <xsl:template match="@org">
    <xsl:if test="not(translate(., $uc, $lc) = 'uniform')">
      <xsl:attribute name="org">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="teiHeader/@type">
    <xsl:if test="not(translate(., $uc, $lc) = 'text')">
      <xsl:attribute name="type">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- yes|no to boolean -->

  <xsl:template match="@anchored">
    <xsl:attribute name="anchored">
      <xsl:choose>
        <xsl:when test="translate(., $uc, $lc) = 'yes'">true</xsl:when>
        <xsl:when test="translate(., $uc, $lc) = 'no'">false</xsl:when>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="sourceDesc/@default"/>

  <xsl:template match="@tei">
    <xsl:attribute name="tei">
      <xsl:choose>
        <xsl:when test="translate(., $uc, $lc) = 'yes'">true</xsl:when>
        <xsl:when test="translate(., $uc, $lc) = 'no'">false</xsl:when>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@langKey"/>

  <xsl:template match="@TEIform"/>

  <!-- assorted atts -->
  <xsl:template match="@old"/>

  <xsl:template match="@mergedin">
    <xsl:attribute name="mergedIn">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <!-- deal with the loss of div0 -->

  <xsl:template match="div1 | div2 | div3 | div4 | div5 | div6">
    <xsl:element name="div" namespace="http://www.tei-c.org/ns/1.0">
      <xsl:attribute name="subtype" select="substring-after(local-name(), 'div')"/>
      <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="div0">
    <div xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:attribute name="subtype" select="'0'"/>
      <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
    </div>
  </xsl:template>

  <xsl:template match="@type[parent::div1]">
    <xsl:attribute name="type" select="'letter'"/>  
  </xsl:template>
  
  <!-- addressing div/@type in pav.xml -->
  <xsl:template match="@type[parent::div1][contains(.,'financial valuation')]">
    <xsl:attribute name="type" select="'valuation'"/>
  </xsl:template>
  
  <!-- insert a wrapping note element in add elements -->
  <xsl:template match="add[p]">
    <add xmlns="http://www.tei-c.org/ns/1.0">
      <xsl:apply-templates select="@*"/>
      <note xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:apply-templates/>
      </note>
    </add>
  </xsl:template>
  
  <xsl:template match="add/@place[normalize-space(.) = '']"/>
  
  <!-- override current value of del/@type -->
  <xsl:template match="del/@type">
    <xsl:attribute name="type" select="'overstrike'"/>
  </xsl:template>
   
  <xsl:template match="note/@type[count(tokenize(., ' ')) &gt; 1]">
    <xsl:attribute name="type" select="lower-case(substring-before(., ' '))"/>
  </xsl:template>
  
  <xsl:template match="unclear[parent::figDesc]">
    <choice xmlns="http://www.tei-c.org/ns/1.0">
      <sic xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="text()"/>
      </sic>
      <orig xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:value-of select="text()"/>
      </orig>
    </choice>
  </xsl:template>
  
  <xsl:template match="gap[parent::figDesc]"/>
  
  <xsl:template match="p[@align]"/>
  
  <!--
    holding off on this for now.
  -->
  <!--<xsl:template match="encodingDecl">
    <xsl:call-template name="create-tagsdecl"/>
  </xsl:template>-->

</xsl:stylesheet>
