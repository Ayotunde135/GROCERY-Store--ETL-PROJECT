

-----SCHEMA FOR STAGGING
create schema tescadb
create schema hrOvertime
create schema hrAbsent
create schema hrmisconduct


----------------------PRODUCT DIMENSION-------------

---------PRECOUNT FOR CONTROL METRICS (SOURCECOUNT DECLARATION)------ 
Select  Count(*) as StgSourceCount  from Product p ------Before move-------
inner join Department d on p.DepartmentID=d.DepartmentID

---------POSTCOUNT FOR CONTROL PACKAGE (DESTINATION COUNT DECLARATION)------ 
select count(*) as StgDescCount from tescadb.product  ------After move-------


-------PREPARE PRODUCT DATA TO LOAD INTO STAGGING FROM OLTP (DENORMALIZED)---
use [Tesca OLTP Database ]
Select p.ProductID, p.Product, p.ProductNumber, p.UnitPrice, d.Department from Product p
inner join Department d on d.DepartmentID = p.DepartmentID

-------CREATE STAGGING PRODUCT DIMENSION TABLE (PRODUCT)-----
use [Tesca Staging Database]
create table tescadb.product
(
	productID INT,
	PRODUCT NVARCHAR (50),
	PRODUCTNUMBER NVARCHAR (50),
	UNITPRICE FLOAT,
	DEPARTMENT NVARCHAR (50),
	LOADDATE DATETIME default getdate(),
	Constraint tescadb_product_pk primary key (productid)
)
-------TRUNCATE------
truncate table tescadb.product



---------------STORE DIMENSION------------

---------PRECOUNT FOR CONTROL METRICS (SOURCECOUNT DECLARATION)------ 
Select  Count(*) as StgSourceCount  from Store s ------Before move-------
inner join City c on c.CityID = s.CityID
inner join state st on st.StateID = s.StateID

---------POSTCOUNT FOR CONTROL PACKAGE (DESTINATION COUNT DECLARATION)------ 
select count(*) as StgDescCount from tescadb.store  ------After move-------


-------PREPARE STORE DATA TO LOAD INTO STAGGING FROM OLTP (DENORMALIZED)---
use [Tesca OLTP Database ]
select s.StoreID,s.StoreName,s.StreetAddress,c.CityName as City, st.State ,getdate() as LoadDate from Store s
inner join City c on c.CityID = s.CityID
inner join state st on st.StateID = s.StateID

-------CREATE STAGGING STORE DIMENSION TABLE (STORE)-----
use [Tesca Staging Database]
create table tescadb.Store 
(
	Storeid int,
	StoreName nvarchar (50),
	StreetAddress nvarchar (50),
	City nvarchar (50),
	State Nvarchar (50),
	Loaddate datetime default getdate(),
	constraint tescadb_storeid_pk primary key (storeid)
)
Truncate table tescadb.store





-----------------------------PROMOTION DIMENSION-----------------

---------PRECOUNT FOR CONTROL METRICS (SOURCECOUNT DECLARATION)------ 
Select  Count(*) as StgSourceCount from Promotion p   ------Before move-------
inner join PromotionType t on t.PromotionTypeID = p.PromotionTypeID

---------POSTCOUNT FOR CONTROL PACKAGE (DESTINATION COUNT DECLARATION)------ 
select count(*) as StgDescCount from tescadb.promotion  ------After move-------



-------PREPARE PROMOTION DATA TO LOAD INTO STAGGING FROM OLTP (DENORMALIZED)---

use [Tesca OLTP Database ]
Select P.PromotionId, P.startdate as PromotionStartdate , P.enddate as PromotionEnddate, P.discountpercent, t.Promotion, Getdate () as Loaddate from promotion P
inner join PromotionType t on t.promotiontypeid = P.promotiontypeid

-------CREATE STAGGING PROMOTION DIMENSION TABLE (PROMOTION)-----
use [Tesca Staging Database]

