----------------------------------------------------------------------------------------------------------
-- A tourist can buy more than one tour in the same sale.
-- YYYYMMDD
GO
DROP PROC IF EXISTS [sp_Insert Sale & Invoice_Main]
GO
CREATE PROC [sp_Insert Sale & Invoice_Main]
(
	@TouristID AS INT,
	--@GuideID AS INT,
	@TourIDs AS VARCHAR(30),              -- comma separated IDs and thier dates or singular values. Both acceptable
	@tourDates AS NVARCHAR(255),
	@fakeDate AS DATETIME       ---!!!! REMOVE THIS
)
AS
BEGIN
	--- REMOVE --
	--------- choosing a guide suitable for the tourists' nationality information
	DECLARE @touristLang NVARCHAR(20) = (SELECT Nationality FROM Tourist WHERE TouristID = @TouristID)

	DECLARE @GuideID INT = 1
	IF @touristLang = 'Japanese'
	SET @GuideID = 2
	ELSE IF @touristLang = 'English'
	SET @GuideID = 1 + FLOOR(RAND() * 5)
	ELSE IF @touristLang = 'Dutch'
	SET @GuideID = CASE WHEN FLOOR(RAND() * 4) = 0 THEN 3 ELSE FLOOR(RAND() * 4) + 1 END
	ELSE IF @touristLang = 'Finnish'
	SET @GuideID = 4
	ELSE IF @touristLang = 'Greek'
	SET @GuideID = CASE WHEN FLOOR(RAND() * 2) = 0 THEN 1 ELSE 3 END
	ELSE IF @touristLang = 'Italian'
	SET @GuideID = CASE WHEN FLOOR(RAND() * 2) = 0 THEN 4 ELSE 5 END
	ELSE IF @touristLang = 'Ukranian'
	SET @GuideID = 3



	INSERT INTO TourSale VALUES(@TouristID, @GuideID)

	--If bought a tour before => Tourist.NewTourist = 0
	DECLARE @oldCustomer INT = (SELECT COUNT(TouristID) FROM TourSale WHERE TouristID = @TouristID)

	IF @oldCustomer > 1
	BEGIN
		UPDATE Tourist SET NewTourist = 0 WHERE TouristID = @TouristID
	END
	ELSE
	BEGIN
		PRINT 'First Time Tour Purchase'
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

			EXEC [sp_Create Invoice Item] @orderID, @TourID, @TouristID, @fakeDate

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

			EXEC [sp_Create Invoice Item] @orderID, @TourID, @TouristID, @fakeDate
		END
	END
	ELSE
	BEGIN
		-- if @TourIDs is a single value @nextpos = 0
		EXEC [sp_Insert Sale Detail] @orderID, @TourIDs, @tourDates

		EXEC [sp_Create Invoice Item] @orderID, @TourIDs, @TouristID, @fakeDate
	END
END

--exec [sp_Insert Sale & Invoice_Main] 48, 4, '2, 7, 5', '20191119, 20191125, 20191130', '20191118'

-------------------------- Invoice ---------------------------------------------------------------
GO
DROP PROC IF EXISTS [sp_Create Invoice Item]
GO
CREATE PROC [sp_Create Invoice Item]
(
	@orderID AS INT,
	@TourID AS INT,
	@TouristID AS INT,
	@date AS DATETIME   -- Fake Date is an input. delete this on the production
)
AS
BEGIN

	-- Invoice Discount calculation
	DECLARE @TouristAge AS TINYINT = (SELECT DATEDIFF(YEAR, BirthDate, CONVERT(DATETIME, @date))
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
		IF (SELECT FORMAT (@date, 'yyyy-MM-dd') AS DATE) = @lastBillDate
		BEGIN
			SET @billNumber = (SELECT SUBSTRING(@lastBill, 12, 14))
			SET @billNo = 'FTR' + FORMAT (@date, 'yyyyMMdd') +  FORMAT ((@billNumber + 1), 'D3', 'en-us')
		END
		ELSE
		BEGIN
			SET @billNo = 'FTR' + FORMAT (@date, 'yyyyMMdd') +  FORMAT ( 1, 'D3', 'en-us')
		END
	END

	DECLARE @TouristFullName AS NVARCHAR(60) = (SELECT dbo.fn_getFullName(TouristName, TouristSurname)
											   FROM Tourist WHERE TouristID = @TouristID)

	INSERT INTO Invoice
	VALUES( @billNo, @orderID, @TourID, @TouristID, @TouristFullName, @date, @discount, @cost * (1 - @discount))
END

-- Tourists Ordered Old to Young
SELECT * FROM [vw_Tourists Ordered Old to Young]


-- Produce Random Tour Sale Data For Testing
-- x: TouristID, y: TourID, z: tourDates, t: InvoiceDate
-- GO
-- DECLARE @x INT = 1, @startdate DATE = '20190701'
-- WHILE (@x <= 78)
-- BEGIN
-- 	DECLARE @y INT = FLOOR(RAND() * 13) + 1,
-- 	   	    @z VARCHAR(100) = '',
--             @t VARCHAR(20) = '',
--             @date DATE = @startdate,
--             @count INT = FLOOR(RAND() * 3) + 1

-- 	WHILE (@count > 0)
-- 	BEGIN
-- 	SET @z = @z + CONVERT(VARCHAR(8), @date, 112) + ','
-- 	SET @date = DATEADD(day, FLOOR(RAND() * 5) + 1, @date)
-- 	SET @count = @count - 1
-- 	END

-- 	SET @z = LEFT(@z, LEN(@z) - 1)
-- 	SET @t = CONVERT(VARCHAR(8), @startdate, 112)
-- 	PRINT 'EXEC [sp_Insert Sale & Invoice_Main]' + CAST(@x AS VARCHAR) + ', ' + CAST(@y AS VARCHAR) + ', ''' + @z + ''', ''' + @t + ''''

-- 	SET @startdate = DATEADD(day, 10, @date)
-- 	SET @x = @x + 1
-- END


