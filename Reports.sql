--1. Mostly visited area/ areas ?
SELECT TOP 1 b.AreaName, COUNT(b.AreaID) AS [Visit Count]
FROM TourAreaDetail bd
JOIN SaleDetail sd ON sd.TourID = bd.TourID
JOIN TourSale ts ON ts.SaleID = sd.SaleID
JOIN Area b ON b.AreaID = bd.AreaID
GROUP BY b.AreaName
ORDER BY COUNT(b.AreaID) DESC


--2. Which guide worked the most in august?
SELECT TOP 1 dbo.fn_getFullName(g.GuideName, g.GuideSurname) AS GuideFullName,
		  COUNT(dbo.fn_getFullName(g.GuideName, g.GuideSurname)) AS Count
FROM Guide g
JOIN TourSale ts ON g.GuideID = ts.GuideID
JOIN SaleDetail sd ON ts.SaleID = sd.SaleID
WHERE MONTH(sd.TourDate) = 8
GROUP BY dbo.fn_getFullName(g.GuideName, g.GuideSurname)
ORDER BY COUNT(dbo.fn_getFullName(g.GuideName, g.GuideSurname)) DESC


--3. List areas visited by female tourists with their trip counts.
SELECT b.AreaName,
	   COUNT(b.AreaID) AS [Visit Count]
FROM TourAreaDetail bd
JOIN SaleDetail td ON td.TourID = bd.TourID
JOIN TourSale ts ON ts.SaleID = td.SaleID
JOIN Area b ON b.AreaID = bd.AreaID
JOIN Tourist t ON ts.TouristID = t.TouristID
WHERE t.Gender = 'female'
GROUP BY b.AreaName
ORDER BY COUNT(b.AreaID) DESC


--4. Get tourists came from England and visited Kiz Kulesi
SELECT t.TouristID,dbo.fn_getFullName(t.TouristName, t.TouristSurname) AS TouristFullName
FROM Tourist t
JOIN TourSale ts ON t.TouristID = ts.TouristID
JOIN SaleDetail td ON td.SaleID = ts.SaleID
JOIN TourAreaDetail bd ON bd.TourID = td.TourID
JOIN Area b ON b.AreaID = bd.AreaID
WHERE t.ComesFrom = 'English' AND b.AreaName = 'Kiz Kulesi'
GROUP BY t.TouristID,dbo.fn_getFullName(t.TouristName, t.TouristSurname)


--5. List areas with their visitation count year by year.
SELECT * FROM [vw_Trip Counts of Areas by Year]

GO
DROP VIEW IF EXISTS [vw_Trip Counts of Areas by Year]
GO
CREATE VIEW [vw_Trip Counts of Areas by Year]
AS
SELECT TOP 100 YEAR(sd.TourDate) AS Yil, b.AreaName, COUNT(b.AreaName) AS [Visit Count]
FROM TourSale ts
JOIN SaleDetail sd ON sd.SaleID = ts.SaleID
JOIN TourAreaDetail td ON sd.TourID = td.TourID
JOIN Area b ON b.AreaID = td.AreaID
GROUP BY YEAR(sd.TourDate), b.AreaName
ORDER BY YEAR(sd.TourDate) DESC

--6. Get most tripped areas which are toured by guides who work with tourists that bought more than two tours in the same sales transaction.
SELECT b.AreaName, COUNT(b.AreaName) AS [Visit Count]
FROM Guide g
JOIN TourSale ts ON ts.GuideID = g.GuideID
JOIN SaleDetail sd ON sd.SaleID = ts.SaleID
JOIN TourAreaDetail bd ON bd.TourID = sd.TourID
JOIN Area b ON b.AreaID = bd.AreaID
WHERE g.GuideID IN (SELECT GuideID
					 FROM [vw_Guide to more than two]
					 GROUP BY GuideID)
GROUP BY b.AreaName
ORDER BY COUNT(b.AreaName) DESC


