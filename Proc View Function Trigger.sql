---- Guide ekle
GO
CREATE PROC sp_GuideEkle
(
	@firstName AS NVARCHAR(20),
    @lastName AS NVARCHAR(40),
    @Gender AS NVARCHAR(5),
    @Phone AS NVARCHAR(15)
)
AS
BEGIN
    INSERT INTO Guide(GuideName, GuideSurname, Gender, Phone)
    VALUES(@firstName, @lastName, @Gender, @Phone)

END
GO
-- Guide yabanci dili ekle
-- GuideID ve LanguageName composite primary key olduklari icin ayni Guidee ayni dili iki defa tanimlamaya izin vermez
GO
CREATE PROC [sp_Insert Guide Language]
(
	@firstName AS NVARCHAR(20),
    @lastName AS NVARCHAR(40),
	@lang AS NVARCHAR(20)
)
AS
BEGIN
	DECLARE @id AS INT
	SELECT @id = GuideID
	FROM Guide
	WHERE GuideName = @firstName AND GuideSurname = @lastName

    INSERT INTO GuideLanguage(LanguageName, GuideID)
    VALUES(@lang, @id)

END
GO
--Tam Guide adi getir
GO
DROP FUNCTION IF EXISTS fn_getFullName
GO
CREATE FUNCTION fn_getFullName(@name AS NVARCHAR(20), @surname AS NVARCHAR(40))
RETURNS NVARCHAR (60)
AS
BEGIN
    RETURN @name + ' ' + @surname
END
GO
-- GuideID ile tam adını getir
GO
CREATE PROC sp_GuideIDIleTamAdıGetir
(
	@GuideID AS INT
)
AS
BEGIN
	SELECT dbo.fn_getFullName(GuideName, GuideSurname) AS GuideFullName
	FROM Guide
	WHERE GuideID = @GuideID
END

-- Guideleri diller ile birlike getirend view
GO
DROP VIEW IF EXISTS [vw_Guides & Languages]
GO
CREATE VIEW [vw_Guides & Languages]
AS
SELECT dbo.fn_getFullName(r.GuideName, r.GuideSurname) AS GuideFullName,
		y.LanguageName
FROM Guide g
JOIN GuideLanguage y ON y.GuideID = r.GuideID

GO
DROP VIEW [vw_Guide Languages Single Row]
GO
CREATE VIEW [vw_Guide Languages Single Row] AS
WITH [cte_Guide Languages Single Row]
AS
(
	SELECT GuideFullName,
			LanguageName,
			ROW_NUMBER() OVER(PARTITION BY GuideFullName ORDER BY GuideFullName) AS RowNo
	FROM [vw_Guides & Languages]
)
SELECT GuideFullName,
		STUFF((SELECT ', ' + LanguageName
				FROM [cte_Guide Languages Single Row]
				WHERE GuideFullName = cte.GuideFullName
				FOR XML PATH('')), 1, 1, '') AS Languages
FROM [cte_Guide Languages Single Row] cte
GROUP BY GuideFullName


--SELECT *
--FROM [vw_Guides & Languages]

-------------------- Tourist  ---------------------------------------------

GO
DROP PROC IF EXISTS [sp_Insert Tourist]
GO
CREATE PROC [sp_Insert Tourist]
(
	@TouristName AS NVARCHAR(20),
	@TouristSurname AS NVARCHAR(40),
	@TouristGender AS NVARCHAR(10),
	@TouristBirthDate AS DATETIME,
	@TouristNationality AS NVARCHAR(15),
	@TouristComesFrom AS NVARCHAR(30)
)
AS
BEGIN
	DECLARE @trimmedName NVARCHAR(20) = LTRIM(RTRIM(@TouristName))
    DECLARE @trimmedSurname NVARCHAR(40) = LTRIM(RTRIM(@TouristSurname))
    DECLARE @trimmedGender NVARCHAR(40) = LTRIM(RTRIM(@TouristGender))
    DECLARE @trimmeNation NVARCHAR(40) = LTRIM(RTRIM(@TouristNationality))
    DECLARE @trimmedCountry NVARCHAR(40) = LTRIM(RTRIM(@TouristComesFrom))

	INSERT Tourist
	VALUES(@trimmedName, @trimmedSurname, @trimmedGender, @TouristBirthDate, @trimmeNation, @trimmedCountry, 1)
