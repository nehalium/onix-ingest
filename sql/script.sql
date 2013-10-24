CREATE TABLE `productmasterfile` (
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
