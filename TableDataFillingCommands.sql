-- Insert Commands
-- Guide
INSERT INTO Guide(GuideName, GuideSurname, Gender, Phone)
VALUES('Ozan', 'Temiz', 'erkek', '7773204562'),
		('Bahar', 'Sevgin', 'kadin', '7773204563'),
		('Omer', 'Ucar', 'erkek', '7773204564'),
		('Sevgi', 'Cakmak', 'kadin', '7773204565'),
		('Linda', 'Callahan', 'kadin', '7773204566')

GO
EXEC [sp_Insert Guide Language] 'Ozan', 'Temiz', 'Dutch'
GO
EXEC [sp_Insert Guide Language] 'Ozan', 'Temiz', 'Finnish'
GO
EXEC [sp_Insert Guide Language] 'Ozan', 'Temiz', 'Italian'

GO
EXEC [sp_Insert Guide Language] 'Bahar', 'Sevgin', 'Dutch'
GO
EXEC [sp_Insert Guide Language] 'Bahar', 'Sevgin', 'Greek'
GO
EXEC [sp_Insert Guide Language] 'Bahar', 'Sevgin', 'English'

GO
EXEC [sp_Insert Guide Language] 'Omer', 'Ucar', 'Greek'
GO
EXEC [sp_Insert Guide Language] 'Omer', 'Ucar', 'Ukranian'
GO
EXEC [sp_Insert Guide Language] 'Omer', 'Ucar', 'English'

GO
EXEC [sp_Insert Guide Language] 'Sevgi', 'Cakmak', 'Japanese'
GO
EXEC [sp_Insert Guide Language] 'Sevgi', 'Cakmak', 'English'
GO
EXEC [sp_Insert Guide Language] 'Sevgi', 'Cakmak', 'Italian'
GO

EXEC [sp_Insert Guide Language]  'Linda', 'Callahan', 'Dutch'
GO
EXEC [sp_Insert Guide Language]  'Linda', 'Callahan', 'English'
GO
EXEC [sp_Insert Guide Language]  'Linda', 'Callahan', 'Japanese'




--=================================================================================================================
-- Area
INSERT INTO Area(AreaName, AreaPrice)
VALUES('Ayasofya', '40'),
			('Yerebatan Sarnici', '20'),
			('Pierre Loti', '30'),
			('Kiz Kulesi', '50'),
			('Kapali Carsi', '25'),
			('Adalar', '60'),
			('Dolmabahce Sarayi', '50'),
			('Miniaturk', '35'),
			('Sultan Ahmet Cami', '30'),
			('Ataturk Arboretumu', '68'),
			('Misir Carsisi', '28'),
			('Rumeli Hisari', '38'),
			('Anadolu Hisari', '40'),
			('Eyup Sultan Cami', '40')



--=================================================================================================================
-- Define Tour name and tour areas
GO
EXEC [sp_Name Tour & Enter Area] 'Ayasofya ve Yerebatan Sarnici', 'Ayasofya', 'Yerebatan Sarnici'
GO
EXEC [sp_Name Tour & Enter Area] 'Adalar, Ayasofya ve Dolmabahce', 'Adalar', 'Ayasofya', 'Dolmabahce Sarayi'
GO
EXEC [sp_Name Tour & Enter Area] 'Ayasofya, Miniaturk ve Sultan Ahmet',  'Ayasofya', 'Miniaturk', 'Sultan Ahmet Cami'
GO
EXEC [sp_Name Tour & Enter Area] 'Rumeli Hisari', 'Rumeli Hisari'
GO
EXEC [sp_Name Tour & Enter Area] 'Dolmabahce Sarayi ve  Misir Carsisi', 'Dolmabahce Sarayi', 'Misir Carsisi'
GO
EXEC [sp_Name Tour & Enter Area] 'Rumeli Hisari ve Kiz Kulesi', 'Rumeli Hisari', 'Kiz Kulesi'
GO
EXEC [sp_Name Tour & Enter Area] 'Anadolu Hisari ve Eyup Sultan', 'Anadolu Hisari', 'Eyup Sultan Cami'
GO
EXEC [sp_Name Tour & Enter Area] 'Ataturk Arboretumu ve Dolmabahce', 'Ataturk Arboretumu', 'Dolmabahce Sarayi'
GO
EXEC [sp_Name Tour & Enter Area] 'Ataturk Arboretumu ve Pierre Loti', 'Ataturk Arboretumu', 'Pierre Loti'
GO
EXEC [sp_Name Tour & Enter Area] 'Kapalicarsi ve Misir Carsisi', 'Kapali Carsi', 'Misir Carsisi'
GO
EXEC [sp_Name Tour & Enter Area] 'Misir Carsisi ve Ataturk Arboretumu', 'Misir Carsisi', 'Ataturk Arboretumu'
GO
EXEC [sp_Name Tour & Enter Area] 'Miniaturk ve Sultan Ahmet', 'Miniaturk', 'Sultan Ahmet Cami'
GO
EXEC [sp_Name Tour & Enter Area] 'Miniaturk ve Kiz Kulesi', 'Miniaturk', 'Kiz Kulesi'