END

GO
DROP PROC IF EXISTS [sp_Get Registered Tourist ID]
GO
CREATE PROC [sp_Get Registered Tourist ID]
(
	@TouristName AS NVARCHAR(20),
	@TouristSurname AS NVARCHAR(40),
	@TouristBirthDate AS DATETIME
)
AS
BEGIN
	DECLARE @ID INT = ( SELECT TouristID
						FROM Tourist
						WHERE TouristName = @TouristName
							AND TouristSurname = @TouristSurname
							AND @TouristBirthDate = BirthDate)
	RETURN @ID
END


GO
DROP TRIGGER IF EXISTS [sp_Registered Tourist Detection]
GO
CREATE TRIGGER [sp_Registered Tourist Detection]
ON Tourist
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @TouristName AS NVARCHAR(20)
	DECLARE @TouristSurname AS NVARCHAR(40)
	DECLARE @TouristGender AS NVARCHAR(10)
	DECLARE @TouristBirthDate AS DATETIME
	DECLARE @TouristNationality AS NVARCHAR(15)
	DECLARE @TouristComesFrom AS NVARCHAR(30)

	SELECT @TouristName = TouristName,
		   @TouristSurname = TouristSurname,
		   @TouristGender = Gender,
		   @TouristBirthDate = CAST(BirthDate AS datetime),
		   @TouristNationality = Nationality,
		   @TouristComesFrom = ComesFrom
	FROM inserted


	IF EXISTS(SELECT *
			  FROM Tourist
			  WHERE TouristName = @TouristName AND TouristSurname = @TouristSurname AND @TouristBirthDate = BirthDate)
	BEGIN
		SELECT *
		FROM Tourist
		WHERE TouristName = @TouristName AND TouristSurname = @TouristSurname AND @TouristBirthDate = BirthDate
	END
	ELSE
	BEGIN
		INSERT INTO Tourist(TouristName, TouristSurname, Gender, BirthDate, Nationality, ComesFrom, NewTourist)
		VALUES(@TouristName, @TouristSurname, @TouristGender, @TouristBirthDate, @TouristNationality, @TouristComesFrom, 1)
	END
END

-- Touristleri Yaslidan Gence sirala
GO
DROP VIEW IF EXISTS [vw_Tourists Ordered Old to Young]
GO
CREATE VIEW [vw_Tourists Ordered Old to Young]
AS
SELECT TOP 1000 *, DATEDIFF(YEAR, BirthDate, GETDATE()) AS AGE
FROM Tourist
ORDER BY DATEDIFF(YEAR, BirthDate, GETDATE()) DESC



-- Define Tour.
--1) Firstlty, Area names and prices should have inserted.
--2) After name tours and allocate min 1 area max 3 area.

-- insert Tour Area, update Tour Prices

GO
DROP PROC IF EXISTS [sp_Update Tour Price & Allocate Areas]
GO
CREATE PROC [sp_Update Tour Price & Allocate Areas]
(
	@TourID AS INT,
	@areaID AS INT
)
AS
BEGIN
	--If there is a tour sale, you can't change details of it.
	DECLARE @boughtTour AS INT = (SELECT TourID FROM Invoice WHERE TourID = @TourID )

	IF @boughtTour IS NULL
	BEGIN
		DECLARE @currentTourPrice AS DECIMAL
		DECLARE @areaPrice AS DECIMAL

		INSERT INTO TourAreaDetail(TourID, AreaID) VALUES(@TourID, @areaID)

		SELECT @currentTourPrice = TourPrice FROM Tour WHERE TourID = @TourID
		SELECT @areaPrice = AreaPrice FROM Area WHERE AreaID = @areaID

		IF @currentTourPrice IS NULL
		BEGIN
			UPDATE Tour SET TourPrice = @areaPrice WHERE TourID =  @TourID
		END
		ELSE IF @currentTourPrice IS NOT NULL
		BEGIN
			UPDATE Tour SET TourPrice = @currentTourPrice + @areaPrice WHERE TourID =  @TourID
		END
		PRINT @currentTourPrice
	END
	ELSE
	BEGIN
		PRINT 'If there is a tour sale, you can''t change details of it.'
	END
