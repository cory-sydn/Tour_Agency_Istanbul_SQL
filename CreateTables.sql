/* Create database */
CREATE DATABASE [Istanbul Tour Agency];
GO

USE TourCompany;
GO

CREATE TABLE Guide(
    GuideID INT IDENTITY(1,1) PRIMARY KEY,
    GuideName NVARCHAR(20) NULL,
    GuideSurname NVARCHAR(40) NULL,
    Gender NVARCHAR(5),
    Phone NVARCHAR(15),
)

CREATE TABLE GuideLanguage(
	LanguageName NVARCHAR(20) NULL,
	GuideID INT NULL,
    CONSTRAINT [FK_GuideLanguage_Guide] FOREIGN KEY ([GuideID]) REFERENCES [dbo].[Guide] ([GuideID]),
)

CREATE TABLE Tourist (
    TouristID INT IDENTITY(1,1) PRIMARY KEY,
    TouristName NVARCHAR(20),
    TouristSurname NVARCHAR(40),
    Gender NVARCHAR(10),
    BirthDate DATETIME,
    Nationality NVARCHAR(15),
    ComesFrom NVARCHAR(30),
	NewTourist BIT
)

ALTER TABLE Tourist
ADD CONSTRAINT df_NewTourist
DEFAULT 1 FOR NewTourist


CREATE TABLE Area(
    AreaID INT IDENTITY(1,1) PRIMARY KEY,
    AreaName NVARCHAR(30),
	AreaPrice DECIMAL(18,2) CHECK([AreaPrice] >= 20)
)

CREATE TABLE Tour(
    TourID INT IDENTITY(1,1) PRIMARY KEY,
    TourName NVARCHAR(150),
    TourPrice DECIMAL(18,2)
)

CREATE TABLE TourAreaDetail(
    TourID INT NOT NULL,
    AreaID INT NOT NULL
    CONSTRAINT [FK_TourAreaDetail_Tur] FOREIGN KEY ([TourID]) REFERENCES [dbo].[Tour] ([TourID]),
    CONSTRAINT [FK_TourAreaDetail_Area] FOREIGN KEY ([AreaID]) REFERENCES [dbo].[Area] ([AreaID]),
	CONSTRAINT [CPK_TourAreaDetail] PRIMARY KEY (TourID, AreaID)
)

CREATE TABLE TourSale(
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    TouristID INT NOT NULL,
    GuideID INT,
    CONSTRAINT [FK_TourSale_Tourist] FOREIGN KEY ([TouristID]) REFERENCES [dbo].[Tourist] ([TouristID]),
    CONSTRAINT [FK_TourSale_Guide] FOREIGN KEY ([GuideID]) REFERENCES [dbo].[Guide] ([GuideID])
)

CREATE TABLE SaleDetail(
	SaleID INT NOT NULL,
    TourID INT NOT NULL,
	TourDate DATETIME,
    CONSTRAINT [FK_SaleDetail_TourSale] FOREIGN KEY ([SaleID]) REFERENCES [dbo].[TourSale] ([SaleID]),
    CONSTRAINT [FK_SaleDetail_Tur] FOREIGN KEY ([TourID]) REFERENCES [dbo].[Tour] ([TourID]),
	CONSTRAINT [CPK_SaleDetail] PRIMARY KEY (SaleID, TourID)
)

CREATE TABLE Invoice(
    InvoiceNo NVARCHAR(14) NOT NULL,
	SaleID INT NOT NULL,
    TourID INT,
    TouristID INT,
	TouristFullName NVARCHAR(60),
    InvoiceDate DATETIME NULL,
    Discount DECIMAL(18,2) DEFAULT (0),
    TotalPrice DECIMAL(18,2) NULL,
    CONSTRAINT [FK_Invoice_Tur] FOREIGN KEY ([TourID]) REFERENCES [dbo].[Tour] ([TourID]),
    CONSTRAINT [FK_Invoice_Tourist] FOREIGN KEY ([TouristID]) REFERENCES [dbo].[Tourist] ([TouristID]),
    CONSTRAINT [FK_Invoice_TourSale] FOREIGN KEY ([SaleID]) REFERENCES [dbo].[TourSale] ([SaleID])
)


-- Adding composite primary key to GuideLanguage table
ALTER TABLE GuideLanguage
ALTER COLUMN LanguageName NVARCHAR(20) NOT NULL

ALTER TABLE GuideLanguage
ALTER COLUMN GuideID INT NOT NULL

ALTER TABLE GuideLanguage
ADD CONSTRAINT CPK_GuideLanguage
PRIMARY KEY (LanguageName, GuideID)



-------------------------- TEST   ----------------------------------

CREATE TABLE TestTourSale(
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    TouristID INT NOT NULL,
    GuideID INT,
    CONSTRAINT [FK_TestTourSale_Tourist] FOREIGN KEY ([TouristID]) REFERENCES [dbo].[Tourist] ([TouristID]),
    CONSTRAINT [FK_TestTourSale_Guide] FOREIGN KEY ([GuideID]) REFERENCES [dbo].[Guide] ([GuideID])
)


CREATE TABLE TestSaleDetail(
	SaleID INT NOT NULL,
    TourID INT NOT NULL,
	TourDate DATETIME,
    CONSTRAINT [FK_TestSaleDetail_TestTourSale] FOREIGN KEY ([SaleID]) REFERENCES [dbo].[TestTourSale] ([SaleID]),
    CONSTRAINT [FK_TestSaleDetail_Tur] FOREIGN KEY ([TourID]) REFERENCES [dbo].[Tour] ([TourID]),
	CONSTRAINT [CPK_TestSaleDetail] PRIMARY KEY (SaleID, TourID)
)

CREATE TABLE TestInvoice(
    InvoiceNo NVARCHAR(14) NOT NULL,
	SaleID INT NOT NULL,
    TourID INT,
    TouristID INT,
	TouristFullName NVARCHAR(60),
    InvoiceDate DATETIME NULL,
    Discount DECIMAL(18,2) DEFAULT (0),
    TotalPrice DECIMAL(18,2) NULL,
    CONSTRAINT [FK_TestInvoice_Tur] FOREIGN KEY ([TourID]) REFERENCES [dbo].[Tour] ([TourID]),
    CONSTRAINT [FK_TestInvoice_Tourist] FOREIGN KEY ([TouristID]) REFERENCES [dbo].[Tourist] ([TouristID]),
    CONSTRAINT [FK_TestInvoice_TestTourSale] FOREIGN KEY ([SaleID]) REFERENCES [dbo].[TestTourSale] ([SaleID])
)
