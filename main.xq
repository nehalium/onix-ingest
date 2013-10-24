declare option output:method "xml";
declare option output:cdata-section-elements "description";

(: ----------- USER-DEFINED FUNCTIONS ----------- :)
(: Returns digit from ISBN at specified index, 10 for X :)
declare function local:isbnDigit($isbn, $index) as xs:integer{
  if (fn:lower-case(fn:substring($isbn, $index, 1)) = 'x') then
    xs:int(10)
  else
    xs:int(fn:substring($isbn, $index, 1))
};
(: Returns the converted values of an ISBN13 string as an array :)
declare function local:ISBN10Values($isbn10){
  let $isbn := fn:translate($isbn10, '-', '')
  for $i in 1 to 9 
  return local:isbnDigit($isbn, $i) * (10 - ($i - 1))
};
(: Returns the sum value for specified ISBN10 for calculating the checksum :)
declare function local:ISBN10CheckSum($isbn10) as xs:integer{
  fn:sum(local:ISBN10Values($isbn10)) mod 11
};
(: Checks if a specified ISBN10 is valid :)
declare function local:isISBN10Valid($isbn10) as xs:boolean{
  local:ISBN10CheckSum($isbn10) = 0
};
(: Returns the converted values of an ISBN13 string as an array :)
declare function local:ISBN13Values($isbn13){
  let $isbn := fn:translate($isbn13, '-', '')
  for $i in 1 to 12
  return xs:integer(local:isbnDigit($isbn, $i) * (1 + (2 *(($i + 1) mod 2))))
};
(: Returns the sum value for specified ISBN13 for calculating the checksum :)
declare function local:ISBN13CheckSum($isbn13) as xs:integer{
  fn:sum(local:ISBN13Values($isbn13)) mod 10
};
(: Checks if a specified ISBN13 is valid :)
declare function local:isISBN13Valid($isbn13) as xs:boolean{
  local:ISBN13CheckSum($isbn13) = 0
};
(: Converts an ISBN10 to an ISBN13  :)
declare function local:ISBN10To13($isbn10) as xs:string{
  let $isbn := fn:concat('978', fn:translate($isbn10, '-', ''))
  let $isbnWithoutCheckSum := fn:substring($isbn, 1, 12)
  return fn:concat($isbnWithoutCheckSum, (10 - (local:ISBN13CheckSum($isbnWithoutCheckSum))))
};
(: Removes punctuation and symbols from a given string :)
declare function local:stripPunctuationAndSymbols($text) as xs:string{
  fn:translate(fn:translate($text, ',.;:!?{}[]/\\|()-+=*^%$#~`"<>&amp;', ' '), '&apos;', '')
};
(: Removes whitespace from a given string including leading/trailing spaces, 
 : reduces extraneous spaces to one space 
 :)
declare function local:stripWhitespace($text) as xs:string{
  fn:normalize-space($text)
};
(: Removes extra whitespace, punctuation, symbols in a given string,
 : wrapper for stripWhitespace and stripPunctuationAndSymbols
 :)
declare function local:cleanText($text) as xs:string{
  local:stripWhitespace(local:stripPunctuationAndSymbols($text))
};
(: Moves leading articles :)
declare function local:stripArticles($text) as xs:string{
  let $firstWord := fn:substring-before(fn:lower-case(local:stripWhitespace($text)), ' ')
  return if ($firstWord = 'the' or 
             $firstWord = '¡the' or 
             $firstWord = '¿the' or
             $firstWord = 'a' or 
             $firstWord = '¡a' or 
             $firstWord = '¿a') then
    local:stripWhitespace(fn:substring-after($text, ' '))
  else
    local:stripWhitespace($text)
};
(: Check a list of given nodes for values, return the first value found
 : otherwise, return the default value
 :)
declare function local:eval($nodes, $defaultValue) as xs:string{
  let $validNodes := for $node in $nodes
    where $node/text() != ''
    return $node
  return if (count($validNodes) > 0) then local:stripWhitespace($validNodes[1]/text())
  else $defaultValue
};
(: Check a list of given nodes for values, concatenate all values with given separator
 : otherwise, return default value
 :)
