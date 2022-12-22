

----LOADING EDW DIMENSIONS FROM STAGGING


-------SCHEMA FOR EDW--------
Create schema (tesca)

----------------------PRODUCT DIMENSION-------------
-------PREPARE PRODUCT DATA TO LOAD INTO EDW FROM STAGGING (DENORMALIZED)---

USE [Tesca Staging Database]
select productid, product, productNumber, Unitprice, department from tescadb.product


-------CREATE EDW PRODUCT DIMENSION TABLE (DIMPRODUCT)-----
use [Tesca EDW Database]

create table tesca.dimproduct 
(
	productSk int identity (1,1),
	productID INT,
	PRODUCT NVARCHAR (50),
	PRODUCTNUMBER NVARCHAR (50),
	UNITPRICE FLOAT,
	DEPARTMENT NVARCHAR (50),
	Startdate DATETIME,
	ENDDATE DATETIME,
	Constraint tesca_dimproduct_sk primary key (productSk)

)

-----------------CONTROL METRICS-----------
Select Count(*) as Currentcount from tescadb.product
select count(*) as PreCount from tesca.dimproduct
select count(*) as PostCount from tesca.dimproduct


---------------STORE DIMENSION------------

-------PREPARE STORE DATA TO LOAD INTO EDW FROM STAGGING (DENORMALIZED)---

USE [Tesca Staging Database]

select storeid,StoreName,StreetAddress,City,State, getdate() as startdate from tescadb.store

-------CREATE EDW STORE DIMENSION TABLE (DIMSTORE)-----
use [Tesca EDW Database]
create table tesca.dimStore 
(
	StoreSk int identity (1,1),
	Storeid int,
	StoreName nvarchar (50),
	StreetAddress nvarchar (50),
	City nvarchar (50),
	State Nvarchar (50),
	Startdate Datetime,
	constraint tescadb_dimstore_Sk primary key (StoreSk)
)

-----------------CONTROL METRICS-----------
Select Count(*) as Currentcount from tescadb.store
select count(*) as PreCount from tesca.dimStore 
select count(*) as PostCount from tesca.dimStore 


-----------------------------PROMOTION DIMENSION-----------------

-------PREPARE PROMOTION DATA TO LOAD INTO EDW FROM STAGGING (DENORMALIZED)---

USE [Tesca Staging Database]

Select tp.promotionid,tp.promotion,tp.discountpercent,tp.promotionstartdate,tp.promotionenddate, getdate() from tescadb.promotion tp


-------CREATE EDW PROMOTION DIMENSION TABLE (DIMPROMOTION)-----
USE [Tesca EDW Database]

Create table tesca.dimpromotion 
(
	PromotionSK INT identity (1,1),
	PromotionID int,
	Promotion nvarchar (50),
	Discountpercent float, 
	PromotionStartdate date,
	PromotionEnddate Date,
	Startdate datetime,
	Constraint tescadb_dimpromotion_sk primary key (Promotionsk)
)

-----------------CONTROL METRICS-----------
Select Count(*) as Currentcount from tescadb.promotion
select count(*) as PreCount from tesca.DIMpromotion
select count(*) as PostCount from tesca.DIMpromotion


------------------------CUSTOMER DIMENSION---------------------

-------PREPARE CUSTOMER DATA TO LOAD INTO EDW FROM STAGGING (DENORMALIZED)---

use [Tesca Staging Database]
select tc.customerid, tc.customername, tc.customeraddress, tc.city, tc.state from tescadb.customer tc

-------CREATE EDW PROMOTION DIMENSION TABLE (DIMCUSTOMER)-----
USE [Tesca EDW Database]

CREATE TABLE tesca.dimcustomer 
(
	CustomerSk int identity (1,1),
	CustomerID INT,
	CustomerName nvarchar (250),
	CustomerAddress nvarchar (250),
	City nvarchar (50),
	State nvarchar (50),
	Startdate datetime,
	EndDate datetime,
	constraint Tesca_dimcustomer_sk primary key (customerSk)
)

-----------------CONTROL METRICS-----------
Select Count(*) as Currentcount from Tescadb.customer
select count(*) as PreCount from TESCA.DIMCUSTOMER
select count(*) as PostCount from TESCA.DIMCUSTOMER




--------------------------POS CHANNEL DIMENSION-----------------------------
-------PREPARE POSCHANNEL DATA TO LOAD INTO EDW FROM STAGGING (DENORMALIZED)--

SELECT PS.ChannelID, PS.ChannelNo, ps.DeviceModel, ps.SerialNo, ps.InstallationDate FROM TESCADB.POSCHANNEL PS

-------CREATE EDW POSCHANNEL DIMENSION TABLE (DIMPOSCHANNEL)-----
USE [Tesca EDW Database]

CREATE TABLE tesca.dimposchannel
(
	ChannelSK INT IDENTITY (1,1),
	ChannelID INT,
	ChannelNo NVARCHAR (50),
	DeviceModel nvarchar (50),
	SerialNo nvarchar (50),
	InstallationDate date, 
	Startdate datetime,
	Enddate Datetime,
	constraint tesca_dimposchannel_Sk primary key (ChannelSk)
) 

-----------------CONTROL METRICS-----------
Select Count(*) as Currentcount from tescadb.poschannel
select count(*) as PreCount from TESCA.DIMPOSCHANNEL
select count(*) as PostCount from TESCA.DIMPOSCHANNEL



