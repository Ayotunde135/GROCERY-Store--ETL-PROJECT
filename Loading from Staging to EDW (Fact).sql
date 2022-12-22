


---------------------------------------------LOADING EDW FACT FROM STAGGING----------


---------------FACT TABLES SALES TRANSACTION EDW-------------------------------

----------SELECT DATA TO LOAD FROM STAGGING INTO EDW FOR SALES_TRANS
	
	Use [Tesca Staging Database]

	Select  TransactionID,TransactionNo ,TransDate, 
			TransHour,OrderDate,OrderHour, DeliveryDate ,
			ChannelID, CustomerID, EmployeeID,ProductID,StoreID,
			PromotionID,Quantity,TaxAmount,LineAmount,LineDiscountAmount, 
			GetDate() as LoadDate 
	
		From tescadb.sales_Trans


-----CREATE EDW TABLE (Sales) TO LOAD THE DATA FROM Stagging------

USE [Tesca EDW Database]

create table  tesca.fact_sales_analysis
(
 sales_analysis_sk bigint identity(1,1),
 TransactionID int,
 TransactionNo nvarchar(50),
 TransDateSk  int,
 TransHoursk int,
 OrderDateSK int, 
 OrderHourSk  int,
 DeliveryDateSK int, 
 ChannelSk int,
 customerSk int,
 EmployeeSk int,
 ProductSk int,
 StoreSk int,
 PromotionSk int,
 Quantity float,
 TaxAmount float,
 LineAmount float,
 LineDiscountAmount float,
 LoadDate datetime, 
 constraint  tesca_sales_analysis_sk  primary key(sales_analysis_sk),
 constraint  tesca_sales_transDatesk   foreign key (TransDateSk) references tesca.dimdate(datesk),
 constraint  tesca_sales_transHoursk   foreign key (TransHourSk) references tesca.dimHour(Hoursk),
 constraint  tesca_sales_OrderDateSk   foreign key (OrderDateSk) references tesca.dimdate(datesk),
 constraint  tesca_sales_OrderHoursk   foreign key (OrderHourSk) references tesca.dimHour(Hoursk),
 constraint  tesca_sales_DeliveryDatesk   foreign key (DeliveryDateSk) references tesca.dimdate(datesk),
 constraint  tesca_Sales_channelsk  foreign key(ChannelSk) references tesca.dimPosChannel(ChannelSk),
 constraint  tesca_Sales_customersk  foreign key(CustomerSk) references tesca.dimCustomer(CustomerSk),
 constraint  tesca_Sales_Employeesk  foreign key(EmployeeSk) references tesca.dimEmployee(EmployeeSk),
 constraint  tesca_Sales_productsk  foreign key(ProductSk) references tesca.dimProduct(productSk),
 constraint  tesca_Sales_Storesk  foreign key(StoreSk) references tesca.dimStore(StoreSk),
 constraint  tesca_Sales_Promotionsk  foreign key(promotionSk) references tesca.dimPromotion(promotionsk)
)




	---------PURCHASE TRANSACTION EDW FACT ----------------------------

 	-----CREATE EDW TABLE SALES ------