declare function local:evalAll($nodes, $separator, $defaultValue) as xs:string{
  let $validNodes := for $node in $nodes
    where $node/text() != ''
    return $node
  return if (count($validNodes) > 0) then local:stripWhitespace(fn:string-join($validNodes/text(), $separator))
  else $defaultValue
};
(: Return a | separate list of contributors for a specified contributors node and codes :)
declare function local:evalContributor($contributorNodes, $codes) as xs:string{
  let $selectedContributors := for $code in $codes
    return $contributorNodes[fn:lower-case(b035) = $code or fn:lower-case(contributorrole) = $code]
  let $contributorNames := for $contributor in $selectedContributors
    return local:eval((
	    $contributor/b037,
	    $contributor/personnameinverted,
	    $contributor/b036,
	    $contributor/personname), '')
  return local:stripWhitespace(fn:string-join($contributorNames, '|'))
};
(: Return vali price nodes base on currency code found :)
declare function local:validPriceNodes($supplyDetailNode){
  	if (count($supplyDetailNode/price[fn:lower-case(j152) = 'usd' or fn:lower-case(currencycode) = 'usd']) > 0) then
	  	$supplyDetailNode/price[fn:lower-case(j152) = 'usd' or fn:lower-case(currencycode) = 'usd']
  	else if (count($supplyDetailNode/price[fn:lower-case(j152) = 'can' or fn:lower-case(currencycode) = 'can']) > 0) then
	  	$supplyDetailNode/price[fn:lower-case(j152) = 'can' or fn:lower-case(currencycode) = 'can']
    else 
      (: Return empty node :)
      $supplyDetailNode/price[true = 'false']
};
(: Determine price based on pricetypecode :)
declare function local:evalPrice($supplyDetailNode){
  let $priceNodes := local:validPriceNodes($supplyDetailNode)
  return 
    if (count($priceNodes[j148 = '01' or pricetypecode = '01']) > 0) then
	  	$priceNodes[j148 = '01' or pricetypecode = '01']
	  else if (count($priceNodes[j148 = '05' or pricetypecode = '05']) > 0) then
		  $priceNodes[j148 = '05' or pricetypecode = '05']
	  else if (count($priceNodes[j148 = '11' or pricetypecode = '11']) > 0) then
		  $priceNodes[j148 = '11' or pricetypecode = '11']
	  else if (count($priceNodes[j148 = '21' or pricetypecode = '21']) > 0) then
		  $priceNodes[j148 = '21' or pricetypecode = '21']
    else 
      (: Return empty node :)
      $priceNodes[true = 'false']
};
(: Determine net price based on pricetypecode  :)
declare function local:evalNetPrice($supplyDetailNode){
  let $priceNodes := local:validPriceNodes($supplyDetailNode)
  return 
    if (count($priceNodes[j148 = '05' or pricetypecode = '05']) > 0) then
		  $priceNodes[j148 = '05' or pricetypecode = '05']
	  else if (count($priceNodes[j148 = '15' or pricetypecode = '15']) > 0) then
	  	$priceNodes[j148 = '15' or pricetypecode = '15']
	  else if (count($priceNodes[j148 = '25' or pricetypecode = '25']) > 0) then
		  $priceNodes[j148 = '25' or pricetypecode = '25']
    else 
      (: Return empty node :)
      $priceNodes[true = 'false']
};

(: ----------- OUTPUT ----------- :)
(: Pull in header data :)
for $header in //header
let $defaultPriceTypeCode := local:eval((
					$header/m185, 
					$header/defaultpricetypecode,
          /m185,
          /defaultpricetypecode), '01')
let $defaultCurrencyCode := local:eval((
					$header/m186, 
					$header/defaultcurrencycode,
          /m186,
          /defaultcurrencycode), 'USD')
let $defaultLinearUnit := local:eval((
					$header/m187, 
					$header/defaultlinearunit,
          /m187,
          /defaultlinearunit), 'in')
let $defaultWeightUnit := local:eval((
					$header/m188, 
					$header/defaultweightunit,
          /m188,
          /defaultweightunit), 'oz')

