
----------------HOUR AND DATE DIMENSION------------TSQL
select DATEPART (hour, getdate ())*60 + DATEPART (minute, getdate ()) as BreakTime
select DATEPART (hour, getdate ()) Breakhour
select DATEPART (minute, getdate ())as Breakminutes

select DATEPART (hour, getdate ())*60 + DATEPART (minute, getdate ()) as BreakTime

SET NOCOUNT ON
DECLARE @MAXNUM INT = 50
DECLARE @CURRENTCOUNT INT =1
WHILE @CURRENTCOUNT<=@MAXNUM
BEGIN
	If @CURRENTCOUNT%2 = 1
	PRINT ('male :' + cast(@CURRENTCOUNT as nvarchar))
	else
	PRINT ('Female :' + cast(@CURRENTCOUNT as nvarchar))
	SELECT @CURRENTCOUNT = @CURRENTCOUNT + 1

END
PRINT ('COUNT ENDS')


----------------HOUR AND DATE DIMENSION------------TSQL
USE [Tesca EDW Database]

CREATE TABLE TESCA.DIMHOUR 
(
	HOURSK Int identity (1,1),
	Time_Hour int,
	PeriodofDay nvarchar (50),
	BusinessHour nvarchar (50),
	StartDate datetime default getdate(),
	constraint tesca_dimhour_sk primary key (HOURSK)
)
 
 Create Procedure tesca.spDimhour
 
 AS

BEGIN
set nocount on 
 Declare @hourcount int = 0
 Declare @PeriodofDay nvarchar (50)
 Declare @BusinessHour nvarchar (50)
 
 Begin
		IF (select object_id (N'TESCA.DIMHOUR')) is NOT NULL   ------Control duplication---
			TRUNCATE TABLE TESCA.DIMHOUR
	
		while @hourcount <=23
		
	Begin
		insert into tesca.DIMHOUR (Time_Hour,PeriodofDay,BusinessHour,StartDate)
		
		Select @hourcount as Time_hour,
		Case
			when @hourcount =0 then 'Mid Night'
			When @hourcount >=1 and @hourcount <=4 then 'Early Hour'
			When @hourcount >=5 and @hourcount <=11 then 'Morning'
			When @hourcount =12 then 'Noon'
			When @hourcount >=13 and @hourcount <=16 then 'Afternoon'
			When @hourcount >=17 and @hourcount <=20 then 'Evening'
			when @hourcount >=21 and @hourcount <=23 then 'Night'
			End as periodoftheday,

		CASE 
			when @hourcount between 0 and 6 or  @hourcount between 18 and 23 then 'closed'
			when @hourcount between 7 and 17 then 'Open'
			End as BusinessHour, 
			Getdate() as Startdate

		select @hourcount = @hourcount +1
	End
 End
 END
 
 EXEC tesca.spDimhour

 select* from tesca.DIMHOUR
 
 -------Date----  
--- Datekey    --- YYYYMMDD
--- Date YYYY-MM-DD
--- Year
----Quarter 
--  Month
--- EnglishMonth
--- SpanishMonth
--- HinduMonth
--- DayofWeek ---Mond
--- Week
---select convert(nvarchar(8), GETDATE(),112)--- Surrogate key (DATESK)
---select DATEPART(year, getdate()) --- Actual Year
---select 'Q'+ cast(DATEPART(Quarter, getdate()) as nvarchar)------ACTUAL QUATER
----select DATEPART(MONTH, getdate())------ACTUAL MONTH
----select DATENAME (MONTH, getdate()) -----ENGLISH MONTH 
----SELECT DATENAME (WEEKDAY, getdate())-----EnglishDayofWeek

---Create date Dimension -----

exec  tesca.spdimDateGenerator  '2110-12-31'
select * from tesca.DimDate

Use [Tesca EDW Database]

Create table tesca.DimDate
(
 DateSk int, 
 ActualDate Date,
 ActualYear int,
 ActuaQuarter nvarchar(2),---- Q1, Q2, Q3
 ActualMonth int,
 EnglishMonth nvarchar(50),
 SpanishMonth nvarchar(50),
 HinduMonth nvarchar(50),
 EnglishDayofWeek nvarchar(50),
 SpanishDayofWeek nvarchar(50),
 HinduDayofWeek nvarchar(50),
 ActualWeekday int,
 ActualWeek int,
 ActualDayofYear int,
 ActualDayofMonth int,
 constraint testca_dimDate_sk primary key(DateSk) 
)