END
GO


--------------------------------------------------------------------------------
GO
DROP PROC IF EXISTS [sp_Name Tour & Enter Area]
GO
CREATE PROC [sp_Name Tour & Enter Area]
(
	@tourName AS NVARCHAR(150),
	@firstArea AS NVARCHAR(30),
	@secondArea AS NVARCHAR(30) = NULL,
	@thirdArea AS NVARCHAR(30) = NULL
)
AS
BEGIN
	DECLARE @TourID AS INT
	DECLARE @areaID AS INT

	INSERT INTO Tour(TourName)	VALUES(@tourName)

	SELECT @TourID = TourID FROM Tour WHERE TourName = @tourName

	SELECT @areaID = AreaID FROM Area WHERE AreaName = @firstArea

	EXEC [sp_Update Tour Price & Allocate Areas] @TourID, @areaID

	IF @secondArea IS NOT NULL
	BEGIN
		SELECT @areaID = AreaID FROM Area WHERE AreaName = @secondArea
		EXEC [sp_Update Tour Price & Allocate Areas] @TourID, @areaID
	END
	ELSE IF @thirdArea IS NOT NULL
	BEGIN
		SELECT @areaID = AreaID FROM Area WHERE AreaName = @thirdArea
		EXEC [sp_Update Tour Price & Allocate Areas] @TourID, @areaID
	END
END



--------------------------------------------------------------------------------
GO
CREATE PROC [sp_Add Area with Tour Name]
(
	@TourName AS NVARCHAR(150),
	@areaName AS NVARCHAR(30)
)
AS
BEGIN
	DECLARE @TourID AS INT
	SELECT @TourID = TourID FROM Tour WHERE TourName = @TourName

	DECLARE @AreaID AS INT
	SELECT @AreaID = AreaID FROM Area WHERE AreaName = @areaName

	EXEC [sp_Update Tour Price & Allocate Areas] @TourID, @AreaID
END

----------------------------------------------------------------------------------
GO
CREATE PROC [sp_Get Tour Areas]
AS
BEGIN
	SELECT Tour.TourID,
		   Tour.TourName,
		   b.AreaName
	FROM Tour Tour
	JOIN TourAreaDetail td ON td.TourID = Tour.TourID
	JOIN Area b ON b.AreaID = td.AreaID
END

--------------------------------------------------------------------------------
GO
DROP PROC IF EXISTS [sp_Delete Tour Area]
GO
CREATE PROC [sp_Delete Tour Area]
(
	@TourName AS NVARCHAR(150),
	@areaName AS NVARCHAR(30)
)
AS
BEGIN
	DECLARE @TourID AS INT
	SELECT @TourID = TourID FROM Tour WHERE TourName = @TourName

	DECLARE @AreaID AS INT
	SELECT @AreaID = AreaID FROM Area WHERE AreaName = @areaName

	IF @TourID IS NOT NULL AND @AreaID IS NOT NULL
	BEGIN
		DELETE TourAreaDetail WHERE TourID = @TourID AND AreaID = @AreaID

		UPDATE Tour SET TourPrice -= (SELECT AreaPrice FROM Area WHERE AreaName = @areaName) WHERE TourID = @TourID
	END
	EXEC [sp_Get Tour Areas]
END


