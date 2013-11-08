<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn = "http://www.w3.org/2005/xpath-functions"
	xmlns:local="http://www.adamsbook.com"
	exclude-result-prefixes="xs fn local">

  <xsl:output method="xml" indent="yes" cdata-section-elements="descriptions"/>

  <xsl:function name="local:isbnDigit" as="xs:integer">
    <xsl:param name="isbn" as="xs:string"/>
    <xsl:param name="index" as="xs:integer"/>
    <xsl:variable name="digit" select="fn:lower-case(fn:substring($isbn, $index, 1))"/>
    <xsl:choose>
      <xsl:when test="$digit = 'x'">
        <xsl:value-of select="xs:integer(10)"/>
      </xsl:when>
      <xsl:when test="$digit = ''">
        <xsl:value-of select="xs:integer(0)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="xs:integer($digit)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="local:ISBN10Values">
    <xsl:param name="isbn10" as="xs:string"/>
    <xsl:variable name="isbn" select="fn:translate($isbn10, '-', '')"/>
    <xsl:for-each select="1 to 10">
      <xsl:value-of select="local:isbnDigit($isbn, position()) * (10 - (position() - 1))"/>
    </xsl:for-each>
  </xsl:function>

  <xsl:function name="local:ISBN10CheckSum" as="xs:integer">
    <xsl:param name="isbn10" as="xs:string"/>
    <xsl:value-of select="fn:sum(local:ISBN10Values($isbn10)) mod 11"/>
  </xsl:function>

  <xsl:function name="local:isISBN10Valid" as="xs:boolean">
    <xsl:param name="isbn10" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$isbn10 = ''">
        <xsl:value-of select="false()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="local:ISBN10CheckSum($isbn10) = 0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="local:ISBN13Values">
    <xsl:param name="isbn13" as="xs:string"/>
    <xsl:variable name="isbn" select="fn:translate($isbn13, '-', '')"/>
    <xsl:for-each select="1 to 13">
      <xsl:value-of select="local:isbnDigit($isbn, position()) * (1 + (2 *((position() + 1) mod 2)))"/>
    </xsl:for-each>
  </xsl:function>

  <xsl:function name="local:ISBN13CheckSum" as="xs:integer">
    <xsl:param name="isbn13" as="xs:string"/>
    <xsl:value-of select="fn:sum(local:ISBN13Values($isbn13)) mod 10"/>
  </xsl:function>

  <xsl:function name="local:isISBN13Valid" as="xs:boolean">
    <xsl:param name="isbn13" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$isbn13 = ''">
        <xsl:value-of select="false()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="local:ISBN13CheckSum($isbn13) = 0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="local:ISBN10To13" as="xs:string">
    <xsl:param name="isbn10" as="xs:string"/>
    <xsl:variable name="isbn" select="fn:concat('978', fn:translate($isbn10, '-', ''))"/>
    <xsl:variable name="isbnWithoutCheckSum" select="fn:substring($isbn, 1, 12)"/>
    <xsl:value-of select="fn:concat($isbnWithoutCheckSum, (10 - (local:ISBN13CheckSum($isbnWithoutCheckSum))))"/>
  </xsl:function>

  <xsl:function name="local:stripPunctuationAndSymbols" as="xs:string">
    <xsl:param name="text" as="xs:string"/>
    <xsl:variable name="apos">'</xsl:variable>
    <xsl:variable name="quot">"</xsl:variable>
    <xsl:variable name="x" select="fn:translate($text, ',.;:!?{}[]/\\|()-+=*^%$#~`&gt;&lt;&amp;', ' ')"/>
    <xsl:variable name="y" select="fn:translate($x, $quot, ' ')"/>
    <xsl:value-of select="fn:translate($y, $apos, '')"/>
  </xsl:function>

  <xsl:function name="local:stripWhitespace" as="xs:string">
    <xsl:param name="text" as="xs:string"/>
    <xsl:value-of select="fn:normalize-space($text)"/>
  </xsl:function>

  <xsl:function name="local:cleanText" as="xs:string">
    <xsl:param name="text" as="xs:string"/>
    <xsl:value-of select="local:stripWhitespace(local:stripPunctuationAndSymbols($text))"/>
  </xsl:function>

  <xsl:function name="local:stripArticles" as="xs:string">
    <xsl:param name="text" as="xs:string"/>
    <xsl:variable name="firstWord" select="fn:substring-before(fn:lower-case(local:stripWhitespace($text)), ' ')"/>
    <xsl:choose>
      <xsl:when test="$firstWord = 'the' or $firstWord = '¡the' or $firstWord = '¿the' or $firstWord = 'a' or  $firstWord = '¡a' or $firstWord = '¿a'">
        <xsl:value-of select="local:stripWhitespace(fn:substring-after($text, ' '))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="local:stripWhitespace($text)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="local:eval" as="xs:string">
    <xsl:param name="nodes"/>
    <xsl:param name="defaultValue" as="xs:string"/>
    <xsl:variable name="validNodes" select="$nodes[text() != '']"/>
    <xsl:choose>
      <xsl:when test="count($validNodes) &gt; 0">
        <xsl:value-of select="local:stripWhitespace($validNodes[1]/text())"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$defaultValue"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="local:evalAll" as="xs:string">
    <xsl:param name="nodes"/>
    <xsl:param name="separator" as="xs:string"/>
    <xsl:param name="defaultValue" as="xs:string"/>
    <xsl:variable name="validNodes" select="$nodes[text() != '']"/>
    <xsl:choose>
      <xsl:when test="count($validNodes) &gt; 0">
        <xsl:value-of select="local:stripWhitespace(fn:string-join($validNodes/text(), $separator))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$defaultValue"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="local:evalContributor" as="xs:string">
    <xsl:param name="contributorNodes"/>
    <xsl:param name="codes"/>
    <xsl:variable name="selectedContributors" select="$contributorNodes[fn:index-of($codes, fn:lower-case(b035)) &gt; 0 or fn:index-of($codes, fn:lower-case(contributorrole)) &gt; 0]"/>
    <xsl:variable name="contributorNames">
      <xsl:for-each select="$selectedContributors">
        <xsl:if test="position() &gt; 1">|</xsl:if>
        <xsl:value-of select="local:eval((
		  b037,
		  personnameinverted,
		  b036,
		  personname), '')"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="local:stripWhitespace($contributorNames)"/>
  </xsl:function>

  <xsl:function name="local:validPriceNodes">
    <xsl:param name="supplyDetailNode"/>
    <xsl:choose>
      <xsl:when test="count($supplyDetailNode/price[fn:lower-case(j152) = 'usd' or fn:lower-case(currencycode) = 'usd']) &gt; 0">
        <xsl:copy-of select="$supplyDetailNode/price[fn:lower-case(j152) = 'usd' or fn:lower-case(currencycode) = 'usd']"/>
      </xsl:when>
      <xsl:when test="count($supplyDetailNode/price[fn:lower-case(j152) = 'can' or fn:lower-case(currencycode) = 'can']) &gt; 0">
        <xsl:copy-of select="$supplyDetailNode/price[fn:lower-case(j152) = 'can' or fn:lower-case(currencycode) = 'can']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select=" $supplyDetailNode/price[1]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="local:evalPrice">
    <xsl:param name="supplyDetailNode"/>
    <xsl:variable name="priceNodes" select="local:validPriceNodes($supplyDetailNode)"/>
    <xsl:choose>
      <xsl:when test="count($priceNodes[j148 = '01' or pricetypecode = '01']) &gt; 0">
        <xsl:copy-of select="$priceNodes[j148 = '01' or pricetypecode = '01']"/>
      </xsl:when>
      <xsl:when test="count($priceNodes[j148 = '05' or pricetypecode = '05']) &gt; 0">
        <xsl:copy-of select="$priceNodes[j148 = '05' or pricetypecode = '05']"/>
      </xsl:when>
      <xsl:when test="count($priceNodes[j148 = '11' or pricetypecode = '11']) &gt; 0">
        <xsl:copy-of select="$priceNodes[j148 = '11' or pricetypecode = '11']"/>
      </xsl:when>
      <xsl:when test="count($priceNodes[j148 = '21' or pricetypecode = '21']) &gt; 0">
        <xsl:copy-of select="$priceNodes[j148 = '21' or pricetypecode = '21']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$priceNodes[return = 'nothing']"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="local:evalNetPrice">
    <xsl:param name="supplyDetailNode"/>
    <xsl:variable name="priceNodes" select="local:validPriceNodes($supplyDetailNode)"/>
    <xsl:choose>
      <xsl:when test="count($priceNodes[j148 = '05' or pricetypecode = '05']) &gt; 0">
        <xsl:copy-of select="$priceNodes[j148 = '05' or pricetypecode = '05']"/>
      </xsl:when>
      <xsl:when test="count($priceNodes[j148 = '15' or pricetypecode = '15']) &gt; 0">
        <xsl:copy-of select="$priceNodes[j148 = '15' or pricetypecode = '15']"/>
      </xsl:when>
      <xsl:when test="count($priceNodes[j148 = '25' or pricetypecode = '25']) &gt; 0">
        <xsl:copy-of select="$priceNodes[j148 = '25' or pricetypecode = '25']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$priceNodes[return = 'nothing']"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:template match="/">
    <record>
      <xsl:apply-templates/>
    </record>
  </xsl:template>

  <xsl:template match="header">
    <header>
      <defaultPriceTypeCode>
        <xsl:value-of select="local:eval((
					m185, 
					defaultpricetypecode,
          /m185,
          /defaultpricetypecode), '01')"/>
      </defaultPriceTypeCode>
      <defaultCurrencyCode>
        <xsl:value-of select="local:eval((
					m186, 
					defaultcurrencycode,
          /m186,
          /defaultcurrencycode), 'USD')"/>
      </defaultCurrencyCode>
      <defaultLinearUnit>
        <xsl:value-of select="local:eval((
					m187, 
					defaultlinearunit,
          /m187,
          /defaultlinearunit), 'in')"/>
      </defaultLinearUnit>
      <defaultWeightUnit>
        <xsl:value-of select="local:eval((
					m188, 
					defaultweightunit,
          /m188,
          /defaultweightunit), 'oz')"/>
      </defaultWeightUnit>
    </header>
  </xsl:template>

  <xsl:template match="product">
    <xsl:variable name="rawISBN10" select="local:cleanText(local:eval(( 
					productidentifier[b221 = '02' or productidtype = '02']/b244, 
					productidentifier[b221 = '02' or productidtype = '02']/idvalue,
					b004, 
					isbn), ''))"/>
    <xsl:variable name="ISBN10">
      <xsl:choose>
        <xsl:when test="local:isISBN10Valid($rawISBN10)">
          <xsl:value-of select="$rawISBN10"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="rawISBN13" select="local:cleanText(local:eval((
					productidentifier[b221 = '03' or productidtype = '03']/b244, 
					productidentifier[b221 = '03' or productidtype = '03']/idvalue, 
					productidentifier[b221 = '15' or productidtype = '15']/b244, 
					productidentifier[b221 = '15' or productidtype = '15']/idvalue,
					b010, 
					replacesisbn), ''))"/>
    <xsl:variable name="rawEAN13" select="local:cleanText(local:eval((
					b005, 
					ean1), ''))"/>
    <xsl:variable name="ISBN13">
      <xsl:choose>
        <xsl:when test="local:isISBN13Valid($rawISBN13)">
          <xsl:value-of select="$rawISBN13"/>
        </xsl:when>
        <xsl:when test="local:isISBN13Valid($rawEAN13)">
          <xsl:value-of select="$rawEAN13"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="local:ISBN10To13($ISBN10)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="EAN13">
      <xsl:choose>
        <xsl:when test="local:isISBN13Valid($rawEAN13)">
          <xsl:value-of select="$rawEAN13"/>
        </xsl:when>
        <xsl:when test="local:isISBN13Valid($ISBN13)">
          <xsl:value-of select="$ISBN13"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="rawLCCN" select=" local:eval((
					productidentifier[b221 = '13' or productidtype = '13']/b244, 
					productidentifier[b221 = '13' or productidtype = '13']/idvalue), '')"/>
    <xsl:variable name="LCCN">
      <xsl:choose>
        <xsl:when test="$rawLCCN != '' and fn:string-length($rawLCCN) &gt; 12">
          <xsl:value-of select="fn:translate($rawLCCN, '[] ', '')"/>
        </xsl:when>
        <xsl:when test="fn:string-length($rawLCCN) &lt;= 50">
          <xsl:value-of select="$rawLCCN"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="rawSeriesTitle" select="local:eval((
					series/b018, 
					series/titleofseries, 
					series/title/b203,
					series/title/titletext), '')"/>
    <xsl:variable name="seriesTitleNoPrefix" select="local:eval((
					series/title/b031,
					series/title/TitleWithoutPrefix), '')"/>
    <xsl:variable name="seriesTitlePrefix" select="local:eval((
					series/title/b030,
					series/title/TitlePrefix), '')"/>
    <xsl:variable name="seriesTitle">
      <xsl:choose>
        <xsl:when test="$rawSeriesTitle != ''">
          <xsl:value-of select="$rawSeriesTitle"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="fn:concat($seriesTitlePrefix, ' ' ,$seriesTitleNoPrefix)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="rawTitle" select="local:eval(( 
					title/b203, 
					title/titletext,
					b028, 
					distinctivetitle), '')"/>
    <xsl:variable name="titleNoPrefix" select="local:eval((
					title/b031, 
					title/TitleWithoutPrefix), '')"/>
    <xsl:variable name="titlePrefix" select="local:eval((
					title/b030, 
					title/TitlePrefix), '')"/>
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="$rawTitle != ''">
          <xsl:value-of select="$rawTitle"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="fn:concat($titlePrefix, ' ', $titleNoPrefix)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="tTitle" select="local:stripArticles($title)"/>
    <xsl:variable name="subtitle" select="local:eval(( 
					title/b029, 
					title/subtitle,
					b029, 
					subtitle), '')"/>
    <xsl:variable name="priceNode" select="local:evalPrice(supplydetail)"/>
    <xsl:variable name="netPriceNode" select="local:evalNetPrice(supplydetail)"/>
    <xsl:variable name="unadjustedPrice" select="local:eval((
					$priceNode/j151,
					$priceNode/priceamount), '')"/>
    <xsl:variable name="price" select="if (local:eval(($priceNode/j148, $priceNode/pricetypecode), '') = '05') then 
				  xs:decimal($unadjustedPrice) div 0.75
			  else
				  $unadjustedPrice"/>
    <xsl:variable name="priceTypeCode" select="local:eval((
					$priceNode/j148,
					$priceNode/pricetypecode), '')"/>
    <xsl:variable name="netPrice">
      <xsl:choose>
        <xsl:when test="count($netPriceNode) &gt; 0">
          <xsl:value-of select="local:eval((
											$netPriceNode/j151,
											$netPriceNode/priceamount), '')"/>
        </xsl:when>
        <xsl:when test="$priceTypeCode != '' and xs:decimal($priceTypeCode) = 11">
          <xsl:value-of select="xs:decimal($price) div 0.75"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="deducedPrice">
      <xsl:choose>
        <xsl:when test="count($netPriceNode) = 0 and $priceTypeCode != '' and xs:decimal($priceTypeCode) = 11">
          <xsl:value-of select="true()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="false()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <product>
      <ONIXProductRef type="decimal">
        <xsl:value-of select="local:eval((
					a001, 
					recordreference), '')"/>
      </ONIXProductRef>
      <PPN type="varchar">
        <xsl:value-of select="local:eval(( 
					productidentifier[b221 = '01' or productidtype = '01']/b244, 
					productidentifier[b221 = '01' or productidtype = '01']/idvalue,
					b007, 
					publisherproductno), '')"/>
      </PPN>
      <ISBN10 type="varchar">
        <xsl:value-of select="$ISBN10"/>
      </ISBN10>
      <ISBN13 type="varchar">
        <xsl:value-of select="$ISBN13"/>
      </ISBN13>
      <EAN13 type="varchar">
        <xsl:value-of select="$EAN13"/>
      </EAN13>
      <UPC type="varchar">
        <xsl:value-of select="local:eval((
					b006, 
					upc, 
					productidentifier[b221 = '04' or productidtype = '04']/b244, 
					productidentifier[b221 = '04' or productidtype = '04']/idvalue), '')"/>
      </UPC>
      <ISMN type="varchar">
        <xsl:value-of select="local:eval((
					b008, 
					ismn, 
					productidentifier[b221 = '05' or productidtype = '05']/b244, 
					productidentifier[b221 = '05' or productidtype = '05']/idvalue), '')"/>
      </ISMN>
      <DOI type="varchar">
        <xsl:value-of select="local:eval((
					b009, 
					doi, 
					productidentifier[b221 = '06' or productidtype = '06']/b244, 
					productidentifier[b221 = '06' or productidtype = '06']/idvalue), '')"/>
      </DOI>
      <LCCN type="varchar">
        <xsl:value-of select="$LCCN"/>
      </LCCN>
      <GTIN14 type="varchar">
        <xsl:value-of select="local:eval((
					productidentifier[b221 = '14' or productidtype = '14']/b244, 
					productidentifier[b221 = '14' or productidtype = '14']/idvalue), '')"/>
      </GTIN14>
      <publisher type="varchar" ignore="true">
        <xsl:value-of select="fn:substring(local:eval(( 
					publisher/b081, 
					publisher/publishername,
					b081, 
					publishername), ''), 0, 100)"/>
      </publisher>
      <format type="char">
        <xsl:value-of select="local:eval((
					b012, 
					productform), '')"/>
      </format>
      <formDetail type="varchar">
        <xsl:value-of select="fn:string-join((b333/text(), productformdetail/text()), '|')"/>
      </formDetail>
      <formatDescription type="varchar">
        <xsl:value-of select="local:eval((
					b014, 
					productformdescription), '')"/>
      </formatDescription>
      <seriesTitle type="varchar">
        <xsl:value-of select="$seriesTitle"/>
      </seriesTitle>
      <seriesTitleNoPrefix type="varchar" ignore="true">
        <xsl:value-of select="$seriesTitleNoPrefix"/>
      </seriesTitleNoPrefix>
      <seriesTitlePrefix type="varchar" ignore="true">
        <xsl:value-of select="$seriesTitlePrefix"/>
      </seriesTitlePrefix>
      <title type="varchar">
        <xsl:value-of select="$title"/>
      </title>
      <subtitle type="varchar">
        <xsl:value-of select="$subtitle"/>
      </subtitle>
      <titleNoPrefix type="varchar" ignore="true">
        <xsl:value-of select="$titleNoPrefix"/>
      </titleNoPrefix>
      <titlePrefix type="varchar" ignore="true">
        <xsl:value-of select="$titlePrefix"/>
      </titlePrefix>
      <tTitle type="varchar">
        <xsl:value-of select="$tTitle"/>
      </tTitle>
      <nptTitle type="varchar">
        <xsl:value-of select="local:cleanText($tTitle)"/>
      </nptTitle>
      <npSubtitle type="varchar">
        <xsl:value-of select="local:cleanText($subtitle)"/>
      </npSubtitle>
      <npSeriesTitle type="varchar">
        <xsl:value-of select=" local:cleanText($seriesTitle)"/>
      </npSeriesTitle>
      <author type="varchar">
        <xsl:value-of select="local:evalContributor(contributor, ('a01', 'a02', 'a03', 'a04', 'a05', 'a06', 'a07', 'a08', 'a09'))"/>
      </author>
      <illustrator type="varchar">
        <xsl:value-of select="local:evalContributor(contributor, ('a12'))"/>
      </illustrator>
      <translator type="varchar">
        <xsl:value-of select="local:evalContributor(contributor, ('b06'))"/>
      </translator>
      <bisac type="varchar">
        <xsl:value-of select="local:evalAll((
					j137, 
					suppliername,
					b064, 
					basicmainsubject, 
					subject[b067 = '10' or subjectschemeidentifier = '10']/b069, 
					subject[b067 = '10' or subjectschemeidentifier = '10']/subjectcode, 
					subject[b067 = '10' or subjectschemeidentifier = '10']/b064, 
					subject[b067 = '10' or subjectschemeidentifier = '10']/basicmainsubject, 
					subject[b067 = '22' or subjectschemeidentifier = '22']/b069, 
					subject[b067 = '22' or subjectschemeidentifier = '22']/subjectcode, 
					subject[b067 = '22' or subjectschemeidentifier = '22']/b064, 
					subject[b067 = '22' or subjectschemeidentifier = '22']/basicmainsubject), ' ', '')"/>
      </bisac>
      <edition type="varchar">
        <xsl:value-of select="fn:substring(local:eval((
          b058, 
          editionstatement), ''), 0, 512)"/>
      </edition>
      <descriptions type="text">
        <xsl:value-of select="local:evalAll((
					othertext/d104,
					othertext/text), '&gt;hr&lt;', '')"/>
      </descriptions>
      <imprint type="varchar">
        <xsl:value-of select="fn:substring(local:eval((
					imprint/b079, 
					imprint/imprintname), ''), 0, 100)"/>
      </imprint>
      <copyright type="varchar">
        <xsl:value-of select="fn:substring(local:eval((
          copyrightstatement/b079, 
          copyrightstatement/imprintname,
          b087,
          copyrightyear), ''), 0, 32)"/>
      </copyright>
      <height type="decimal">
        <xsl:value-of select="local:eval((
					measure[c093 = '01' or measuretypecode = '01']/c094,
					measure[c093 = '01' or measuretypecode = '01']/measurement), '')"/>
      </height>
      <width type="decimal">
        <xsl:value-of select="local:eval((
					measure[c093 = '02' or measuretypecode = '02']/c094,
					measure[c093 = '02' or measuretypecode = '02']/measurement), '')"/>
      </width>
      <depth type="decimal">
        <xsl:value-of select="local:eval((
					measure[c093 = '03' or measuretypecode = '03']/c094,
					measure[c093 = '03' or measuretypecode = '03']/measurement), '')"/>
      </depth>
      <weight type="decimal">
        <xsl:value-of select="local:eval((
					measure[c093 = '08' or measuretypecode = '08']/c094,
					measure[c093 = '08' or measuretypecode = '08']/measurement), '')"/>
      </weight>
      <dimensionsUM type="varchar">
        <xsl:value-of select="local:eval((
					measure[c093 = '01' or measuretypecode = '01']/c095,
					measure[c093 = '01' or measuretypecode = '01']/measureunitcode), '')"/>
      </dimensionsUM>
      <weightUM type="varchar">
        <xsl:value-of select="local:eval((
					measure[c093 = '08' or measuretypecode = '08']/c095,
					measure[c093 = '08' or measuretypecode = '08']/measureunitcode), '')"/>
      </weightUM>
      <supplier type="varchar">
        <xsl:value-of select="fn:substring(local:eval(( 
					publisher/b081, 
					publisher/publishername,
					b081, 
					publishername), ''), 0, 100)"/>
      </supplier>
      <supplierOfOrigin type="varchar">
        <xsl:value-of select="fn:substring(local:eval((
					supplydetail/j137,
					supplydetail/suppliername,
					j137, 
					suppliername), ''), 0, 100)"/>
      </supplierOfOrigin>
      <availability type="varchar">
        <xsl:value-of select="local:eval((
					supplydetail/j396,
					supplydetail/j141,
					supplydetail/productavailability,
					supplydetail/availabilitycode), 'CS')"/>
      </availability>
      <expected type="int">
        <xsl:value-of select="local:eval((
					supplydetail/j142,
					supplydetail/expectedshipdate), '')"/>
      </expected>
      <caseQty type="int">
        <xsl:value-of select=" local:eval((
					supplydetail/j145,
					supplydetail/packquantity), '')"/>
      </caseQty>
      <price type="varchar">
        <xsl:value-of select="$price"/>
      </price>
      <netPrice type="varchar">
        <xsl:value-of select="$netPrice"/>
      </netPrice>
      <deducedPrice type="bit">
        <xsl:value-of select="$deducedPrice"/>
      </deducedPrice>
      <priceTypeCode type="varchar" ignore="true">
        <xsl:value-of select="$priceTypeCode"/>
      </priceTypeCode>
      <denomination type="varchar">
        <xsl:value-of select="local:eval((
					$priceNode/j152,
					$priceNode/currencycode), '')"/>
      </denomination>
      <stockedBy type="int">0</stockedBy>
    </product>
  </xsl:template>

</xsl:stylesheet>