--=================================================================================================================
-- Tourist
GO
EXEC [sp_Insert Tourist] 'Levi', 'Acevedo', 'kadin', '06.11.91', 'Japanese', 'Italy'
GO
EXEC [sp_Insert Tourist] 'Basil', 'Aguilar','erkek', '04.22.94', 'Greek', 'Greek'
GO
EXEC [sp_Insert Tourist] 'Basil', 'Aguilar','erkek', '04.22.94', 'Greek', 'Greek'
GO
EXEC [sp_Insert Tourist] 'Zenaida', 'Holder',	'erkek', '01.09.90','Finnish','Greek'
GO
EXEC [sp_Insert Tourist] 'Illana', 'Browning','kadin', '01.28.91','Greek','English'
GO
EXEC [sp_Insert Tourist] 'Raja', 'Duke', 'erkek', '07.27.83', 'Dutch', 'Dutch'
GO
EXEC [sp_Insert Tourist] 'Isaiah', 'Valdez', 'erkek', '01.16.98','Finnish', 'Finnish'
GO
EXEC [sp_Insert Tourist] 'Gray', 'Marshall', 'kadin', '11.21.80', 'Japanese','Japanese'
GO
EXEC [sp_Insert Tourist] 'Ora', 'Fletcher', 'kadin', '01.19.94', 'English', 'English'
GO
EXEC [sp_Insert Tourist] 'Lavinia', 'Lloyd', 'kadin', '10.26.86', 'English',	'English'
GO
EXEC [sp_Insert Tourist] 'Jenna', 'Williams', 'kadin', '05.01.82', 'Greek', 'Greek'
GO
EXEC [sp_Insert Tourist] 'Christian', 'Nash', 'erkek', '08.09.80', 'English', 'English'
GO
EXEC [sp_Insert Tourist] 'Quinn', 'Hamilton', 'erkek', '07.10.90', 'English', 'English'
GO
EXEC [sp_Insert Tourist] 'Geoffrey', 'Knowles', 'erkek', '02.17.85', 'Ukrainian', 'Ukrainian'
GO
EXEC [sp_Insert Tourist] 'Brianna', 'Everett', 'erkek', '09.03.78', 'Japanese', 'Japanese'
GO
EXEC [sp_Insert Tourist] 'Sofia', 'Kostas', 'kadin', '05.20.85', 'Greek', 'Greek'
GO
EXEC [sp_Insert Tourist] 'Michael', 'Brown', 'erkek', '12.15.80', 'Dutch', 'Dutch'
GO
EXEC [sp_Insert Tourist] 'Nina', 'Koskinen', 'kadin', '09.22.83', 'Finnish', 'Finnish'
GO
EXEC [sp_Insert Tourist] 'Yukio', 'Sato', 'erkek', '07.01.82', 'Japanese', 'Japanese'
GO
EXEC [sp_Insert Tourist] 'Anna', 'Ivanova', 'kadin', '11.05.87', 'Ukrainian', 'Ukrainian'
GO
EXEC [sp_Insert Tourist] 'Mark', 'Johnson', 'erkek', '02.14.84', 'English', 'English'
GO
EXEC [sp_Insert Tourist] 'Mia', 'Henderson', 'kadin', '06.12.81', 'English', 'English'
GO
EXEC [sp_Insert Tourist] 'Lucas', 'Garcia', 'erkek', '03.28.79', 'Dutch', 'Japanese'
GO
EXEC [sp_Insert Tourist] 'Emma', 'Williams', 'kadin', '04.05.90', 'English', 'English'
GO
EXEC [sp_Insert Tourist] 'Noah', 'Jones', 'erkek', '07.08.85', 'Dutch', 'Dutch'
GO
EXEC [sp_Insert Tourist] 'Olivia', 'Brown', 'kadin', '09.20.83', 'Finnish', 'Finnish'
GO
EXEC [sp_Insert Tourist] 'Liam', 'Miller', 'erkek', '06.12.82', 'Japanese', 'Japanese'
GO
EXEC [sp_Insert Tourist] 'Ava', 'Davis', 'kadin', '02.01.87', 'Greek', 'Greek'
GO
EXEC [sp_Insert Tourist] 'Jacob', 'Garcia', 'erkek', '01.15.80', 'Ukrainian', 'Ukrainian'
GO
EXEC [sp_Insert Tourist] 'Isabella', 'Rodriguez', 'kadin', '05.10.84', 'English', 'English'
GO
EXEC [sp_Insert Tourist] 'Ethan', 'Taylor', 'erkek', '11.01.81', 'English', 'English'
GO
EXEC [sp_Insert Tourist] 'Mia', 'Henderson', 'kadin', '06.12.81', 'English', 'English'
GO
EXEC [sp_Insert Tourist] 'Lucas', 'Garcia', 'erkek', '03.28.79', 'Dutch', 'Japanese'
GO
EXEC [sp_Insert Tourist] 'Aisha', 'Wang', 'kadin', '03.28.69', 'Japanese', 'Japanese'
GO
EXEC [sp_Insert Tourist] 'Maryam', 'Gonzalez', 'kadin', '03.28.65', 'Japanese', 'Japanese'
GO
EXEC [sp_Insert Tourist] 'Taichi', 'Yu ', 'erkek', '03.28.60', 'Japanese', 'Japanese'
GO
EXEC [sp_Insert Tourist] 'Giuseppe', 'Rossi', 'erkek', '07.18.85', 'Italian', 'Italian'
GO
EXEC [sp_Insert Tourist] 'Maria', 'Ferrari', 'kadin', '07.18.95', 'Italian', 'Italian'
GO
EXEC [sp_Insert Tourist] 'Giovanni', 'Bianchi', 'erkek', '07.18.75', 'Italian', 'Italian'
GO
EXEC [sp_Insert Tourist] 'Alessandra', 'Lombardi', 'kadin', '07.18.65', 'Italian', 'Italian'
GO
EXEC [sp_Insert Tourist] 'Marco', 'Neri', 'erkek', '07.18.70', 'Italian', 'Italian'
GO
EXEC [sp_Insert Tourist] 'Federica', 'Gialli', 'kadin', '07.18.61', 'Italian', 'Italian'
GO
EXEC [sp_Insert Tourist] 'Roberto', 'Verde', 'erkek', '07.18.62', 'Italian', 'Italian'
GO
EXEC [sp_Insert Tourist] 'Beat', 'Blu', 'kadin', '07.18.62', 'Italian', 'Italian'
GO
EXEC [sp_Insert Tourist] 'Andrea', 'Gialli', 'erkek', '07.18.78', 'Italian', 'Italian'
GO
EXEC [sp_Insert Tourist] 'Isabella', 'Neri', 'kadin', '07.18.88', 'Italian', 'Italian'
GO
EXEC [sp_Insert Tourist] 'Kalle ', 'Järvinen', 'kadin', '07.18.89', 'Finnish', 'Finnish'
GO
EXEC [sp_Insert Tourist] 'Haruka ', 'Nakamura', 'erkek', '07.18.78', 'Japanese', 'Japanese'
GO
EXEC [sp_Insert Tourist] 'Jeroen ', 'van der Meer', 'erkek', '07.18.58', 'Dutch', 'Dutch'
GO
EXEC [sp_Insert Tourist] 'Volodymyr', 'Kovalchuk', 'erkek', '07.18.59', 'Ukranian', 'Ukranian'
GO
EXEC [sp_Insert Tourist] 'Atsushi ', 'Miyamoto', 'kadin', '07.18.57', 'Japanese', 'Japanese'
GO
EXEC [sp_Insert Tourist] 'Pieter ', 'Hofstra', 'erkek', '07.18.77', 'Dutch', 'Japanese'
GO
EXEC [sp_Insert Tourist] 'Emma ', 'Taylor', 'kadin', '07.18.87', 'English', 'English'
GO
EXEC [sp_Insert Tourist] 'Jan ', 'de Vries', 'erkek', '07.18.75', 'Dutch', 'Dutch'
GO
EXEC [sp_Insert Tourist] 'David ', 'Brown', 'erkek', '07.18.74', 'English', 'English'
GO
EXEC [sp_Insert Tourist] 'Juho ', 'Nieminen', 'erkek', '07.18.63', 'Finnish', 'Finnish'
GO
EXEC [sp_Insert Tourist] 'Tuula ', 'Tuula', 'kadin', '07.18.57', 'Finnish', 'Finnish'
GO
EXEC [sp_Insert Tourist] 'Olena ', 'Petrenko', 'kadin', '07.18.66', 'Ukranian', 'Ukranian'
GO
EXEC [sp_Insert Tourist] 'Sarah ', 'Jones', 'kadin', '07.18.96', 'English:', 'English'
GO
EXEC [sp_Insert Tourist] 'Alice', 'Smith', 'kadin', '01.01.2000', 'Dutch', 'English'
GO
EXEC [sp_Insert Tourist] 'Bob', 'Johnson', 'erkek', '02.15.1998', 'Finnish', 'Greek'
GO
EXEC [sp_Insert Tourist] 'Charlie', 'Williams', 'kadin', '03.31.1999', 'Japanese', 'Ukrainian'
GO
EXEC [sp_Insert Tourist] 'Dave', 'Jones', 'erkek', '04.01.1997', 'Dutch', 'English'
GO
EXEC [sp_Insert Tourist] 'Eve', 'Brown', 'kadin', '05.21.1999', 'Finnish', 'Greek'
GO
EXEC [sp_Insert Tourist] 'Frank', 'Davis', 'erkek', '06.05.1998', 'Japanese', 'Ukrainian'
GO
EXEC [sp_Insert Tourist] 'Grace', 'Miller', 'kadin', '07.12.1997', 'Dutch', 'English'
GO
EXEC [sp_Insert Tourist] 'Harry', 'Wilson', 'erkek', '08.31.1999', 'Finnish', 'Greek'
GO
EXEC [sp_Insert Tourist] 'Isabel', 'Moore', 'kadin', '09.25.1998', 'Japanese', 'Ukrainian'
GO
EXEC [sp_Insert Tourist] 'Jack', 'Taylor', 'erkek', '10.01.1997', 'Dutch', 'English'
GO
EXEC [sp_Insert Tourist] 'Kyle', 'Anderson', 'erkek', '11.03.1999', 'Finnish', 'Greek'
GO
EXEC [sp_Insert Tourist] 'Lucy', 'Thomas', 'erkek', '12.12.1998', 'Japanese', 'Ukrainian'
GO
EXEC [sp_Insert Tourist] 'Mike', 'Jackson', 'erkek', '01.06.1997', 'Dutch', 'English'
GO
EXEC [sp_Insert Tourist] 'Nate', 'White', 'erkek', '02.15.1999', 'Finnish', 'Greek'
GO
EXEC [sp_Insert Tourist] 'Olivia', 'Harris', 'kadin', '03.22.1998', 'Japanese', 'Ukrainian'
GO
EXEC [sp_Insert Tourist] 'Paul', 'Martin', 'erkek', '04.01.1997', 'Dutch', 'English'
GO
EXEC [sp_Insert Tourist] 'Quinn', 'Thompson', 'kadin', '05.19.1999', 'Finnish', 'Greek'
GO
EXEC [sp_Insert Tourist] 'Ryan', 'Garcia', 'erkek', '06.03.1998', 'Japanese', 'Ukrainian'
GO
EXEC [sp_Insert Tourist] 'Sarah', 'Martinez', 'kadin', '07.10.1997', 'Dutch', 'English'
GO
EXEC [sp_Insert Tourist] 'Tim', 'Robinson', 'erkek', '08.31.1999', 'Finnish', 'Greek'
GO
EXEC [sp_Insert Tourist] 'Uma', 'Clark', 'kadin', '09.24.1998', 'Japanese', 'Ukrainian'
GO
EXEC [sp_Insert Tourist] 'Victor', 'Rodriguez', 'erkek',  '07.18.66', 'Dutch', 'English'


