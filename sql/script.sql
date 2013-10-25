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

CREATE TABLE `availabilitystatuscode` (
  `id` char(5) NOT NULL,
  `Description` varchar(60) NOT NULL,
  `active` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `productformat` (
  `id` char(2) NOT NULL,
  `Description` varchar(60) NOT NULL,
  `visible` bit(1) DEFAULT NULL,
  `categoryBitMask` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO onix.availabilitystatuscode (id, description, active) values ('01   ', 'Cancelled', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('10   ', 'Not yet available', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('11   ', 'Awaiting stock', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('20   ', 'Available', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('21   ', 'In stock', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('22   ', 'To order', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('23   ', 'Manufactured on demand', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('30   ', 'Temporarily unavailable', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('31   ', 'Out of stock', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('32   ', 'Reprinting', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('33   ', 'Awaiting reissue', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('40   ', 'Not available', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('41   ', 'Replaced by new product', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('42   ', 'Other format available', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('43   ', 'No longer supplied by us', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('44   ', 'Apply direct', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('45   ', 'Not sold separately', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('46   ', 'Withdrawn from sale', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('47   ', 'Remaindered', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('99   ', 'Uncertain', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('AB   ', 'Cancelled', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('AD   ', 'Available direct from publisher only.', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('CS   ', 'Availability uncertain.', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('EX   ', 'No longer stocked by us.', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('IP   ', 'Available', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('MD   ', 'Manufactured on demand.', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('NP   ', 'Not yet published.', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('NY   ', 'Newly catalogued, not yet in stock.', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('OF   ', 'Other format available.', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('OI   ', 'Out of stock indefinitely.', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('OP   ', 'Out of print. Discontinued', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('OR   ', 'Replaced by new edition.', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('PP   ', 'Publication postponed indefinitely.', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('RF   ', 'Refer to another supplier.', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('RM   ', 'Remaindered', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('RP   ', 'Reprinting', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('RU   ', 'Reprinting, undated', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('TO   ', 'Special order.', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('TP   ', 'Temporarily out of stock because publisher cannot supply.', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('TU   ', 'Temporarily unavailable.', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('UR   ', 'Unavailable, awaiting reissue.', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('WR   ', 'Will be remaindered as of (date)', 1);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('WS   ', 'Withdrawn from sale.', 0);
INSERT INTO onix.availabilitystatuscode (id, description, active) values ('--   ', 'Availability uncertain.', 1);

INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('00', 'Undefined', 0, 32);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('AA', 'Audio', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('AB', 'Audio cassette', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('AC', 'CD-Audio', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('AD', 'DAT', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('AE', 'Audio disk', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('AF', 'Audio tape', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('AG', 'MiniDisc', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('AH', 'CD-Extra', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('AI', 'DVD Audio  ', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('AJ', 'Downloadable audio file', 0, 12);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('AZ', 'Other audio format', 0, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('BA', 'Book', 1, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('BB', 'Hardback', 1, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('BC', 'Paperback', 1, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('BD', 'Loose-leaf', 1, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('BE', 'Spiral bound', 1, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('BF', 'Pamphlet', 1, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('BG', 'Leather / fine binding  ', 1, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('BH', 'Board book', 1, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('BI', 'Rag book', 1, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('BJ', 'Bath book', 1, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('BK', 'Novelty book', 1, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('BL', 'Slide bound', 1, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('BM', 'Big book', 1, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('BZ', 'Other book format', 0, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('CA', 'Sheet map', 1, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('CB', 'Sheet map, folded', 1, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('CC', 'Sheet map, flat', 1, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('CD', 'Sheet map, rolled', 1, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('CE', 'Globe', 1, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('CZ', 'Other cartographic', 0, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('DA', 'Digital', 1, 12);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('DB', 'CD-ROM', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('DC', 'CD-I', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('DD', 'DVD', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('DE', 'Game cartridge', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('DF', 'Diskette', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('DG', 'Electronic book text', 0, 9);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('DH', 'Online resource', 1, 8);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('DI', 'DVD-ROM', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('DZ', 'Other digital', 0, 8);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('FA', 'Film or transparency', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('FB', 'Film', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('FC', 'Slides', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('FD', 'OHP transparencies', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('FE', 'Filmstrip', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('FF', 'Film', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('FZ', 'Other film or transparency', 0, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('MA', 'Microform', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('MB', 'Microfiche', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('MC', 'Microfilm', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('MZ', 'Other microform', 0, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PA', 'Miscellaneous print', 1, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PB', 'Address book', 1, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PC', 'Calendar', 1, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PD', 'Cards Cards', 1, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PE', 'Copymasters', 1, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PF', 'Diary', 1, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PG', 'Frieze', 1, 32);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PH', 'Kit', 1, 32);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PI', 'Sheet music', 1, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PJ', 'Postcard book or pack  ', 1, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PK', 'Poster', 1, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PL', 'Record book', 1, 1);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PM', 'Wallet', 1, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PN', 'Pictures or photographs  ', 1, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PO', 'Wallchart  ', 1, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PP', 'Stickers  ', 1, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('PZ', 'Other printed item', 0, 2);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('VA', 'Video', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('VB', 'Video, VHS, PAL', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('VC', 'Video, VHS, NTSC', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('VD', 'Video, Betamax, PAL', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('VE', 'Video, Betamax, NTSC', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('VF', 'Videodisk', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('VG', 'Video, VHS, SECAM', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('VH', 'Video, Betamax, SECAM', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('VI', 'DVD video', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('VJ', 'VHS video', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('VK', 'Betamax video', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('VZ', 'Other video format', 0, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('WW', 'Mixed media product', 1, 4);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('WX', 'Quantity pack', 1, 32);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('XA', 'Trade-only material', 1, 32);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('XB', 'Dumpbin û empty  ', 0, 16);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('XC', 'Dumpbin û filled Dumpbin with contents ', 0, 16);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('XD', 'Counterpack û empty  ', 1, 16);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('XE', 'Counterpack û filled', 1, 16);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('XF', 'Poster, promotional', 1, 18);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('XG', 'Shelf strip  ', 1, 16);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('XH', 'Window piece ', 1, 16);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('XI', 'Streamer  ', 1, 16);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('XJ', 'Spinner  ', 1, 16);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('XK', 'Large book display', 1, 16);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('XL', 'Shrink-wrapped pack', 1, 32);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('XZ', 'Other point of sale ', 0, 16);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('ZA', 'General merchandise ', 0, 16);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('ZB', 'Doll  ', 1, 32);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('ZC', 'Soft toy', 1, 32);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('ZD', 'Toy  ', 1, 32);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('ZE', 'Game', 1, 32);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('ZF', 'T-shirt  ', 1, 48);
INSERT INTO onix.productformat (id, description, visible, categoryBitMask) values ('ZZ', 'Other merchandise', 0, 32);

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
					pmf.`Format` = 
						CASE WHEN EXISTS (SELECT id FROM onix.productformat WHERE id = `Format`)
						THEN `Format` 
						ELSE '--'
						END,
					pmf.`FormDetail` = pmfs.FormDetail,
					pmf.`FormatDescription` = pmfs.FormatDescription,
					pmf.`Availability` = 
						CASE WHEN EXISTS (SELECT id FROM availabilitystatuscode WHERE id = `Availability`)
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
					CASE WHEN EXISTS (SELECT id FROM onix.productformat WHERE id = `Format`)
					THEN `Format` 
					ELSE '--'
					END,
					`FormDetail`,
					`FormatDescription`,
					CASE WHEN EXISTS (SELECT id FROM onix.availabilitystatuscode WHERE id = `Availability`)
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