----------SELECT DATA TO LOAD FROM STAGGING INTO EDW FOR FACT_ SALES-TRANS
	
	Use [Tesca Staging Database]

		Select  TransactionID, TransactionNO, TransDate, 
				OrderDate ,DeliveryDate,ShipDate,VendorID,
				EmployeeID,ProductID,StoreID,Quantity,LineAmount,
				TaxAmount,Delivery_Services,
				Getdate() as LoadDate  
				
		from tescaDB.Purchase_Analysis

 -----CREATE EDW TABLE (Purchase) TO LOAD THE DATA FROM Stagging------
 
 use [Tesca EDW Database]

 create table tesca.Fact_Purchase_Analysis
 (
  purchase_analysis_sk bigint identity(1,1),
  Transactionid int,
  TransactionNo nvarchar(50),
  TransDateSk  int,
  OrderDateSk int,
  DeliveryDateSk int,
  ShipDateSk int,
  VendorSk int,
  EmployeeSk int,
  ProductSK int,
  StoreSK int,  
  Quantity float,
  LineAmount float,
  TaxAmount float,
  Delivery_Services int,
  LoadDate datetime default getdate(), 
 Constraint  tesca_Purchase_Analysis_sk  primary key(purchase_analysis_sk),
 constraint  tesca_purchase_transDatesk   foreign key (TransDateSk) references tesca.dimdate(datesk),
 constraint  tesca_purchase_OrderDatesk   foreign key (OrderDateSk) references tesca.dimdate(datesk),
 constraint  tesca_purchase_DeliveryDatesk   foreign key (DeliveryDateSk) references tesca.dimdate(datesk),
 constraint  tesca_purchase_ShipDatesk   foreign key (ShipDateSk) references tesca.dimdate(datesk),
 constraint tesca_purchase_VendorSk foreign key(VendorSk) references tesca.DimVendor(VendorSK),
 constraint tesca_purchase_EmployeeSk foreign key(EmployeeSk) references tesca.DimEmployee(EmployeeSK),
 constraint tesca_purchase_ProductSk foreign key(ProductSk) references tesca.DimProduct(ProductSK),
 constraint tesca_purchase_StoreSk foreign key(StoreSk) references tesca.DimStore(StoreSK) 
 )






 ------------------HR OVERTIME---------------

 	-----CREATE EDW TABLE SALES ------
----------SELECT DATA TO LOAD FROM STAGGING INTO EDW FOR OVERTIME

 use [Tesca Staging Database]

	Select  OvertimeID, EmployeeNo,FirstName, LastName, 
			Convert(date, StartOvertime) StartOvertimeDate,
			Datepart(hour, StartOvertime) StartOvertimeHour,
			Convert(date,EndOvertime) EndOvertimeDate,
			DATEPART(hour, EndOvertime) EndOvertimeHour,  
			DATEDIFF(hour,StartOvertime,EndOvertime) OvertimeHour
  
  FROM	 tescaDb.Overtime_Trans Where OvertimeID in
		( 
		
		Select min(OvertimeID)  from tescaDb.Overtime_Trans
		Group by EmployeeNo,FirstName, LastName,StartOvertime,EndOvertime
		
		)

	 -----CREATE EDW TABLE (OVERTIME) TO LOAD THE DATA FROM Stagging------

  use [Tesca EDW Database]

 Create Table tesca.Fact_Hr_Overtime
 (
  Hr_Overtime_SK bigint  identity(1,1),
  EmployeeSk int,
  StartOverDateSk int,
  StartOverHourSk int,
  EndOverDateSk int,
  EndOverHourSk int,
  OvertimeHour int,
  LoadDate datetime default getdate(),
  constraint tesca_hr_overtime_sk primary key (Hr_Overtime_SK),
  constraint tesca_hr_overtime_employeesk foreign key (EmployeeSk) references  tesca.dimEmployee(EmployeeSk),
  constraint tesca_hr_Overtime_StartOverDatesk foreign key(StartoverDateSk) references tesca.dimDate(datesk),
  constraint tesca_hr_Overtime_StartOverHoursk foreign key(StartoverHourSk) references tesca.dimHour(HourSk),
  constraint tesca_hr_Overtime_EndOverDatesk foreign key(EndoverDateSk) references tesca.dimDate(datesk),
  constraint tesca_hr_Overtime_EndOverHoursk foreign key(EndoverHourSk) references tesca.dimHour(HourSk) 
 )





   ---------------------------- Absent data ------------------------
 
 	-----CREATE EDW TABLE SALES ------
