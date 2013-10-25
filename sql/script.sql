CREATE TABLE onix.`productmasterfile` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ONIXProductRef` decimal(18,0) DEFAULT NULL,
  `PPN` varchar(50) DEFAULT NULL,
  `ISBN10` varchar(10) DEFAULT NULL,
  `RevISBN10` varchar(10) DEFAULT NULL,
  `ISBN13` varchar(13) DEFAULT NULL,
  `RevISBN13` varchar(13) DEFAULT NULL,
  `EAN13` varchar(13) DEFAULT NULL,
  `UPC` varchar(20) DEFAULT NULL,
  `ISMN` varchar(13) DEFAULT NULL,
  `DOI` varchar(50) DEFAULT NULL,
  `LCCN` varchar(50) DEFAULT NULL,
  `GTIN14` varchar(14) DEFAULT NULL,
  `Title` varchar(500) DEFAULT NULL,
  `SubTitle` varchar(500) DEFAULT NULL,
  `SeriesTitle` varchar(500) DEFAULT NULL,
  `TTitle` varchar(500) DEFAULT NULL,
  `NPTTitle` varchar(500) DEFAULT NULL,
  `NPSubTitle` varchar(500) DEFAULT NULL,
  `NPSeriesTitle` varchar(500) DEFAULT NULL,
  `Author` varchar(1000) DEFAULT NULL,
  `Illustrator` varchar(1000) DEFAULT NULL,
  `Translator` varchar(1000) DEFAULT NULL,
  `Imprint` varchar(100) DEFAULT NULL,
  `Supplier` varchar(100) DEFAULT NULL,
  `Copyright` varchar(32) DEFAULT NULL,
  `Edition` varchar(512) DEFAULT NULL,
  `CaseQty` int(11) DEFAULT NULL,
  `Height` decimal(18,0) DEFAULT NULL,
  `Width` decimal(18,0) DEFAULT NULL,
  `Depth` decimal(18,0) DEFAULT NULL,
  `DimensionsUM` varchar(5) DEFAULT NULL,
  `Weight` decimal(18,0) DEFAULT NULL,
  `WeightUM` varchar(5) DEFAULT NULL,
  `Format` char(2) DEFAULT NULL,
  `FormDetail` varchar(500) DEFAULT NULL,
  `FormatDescription` varchar(200) DEFAULT NULL,
  `Availability` varchar(5) DEFAULT NULL,
  `Expected` int(11) DEFAULT NULL,
  `Price` varchar(8) DEFAULT NULL,
  `NetPrice` varchar(8) DEFAULT NULL,
  `Denomination` varchar(3) DEFAULT NULL,
  `Opened` datetime DEFAULT NULL,
  `Updated` datetime DEFAULT NULL,
  `Descriptions` text,
  `StockedBy` int(11) DEFAULT NULL,
  `deducedPrice` bit(1) DEFAULT NULL,
  `supplierOfOrigin` varchar(100) DEFAULT NULL,
  `bisac` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `productmasterfile_stage` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ONIXProductRef` decimal(18,0) DEFAULT NULL,
  `PPN` varchar(50) DEFAULT NULL,
  `ISBN10` varchar(10) DEFAULT NULL,
  `ISBN13` varchar(13) DEFAULT NULL,
  `EAN13` varchar(13) DEFAULT NULL,
  `UPC` varchar(20) DEFAULT NULL,
  `ISMN` varchar(13) DEFAULT NULL,
  `DOI` varchar(50) DEFAULT NULL,
  `LCCN` varchar(50) DEFAULT NULL,
  `GTIN14` varchar(14) DEFAULT NULL,
  `Title` varchar(500) DEFAULT NULL,
  `SubTitle` varchar(500) DEFAULT NULL,
  `SeriesTitle` varchar(500) DEFAULT NULL,
  `TTitle` varchar(500) DEFAULT NULL,
  `NPTTitle` varchar(500) DEFAULT NULL,
  `NPSubTitle` varchar(500) DEFAULT NULL,
  `NPSeriesTitle` varchar(500) DEFAULT NULL,
  `Author` varchar(1000) DEFAULT NULL,
  `Illustrator` varchar(1000) DEFAULT NULL,
  `Translator` varchar(1000) DEFAULT NULL,
  `Imprint` varchar(100) DEFAULT NULL,
  `Supplier` varchar(100) DEFAULT NULL,
  `Copyright` varchar(32) DEFAULT NULL,
  `Edition` varchar(512) DEFAULT NULL,
  `CaseQty` int(11) DEFAULT NULL,
  `Height` decimal(18,0) DEFAULT NULL,
  `Width` decimal(18,0) DEFAULT NULL,
  `Depth` decimal(18,0) DEFAULT NULL,
  `DimensionsUM` varchar(5) DEFAULT NULL,
  `Weight` decimal(18,0) DEFAULT NULL,
  `WeightUM` varchar(5) DEFAULT NULL,
  `Format` char(2) DEFAULT NULL,
  `FormDetail` varchar(500) DEFAULT NULL,
  `FormatDescription` varchar(200) DEFAULT NULL,
  `Availability` varchar(5) DEFAULT NULL,
  `Expected` int(11) DEFAULT NULL,
  `Price` varchar(8) DEFAULT NULL,
  `NetPrice` varchar(8) DEFAULT NULL,
  `Denomination` varchar(3) DEFAULT NULL,
  `Opened` datetime DEFAULT NULL,
  `Updated` datetime DEFAULT NULL,
  `Descriptions` text,
  `StockedBy` int(11) DEFAULT NULL,
  `deducedPrice` bit(1) DEFAULT NULL,
  `supplierOfOrigin` varchar(100) DEFAULT NULL,
  `bisac` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2389 DEFAULT CHARSET=utf8;