------------------------------[sp_Insert Sale & Invoice_Main]------------------PRODUCTION VERSION------------------
GO
DROP PROC IF EXISTS [sp_Insert Sale & Invoice_Main]
GO
CREATE PROC [sp_Insert Sale & Invoice_Main]
(
	@TouristID AS INT,
	@GuideID AS INT,
	@TourIDs AS VARCHAR(30),                -- tek tek veya virgul ile ayrilmiş birden fazla id ve tarih
	@tourDates AS NVARCHAR(255)
)
AS
BEGIN

	INSERT INTO TourSale VALUES(@TouristID, @GuideID)
	--Detect cutomer if bought tour before
	DECLARE @oldCustomer INT = (SELECT COUNT(TouristID) FROM TourSale WHERE TouristID = @TouristID)

	IF @oldCustomer > 1
	BEGIN
		UPDATE Tourist SET NewTourist = 0 WHERE TouristID = @TouristID
	END
	ELSE
	BEGIN
		PRINT 'Ilk defa Tour alisi'
	END

	DECLARE @orderID AS INT = SCOPE_IDENTITY()

	IF (@TourIDs LIKE '%,%')
	BEGIN
		DECLARE @TourID INT
		DECLARE @tourDate DATETIME

		DECLARE @pos INT = 1
		DECLARE @dPos INT = 1
		DECLARE @nextpos INT
		DECLARE @nextDpos INT

		SET @nextpos = CHARINDEX(',', @TourIDs, @pos)
		SET @nextDpos = CHARINDEX(',', @tourDates, @dPos)

		WHILE @nextpos != 0
		BEGIN
			SET @TourID = SUBSTRING(@TourIDs, @pos, @nextpos - @pos)
			PRINT @TourID
			SET @tourDate = CONVERT(DATETIME2, SUBSTRING(@tourDates, @dPos, @nextDpos - @dPos))
			PRINT @tourDate

			EXEC [sp_Insert Sale Detail] @orderID, @TourID, @tourDate

			EXEC [sp_Create Invoice Item] @orderID, @TourID, @TouristID

			SET @pos = @nextpos + 1
			SET @dPos = @nextDpos + 1
			SET @nextpos = CHARINDEX(',', @TourIDs, @pos)
			SET @nextDpos = CHARINDEX(',', @tourDates, @dPos)
		END

		IF LEN(@TourIDs) > @pos
		BEGIN
			SET @TourID = SUBSTRING(@TourIDs, @pos, LEN(@TourIDs))
			PRINT @TourID
			SET @tourDate = CONVERT(DATETIME2, SUBSTRING(@tourDates, @dPos, LEN(@tourDates)))
			PRINT @tourDate

			EXEC [sp_Insert Sale Detail] @orderID, @TourID, @tourDate

			EXEC [sp_Create Invoice Item] @orderID, @TourID, @TouristID
		END
	END
	ELSE
	BEGIN
		-- @TourIDs is not multiple => @nextpos = 0
		EXEC [sp_Insert Sale Detail] @orderID, @TourIDs, @tourDates

		EXEC [sp_Create Invoice Item] @orderID, @TourIDs, @TouristID
	END
END


GO
EXEC [sp_Insert Sale & Invoice_Main] 17, 4, '6,1', '20230126,20230130'


-------------------------------------------------------------------------------------------
GO
DROP PROC IF EXISTS [sp_Create Invoice Item]
GO
CREATE PROC [sp_Create Invoice Item]
(
	@orderID AS INT,
	@TourID AS INT,
	@TouristID AS INT
)
AS
BEGIN

	-- Invoice Discount calculation
	DECLARE @TouristAge AS TINYINT = (SELECT DATEDIFF(YEAR, BirthDate, CONVERT(DATETIME, GETDATE()))
									 FROM Tourist
									 WHERE TouristID = @TouristID)
	DECLARE @cost AS DECIMAL = (SELECT TourPrice FROM Tour WHERE TourID = @TourID)
	DECLARE @discount AS DECIMAL(18,2)

	IF @TouristAge > 60
	BEGIN
		SET @discount = 0.15
	END
	ELSE
	BEGIN
		SET @discount = 0
	END

	-- Invoice no calculation
	DECLARE @lastOrderID AS INT = (SELECT TOP 1 SaleID FROM Invoice ORDER BY SaleID DESC)
	DECLARE @lastBill AS NVARCHAR(14) = (SELECT TOP 1 InvoiceNo
										 FROM Invoice
										 ORDER BY InvoiceNo DESC )
	DECLARE @lastBillDate AS NVARCHAR(11) = (SELECT CONVERT(DATE, SUBSTRING(@lastBill, 4, 8)))

	DECLARE @billNumber AS NVARCHAR(3)
	DECLARE @billNo AS NVARCHAR(14)

	-- if last SaleID and @OrderID is same, continue with same InvoiceNo
	IF @lastOrderID = @orderID
	BEGIN
		SET @billNo = @lastBill
	END
	ELSE
	BEGIN
		IF (SELECT FORMAT (GETDATE(), 'yyyy-MM-dd') AS DATE) = @lastBillDate
		BEGIN
			SET @billNumber = (SELECT SUBSTRING(@lastBill, 12, 14))
			SET @billNo = 'FTR' + FORMAT (GETDATE(), 'yyyyMMdd') +  FORMAT ((@billNumber + 1), 'D3', 'en-us')
		END
		ELSE
		BEGIN
			SET @billNo = 'FTR' + FORMAT (GETDATE(), 'yyyyMMdd') +  FORMAT ( 1, 'D3', 'en-us')
		END
	END

	DECLARE @TouristFullName AS NVARCHAR(60) = (SELECT dbo.fn_getFullName(TouristName, TouristSurname)
											   FROM Tourist WHERE TouristID = @TouristID)

	INSERT INTO Invoice
	VALUES( @billNo, @orderID, @TourID, @TouristID, @TouristFullName, GETDATE(), @discount, @cost * (1 - @discount))