(: Pull in product detail data :)
for $product in //product
let $productRef := local:eval((
					$product/a001, 
					$product/recordreference), '')
let $PPN := local:eval(( 
					$product/productidentifier[b221 = '01' or productidtype = '01']/b244, 
					$product/productidentifier[b221 = '01' or productidtype = '01']/idvalue,
					$product/b007, 
					$product/publisherproductno), '')
let $ISBN10 := local:cleanText(local:eval(( 
					$product/productidentifier[b221 = '02' or productidtype = '02']/b244, 
					$product/productidentifier[b221 = '02' or productidtype = '02']/idvalue,
					$product/b004, 
					$product/isbn), ''))
let $ISBN13Found := local:cleanText(local:eval((
					$product/productidentifier[b221 = '03' or productidtype = '03']/b244, 
					$product/productidentifier[b221 = '03' or productidtype = '03']/idvalue, 
					$product/productidentifier[b221 = '15' or productidtype = '15']/b244, 
					$product/productidentifier[b221 = '15' or productidtype = '15']/idvalue,
					$product/b010, 
					$product/replacesisbn), ''))
let $ISBN13 := if (local:isISBN13Valid($ISBN13Found)) then
            $ISBN13Found
          else
            local:ISBN10To13($ISBN10)
let $EAN13 := local:cleanText(local:eval((
					$product/b005, 
					$product/ean1), ''))
let $UPC := local:eval((
					$product/b006, 
					$product/upc, 
					$product/productidentifier[b221 = '04' or productidtype = '04']/b244, 
					$product/productidentifier[b221 = '04' or productidtype = '04']/idvalue), '')
let $ISMN := local:eval((
					$product/b008, 
					$product/ismn, 
					$product/productidentifier[b221 = '05' or productidtype = '05']/b244, 
					$product/productidentifier[b221 = '05' or productidtype = '05']/idvalue), '')
let $DOI := local:eval((
					$product/b009, 
					$product/doi, 
					$product/productidentifier[b221 = '06' or productidtype = '06']/b244, 
					$product/productidentifier[b221 = '06' or productidtype = '06']/idvalue), '')
let $LCCN := local:eval((
					$product/productidentifier[b221 = '13' or productidtype = '13']/b244, 
					$product/productidentifier[b221 = '13' or productidtype = '13']/idvalue), '')
let $GTIN14 := local:eval((
					$product/productidentifier[b221 = '14' or productidtype = '14']/b244, 
					$product/productidentifier[b221 = '14' or productidtype = '14']/idvalue), '')
let $publisher := local:eval(( 
					$product/publisher/b08, 
					$product/publisher/publishername,
					$product/b081, 
					$product/publishername), '')
let $format := local:eval((
					$product/b012, 
					$product/productform), '')
let $formDetail := fn:string-join(($product/b333/text(), $product/productformdetail/text()), '|')
let $formatDescription := local:eval((
					$product/b014, 
					$product/productformdescription), '')
let $seriesTitle := local:eval((
					$product/series/b018, 
					$product/series/titleofseries, 
					$product/series/title/b203,
					$product/series/title/titletext), '')
let $seriesTitleNoPrefix := local:eval((
					$product/series/title/b031,
					$product/series/title/TitleWithoutPrefix), '')
let $seriesTitlePrefix := local:eval((
					$product/series/title/b030,
					$product/series/title/TitlePrefix), '')
let $title := local:eval(( 
					$product/title/b203, 
					$product/title/titletext,
					$product/b028, 
					$product/distinctivetitle), '')
let $titleNoPrefix := local:eval((
					$product/title/b031, 
					$product/title/TitleWithoutPrefix), '')
let $titlePrefix := local:eval((
					$product/title/b030, 
					$product/title/TitlePrefix), '')
let $subtitle := local:eval(( 
					$product/title/b029, 
					$product/title/subtitle,
					$product/b029, 
					$product/subtitle), '')
