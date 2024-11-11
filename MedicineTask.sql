Create Database PharmacyDatabase
Use PharmacyDatabase

Create Table Depots(
Id int Primary Key Identity,
[Name] Nvarchar(100) Not Null,
City Nvarchar(100) Not Null,
ZipCode Nvarchar(100) Not Null
)

Insert Into Depots Values
(N'Depo 1', N'Baku', N'1011'), 
(N'Depo 2', N'Sumqayıt', N'2529'), 
(N'Depo 3', N'Gəncə', N'3011'), 
(N'Depo 4', N'New York', N'8891')


Create Table Medicines(
Id int Primary Key Identity,
[Name] Nvarchar(100) Not Null,
Manufacturer Nvarchar(100) Not Null,
Price int Not Null
)

Insert Into Medicines Values('Ketonal','Manufacturer 1', 1)
Insert Into Medicines Values('Anpitsilin','Manufacturer 2', 1.50)
Insert Into Medicines Values('Almagel','Manufacturer 3', 2)
Insert Into Medicines Values('Oksen Forte','Manufacturer 4', 4.50)



Create Table Pharmacies(
Id int Primary Key Identity,
[Name] Nvarchar(100) Not Null,
City Nvarchar(100) Not Null,
ZipCode Nvarchar(100) Not Null
)

Insert Into Pharmacies Values('Aptek 1',N'Sumqayıt', 1011)
Insert Into Pharmacies Values('Aptek 2',N'Oslo', 2219)
Insert Into Pharmacies Values('Aptek 3',N'Bakı', 1100)
Insert Into Pharmacies Values('Aptek 4',N'Gəncə', 9090)


Create Table DepotsMedicines(
Id int Primary Key Identity,
DepotsId int References Depots(Id),
MedicinesId int References Medicines(Id),
Quantity int
)

Insert Into DepotsMedicines Values(1,1,10)
Insert Into DepotsMedicines Values(1,2,5)
Insert Into DepotsMedicines Values(2,1,7)
Insert Into DepotsMedicines Values(2,2,15)
Insert Into DepotsMedicines Values(3,1,20)
Insert Into DepotsMedicines Values(3,4,17)
Insert Into DepotsMedicines Values(4,3,28)
Insert Into DepotsMedicines Values(4,4,30)




Create Table PharmaciesMedicines(
Id int Primary Key Identity,
PharmaciesId int References Pharmacies(Id),
MedicinesId int References Medicines(Id),
Quantity int
)


Insert Into PharmaciesMedicines Values(1,1,10)
Insert Into PharmaciesMedicines Values(1,2,8)
Insert Into PharmaciesMedicines Values(2,1,15)
Insert Into PharmaciesMedicines Values(2,2,50)
Insert Into PharmaciesMedicines Values(3,1,7)
Insert Into PharmaciesMedicines Values(3,3,56)
Insert Into PharmaciesMedicines Values(4,3,100)
Insert Into PharmaciesMedicines Values(4,4,2)







Create VIEW ShowAll 
As
Select 
m.Id As [Medicine Id],
m.Name As [Medicine Name],
m.Manufacturer,
m.Price,
p.Name As [Pharmacy Name],
d.Name As [Depot Name]
From 
    Medicines As m
JOIN 
    PharmaciesMedicines As pm On m.Id = pm.MedicinesId
JOIN 
    Pharmacies As p On pm.PharmaciesId = p.Id
JOIN 
    DepotsMedicines As dm On m.Id = dm.MedicinesId
JOIN 
    Depots As d On dm.DepotsId = d.Id

Select * From ShowAll 



Create VIEW ListOfMedicines 
AS 
SELECT 
    sa.[Medicine Id], 
    sa.[Medicine Name], 
    sa.Manufacturer, 
    sa.Price, 
    sa.[Pharmacy Name], 
    pm.Quantity
FROM 
    ShowAll AS sa
JOIN 
    PharmaciesMedicines AS pm ON sa.[Medicine Id] = pm.MedicinesId
WHERE 
    pm.Quantity < 10;


	Select * From ListofMedicines


Create Procedure usp_IncreaseQuantity 
    @MedicineId int
As
Begin
    Update PharmaciesMedicines
    Set Quantity = Quantity + 100
    Where MedicinesId = @MedicineId
    And Quantity < 10;
End;

Exec usp_IncreaseQuantity @MedicineId = 1


Create Function dbo.AverageMedicineQuantity(@ZipCode Nvarchar(100))
Returns Float
As
Begin
    Declare @AverageQuantity FLOAT

    Select @AverageQuantity = AVG(pm.Quantity)
    From Pharmacies p
    Join PharmaciesMedicines pm On p.Id = pm.PharmaciesId
    Where p.ZipCode = @ZipCode;

    Return @AverageQuantity;
End;

Select dbo.AverageMedicineQuantity('1011') As AverageQuantity;
