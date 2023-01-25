--1. En cok gezilen yer/yerler neresidir?
SELECT TOP 1 b.AreaName, COUNT(b.AreaID) AS ZiyaretEdilmeSayilari
FROM TourAreaDetail bd
JOIN SaleDetail sd ON sd.TourID = bd.TourID
JOIN TourSale ts ON ts.SaleID = sd.SaleID
JOIN Area b ON b.AreaID = bd.AreaID
GROUP BY b.AreaName
ORDER BY COUNT(b.AreaID) DESC


--2. Agustos ayinda en cok calisan Guide/Guideler kimdir/kimlerdir?
SELECT TOP 1 dbo.fn_getFullName(r.GuideName, r.GuideSurname) AS GuideFullName,
		  COUNT(dbo.fn_getFullName(r.GuideName, r.GuideSurname)) AS Sayi
FROM Guide g
JOIN TourSale ts ON r.GuideID = ts.GuideID
JOIN SaleDetail sd ON ts.SaleID = sd.SaleID
WHERE MONTH(sd.TourDate) = 8
GROUP BY dbo.fn_getFullName(r.GuideName, r.GuideSurname)
ORDER BY COUNT(dbo.fn_getFullName(r.GuideName, r.GuideSurname)) DESC


--3. Kadin Touristlerin gezdigi yerleri, toplam ziyaret edilme sayilariyla beraber listeleyin
SELECT b.AreaName,
	   COUNT(b.AreaID) AS ZiyaretEdilmeSayilari
FROM TourAreaDetail bd
JOIN SaleDetail td ON td.TourID = bd.TourID
JOIN TourSale ts ON ts.SaleID = td.SaleID
JOIN Area b ON b.AreaID = bd.AreaID
JOIN Tourist t ON ts.TouristID = t.TouristID
WHERE t.Gender = 'kadin'
GROUP BY b.AreaName
ORDER BY COUNT(b.AreaID) DESC


--4. Ingiltere’den gelip de Kiz Kulesi’ni gezen Touristler kimlerdir?
SELECT t.TouristID,dbo.fn_getFullName(t.TouristName, t.TouristSurname) AS TouristFullName
FROM Tourist t
JOIN TourSale ts ON t.TouristID = ts.TouristID
JOIN SaleDetail td ON td.SaleID = ts.SaleID
JOIN TourAreaDetail bd ON bd.TourID = td.TourID
JOIN Area b ON b.AreaID = bd.AreaID
WHERE t.ComesFrom = 'English' AND b.AreaName = 'Kiz Kulesi'
GROUP BY t.TouristID,dbo.fn_getFullName(t.TouristName, t.TouristSurname)


--5. Gezilen yerler hangi yilda kac defa gezilmistir?
SELECT * FROM [vw_Trip Counts of Areas by Year]

GO
DROP VIEW IF EXISTS [vw_Trip Counts of Areas by Year]
GO
CREATE VIEW [vw_Trip Counts of Areas by Year]
AS
SELECT TOP 100 YEAR(sd.TourDate) AS Yil, b.AreaName, COUNT(b.AreaName) AS [Gezilme Sayilari]
FROM TourSale ts
JOIN SaleDetail sd ON sd.SaleID = ts.SaleID
JOIN TourAreaDetail td ON sd.TourID = td.TourID
JOIN Area b ON b.AreaID = td.AreaID
GROUP BY YEAR(sd.TourDate), b.AreaName
ORDER BY YEAR(sd.TourDate) DESC


--6. 2’den fazla tura Guidelik eden Guidelerin en cok tanittiklari yerler nelerdir?
-- Bir satis islemi icindeki 2den fazla tura Guidelik eden Guidelerin en cok tanittiklari yerler nelerdir?

SELECT b.AreaName, COUNT(b.AreaName) AS [Tanitma Sayisi]
FROM Guide g
JOIN TourSale ts ON ts.GuideID = r.GuideID
JOIN SaleDetail sd ON sd.SaleID = ts.SaleID
JOIN TourAreaDetail bd ON bd.TourID = sd.TourID
JOIN Area b ON b.AreaID = bd.AreaID
WHERE r.GuideID IN (SELECT GuideID
					 FROM [vw_Ikiden fazla tura bakan Guideler]
					 GROUP BY GuideID)
GROUP BY b.AreaName
ORDER BY COUNT(b.AreaName) DESC


