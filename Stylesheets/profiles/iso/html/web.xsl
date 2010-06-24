<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                xmlns:tbx="http://www.lisa.org/TBX-Specification.33.0.html"
		xmlns:iso="http://www.iso.org/ns/1.0"
		xmlns:cals="http://www.oasis-open.org/specs/tm9901"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:s="http://www.ascc.net/xml/schematron"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:t="http://www.thaiopensource.com/ns/annotations"
                xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                exclude-result-prefixes="tei html t a rng s iso tbx
					 cals teix w"
                version="2.0">
   <xsl:template name="myi18n">
      <xsl:param name="word"/>
      <xsl:choose>
         <xsl:when test="$word='appendixWords'">
            <xsl:text>Annex</xsl:text>
    </xsl:when>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="processing-instruction()[name()='ISOerror']">
     <span style="border: solid red 1pt; color:red">
       <xsl:value-of select="."/>
     </span>
   </xsl:template>

   <xsl:template match="tei:note[@place='comment']">
     <span style="border: solid red 1pt; color:red">
       <xsl:value-of select="."/>
     </span>
   </xsl:template>

  <xsl:template name="divClassAttribute">
      <xsl:param name="depth"/>
      <xsl:choose>
         <xsl:when test="@type">
            <xsl:attribute name="class">
               <xsl:value-of select="@type"/>
            </xsl:attribute>
         </xsl:when>
         <xsl:otherwise>
            <xsl:attribute name="class">
               <xsl:text>teidiv</xsl:text>
               <xsl:value-of select="$depth"/>
	              <xsl:text> from-</xsl:text>
	              <xsl:value-of select="local-name(ancestor::tei:body|ancestor::tei:front|ancestor::tei:back)"/>
            </xsl:attribute>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="ident">
         <xsl:apply-templates mode="ident" select="."/>
      </xsl:variable>
      <xsl:attribute name="id">
         <xsl:value-of select="$ident"/>
      </xsl:attribute>
  </xsl:template>


   <xsl:template match="tei:note[@place='foot']">
     <span class="footnote">
       <xsl:number level="any"/>
       <xsl:apply-templates/>
     </span>
   </xsl:template>

   <xsl:template match="tei:note[@place='foot']/tei:p">
     <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="tei:note[@rend='example']">
      <p>EXAMPLE <xsl:apply-templates/>
      </p>
   </xsl:template>


   <xsl:template match="tei:p[count(*)=1 and tei:gloss]">
      <p style="margin-left: 1em">
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template match="tei:num">
      <span class="isonum">
         <xsl:choose>
            <xsl:when test="$numberFormat='fr'">
	              <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
	              <xsl:value-of select="translate(.,', ','.,')"/>
            </xsl:otherwise>
         </xsl:choose>
      </span>
   </xsl:template>

   <xsl:template match="tei:g[@ref='x:tab']">
      <xsl:text>	</xsl:text>
   </xsl:template>

   <xsl:template match="tei:c[@iso:font]">
      <xsl:value-of select="@n"/>
   </xsl:template>

   <xsl:template match="tei:seg[@iso:provision]">
      <span class="provision_{@iso:provision}">
         <xsl:apply-templates/>
      </span>
   </xsl:template>


   <xsl:template name="block-element">
     <xsl:param name="pPr"/>
     <xsl:param name="style"/>
     <xsl:param name="select" select="."/>
     <xsl:for-each select="$select">
       <p>
	 <xsl:choose>
	 <xsl:when test="not($style='')">
	   <xsl:attribute name="class">
	     <xsl:value-of select="$style"/>
	   </xsl:attribute>
	 </xsl:when>
	 <xsl:when test="w:pPr/w:pStyle">
	   <xsl:attribute name="class">
	     <xsl:value-of select="w:pPr/w:pStyle/@w:val"/>
	   </xsl:attribute>
	 </xsl:when>
	 </xsl:choose>
	 <xsl:apply-templates/>
       </p>
     </xsl:for-each>
   </xsl:template>

   <xsl:template name="generateError">
     <xsl:param name="message"/>
     <xsl:processing-instruction name="ISOerror">
       <xsl:value-of select="$message"/>
     </xsl:processing-instruction>
   </xsl:template>

   <xsl:template name="copyIt">
      <xsl:copy>
	<xsl:apply-templates select="@*" mode="checkSchematron"/>
	<xsl:apply-templates select="*|processing-instruction()|comment()|text()" mode="checkSchematron"/>
      </xsl:copy>
   </xsl:template>

   <xsl:template name="copyMe">
      <xsl:copy-of select="."/>
   </xsl:template>

   <xsl:template match="text()">
       <xsl:value-of select="translate(.,'&#2011;','-')"/>
   </xsl:template>

  <xsl:template name="simpleRun">
    <xsl:param name="text"/>
    <xsl:param name="prefix"/>
    <xsl:param name="italic"/>
    <xsl:value-of select="$prefix"/>
    <xsl:choose>
      <xsl:when test="$italic='true'">
	<i>
	  <xsl:value-of select="$text"/>
	</i>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:hi[@rend]">
    <span>
      <xsl:attribute name="style">
	<xsl:for-each select="tokenize(@rend,' ')">
	  <xsl:choose>
	    <xsl:when test=".='bold'">
	      <xsl:text>font-weight:bold;</xsl:text>
	    </xsl:when>
	    <xsl:when test=".='italic'">
	      <xsl:text>font-style:italic;</xsl:text>
	    </xsl:when>
	    <xsl:when test=".='smallcaps'">
	      <xsl:text>font-variant:small-caps;</xsl:text>
	    </xsl:when>
	    <xsl:when test=".='capsall'">
	      <xsl:text>text-transform:capitalize;</xsl:text>
	    </xsl:when>
	    <xsl:when test=".='strikethrough'">
	      <xsl:text>text-decoration:line-through;</xsl:text>
	    </xsl:when>
	    <xsl:when test=".='strikedoublethrough'">
	      <xsl:text>text-decoration:line-through;</xsl:text>
	    </xsl:when>
	    <xsl:when test=".='underline'">
	      <xsl:text>text-decoration:underline;</xsl:text>
	    </xsl:when>
	    <xsl:when test=".='underdoubleline'">
	      <xsl:text>border-bottom: 3px double;</xsl:text>
	    </xsl:when>
	    <xsl:when test="starts-with(.,'color(')">
	      <xsl:value-of select="translate(.,'()',':;')"/>
	    </xsl:when>
	    <xsl:when test=".='superscript'">
	      <xsl:text>vertical-align: top;font-size: 70%;</xsl:text>
	    </xsl:when>
	    <xsl:when test=".='subscript'">
	      <xsl:text>vertical-align: bottom;font-size: 70%;</xsl:text>
	    </xsl:when>
	    <xsl:when test="starts-with(.,'background(')">
	      <xsl:text>background-color: </xsl:text>
	      <xsl:value-of
		  select="substring-before(substring-after(.,'('),')')"/>
	      <xsl:text>;</xsl:text>
	    </xsl:when>
	  </xsl:choose>
	</xsl:for-each>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
</xsl:stylesheet>