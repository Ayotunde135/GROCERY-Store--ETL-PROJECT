

Schema Tesca

				---------------FACT TABLES SALES TRANSACTION  Stagging-------------------------------

	---------PRECOUNT FOR CONTROL METRICS (SOURCECOUNT DECLARATION)------------

	Declare @StgSourceCount bigint = 0                     ------Before move-------

	IF (Select count (*) from [Tesca EDW Database].tesca.fact_sales_analysis) > 0
		
		BEGIN
		
				Select @StgSourceCount = 
								
								(
									Select count(*) as StgSourceCount From salesTransaction s	
									Where convert(date, TransDate) =dateadd(day, -1 , convert(date,getdate()))
								 )	
		END
	ELSE 
		BEGIN


				Select @StgSourceCount = 
				
									(
										Select count(*) as StgSourceCount From salesTransaction s
		
										Where convert(date, TransDate) <=dateadd(day, -1 , convert(date,getdate()))
									)   

		END
		
		Select @StgSourceCount as StgSourceCount

---------POSTCOUNT FOR CONTROL PACKAGE (DESTINATION COUNT DECLARATION)------ 

 Select count(*) as StgDescCount from tescaDb.sales_Trans   ------After move-------



----------SELECT DATA TO LOAD FROM OLTP INTO STAGGING FOR SALES _TRANS

		USE [Tesca OLTP Database ]

	 IF (Select count (*) from [Tesca EDW Database].tesca.fact_sales_analysis) > 0
		
		BEGIN

		Select  s.TransactionID, s.TransactionNO,
				convert(date, TransDate) as TransDate, datepart(hour, TransDate) TransHour,
				convert(date, OrderDate) as OrderDate, datepart(hour, OrderDate) OrderHour,
				convert(date,deliveryDate) as DeliveryDate, 
				ChannelID,CustomerID,EmployeeID, ProductID,StoreID,PromotionID,
				Quantity,TaxAmount,LineAmount, LineDiscountAmount,
				GetDate() as LoadDate

			From salesTransaction s
		Where   convert(date, TransDate) =dateadd(day, -1 , convert(date,getdate())) 	

		END
ELSE 
		BEGIN


		Select  s.TransactionID, s.TransactionNO,
					convert(date, TransDate) as TransDate, datepart(hour, TransDate) TransHour,
					convert(date, OrderDate) as OrderDate, datepart(hour, OrderDate) OrderHour,
					convert(date,deliveryDate) DeliveryDate, 
					ChannelID,CustomerID,EmployeeID, ProductID,StoreID,PromotionID,
					Quantity,TaxAmount,LineAmount, LineDiscountAmount,
					GetDate() as LoadDate
		
				From salesTransaction s
		
		Where   convert(date, TransDate) <=dateadd(day, -1 , convert(date,getdate()))    

		END
	
		-----CREATE STAGING TABLE (SALES) TO LOAD THE DATA FROM OLTP------
	
		Use [Tesca Staging Database]

	Create table tescaDb.sales_trans
 (  TransactionID int,
    TransactionNo nvarchar(50),
	TransDate Date, 
	TransHour int, 
	OrderDate date,
	OrderHour int, 
	DeliveryDate date,
	ChannelID int, 
	CustomerID int, 
	EmployeeID int,
	ProductID int,
	StoreID int,
	PromotionID int,
	Quantity float,
	TaxAmount float,
	LineAmount float,
	LineDiscountAmount float,
	LoadDate datetime default getdate(),
	constraint tescaDb_sales_trans_pk primary key(TransactionID)
)

 Truncate Table tescaDb.sales_Trans




					------------------HR OVERTIME---------------
 

 -----CREATE STAGING TABLE (Overtime) TO LOAD THE DATA FROM Flat file ------
 
 use [Tesca Staging Database]
 
  Drop table tescaDb.Overtime_Trans
 Create table tescaDb.Overtime_Trans
 (
   OvertimeID Bigint,
   EmployeeNo nvarchar(50),
   FirstName nvarchar(50),
   LastName nvarchar(50),
   StartOvertime datetime,
   EndOvertime datetime,
   LoadDate datetime
 )
Truncate table  tescaDb.Overtime_Trans


Select count(*) as StgDescCount from tescadb.Overtime_Trans
Select count(*) as EdwCount from tesca.Fact_Hr_Overtime




               ----------------- Absent data ------------------------
 -----CREATE STAGING TABLE (Absent data) TO LOAD THE DATA FROM Flat file------
 
 use [Tesca Staging Database]
 
 Create Table  tescaDB.hr_absence_analysis
	(
	  empid int,
	  store int,
	  absent_date date,
	  absent_hour  int,
	  absent_category  int,
	  Loadate datetime default getdate()
	)

Truncate table  tescaDB.hr_absence_analysis

Select count(*) as StgDescCount from tescaDB.hr_absence_analysis
Select count(*) as EdwCount from tesca.fact_hr_absence_analysis





                    ---------------------------------------------MISCONDUCT ANALYSIS-----------------------------------------

 -----CREATE STAGING TABLE (Misconduct) TO LOAD THE DATA OLTP

 empid,storeid,misconduct_date,misconduct_id,decision_id

 use [Tesca Staging Database]
 
 Create Table  tescaDB.hr_misconduct_analysis
 (
  misconduct_id  int,
  empid int,
  storeID int,
  Misconduct_date date,
  decision_Id  int,
  Loadate datetime default getdate()
 )

Truncate table  tescaDB.hr_misconduct_analysis

Select * from tescaDb.Overtime_Trans

Select count(*) as StgDescCount from tescaDB.hr_misconduct_analysis

Select count(*) as EdwCount from tesca.fact_hr_misconduct_analysis



 	