Create table tescadb.promotion 
(
	PromotionID int,
	Promotion nvarchar (50),
	Discountpercent float, 
	PromotionStartdate date,
	PromotionEnddate Date,
	Loaddate datetime default getdate(),
	Constraint tescadb_promotion_pk primary key (PromotionId)
)

Truncate table tescadb.promotion



------------------------CUSTOMER DIMENSION---------------------

---------PRECOUNT FOR CONTROL METRICS (SOURCECOUNT DECLARATION)------ 
Select  Count(*) as StgSourceCount  from Customer C   ------Before move-------
INNER JOIN City CT ON CT.CityID = C.CityID
INNER JOIN STATE S ON S.StateID = CT.StateID

---------POSTCOUNT FOR CONTROL PACKAGE (DESTINATION COUNT DECLARATION)------ 
select count(*) as StgDescCount from Tescadb.customer  ------After move-------


-------PREPARE CUSTOMER DATA TO LOAD INTO STAGGING FROM OLTP (DENORMALIZED)---
use [Tesca OLTP Database ]
SELECT C.CustomerID, Upper (C.LastName) + ', ' + c.FirstName as CustomerName, C.CustomerAddress, CT.CityName as City, S.State, getdate() as LoadDate FROM Customer C
INNER JOIN City CT ON CT.CityID = C.CityID
INNER JOIN STATE S ON S.StateID = CT.StateID

-------CREATE STAGGING CUSTOMER DIMENSION TABLE (CUSTOMER)-----
use [Tesca Staging Database]

CREATE TABLE tescadb.customer 
(
	CustomerID INT,
	CustomerName nvarchar (250),
	CustomerAddress nvarchar (250),
	City nvarchar (50),
	State nvarchar (50),
	Loaddate datetime default getdate (),
	constraint Tescadb_customer_pk primary key (customerID)
)

Truncate table Tescadb.customer

 


--------------------------POS CHANNEL DIMENSION-----------------------------

---------PRECOUNT FOR CONTROL METRICS (SOURCECOUNT DECLARATION)------ 
Select  Count(*) as StgSourceCount  from poschannel P ------Before move-------

---------POSTCOUNT FOR CONTROL PACKAGE (DESTINATION COUNT DECLARATION)------ 
select count(*) as StgDescCount from tescadb.poschannel ------After move-------


-------PREPARE POSCHANNEL DATA TO LOAD INTO STAGGING FROM OLTP (DENORMALIZED)---
use [Tesca OLTP Database ]

SELECT P.ChannelID, P.ChannelNo, P.DeviceModel, P.InstallationDate, P.SerialNo, getdate () as loaddate FROM POSChannel P

-------CREATE STAGGING POSCHANNEL DIMENSION TABLE (Pos Channel)-----
use [Tesca Staging Database]

CREATE TABLE tescadb.poschannel
(
	ChannelID INT,
	ChannelNo NVARCHAR (50),
	DeviceModel nvarchar (50),
	SerialNo nvarchar (50),
	InstallationDate date, 
	Loaddate datetime default getdate (),
	constraint tescadb_poschannel_pk primary key (ChannelID)
) 
Truncate table tescadb.poschannel




--------------------------VENDOR DIMENSION---------------------------

---------PRECOUNT FOR CONTROL METRICS (SOURCECOUNT DECLARATION)------ 
Select  Count(*) as StgSourceCount  FROM Vendor V   ------Before move-------
INNER JOIN City C ON C.CityID = V.CityID
INNER JOIN State S ON S.StateID = C.StateID

---------POSTCOUNT FOR CONTROL PACKAGE (DESTINATION COUNT DECLARATION)------ 
select count(*) as StgDescCount from tescadb.vendor ------After move-------


-------PREPARE VENDOR DATA TO LOAD INTO STAGGING FROM OLTP (DENORMALIZED)---
use [Tesca OLTP Database ]

SELECT V.VendorID,V.VendorNo,V.RegistrationNo,CONCAT (UPPER(V.LASTNAME), ',', V.FIRSTNAME) AS VENDORNAME, V.VendorAddress, C.CityName AS City, S.State, getdate() as loaddate FROM Vendor V
INNER JOIN City C ON C.CityID = V.CityID
INNER JOIN State S ON S.StateID = C.StateID