GO
DROP VIEW IF EXISTS [vw_Ikiden fazla tura bakan Guideler]
GO
CREATE VIEW [vw_Ikiden fazla tura bakan Guideler] AS
WITH [cte_GuideTourSaleDIle]
AS (
	SELECT r.GuideID, ROW_NUMBER() OVER(PARTITION BY sd.SaleID ORDER BY sd.SaleID) AS RowNo
	FROM Guide g
	JOIN TourSale ts ON ts.GuideID = r.GuideID
	JOIN SaleDetail sd ON sd.SaleID = ts.SaleID
)
SELECT cte.GuideID, b.AreaName
FROM [cte_GuideTourSaleDIle] cte
JOIN TourSale ts ON ts.GuideID = cte.GuideID
JOIN SaleDetail sd ON sd.SaleID = ts.SaleID
JOIN TourAreaDetail bd ON bd.TourID = ts.TouristID
JOIN Area b ON b.AreaID = bd.AreaID
WHERE cte.RowNo > 2
GROUP BY cte.GuideID, b.AreaName


--7. Italyan Touristler en cok nereyi gezmistir?
SELECT TOP 1 COUNT(b.AreaID) AS GezilmeSayisi,
	   b.AreaName
FROM TourAreaDetail bd
JOIN SaleDetail td ON td.TourID = bd.TourID
JOIN TourSale ts ON ts.SaleID = td.SaleID
JOIN Area b ON b.AreaID = bd.AreaID
JOIN Tourist t ON ts.TouristID = t.TouristID
WHERE t.Nationality = 'Italian'
GROUP BY b.AreaID,b.AreaName
ORDER BY COUNT(b.AreaID) DESC


--8. Kapali carsi’yi gezen en yasli Tourist kimdir?
SELECT TOP 1 DATEDIFF(YEAR, t.BirthDate, GETDATE()) AS Age,
	   dbo.fn_getFullName(t.TouristName, t.TouristSurname) AS FullName
FROM Tourist t
JOIN Invoice f ON f.TouristID = t.TouristID
JOIN TourAreaDetail bd ON bd.TourID = f.TourID
JOIN Area b ON b.AreaID = bd.AreaID
JOIN SaleDetail sd ON sd.SaleID = f.SaleID
WHERE b.AreaName = 'Kapali Carsi'
ORDER BY DATEDIFF(YEAR, t.BirthDate, GETDATE()) DESC


--9. Yunanistan’dan gelen Finlandiyali Touristin gezdigi yerler nerelerdir?
SELECT dbo.fn_getFullName(t.TouristName, t.TouristSurname) AS FullName,
	   b.AreaName,
	   COUNT(b.AreaID) AS [Ziyaret Sayilari]
FROM Tourist t
JOIN Invoice f ON t.TouristID = f.TouristID
JOIN TourAreaDetail td ON f.TourID = td.TourID
JOIN Area b ON b.AreaID = td.AreaID
WHERE t.ComesFrom = 'Greek' AND t.Nationality = 'Finnish'
GROUP BY b.AreaName, dbo.fn_getFullName(t.TouristName, t.TouristSurname)
ORDER BY [Ziyaret Sayilari] DESC


--10. Dolmabahce Sarayi’na en son giden Touristler ve Guidei listeleyin.
SELECT * FROM [vw_Dolmabahce Sarayi'na Son Gidenler]

GO
DROP VIEW IF EXISTS [vw_Dolmabahce Sarayi'na Son Gidenler]
GO
CREATE VIEW [vw_Dolmabahce Sarayi'na Son Gidenler]
AS
WITH [cte_Dolmabahce Sarayi] AS (
	SELECT sd.TourDate,
		   dbo.fn_getFullName(t.TouristName, t.TouristSurname) AS Tourist,
		   dbo.fn_getFullName(r.GuideName, r.GuideSurname) AS Guide
	FROM TourAreaDetail bd
	JOIN SaleDetail sd ON sd.TourID = bd.TourID
	JOIN TourSale ts ON ts.SaleID = sd.SaleID
	JOIN Area b ON b.AreaID = bd.AreaID
	JOIN Guide g ON r.GuideID = ts.GuideID
	JOIN Tourist t ON t.TouristID = ts.TouristID
	WHERE AreaName = 'Dolmabahce Sarayi'
)
SELECT TOP 100 *
FROM [cte_Dolmabahce Sarayi] cte
ORDER BY cte.TourDate DESC



-- TourCompany toplam geliri
SELECT SUM(TotalPrice)
FROM Invoice

-- TourCompany yillara göre toplam geliri
SELECT YEAR(InvoiceDate) AS Yil,
	   SUM(TotalPrice) AS Gelir
FROM Invoice
GROUP BY YEAR(InvoiceDate)