CREATE procedure  tesca.spdimDateGenerator(@EndDate Date)

AS

BEGIN 

SET NOCOUNT ON

declare @StartDate Date = ( 
							select convert(date,min(StartDate)) FROM
							(
								select Min(TransDate) startDate from [Tesca OLTP Database ].DBO.PurchaseTransaction
									union all 
								select Min(TransDate) StartDate from [Tesca OLTP Database ].DBO.SalesTransaction
							)a 
				)

Declare @noofdays int = Datediff (DAY, @StartDate, @EndDate)-----END OF THE LOOP
Declare @currentday int = 0
Declare @currentdate date 

BEGIN

		IF (select object_id (N'tesca.DimDate')) is NOT NULL   ------Control duplication---
					TRUNCATE TABLE tesca.DimDate

		While @currentday <= @noofdays

BEGIN 
	
	
		select @currentdate = (Dateadd(day,@currentday, @StartDate))
	
	
	
		 insert into tesca.DimDate
								 (	DateSk, ActualDate, ActualYear, ActuaQuarter, ActualMonth,
								 
									EnglishMonth, SpanishMonth, HinduMonth, EnglishDayofWeek,
								 
									SpanishDayofWeek, HinduDayofWeek, ActualWeekday, ActualWeek,
								 
									ActualDayofYear, ActualDayofMonth)
	
	select	 convert(int,convert(nvarchar(8),@CurrentDate,112)) as Datekey , @currentdate as Actualdate, year (@currentdate) as ActualYear,
			
			'Q'+ cast(DATEPART(Quarter, @currentdate) as nvarchar) as ActualQuater, DATEPART(MONTH, @currentdate) as ActualMonth,
			 
			 DATENAME (MONTH, @currentdate) as EnglishMonth, 	
	
	Case DATEPART(Month,@CurrentDate) 

		When 1 then 'enero'  When 2 then 'febrero' When 3 then 'marzo' When 4 then 'abril' When 5 then 'mayo' When 6 then 'junio'
		When 7 then 'julio'  When 8 then 'Agosto' When 9 then 'septiembre' When 10 then 'octubre' When 11 then 'noviembre' When 12 then 'diciembre' 
	END SpanishMonth,
	
	Case DATEPART(Month,@CurrentDate) 

		When 1 then 'Chaitra'  When 2 then 'Vaisakha' When 3 then 'Jyaistha' When 4 then 'Asadha' When 5 then 'Shravana' When 6 then 'Bhadra'
		When 7 then 'Ashwin'  When 8 then 'Kartika' When 9 then ' Mārgasirsa (Agrahayana)' When 10 then 'Pausha' When 11 then 'Magha' When 12 then 'Phalguna' 
	END HinduMonth,  

		 DATENAME(WEEKDAY,@CurrentDate) as EnglishDayofWeek,


	Case  DATEPART(WEEKDAY,@CurrentDate) 

		WHEN 1 Then 'domingo'  WHEN 2  THEN 'lunes' WHEN 3 THEN 'martes'  WHEN 4 THEN 'miércoles'  WHEN 5 THEN 'jueves' WHEN 6 THEN 'viernes' WHEN 7 THEN 'sábado'
	END SpanishDayofWeek,

	Case  DATEPART(WEEKDAY,@CurrentDate) 
		WHEN 1 Then 'Raviwar'  WHEN 2  THEN 'Somvar' WHEN 3 THEN 'Mangalwar'  WHEN 4 THEN 'Budhwar'  WHEN 5 THEN 'Guruwar' WHEN 6 THEN 'Shukrawar' WHEN 7 THEN 'Shanivar'
	END HinduDayofWeek, 
 
			DATEPART(WEEKDAY,@CurrentDate)  as ActualWeekday,  datePart(week, @currentDate) as ActualWeek, 
			DATEPART(DAYOFYEAR,@CurrentDate) as ActualDayofYear, Day(@CurrentDate) ActualDayofMonth
	
	SELECT @currentday = @currentday +1
END
END
END