--------------------------VENDOR DIMENSION---------------------------

-------PREPARE VENDOR DATA TO LOAD INTO EDW FROM STAGGING (DENORMALIZED)--
USE [Tesca Staging Database]

SELECT TV.VENDORID, TV.VENDORNO, TV.VENDORNAME, TV.REGISTRATIONNO, TV.VENDORADDRESS, TV.CITY, TV.STATE FROM TESCADB.VENDOR TV


-------CREATE EDW VENDOR DIMENSION TABLE (DIMVENDOR)-----
use [Tesca EDW Database]

CREATE TABLE tesca.dimvendor 

(
		VendorSk int identity (1,1),
		VendorId int,
		VendorNo Nvarchar (50),
		VendorName Nvarchar (50),
		RegistrationNo nvarchar (50),
		VendorAddress Nvarchar (50), 
		City nvarchar (50),
		State nvarchar (50),
		Startdate datetime,
		Enddate datetime,
		constraint tesca_DIMvendor_Sk primary key (VendorSk)
)

-----------------CONTROL METRICS-----------
Select Count(*) as Currentcount from Tescadb.vendor
select count(*) as PreCount from TESCA.DIMvendor
select count(*) as PostCount from TESCA.DIMvendor




--------------------EMPLOYEE DIMENSION-------------------------------
-------PREPARE EMPLOYEE DATA TO LOAD INTO EDW FROM STAGGING (DENORMALIZED)--
use [Tesca Staging Database]
Select TE.employeeid, TE.employeeNo, TE.EmployeeName, TE.EmployeeDOB, TE.maritalstatus from tescadb.employee TE

-------CREATE EDW Employee DIMENSION TABLE (DIMEmployee)-----
use [Tesca EDW Database]

Create Table tesca.dimEmployee 
(
	EmployeeSk int identity (1,1),
	EmployeeID int,
	EmployeeNo Nvarchar (50),
	EmployeeName Nvarchar (250),
	EmployeeDOB Date,
	MaritalStatus Nvarchar (50),
	Startdate Datetime,
	Enddate Datetime,
	Constraint tesca_DIMemployee_Sk primary key (EmployeeSK)
)

-----------------CONTROL METRICS-----------
Select Count(*) as Currentcount from Tescadb.employee
select count(*) as PreCount from Tesca.DimEmployee
select count(*) as PostCount from Tesca.DimEmployee





-----------------------HRMISCONDUCT DIMESION--------------
-------PREPARE MISCONDUCT DATA TO LOAD INTO EDW FROM STAGGING (DENORMALIZED)--

use [Tesca Staging Database]
Select HM.MISCONDUCTID, HM.MISCONDUCTDISCRIPTION from HrMisconduct.misconduct HM
group by HM.MISCONDUCTID, HM.MISCONDUCTDISCRIPTION

-------CREATE EDW MISCONDUCT DIMENSION TABLE (DIMMisconduct)-----
use [Tesca EDW Database]

CREATE TABLE tesca.dimmisconduct 
(
	MisconductSK int identity (1,1),
	Misconductid int,
	Misconductdiscription nvarchar (50),
	Startdate datetime,
	constraint Tesca_DIMmisconduct_Sk primary key (MisconductSK)
)

-----------------CONTROL METRICS-----------
Select Count(*) as Currentcount from [HrMisconduct].misconduct
select count(*) as PreCount from Tesca.DIMmisconduct
select count(*) as PostCount from Tesca.DIMmisconduct






-----------------------------DECISION DIMENSION-----------------
-------PREPARE Decision DATA TO LOAD INTO EDW FROM STAGGING (DENORMALIZED)--
use [Tesca Staging Database]
Select Hd.DecisionID, Hd.Decision from HrMisconduct.Decision Hd
group by Hd.DecisionID, Hd.Decision

-------CREATE EDW Decision DIMENSION TABLE (DIMDecision)-----
use [Tesca EDW Database]

CREATE TABLE tesca.dimdecision
(
	DecisionSK int identity (1,1),
	Decisionid int,
	Decision nvarchar (250),
	Startdate datetime,
	constraint Tesca_DIMDecision_Sk primary key (DecisionSK)
)

-----------------CONTROL METRICS----------
Select Count(*) as Currentcount from [HrMisconduct].Decision
select count(*) as PreCount from Tesca.DIMDecision
select count(*) as PostCount from Tesca.DIMDecision




----------ABSENT MISCONDUCT DIMENSION----------
------PREPARE Decision DATA TO LOAD INTO EDW FROM STAGGING (DENORMALIZED)--
use [Tesca Staging Database]

Select CA.Categoryid, CA.Category from [HrAbsent].Absentcategory CA
group by CA.Categoryid, CA.Category

-------CREATE EDW Employee DIMENSION TABLE (DIMDecision)-----
use [Tesca EDW Database]

CREATE TABLE tesca.dimabsentcategory
(
	CategorySK int identity (1,1),
	Categoryid int,
	Category nvarchar (250),
	Startdate datetime,
	constraint Tesca_DIMAbsentCategory_Sk primary key (CategorySK)
)

-----------------CONTROL METRICS----------
Select Count(*) as Currentcount from [HrAbsent].Absentcategory
select count(*) as PreCount from Tesca.DIMAbsentcategory
select count(*) as PostCount from Tesca.DIMAbsentcategory

