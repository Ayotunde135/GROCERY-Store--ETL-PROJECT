

				---------------CREATE FACT TABLES SALES TRANS -------------------------------



------------------------------SOURCECOUNT DECLARATION FOR SALES-----------------------


	Declare @StgSourceCount bigint = 0

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


 Select count(*) as StgDescCount from tescaDb.sales_Trans ------------------------------------Destination Count



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




 -------------------------------------------------------PURCHASE TRANS-------------------------------------------
 
	--------------------------SOURCE COUNT-----------------------------
	
	Declare @StgSourceCount Bigint = 0

	IF (select count(*) from [Tesca EDW Database].tesca.Fact_Purchase_Analysis)<=0 
	
	BEGIN

		Select	@StgSourceCount=
		
				(
					Select count(*) as StgSourceCount From  PurchaseTransaction  p  
					Where  convert(date,TransDate)<= dateadd(day, -1,convert(date,getdate()))
				)
	END
 ELSE
  BEGIN

		Select	@StgSourceCount=
		
					(
						Select count(*) as StgSourceCount From  PurchaseTransaction  p  
						Where  convert(date,TransDate) = dateadd(day, -1,convert(date,getdate()))
					)
	END

	Select @StgSourceCount as StgSourceCount


 select count(*) as StgDescCount from tescaDB.Purchase_Analysis  ------------------------------------Destination Count



----------SELECT DATA TO LOAD FROM OLTP INTO STAGGING FOR Purchase TRANS

	USE [Tesca OLTP Database ]

			IF (select count(*) from [Tesca EDW Database].tesca.Fact_Purchase_Analysis)<=0 
	BEGIN

		Select	p.TransactionID,p.TransactionNO,
				Convert(date, TransDate) TransDate, CONVERT(date,OrderDate) OrderDate,
				CONVERT(date, p.DeliveryDate) DeliveryDate, Convert(date, p.ShipDate) ShipDate, 
				p.VendorID,p.EmployeeID,p.ProductID,p.StoreID,p.Quantity,p.LineAmount,p.TaxAmount, 
	
				Datediff(day, CONVERT(date, OrderDate), convert(date, DeliveryDate))+1 as Delivery_Services,
				Getdate() as Loaddate
				From  PurchaseTransaction  p  
	
		Where  convert(date,TransDate)<= dateadd(day, -1,convert(date,getdate()))
	END
 ELSE
  BEGIN

		Select	p.TransactionID,p.TransactionNO,
				Convert(date, TransDate) TransDate, CONVERT(date,OrderDate) OrderDate,
				CONVERT(date, p.DeliveryDate) DeliveryDate, Convert(date, p.ShipDate) ShipDate, 
				p.VendorID,p.EmployeeID,p.ProductID,p.StoreID,p.Quantity,p.LineAmount,p.TaxAmount, 
	
				Datediff(day, CONVERT(date, OrderDate), convert(date, DeliveryDate))+1 as Delivery_Services,
				Getdate() as Loaddate
				From  PurchaseTransaction  p  
	
		Where  convert(date,TransDate) = dateadd(day, -1,convert(date,getdate()))
	END

	
	
	-----CREATE STAGING TABLE (Purchase) TO LOAD THE DATA FROM OLTP------

	use [Tesca Staging Database]

 create table tescaDB.Purchase_Analysis
 (
   TransactionID int,
   TransactionNO nvarchar(50),
   TransDate  Date, 
   OrderDate  Date,
   DeliveryDate Date,
  ShipDate  Date,
  VendorID int,
  EmployeeID int,
  ProductID int,
  StoreID int,
  Quantity float,  
  LineAmount float,
  TaxAmount float,  
  Delivery_Services int ,
  LoadDate datetime default getDate(),
  constraint tescaDb_purchase_Analysis_pk primary key(TransactionID) 
 )

 Truncate Table tescaDB.Purchase_Analysis




 ------HR OVERTIME------
 
 -----CREATE STAGING TABLE (Overtime) TO LOAD THE DATA FROM Flat file------
 
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


Select count(*) as StgDescCount from tescaDb.Overtime_Trans
Select count(*) as EdwCount from tesca.Fact_Hr_Overtime




                  -------- Absent data ----
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




      -------- Misconduct ----

 -----CREATE STAGING TABLE (Misconduct) TO LOAD THE DATA FROM Flat file------


 use [Tesca Staging Database]
 
 Create Table  tescaDB.hr_misconduct_analysis
 (
  empid int,
  store int,
  Misconduct_date date,
  misconduct_id  int,
  decision_Id  int,
  Loadate datetime default getdate()
 )

Truncate table  tescaDB.hr_misconduct_analysis

Select count(*) as StgDescCount from tescaDB.hr_misconduct_analysis
Select count(*) as EdwCount from tesca.fact_hr_misconduct_analysis