----------SELECT DATA TO LOAD FROM STAGGING INTO EDW FOR Absent data

 use [Tesca Staging Database]

			With 
	
				Absent_Data (RowID, Absentkey, empid,store,absent_date,absent_hour,absent_category)
					
					AS
					
					(
						 select  
								ROW_NUMBER() over ( order by empid,store,absent_date,absent_hour,absent_category) as RowID, 
								Concat_WS('~',empid,store, absent_date,absent_hour, absent_category) as absentKey, 
								empid,store,absent_date,absent_hour,absent_category
						 
						 FROM  tescaDb.hr_absence_analysis
					)
  
				Select empid,store,absent_date,absent_hour,absent_category from Absent_Data
				
				Where  RowID  in 
								(	
									Select min(RowID) from Absent_Data 
									Group by Absentkey
								)
	  
	  -----CREATE EDW TABLE (Absent data) TO LOAD THE DATA FROM Stagging------

  use [Tesca EDW Database]

  Create Table  tesca.fact_hr_absence_analysis
 (
   hr_absence_analysis_Sk bigInt identity(1,1),
   EmployeeSk int,
   storesk int,
   absentdateSk int,   
   absentcategorySk  int,
   absent_hour  int,
   LoadDate datetime default getdate(),
  constraint tesca_hr_absence_analysis_Sk primary key(hr_absence_analysis_Sk),
  constraint tesca_hr_absence_analysis_employeesk foreign key (EmployeeSk) references  tesca.dimEmployee(EmployeeSk),
  constraint tesca_hr_absence_analysis_Storesk foreign key (StoreSk) references  tesca.dimStore(StoreSk),
  constraint  tesca_hr_absence_analysis_absentDatesk   foreign key (absentdateSk) references tesca.dimdate(datesk),
  constraint  tesca_hr_absence_analysis_absentCategorySk   foreign key (absentcategorySk) references tesca.DimAbsentCategory(Categorysk)
 )






 ---------------------------------------------MISCONDUCT ANALYSIS-----------------------------------------

----------SELECT DATA TO LOAD FROM STAGGING INTO EDW FOR Misconduct

 use [Tesca Staging Database]

 With 
	
				Misconduct_data (RowID, MisconductKey, empid,store,misconduct_date,misconduct_id,decision_id)
					
					AS
					
					(
						 select  
								ROW_NUMBER() over ( order by empid,store,misconduct_date,misconduct_id,decision_id) as RowID, 
								Concat_WS('~',empid,store,misconduct_date,misconduct_id,decision_id) as MisconductKey, 
								empid,store,misconduct_date,misconduct_id,decision_id
						 
						 FROM  tescaDB.hr_misconduct_analysis
					)
  
				Select empid,store,misconduct_date,misconduct_id,decision_id from MisconductKey
				
				Where  RowID  in 
								(	
									Select Max(RowID) from Misconduct_data 
									Group by MisconductKey
								)

                   
				   
				   -----CREATE EDW TABLE (Misconduct) TO LOAD THE DATA FROM Stagging------
				   ----- Fact Absent misconduct fact --------

use [Tesca EDW Database]

Create Table  tesca.fact_hr_misconduct_analysis
 (
   hr_misconduct_analysis_Sk bigInt identity(1,1),
   EmployeeSk int,
   storesk int,
   misconductDateSk int,   
   misconductSk int,   
   decisionSk  int,   
   LoadDate datetime default getdate(),
  constraint tesca_hr_misconduct_analysis_Sk primary key(hr_misconduct_analysis_Sk),
  constraint tesca_hr_misconduct_analysis_employeesk foreign key (EmployeeSk) references  tesca.dimEmployee(EmployeeSk),
  constraint tesca_hr_misconduct_analysis_Storesk foreign key (StoreSk) references  tesca.dimStore(StoreSk),
  constraint  tesca_hr_misconduct_analysis_MisconductDatesk   foreign key (misconductDateSk) references tesca.dimdate(datesk),
  constraint  tesca_hr_misconduct_analysis_misconductSk   foreign key (misconductSk) references tesca.DimMisconduct(misconductSk),
  constraint  tesca_hr_misconduct_analysis_decisionSk   foreign key (decisionSk) references tesca.DimDecision(decisionSk)
 )