-------CREATE STAGGING VENDOR DIMENSION TABLE (VENDOR)-----
use [Tesca Staging Database]
CREATE TABLE tescadb.vendor

(	
		VendorId int,
		VendorNo Nvarchar (50),
		VendorName Nvarchar (250),
		RegistrationNo nvarchar (50),
		VendorAddress Nvarchar (50), 
		City nvarchar (50),
		State nvarchar (50),
		Loaddate datetime default getdate(),
		constraint tescadb_vendor_pk primary key (VendorID)
)
Truncate Table tescadb.vendor	





--------------------EMPLOYEE DIMENSION-------------------------------
Select  Count(*) as StgSourceCount  FROM Employee E    ------Before move-------
INNER JOIN MaritalStatus M ON M.MaritalStatusID = E.MaritalStatus

---------POSTCOUNT FOR CONTROL PACKAGE (DESTINATION COUNT DECLARATION)------ 
select count(*) as StgDescCount from tescadb.employee ------After move-------


-------PREPARE Employee DATA TO LOAD INTO STAGGING FROM OLTP (DENORMALIZED)---
use [Tesca OLTP Database ]
SELECT E.EmployeeID,E.EmployeeNo, CONCAT (UPPER(E.LASTNAME), ',', E.FirstName) as EmployeeName, E.DoB as EmployeeDoB, M.MaritalStatus, getdate () as loaddate FROM Employee E
INNER JOIN MaritalStatus M ON M.MaritalStatusID = E.MaritalStatus


-------CREATE STAGGING EMPLOYEE DIMENSION TABLE (EMPLOYEE)-----
use [Tesca Staging Database]
Create table tescadb.employee 
(
	EmployeeID int,
	EmployeeNo Nvarchar (50),
	EmployeeName Nvarchar (250),
	EmployeeDOB Date,
	MaritalStatus Nvarchar (50),
	Loaddate Datetime default getdate (),
	Constraint tescadb_employee_pk primary key (EmployeeID)
)
Truncate Table tescadb.employee	

	


-----------------------HRMISCONDUCT DIMESION--------------
---------POSTCOUNT FOR CONTROL PACKAGE (DESTINATION COUNT DECLARATION)------ 
select count(*) as StgDescCount from hrmisconduct.misconduct ------After move-------

---------FROM FLAT FILE-------MISCONDUCT No OLTP LOAD TO STAGGING FROM FLAT FILE 
-------CREATE STAGGING Misconduct DIMENSION TABLE (misconduct)-----

USE [Tesca Staging Database]

CREATE TABLE hrmisconduct.misconduct 
(
	Misconductid int,
	Misconductdiscription nvarchar (250),
	Loaddate datetime default getdate (),

)
Truncate Table  hrmisconduct.misconduct  




-----------------------------DECISION DIMENSION-----------------
---------POSTCOUNT FOR CONTROL PACKAGE (DESTINATION COUNT DECLARATION)------ 
select count(*) as StgDescCount from hrmisconduct.decision ------After move-------

-------CREATE STAGGING Decision DIMENSION TABLE (decision)-----

USE [Tesca Staging Database]

CREATE TABLE hrmisconduct.decision 
(
	Decisionid int,
	DEcision nvarchar (250),
	Loaddate datetime default getdate (),

)
Truncate Table  hrmisconduct.Decision 





----------ABSENT MISCONDUCT DIMENSION----------
---------POSTCOUNT FOR CONTROL PACKAGE (DESTINATION COUNT DECLARATION)------ 
select count(*) as StgDescCount from hrabsent.absentcategory  ------After move-------


-------CREATE STAGGING Absent DIMENSION TABLE (absentcategory)-----
USE [Tesca Staging Database]

CREATE TABLE hrabsent.absentcategory
(
	Categoryid int,
	Category nvarchar (250),
	Loaddate datetime default getdate (),

)
Truncate Table  hrabsent.absentcategory 