let $tTitle := local:stripArticles($title)
let $nptTitle := local:cleanText($title)
let $npSubtitle := local:cleanText($subtitle)
let $npSeriesTitle := local:cleanText($seriesTitle)
let $author := local:evalContributor($product/contributor, ('a01', 'a02', 'a03', 'a04', 'a05', 'a06', 'a07', 'a08', 'a09'))
let $illustrator := local:evalContributor($product/contributor, ('a12'))
let $translator := local:evalContributor($product/contributor, ('b06'))
let $bisac := local:evalAll((
					$product/j137, 
					$product/suppliername,
					$product/b064, 
					$product/basicmainsubject, 
					$product/subject[b067 = '10' or subjectschemeidentifier = '10']/b069, 
					$product/subject[b067 = '10' or subjectschemeidentifier = '10']/subjectcode, 
					$product/subject[b067 = '10' or subjectschemeidentifier = '10']/b064, 
					$product/subject[b067 = '10' or subjectschemeidentifier = '10']/basicmainsubject, 
					$product/subject[b067 = '22' or subjectschemeidentifier = '22']/b069, 
					$product/subject[b067 = '22' or subjectschemeidentifier = '22']/subjectcode, 
					$product/subject[b067 = '22' or subjectschemeidentifier = '22']/b064, 
					$product/subject[b067 = '22' or subjectschemeidentifier = '22']/basicmainsubject), ' ', '')
let $edition := local:eval(($product/b058, $product/editionstatement), '')
let $description := local:evalAll((
					$product/othertext/d104,
					$product/othertext/text), '<hr>', '')
let $imprint := local:eval((
					$product/imprint/b079, 
					$product/imprint/imprintname), '')
let $copyright := if (local:eval(($product/copyrightstatement/b079, $product/copyrightstatement/imprintname), '') != '') then
					local:eval(($product/copyrightstatement/b079, $product/copyrightstatement/imprintname), '')
				  else
					local:eval(($product/b087, $product/b087), '')
let $height := local:eval((
					$product/measure[c093 = '01' or measuretypecode = '01']/c094,
					$product/measure[c093 = '01' or measuretypecode = '01']/measurement), '')
let $width := local:eval((
					$product/measure[c093 = '02' or measuretypecode = '02']/c094,
					$product/measure[c093 = '02' or measuretypecode = '02']/measurement), '')
let $depth := local:eval((
					$product/measure[c093 = '03' or measuretypecode = '03']/c094,
					$product/measure[c093 = '03' or measuretypecode = '03']/measurement), '')
let $weight := local:eval((
					$product/measure[c093 = '08' or measuretypecode = '08']/c094,
					$product/measure[c093 = '08' or measuretypecode = '08']/measurement), '')
let $dimensionsUM := local:eval((
					$product/measure[c093 = '01' or measuretypecode = '01']/c095,
					$product/measure[c093 = '01' or measuretypecode = '01']/measureunitcode), '')
let $weightUM := local:eval((
					$product/measure[c093 = '08' or measuretypecode = '08']/c095,
					$product/measure[c093 = '08' or measuretypecode = '08']/measureunitcode), '')
let $supplier := local:eval((
					$product/supplydetail/j137,
					$product/supplydetail/suppliername,
					$product/j137, 
					$product/suppliername), '')
let $availability := local:eval((
					$product/supplydetail/j396,
					$product/supplydetail/j141,
					$product/supplydetail/productavailability,
					$product/supplydetail/availabilitycode), '')
let $expected := local:eval((
					$product/supplydetail/j142,
					$product/supplydetail/expectedshipdate), '')
let $caseQty := local:eval((
					$product/supplydetail/j145,
					$product/supplydetail/packquantity), '')
let $priceNode := local:evalPrice($product/supplydetail)
let $netPriceNode := local:evalNetPrice($product/supplydetail)
let $unadjustedPrice := local:eval((
					$priceNode/j151,
					$priceNode/priceamount), '')
let $price := if (local:eval(($priceNode/j148, $priceNode/pricetypecode), '') = '05') then 
				xs:decimal($unadjustedPrice) / 0.75
			  else
				$unadjustedPrice
let $priceTypeCode := local:eval((
					$priceNode/j148,
					$priceNode/pricetypecode), '')
let $denomination := local:eval((
					$priceNode/j152,
					$priceNode/currencycode), '')
