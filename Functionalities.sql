
---*-*-*        Guide        *-*-*---
INSERT INTO Guide(GuideName, GuideSurname, Gender, Phone)
VALUES('Ozan', 'Temiz', 'erkek', '7773204562')

GO
EXEC [sp_Insert Guide Language] 'Ozan', 'Temiz', 'Dutch'

-- Update Guide Info
UPDATE Guide
SET GuideName = 'Ayse',
	Phone = '7773204567'
WHERE GuideName = 'Bahar'

-- Delete Guide
DELETE FROM Guide WHERE GuideName = 'Linda'

-- Guide Languages organized list
SELECT * FROM [vw_Guide Languages Single Row]

-- Guides who knows Japanese
SELECT dbo.fn_getFullName(r.GuideName, r.GuideSurname) AS Guide
FROM Guide g
JOIN GuideLanguage yd ON yd.GuideID = r.GuideID
WHERE yd.LanguageName = 'Japanese'


---*-*-*     Area      *-*-*-------------------------------------------------------------------
-- Insert Area Prices with their names.
INSERT INTO Area(AreaName, AreaPrice)
VALUES('Ayasofya', '40')

UPDATE Area
SET AreaName = 'Dolmabahce Sarayi'
WHERE AreaName = 'Dolmabahçe Sarayi'

-- Update Area Price
UPDATE Area
SET AreaPrice = 50
WHERE AreaName = 'Ayasofya'

--Delete Area
DELETE FROM Area WHERE AreaName = 'Rumeli Hisari'


---*-*-*        Tour        *-*-*-------------------------------------------------------------------
GO
EXEC [sp_Name Tour & Enter Area] 'Ayasofya ve Yerebatan Sarnici', 'Ayasofya', 'Yerebatan Sarnici'

GO
EXEC [sp_Add Area with Tour Name] 'Miniaturk ve Sultan Ahmet', 'Ayasofya'

GO
EXEC [sp_Delete Tour Area] 'Rumeli Hisari', 'Misir Carsisi'

-- Tour Areas organized list
SELECT * FROM [vw_Tour Areas Single Row]

--Update Tour name
UPDATE Tour SET TourName = 'Adalar, Ayasofya ve Dolmabahce' WHERE TourName = 'Adalar, Ayasofya, Dolmabahçe'

GO
EXEC [sp_Get Tour Areas]


---*-*-*        Tourist         *-*-*---
INSERT INTO Tourist(TouristName, TouristSurname, Gender, BirthDate, Nationality, ComesFrom, NewTourist)
VALUES ('Levi', 'Acevedo', 'Kadin', '06.11.91', 'Japanese', 'Italy', 1),

GO
EXEC [sp_Insert Tourist] 'Levi', 'Acevedo', 'kadin', '06.11.91', 'Japanese', 'Italy'


---*-*-*        Invoice        *-*-*---
-- Tour satisi : -> TouristID, GuideID
-- inputlar: TouristID, GuideID, TourID veya IDleri     (Insert TourIDs with Their Dates)
-- output: Insert sales details and produce invoice item for each tour sale
EXEC [sp_Insert Sale & Invoice_Main] 17, 4, '6,1', '20230126,20230130'

EXEC [sp_Sell Tour with Name Surname] 'Geoffrey', 'Knowles', 3, '9,5', '20230126,20230130'

----------------------------------------------------------------------------------------------------------------
-- View table to assist salesperson choosing a guide suitable for the tourists' nationality information
SELECT * FROM [vw_Guide Languages Single Row]