--=================================================================================================================
-- TurSatisi
-- x: TouristID, y: TourID, z: TourDates, t: Invoice Date
-- Guide allocation considring tourist nationality
UPDATE Tourist SET NewTourist = 1
GO
EXEC [sp_Insert Sale & Invoice_Main] 1, '3,1', '20190701,20190704', '20190701'
GO
EXEC [sp_Insert Sale & Invoice_Main] 2, '13,2', '20190719,20190720', '20190719'
GO
EXEC [sp_Insert Sale & Invoice_Main] 3, '10,5,8', '20190801,20190803,20190807', '20190801'
GO
EXEC [sp_Insert Sale & Invoice_Main] 4, '4', '20190821', '20190821'
GO
EXEC [sp_Insert Sale & Invoice_Main] 5, '9,7,6', '20190904,20190908,20190913', '20190904'
GO
EXEC [sp_Insert Sale & Invoice_Main] 6, '4,5,10', '20190928,20191003,20191004', '20190928'
GO
EXEC [sp_Insert Sale & Invoice_Main] 7, '3', '20191017', '20191017'
GO
EXEC [sp_Insert Sale & Invoice_Main] 8, '7,12', '20191029,20191102', '20191029'
GO
EXEC [sp_Insert Sale & Invoice_Main] 9, '12,9', '20191117,20191121', '20191117'
GO
EXEC [sp_Insert Sale & Invoice_Main] 10, '3,4', '20191206,20191211', '20191206'
GO
EXEC [sp_Insert Sale & Invoice_Main] 11, '1,2,11', '20191223,20191226,20191231', '20191223'
GO
EXEC [sp_Insert Sale & Invoice_Main] 12, '6,8,2', '20200112,20200115,20200120', '20200112'
GO
EXEC [sp_Insert Sale & Invoice_Main] 13, '1,8', '20200204,20200209', '20200204'
GO
EXEC [sp_Insert Sale & Invoice_Main] 14, '7', '20200222', '20200222'
GO
EXEC [sp_Insert Sale & Invoice_Main] 15, '9,3', '20200304,20200308', '20200304'
GO
EXEC [sp_Insert Sale & Invoice_Main] 2,  '13', '20200322', '20200322'
GO
EXEC [sp_Insert Sale & Invoice_Main] 16, '10', '20200322', '20200322'
GO
EXEC [sp_Insert Sale & Invoice_Main] 17, '2', '20200404', '20200404'
GO
EXEC [sp_Insert Sale & Invoice_Main] 18, '8,4', '20200415,20200417', '20200415'
GO
EXEC [sp_Insert Sale & Invoice_Main] 19, '6', '20200430', '20200430'
GO
EXEC [sp_Insert Sale & Invoice_Main] 20, '5', '20200512', '20200512'
GO
EXEC [sp_Insert Sale & Invoice_Main] 21, '7,6', '20200523,20200526', '20200523'
GO
EXEC [sp_Insert Sale & Invoice_Main] 22, '9,8', '20200609,20200612', '20200609'
GO
EXEC [sp_Insert Sale & Invoice_Main] 23, '7,11', '20200624,20200625', '20200624'
GO
EXEC [sp_Insert Sale & Invoice_Main] 24, '6', '20200706', '20200706'
GO
EXEC [sp_Insert Sale & Invoice_Main] 8,  '12', '20200720', '20200720'
GO
EXEC [sp_Insert Sale & Invoice_Main] 25, '13', '20200720', '20200720'
GO
EXEC [sp_Insert Sale & Invoice_Main] 26, '13,10', '20200804,20200808', '20200804'
GO
EXEC [sp_Insert Sale & Invoice_Main] 27, '6,12,4', '20200819,20200820,20200824', '20200819'
GO
EXEC [sp_Insert Sale & Invoice_Main] 28, '4', '20200906', '20200906'
GO
EXEC [sp_Insert Sale & Invoice_Main] 29, '8,12', '20200918,20200922', '20200918'
GO
EXEC [sp_Insert Sale & Invoice_Main] 30, '2,6', '20201005,20201006', '20201005'
GO
EXEC [sp_Insert Sale & Invoice_Main] 31, '1,7', '20201018,20201019', '20201018'
GO
EXEC [sp_Insert Sale & Invoice_Main] 32, '12,2', '20201031,20201102', '20201031'
GO
EXEC [sp_Insert Sale & Invoice_Main] 33, '12', '20201117', '20201117'
GO
EXEC [sp_Insert Sale & Invoice_Main] 34, '11,5,13', '20201128,20201202,20201205', '20201128'
GO
EXEC [sp_Insert Sale & Invoice_Main] 35, '5,2,6', '20201218,20201221,20201226', '20201218'
GO
EXEC [sp_Insert Sale & Invoice_Main] 36, '11', '20210109', '20210109'
GO
EXEC [sp_Insert Sale & Invoice_Main] 37, '5,8,11', '20210120,20210125,20210126', '20210120'
GO
EXEC [sp_Insert Sale & Invoice_Main] 38, '4,1', '20210210,20210212', '20210210'
GO
EXEC [sp_Insert Sale & Invoice_Main] 39, '8,6,2', '20210223,20210224,20210301', '20210223'
GO
EXEC [sp_Insert Sale & Invoice_Main] 40, '13,7,11', '20210316,20210318,20210321', '20210316'
GO
EXEC [sp_Insert Sale & Invoice_Main] 41, '11,10', '20210404,20210406', '20210404'
GO
EXEC [sp_Insert Sale & Invoice_Main] 42, '8,3', '20210421,20210426', '20210421'
GO
EXEC [sp_Insert Sale & Invoice_Main] 43, '6', '20210507', '20210507'
GO
EXEC [sp_Insert Sale & Invoice_Main] 44, '1,9,11', '20210518,20210521,20210522', '20210518'
GO
EXEC [sp_Insert Sale & Invoice_Main] 45, '1,5,7', '20210605,20210610,20210615', '20210605'
GO
EXEC [sp_Insert Sale & Invoice_Main] 46, '10,1,2', '20210629,20210703,20210704', '20210629'
GO
EXEC [sp_Insert Sale & Invoice_Main] 47, '7,13', '20210718,20210719', '20210718'
GO
EXEC [sp_Insert Sale & Invoice_Main] 48, '6,9', '20210803,20210808', '20210803'
GO
EXEC [sp_Insert Sale & Invoice_Main] 49, '11,2', '20210822,20210827', '20210822'
GO
EXEC [sp_Insert Sale & Invoice_Main] 50, '6,2', '20210907,20210908', '20210907'
GO
EXEC [sp_Insert Sale & Invoice_Main] 51, '3,10', '20210919,20210924', '20210919'
GO
EXEC [sp_Insert Sale & Invoice_Main] 52, '6,1', '20211007,20211011', '20211007'
GO
EXEC [sp_Insert Sale & Invoice_Main] 32, '5', '20211024', '20211024'
GO
EXEC [sp_Insert Sale & Invoice_Main] 53, '9', '20211024', '20211024'
GO
EXEC [sp_Insert Sale & Invoice_Main] 54, '8,11,13', '20211104,20211106,20211108', '20211104'
GO
EXEC [sp_Insert Sale & Invoice_Main] 55, '12,7', '20211123,20211127', '20211123'
GO
EXEC [sp_Insert Sale & Invoice_Main] 56, '4', '20211208', '20211208'
GO
EXEC [sp_Insert Sale & Invoice_Main] 57, '8', '20211219', '20211219'
GO
EXEC [sp_Insert Sale & Invoice_Main] 58, '8', '20220101', '20220101'
GO
EXEC [sp_Insert Sale & Invoice_Main] 59, '1,6,12', '20220116,20220117,20220122', '20220116'
GO
EXEC [sp_Insert Sale & Invoice_Main] 60, '8', '20220204', '20220204'
GO
EXEC [sp_Insert Sale & Invoice_Main] 61, '4,7', '20220219,20220221', '20220219'
GO
EXEC [sp_Insert Sale & Invoice_Main] 43, '7', '20220308', '20220308'
GO
EXEC [sp_Insert Sale & Invoice_Main] 62, '4', '20220308', '20220308'
GO
EXEC [sp_Insert Sale & Invoice_Main] 63, '12,2', '20220321,20220326', '20220321'
GO
EXEC [sp_Insert Sale & Invoice_Main] 64, '11,8', '20220410,20220414', '20220410'
GO
EXEC [sp_Insert Sale & Invoice_Main] 65, '2,7', '20220427,20220429', '20220427'
GO
EXEC [sp_Insert Sale & Invoice_Main] 66, '9', '20220512', '20220512'
GO
EXEC [sp_Insert Sale & Invoice_Main] 67, '1', '20220524', '20220524'
GO
EXEC [sp_Insert Sale & Invoice_Main] 68, '4', '20220608', '20220608'
GO
EXEC [sp_Insert Sale & Invoice_Main] 37, '2,4,10', '20220623,20220625,20220627', '20220620'
GO
EXEC [sp_Insert Sale & Invoice_Main] 69, '11,7,5', '20220623,20220625,20220627', '20220623'
GO
EXEC [sp_Insert Sale & Invoice_Main] 70, '7,8,9', '20220712,20220714,20220718', '20220712'
GO
EXEC [sp_Insert Sale & Invoice_Main] 71, '7', '20220802', '20220802'
GO
EXEC [sp_Insert Sale & Invoice_Main] 72, '2,1', '20220813,20220814', '20220813'
GO
EXEC [sp_Insert Sale & Invoice_Main] 73, '6,5,12', '20220825,20220829,20220830', '20220825'
GO
EXEC [sp_Insert Sale & Invoice_Main] 74, '7,11,13', '20220911,20220916,20220919', '20220911'
GO
EXEC [sp_Insert Sale & Invoice_Main] 35, '8,9,10', '20221001,20221006,20221009', '20221001'
GO
EXEC [sp_Insert Sale & Invoice_Main] 75, '4,6,7', '20221001,20221006,20221009', '20221001'
GO
EXEC [sp_Insert Sale & Invoice_Main] 76, '4', '20221020', '20221020'
GO
EXEC [sp_Insert Sale & Invoice_Main] 77, '12', '20221103', '20221103'
GO
EXEC [sp_Insert Sale & Invoice_Main] 78, '10,12', '20221116,20221119', '20221116'
GO
EXEC [sp_Insert Sale & Invoice_Main] 48, '11,1', '20221206,20221216', '20221206'
GO
EXEC [sp_Insert Sale & Invoice_Main] 55, '6,1', '20221216,20221226', '20221216'
--86