DELIMITER $$
CREATE PROCEDURE `spCommitProductMasterFile`()
BEGIN

	#Update existing records, then insert new ones

		UPDATE 		`onix`.`productmasterfile` pmf,
				(
					SELECT	
							`ONIXProductRef`,
							`PPN`,
							`ISBN10`,
							`ISBN13`,
							`EAN13`,
							`UPC`,
							`ISMN`,
							`DOI`,
							`LCCN`,
							`GTIN14`,
							`Title`,
							`SubTitle`,
							`SeriesTitle`,
							`TTitle`,
							`NPTTitle`,
							`NPSubTitle`,
							`NPSeriesTitle`,
							`Author`,
							`Illustrator`,
							`Translator`,
							`Imprint`,
							`Supplier`,
							`Copyright`,
							`Edition`,
							`CaseQty`,
							`Height`,
							`Width`,
							`Depth`,
							`DimensionsUM`,
							`Weight`,
							`WeightUM`,
							`Format`,
							`FormDetail`,
							`FormatDescription`,
							`Availability`,
							`Expected`,
							`Price`,
							`NetPrice`,
							`Denomination`,
							`Opened`,
							`Updated`,
							`Descriptions`,
							`StockedBy`,
							`deducedPrice`,
							`supplierOfOrigin`,
							`bisac`
					FROM	`onix`.`productmasterfile_stage` pmfs_derived
					WHERE	pmfs_derived.id = id
				) pmfs

		SET
					pmf.`ONIXProductRef` = pmfs.ONIXProductRef,
					pmf.`PPN` = pmfs.PPN,
					pmf.`ISBN10` = pmfs.ISBN10,
					pmf.`RevISBN10` = REVERSE(pmfs.ISBN10),
					pmf.`ISBN13` = pmfs.ISBN13,
					pmf.`RevISBN13` = REVERSE(pmfs.ISBN13),
					pmf.`EAN13` = pmfs.EAN13,
					pmf.`UPC` = pmfs.UPC,
					pmf.`ISMN` = pmfs.ISMN,
					pmf.`DOI` = pmfs.DOI,
					pmf.`LCCN` = pmfs.LCCN,
					pmf.`GTIN14` = pmfs.GTIN14,
					pmf.`Title` = pmfs.Title,
					pmf.`SubTitle` = pmfs.SubTitle,
					pmf.`SeriesTitle` = pmfs.SeriesTitle,
					pmf.`TTitle` = pmfs.TTitle,
					pmf.`NPTTitle` = pmfs.NPTTitle,
					pmf.`NPSubTitle` = pmfs.NPSubTitle,
					pmf.`NPSeriesTitle` = pmfs.NPSeriesTitle,
					pmf.`Author` = pmfs.Author,
					pmf.`Illustrator` = pmfs.Illustrator,
					pmf.`Translator` = pmfs.Translator,
					pmf.`Imprint` = pmfs.Imprint,
					pmf.`Supplier` = pmfs.Supplier,
					pmf.`Copyright` = pmfs.Copyright,
					pmf.`Edition` = pmfs.Edition,
					pmf.`CaseQty` = pmfs.CaseQty,
					pmf.`Height` = pmfs.Height,
					pmf.`Width` = pmfs.Width,
					pmf.`Depth` = pmfs.Depth,
					pmf.`DimensionsUM` = pmfs.DimensionsUM,
					pmf.`Weight` = pmfs.Weight,
					pmf.`WeightUM` = pmfs.WeightUM,
					pmf.`Format` = pmfs.Format,
					pmf.`FormDetail` = pmfs.FormDetail,
					pmf.`FormatDescription` = pmfs.FormatDescription,
					pmf.`Availability` = 
						CASE WHEN EXISTS (SELECT id FROM AvailabilityStatusCode WHERE id = `Availability`)
						THEN `Availability` 
						ELSE '--'
						END,
					pmf.`Expected` = pmfs.Expected,
					pmf.`Price` = pmfs.Price,
					pmf.`NetPrice` = pmfs.NetPrice,
					pmf.`Denomination` = pmfs.Denomination,
					pmf.`Opened` = pmfs.Opened,
					pmf.`Updated` = pmfs.Updated,
					pmf.`Descriptions` = pmfs.Descriptions,
					pmf.`StockedBy` = 0,
						#CASE WHEN EXISTS (
						#	SELECT	ISBN
						#	FROM	adamsbook..StockItems
						#	WHERE	ISBN = `ISBN10`	
						#	OR		ISBN = `ISBN13`
						#)
						#THEN 1 
						#ELSE 0
						#END,
					pmf.`deducedPrice` = pmfs.deducedPrice,
					pmf.`supplierOfOrigin` = pmfs.supplierOfOrigin,
					pmf.`bisac` = pmfs.bisac
		WHERE 
					`id` = (
						SELECT 	p.id 
						FROM 	onix.productmasterfile p
						WHERE	p.ISBN13 = pmfs.ISBN13
						OR		p.ISBN10 = pmfs.ISBN10
						OR 		p.EAN13 = pmfs.EAN13
						OR 		p.ISMN = pmfs.ISMN
						OR 		p.PPN = pmfs.PPN
					);

		INSERT INTO `onix`.`productmasterfile` (

					`ONIXProductRef`,
					`PPN`,
					`ISBN10`,
					`RevISBN10`,
					`ISBN13`,
					`RevISBN13`,
					`EAN13`,
					`UPC`,
					`ISMN`,
					`DOI`,
					`LCCN`,
					`GTIN14`,
					`Title`,
					`SubTitle`,
					`SeriesTitle`,
					`TTitle`,
					`NPTTitle`,
					`NPSubTitle`,
					`NPSeriesTitle`,
					`Author`,
					`Illustrator`,
					`Translator`,
					`Imprint`,
					`Supplier`,
					`Copyright`,
					`Edition`,
					`CaseQty`,
					`Height`,
					`Width`,
					`Depth`,
					`DimensionsUM`,
					`Weight`,
					`WeightUM`,
					`Format`,
					`FormDetail`,
					`FormatDescription`,
					`Availability`,
					`Expected`,
					`Price`,
					`NetPrice`,
					`Denomination`,
					`Opened`,
					`Updated`,
					`Descriptions`,
					`StockedBy`,
					`deducedPrice`,
					`supplierOfOrigin`,
					`bisac`)
		SELECT		
					`ONIXProductRef`,
					`PPN`,
					`ISBN10`,
					REVERSE(`ISBN10`),
					`ISBN13`,
					REVERSE(`ISBN13`),
					`EAN13`,
					`UPC`,
					`ISMN`,
					`DOI`,
					`LCCN`,
					`GTIN14`,
					`Title`,
					`SubTitle`,
					`SeriesTitle`,
					`TTitle`,
					`NPTTitle`,
					`NPSubTitle`,
					`NPSeriesTitle`,
					`Author`,
					`Illustrator`,
					`Translator`,
					`Imprint`,
					`Supplier`,
					`Copyright`,
					`Edition`,
					`CaseQty`,
					`Height`,
					`Width`,
					`Depth`,
					`DimensionsUM`,
					`Weight`,
					`WeightUM`,
					CASE WHEN EXISTS (SELECT id FROM onix.ProductFormat WHERE id = `Format`)
					THEN `Format` 
					ELSE '--'
					END,
					`FormDetail`,
					`FormatDescription`,
					CASE WHEN EXISTS (SELECT id FROM onix.AvailabilityStatusCode WHERE id = `Availability`)
					THEN `Availability` 
					ELSE '--'
					END,
					`Expected`,
					`Price`,
					`NetPrice`,
					`Denomination`,
					`Opened`,
					`Updated`,
					`Descriptions`,
					0, #CASE WHEN EXISTS (
					#	SELECT	ISBN
					#	FROM	adamsbook..StockItems
					#	WHERE	ISBN = `ISBN10`	
					#	OR		ISBN = `ISBN13`
					#)
					#THEN 1 
					#ELSE 0
					#END,
					`deducedPrice`,
					`supplierOfOrigin`,
					`bisac`
		FROM 		
					`onix`.`productmasterfile_stage`
		WHERE
					ISBN13 NOT IN (SELECT ISBN13 FROM onix.productmasterfile)
		and			ISBN10 NOT IN (SELECT ISBN10 FROM onix.productmasterfile)
		and			EAN13 NOT IN (SELECT EAN13 FROM onix.productmasterfile)
		and			ISMN NOT IN (SELECT ISMN FROM onix.productmasterfile)
		and			PPN NOT IN (SELECT PPN FROM onix.productmasterfile);

END