let $netPrice := if (count($netPriceNode) > 0) then
										local:eval((
											$netPriceNode/j151,
											$netPriceNode/priceamount), '')
                 else if (xs:decimal($priceTypeCode) = 11) then
					          xs:decimal($price) / 0.75
                 else 
                     ''
let $deducedPrice := ''
return
<record>
<header>
  <defaultPriceTypeCode>{$defaultPriceTypeCode}</defaultPriceTypeCode>
  <defaultCurrencyCode>{$defaultCurrencyCode}</defaultCurrencyCode>
  <defaultLinearUnit>{$defaultLinearUnit}</defaultLinearUnit>
  <defaultWeightUnit>{$defaultWeightUnit}</defaultWeightUnit>
</header>
<product>
  <ONIXProductRef type="decimal">{$productRef}</ONIXProductRef>
  <PPN type="varchar">{$PPN}</PPN>
  <ISBN10 type="varchar">{$ISBN10}</ISBN10>
  <ISBN13 type="varchar">{$ISBN13}</ISBN13>
  <ISBN13Found type="varchar" ignore="true">{$ISBN13Found}</ISBN13Found>
  <EAN13 type="varchar">{$EAN13}</EAN13>
  <UPC type="varchar">{$UPC}</UPC>
  <ISMN type="varchar">{$ISMN}</ISMN>
  <DOI type="varchar">{$DOI}</DOI>
  <LCCN type="varchar">{$LCCN}</LCCN>
  <GTIN14 type="varchar">{$GTIN14}</GTIN14>
  <publisher type="varchar" ignore="true">{$publisher}</publisher>
  <format type="char">{$format}</format>
  <formDetail type="varchar">{$formDetail}</formDetail>
  <formatDescription type="varchar">{$formatDescription}</formatDescription>
  <seriesTitle type="varchar">{$seriesTitle}</seriesTitle>
  <seriesTitleNoPrefix type="varchar" ignore="true">{$seriesTitleNoPrefix}</seriesTitleNoPrefix>
  <seriesTitlePrefix type="varchar" ignore="true">{$seriesTitlePrefix}</seriesTitlePrefix>
  <title type="varchar">{$title}</title>
  <titleNoPrefix type="varchar" ignore="true">{$titleNoPrefix}</titleNoPrefix>
  <titlePrefix type="varchar" ignore="true">{$titlePrefix}</titlePrefix>
  <tTitle type="varchar">{$tTitle}</tTitle>
  <nptTitle type="varchar">{$nptTitle}</nptTitle>
  <npSubtitle type="varchar">{$npSubtitle}</npSubtitle>
  <npSeriesTitle type="varchar">{$npSeriesTitle}</npSeriesTitle>
  <author type="varchar">{$author}</author>
  <illustrator type="varchar">{$illustrator}</illustrator>
  <translator type="varchar">{$translator}</translator>
  <bisac type="varchar">{$bisac}</bisac>
  <edition type="varchar">{$edition}</edition>
  <descriptions type="text">{$description}</descriptions>
  <imprint type="varchar">{$imprint}</imprint>
  <copyright type="varchar">{$copyright}</copyright>
  <height type="decimal">{$height}</height>
  <width type="decimal">{$width}</width>
  <depth type="decimal">{$depth}</depth>
  <weight type="decimal">{$weight}</weight>
  <dimensionsUM type="varchar">{$dimensionsUM}</dimensionsUM>
  <weightUM type="varchar">{$weightUM}</weightUM>
  <supplier type="varchar">{$supplier}</supplier>
  <availability type="varchar">{$availability}</availability>
  <expected type="int">{$expected}</expected>
  <caseQty type="int">{$caseQty}</caseQty>
  <price type="varchar">{$price}</price>
  <netPrice type="varchar">{$netPrice}</netPrice>
  <deducedPrice type="bit">{$deducedPrice}</deducedPrice>
  <priceTypeCode type="varchar" ignore="true">{$priceTypeCode}</priceTypeCode>
  <denomination type="varchar">{$denomination}</denomination>
  <stockedBy type="int">0</stockedBy>
</product>
</record>