END

---------------------------------------------------------------
GO
DROP PROC IF EXISTS [sp_Sell Tour with Name Surname]
GO
CREATE PROC [sp_Sell Tour with Name Surname]
(
	@name AS NVARCHAR(20),
	@surname AS NVARCHAR(40),
	@GuideID AS INT,
	@TourIDs AS VARCHAR(30),      -- Comma separated tourIds and thier dates
	@tourDates AS NVARCHAR(255)
)
AS
BEGIN
	DECLARE @TouristID INT = (SELECT TouristID
							 FROM Tourist
							 WHERE TouristName = @name AND TouristSurname = @surname )

	EXEC [sp_Insert Sale & Invoice_Main] @TouristID, @GuideID, @TourIDs, @tourDates
END


EXEC [sp_Sell Tour with Name Surname] 'Geoffrey', 'Knowles', 3, '9,5', '20230126,20230130'


SELECT Name
FROM sys.procedures
WHERE OBJECT_DEFINITION(OBJECT_ID) LIKE '%SaleDetail%'

EXEC sp_help SaleDetail


-- View table to assist salesperson choosing a guide suitable for the Tourists' Nationality information
GO
DROP PROC IF EXISTS [sp_Guide Languages Organized]
GO
CREATE PROC [sp_Guide Languages Organized]
--(@GuideFullName AS NVARCHAR(60))
AS
BEGIN

	WITH [cte_Guide Languages Single Row]
	AS
	(
		SELECT GuideFullName,
			   LanguageName,
			   ROW_NUMBER() OVER(PARTITION BY GuideFullName ORDER BY GuideFullName) AS RowNo
		FROM [vw_Guides & Languages]
	)
	SELECT GuideFullName,
		   STUFF((SELECT ', ' + LanguageName
				  FROM [cte_Guide Languages Single Row]
				  WHERE GuideFullName = cte.GuideFullName
				  FOR XML PATH('')), 1, 1, '') AS Languages
	FROM [cte_Guide Languages Single Row] cte
	--WHERE GuideFullName = @GuideFullName
	GROUP BY GuideFullName
END




---- Tours and Areas Organized
SELECT * FROM [vw_Tour Areas Single Row]


GO
DROP VIEW [vw_Tour Areas Single Row]
GO
CREATE VIEW [vw_Tour Areas Single Row] AS
WITH [cte_Tour Areas Single Row]
AS
(
	SELECT t.TourName,
			t.TourID,
			b.AreaName,
			ROW_NUMBER() OVER(PARTITION BY t.TourID ORDER BY t.TourID) AS RowNo
	FROM Tour t
	JOIN TourAreaDetail td ON t.TourID = td.TourID
	JOIN Area b ON b.AreaID = td.AreaID
)
SELECT TourName,
		STUFF((SELECT ', ' + AreaName
				FROM [cte_Tour Areas Single Row]
				WHERE TourName = cte.TourName
				FOR XML PATH('')), 1, 1, '') AS TurAreai
FROM [cte_Tour Areas Single Row] cte
GROUP BY TourName