GO
DROP VIEW IF EXISTS [vw_Guide to more than two]
GO
CREATE VIEW [vw_Guide to more than two] AS
WITH [cte_GuideID & Tour]
AS (
	SELECT g.GuideID, ROW_NUMBER() OVER(PARTITION BY sd.SaleID ORDER BY sd.SaleID) AS RowNo
	FROM Guide g
	JOIN TourSale ts ON ts.GuideID = g.GuideID
	JOIN SaleDetail sd ON sd.SaleID = ts.SaleID
)
SELECT cte.GuideID, b.AreaName
FROM [cte_GuideID & Tour] cte
JOIN TourSale ts ON ts.GuideID = cte.GuideID
JOIN SaleDetail sd ON sd.SaleID = ts.SaleID
JOIN TourAreaDetail bd ON bd.TourID = ts.TouristID
JOIN Area b ON b.AreaID = bd.AreaID
WHERE cte.RowNo > 2
GROUP BY cte.GuideID, b.AreaName


--7. Get most visited area by Italian tourists.
SELECT TOP 1 COUNT(b.AreaID) AS [Visit Count],
	   b.AreaName
FROM TourAreaDetail bd
JOIN SaleDetail td ON td.TourID = bd.TourID
JOIN TourSale ts ON ts.SaleID = td.SaleID
JOIN Area b ON b.AreaID = bd.AreaID
JOIN Tourist t ON ts.TouristID = t.TouristID
WHERE t.Nationality = 'Italian'
GROUP BY b.AreaID,b.AreaName
ORDER BY COUNT(b.AreaID) DESC


--8. Get the oldest tourist who visited 'Kapali Carsi'
SELECT TOP 1 DATEDIFF(YEAR, t.BirthDate, GETDATE()) AS Age,
	   	dbo.fn_getFullName(t.TouristName, t.TouristSurname) AS FullName
FROM Tourist t
JOIN Invoice f ON f.TouristID = t.TouristID
JOIN TourAreaDetail bd ON bd.TourID = f.TourID
JOIN Area b ON b.AreaID = bd.AreaID
JOIN SaleDetail sd ON sd.SaleID = f.SaleID
WHERE b.AreaName = 'Kapali Carsi'
ORDER BY DATEDIFF(YEAR, t.BirthDate, GETDATE()) DESC


--9. Get areas visited by Finnish tourist who came from Greece.
SELECT dbo.fn_getFullName(t.TouristName, t.TouristSurname) AS FullName,
			b.AreaName,
			COUNT(b.AreaID) AS [Visit Count]
FROM Tourist t
JOIN Invoice f ON t.TouristID = f.TouristID
JOIN TourAreaDetail td ON f.TourID = td.TourID
JOIN Area b ON b.AreaID = td.AreaID
WHERE t.ComesFrom = 'Greek' AND t.Nationality = 'Finnish'
GROUP BY b.AreaName, dbo.fn_getFullName(t.TouristName, t.TouristSurname)
ORDER BY [Visit Count] DESC


--10. List tourists and guides who are visited the 'Dolmabahce Sarayi' lately.
SELECT * FROM [vw_Lately Visit Dolmabahce Sarayi]

GO
DROP VIEW IF EXISTS [vw_Lately Visit Dolmabahce Sarayi]
GO
CREATE VIEW [vw_Lately Visit Dolmabahce Sarayi]
AS
WITH [cte_Dolmabahce Sarayi] AS (
	SELECT sd.TourDate,
				dbo.fn_getFullName(t.TouristName, t.TouristSurname) AS Tourist,
				dbo.fn_getFullName(g.GuideName, g.GuideSurname) AS Guide
	FROM TourAreaDetail bd
	JOIN SaleDetail sd ON sd.TourID = bd.TourID
	JOIN TourSale ts ON ts.SaleID = sd.SaleID
	JOIN Area b ON b.AreaID = bd.AreaID
	JOIN Guide g ON g.GuideID = ts.GuideID
	JOIN Tourist t ON t.TouristID = ts.TouristID
	WHERE AreaName = 'Dolmabahce Sarayi'
)
SELECT TOP 100 *
FROM [cte_Dolmabahce Sarayi] cte
ORDER BY cte.TourDate DESC



-- Company Total Revenue
SELECT SUM(TotalPrice)
FROM Invoice

-- Company Total Revenue year by year
SELECT YEAR(InvoiceDate) AS Year,
	   SUM(TotalPrice) AS Revenue
FROM Invoice
GROUP BY YEAR(InvoiceDate)
