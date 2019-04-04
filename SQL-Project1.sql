use master 
go 
if db_id('CTUDB') is not null
BEGIN
	alter database CTUDB set single_user with rollback immediate -- Close open queries
	drop Database CTUDB -- Delete DB
END
go 
-- Create DB
create Database CTUDB
go 
use CTUDB 
go
-- Change owner if you want to do Database Diagrams
ALTER DATABASE CTUDB set TRUSTWORTHY ON; 
GO 
EXEC dbo.sp_changedbowner @loginame = N'sa', @map = false 
GO 
sp_configure 'show advanced options', 1; 
GO 
RECONFIGURE; 
GO 
sp_configure 'clr enabled', 1; 
GO 
RECONFIGURE; 
GO
-- stored prosedures
Create procedure dbo.addMarks @schemaName varchar(30), @studentNumber int, @courseID int --onseker oor courseid
As
	DECLARE @sql Nvarchar(2000);
	DECLARE @Upper INT;
	DECLARE @Lower INT
	SET @Lower = 0 --laagste random numb
	SET @Upper = 100 --hoogste random numb
	DECLARE @mark int;
	-- Test-1 Result
	SELECT @mark = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0) -- This will create a random number between 0 and 100
	-- Insert record
	SET @sql = N'INSERT INTO ' + @schemaName + N'.ClassMarks_tbl VALUES (@parStudent, @parCourseInfo, @parMark)';
    EXEC sp_executesql @sql, 
        N'@parStudent int, @parCourseInfo int, @parMark int',
        @parStudent			= @studentNumber,
        @parCourseInfo	= @courseID,
		@parMark			= @mark
    ;
	-- Test-2 Result
	SELECT @mark = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SET @sql = N'INSERT INTO ' + @schemaName + N'.ClassMarks_tbl VALUES (@parStudent, @parCourseInfo, @parMark)';
    EXEC sp_executesql @sql, 
        N'@parStudent int, @parCourseInfo int, @parMark int',
        @parStudent			= @studentNumber,
        @parCourseInfo	= @courseID,
		@parMark			= @mark
    ;
	-- Test-3 Result
	SELECT @mark = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SET @sql = N'INSERT INTO ' + @schemaName + N'.ClassMarks_tbl VALUES (@parStudent, @parCourseInfo, @parMark)';
    EXEC sp_executesql @sql, 
        N'@parStudent int, @parCourseModule int, @parMark int',
        @parStudent			= @studentNumber,
        @parCourseInfo	= @courseID,
		@parMark			= @mark
    ;
	-- Test-4 Result
	SELECT @mark = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SET @sql = N'INSERT INTO ' + @schemaName + N'.ClassMarks_tbl VALUES (@parStudent, @parCourseInfo, @parMark)';
    EXEC sp_executesql @sql, 
        N'@parStudent int, @parCourseModule int, @parMark int',
        @parStudent			= @studentNumber,
        @parCourseInfo	= @courseID,
		@parMark			= @mark
    ;
	-- Test-5 Result
	SELECT @mark = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
	SET @sql = N'INSERT INTO ' + @schemaName + N'.ClassMarks_tbl VALUES (@parStudent, @parCourseInfo, @parMark)';
    EXEC sp_executesql @sql, 
        N'@parStudent int, @parCourseInfo int, @parMark int',
        @parStudent			= @studentNumber,
        @parCourseInfo	= @courseID,
		@parMark			= @mark
    ;
GO

-- Create a stored procedure to create the schema and tables
CREATE PROCEDURE dbo.createTbls @schemaName nvarchar(30)
AS
	-- Create schema (use EXEC to prevent error: Create Schema must be the only statement in a batch)
	EXEC ('CREATE SCHEMA [' + @schemaName + '] AUTHORIZATION [dbo]')
	-- You can't use bind variables for table names, column names, etc. 
	-- IN this case you must generate dynamic SQL and use exec:
	DECLARE @sql nvarchar(1000);


	-- Create Parents_tbl
	SET @sql = 
		'Create Table ' + @schemaName + '.Parents_tbl
		(
			ParentID int identity(1,1) primary key
		)'
	EXEC(@sql);
	-- Add columns
	SET @sql = 
		'ALTER Table ' + @schemaName + '.Parents_tbl 
			ADD ParentName NVarchar(30) not null,
				ParentSurname NVarchar(30) not null,
				ParentAddress NVarChar(30) not null
		'
	EXEC(@sql);

	
	-- Add 1st record
	DECLARE @name nvarchar(30);
	DECLARE @surname nvarchar(30);
	DECLARE @address nvarchar(30);
	SET @name = 'Jacob';
	SET @surname = 'Zuma';
	SET @address = '23 Retief, Paarl';
	SET @sql = N'INSERT INTO ' + @schemaName + N'.Parents_tbl VALUES (@parName, @parSurname, @parAddress)';
    
	EXEC sp_executesql @sql, 
        N'@parName nvarchar(30), @parSurname nvarchar(30), @parAddress nvarchar(30)',
        @parName = @name,
        @parSurname = @surname,
        @parAddress = @address
    ;

	-- Add 2nd record
	SET @name = 'Malema';
	SET @surname = 'Zillen';
	SET @address = '11 Mampoer, CapeTown';
	EXEC sp_executesql @sql, 
        N'@parName nvarchar(30), @parSurname nvarchar(30), @parAddress nvarchar(30)',
        @parName = @name,
        @parSurname = @surname,
        @parAddress = @address
    ;
	
	-- Add 3rd record
	SET @name = 'Abi';
	SET @surname = 'Niemand';
	SET @address = '38 Mainroad, Wellington';
	EXEC sp_executesql @sql, 
        N'@parName nvarchar(30), @parSurname nvarchar(30), @parAddress nvarchar(30)',
        @parName = @name,
        @parSurname = @surname,
        @parAddress = @address
    ;
		

	-- Create StudentInfo_tbl

	SET @sql = 
		'Create Table ' + @schemaName + '.StudentInfo_tbl
		(
			StudentNumber int identity(1,1) primary key
		)'
	EXEC(@sql);
	
	-- Add columns
	SET @sql = 
		'ALTER Table ' + @schemaName + '.StudentInfo_tbl
			ADD StudentName NVarchar(30) not null,
				StudentSurname NVarchar(30) not null,
				StudentAddress NVarchar(30) not null,
				ParentID int not null
		'
	EXEC(@sql);
	
	-- Add FK
	SET @sql = 
		'ALTER Table ' + @schemaName + '.StudentInfo_tbl
			ADD CONSTRAINT FK_Student_Parent 
				FOREIGN KEY (ParentID)     
				REFERENCES ' + @schemaName + '.Parents_tbl(ParentID)     
				ON DELETE CASCADE    
				ON UPDATE CASCADE
		'
	EXEC(@sql);
	
	-- Add 1st record
	DECLARE @parentID int;
	SET @name = 'Seymore';
	SET @surname = 'Green';
	SET @address = '2 Longroad, Pinetown';

	DECLARE @var int;
	-- Read 1st parentID
	SET @sql = N'select TOP 1 @var = ParentID From ' + @schemaName + '.Parents_tbl ORDER BY ParentID'
	execute sp_executesql @sql, N'@var int output', @var = @parentID output

	-- Insert record
    SET @sql = N'INSERT INTO ' + @schemaName + N'.StudentInfo_tbl VALUES (@parName, @parSurname, @parAddress, @parParentID)';
	EXEC sp_executesql @sql, 
        N'@parName nvarchar(30), @parSurname nvarchar(30), @parAddress nvarchar(30), @parParentID int',
        @parName = @name,
        @parSurname = @surname,
        @parAddress = @address,
        @parParentID = @parentID
    ;

	-- Add 2nd record
	SET @name = 'Brett';
	SET @surname = 'Persens';
	SET @address = '4 Koringroad, Paarl';
	-- Read 2nd parentID
	SET @sql = N'select @var = ParentID From ' + @schemaName + '.Parents_tbl ORDER BY ParentID OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY'
	execute sp_executesql @sql, N'@var int output', @var = @parentID output
	
	-- Insert record
	SET @sql = N'INSERT INTO ' + @schemaName + N'.StudentInfo_tbl VALUES (@parName, @parSurname, @parAddress, @parParentID)';
	EXEC sp_executesql @sql, 
        N'@parName nvarchar(30), @parSurname nvarchar(30), @parAddress nvarchar(30), @parParentID int',
        @parName = @name,
        @parSurname = @surname,
		@parAddress = @address,
        @parParentID = @parentID
    ;

	-- Add 3nd record
	SET @name = 'Blom';
	SET @surname = 'Blou';
	SET @address = '7 Agterroad, Moorreesburg';
	-- Read 3rd parentID
	SET @sql = N'select TOP 1 @var = ParentID From ' + @schemaName + '.Parents_tbl ORDER BY ParentID DESC'
	execute sp_executesql @sql, N'@var int output', @var = @parentID output
	
	-- Insert record
	SET @sql = N'INSERT INTO ' + @schemaName + N'.StudentInfo_tbl VALUES (@parName, @parSurname, @parAddress, @parParentID)';
    EXEC sp_executesql @sql, 
        N'@parName nvarchar(30), @parSurname nvarchar(30), @parAddress nvarchar(30), @parParentID int',
        @parName = @name,
        @parSurname = @surname,
	    @parAddress = @address,
        @parParentID = @parentID
    ;


	-- Create Facilitators_tbl

	SET @sql = 
		'Create Table ' + @schemaName + '.Facilitators_tbl
		(
			FacilitatorID int identity(1,1) primary key
		)'
	EXEC(@sql);

	-- Add columns
	SET @sql = 
		'ALTER Table ' + @schemaName + '.Facilitators_tbl 
			ADD	FacilitatorName NVarchar(30) not null,
				FacilitatorSurname NVarchar(30) not null,
				FacilitatorAddress NVarchar(30) not null,
				FacilitatorPay int not null,
				CourseGiven NVarchar(30) not null
		'
	EXEC(@sql);

	-- Add 1st record
	DECLARE @pay int
	DECLARE @coursegiven nvarchar(30)
	SET @name = 'Gerhard';
	SET @surname = 'CSharp';
	SET @address = '88 Centurian, Stellenbosch';
	SET @pay = '50000';
	SET @coursegiven = 'MCSD';
	SET @sql = N'INSERT INTO ' + @schemaName + N'.Facilitators_tbl VALUES (@parName, @parSurname, @parAddress, @parPay, @parCourseGiven)';
	
	EXEC sp_executesql @sql, 
        N'@parName nvarchar(30), @parSurname nvarchar(30), @parAddress nvarchar(30), @parPay int, @parCourseGiven nvarchar(30)',
        @parName = @name,
        @parSurname = @surname,
        @parAddress = @address,
		@parPay = @pay,
		@parCourseGiven = @coursegiven
    ;

	-- Add 2nd record
	SET @name = 'Anton';
	SET @surname = 'Mentor';
	SET @address = '21 Exproad, Stellenbosch';
	SET @pay = '90000';
	SET @coursegiven = 'MCSE';

	EXEC sp_executesql @sql, 
        N'@parName nvarchar(30), @parSurname nvarchar(30), @parAddress nvarchar(30), @parPay int, @parCourseGiven nvarchar(30)',
        @parName = @name,
        @parSurname = @surname,
        @parAddress = @address,
		@parPay = @pay,
		@parCourseGiven = @coursegiven
    ;

	-- Add 3rd record
	SET @name = 'Johannes';
	SET @surname = 'Yellow';
	SET @address = '2 Sparroad, Stellenbosch';
	SET @pay = '40000';
	SET @coursegiven = 'Grapics Design';

	EXEC sp_executesql @sql, 
        N'@parName nvarchar(30), @parSurname nvarchar(30), @parAddress nvarchar(30), @parPay int, @parCourseGiven nvarchar(30)',
        @parName = @name,
        @parSurname = @surname,
        @parAddress = @address,
		@parPay = @pay,
		@parCourseGiven = @coursegiven
    ;


	-- Create CourseInfo_tbl

	SET @sql = 
		'Create Table ' + @schemaName + '.CourseInfo_tbl
		(
			CourseID int identity(1,1) primary key
		)'
	EXEC(@sql);
	
	-- Add columns
	SET @sql = 
		'ALTER Table ' + @schemaName + '.CourseInfo_tbl 
			ADD	CourseName NVarchar(30) not null,
				CourseDescription NVarChar(50) not null
		'
	EXEC(@sql);

	-- Add 1st record
	DECLARE @description NVARCHAR(50)
	SET @name = 'MCSD';
	SET @description = 'Microsoft Software Development';
	SET @sql = N'INSERT INTO ' + @schemaName + N'.CourseInfo_tbl VALUES (@parName, @parDescription)';
	
	EXEC sp_executesql @sql, 
        N'@parName nvarchar(30), @parDescription nvarchar(50)',
        @parName = @name,
        @parDescription = @description
    ;

	-- Add 2nd record
	SET @name = 'MCSE';
	SET @description = 'Microsoft Server Development';

	EXEC sp_executesql @sql, 
        N'@parName nvarchar(30), @parDescription nvarchar(50)',
        @parName = @name,
        @parDescription = @description
    ;

	-- Add 3rd record
	SET @name = 'Grapics Design';
	SET @description = 'Adobe Grapical Design';

	EXEC sp_executesql @sql, 
        N'@parName nvarchar(30), @parDescription nvarchar(50)',
        @parName = @name,
        @parDescription = @description
    ;
	-- Create ClassMarks_tbl

	SET @sql = 
		'Create Table ' + @schemaName + '.ClassMarks_tbl
		(
			ClassMarkID int identity(1,1) primary key
		)'
	EXEC(@sql);
	-- Add columns
	SET @sql = 
		'ALTER Table ' + @schemaName + '.ClassMarks_tbl 
			ADD	StudentNumber int not null,
				CourseID int not null,
				Mark int not null
		'
	EXEC(@sql);
	-- Add FKs 
	SET @sql = 
		'ALTER Table ' + @schemaName + '.ClassMarks_tbl
			ADD CONSTRAINT FK_Mark_Student
				FOREIGN KEY (StudentNumber)     
				REFERENCES ' + @schemaName + '.StudentInfo_tbl(StudentNumber)     
				ON DELETE CASCADE    
				ON UPDATE CASCADE,
				
				CONSTRAINT FK_Mark_CourseInfo 
				FOREIGN KEY (CourseID)     
				REFERENCES ' + @schemaName + '.CourseInfo_tbl(CourseID)     
				ON DELETE CASCADE    
				ON UPDATE CASCADE
		'
	EXEC(@sql);
	-- No need for unique constraints, because the student could have multiple marks for the same module

	-- Add 5 marks each (in addMarks) for student 1 CourseModule 1-9
	EXEC dbo.addMarks @schemaName, 1, 1
	EXEC dbo.addMarks @schemaName, 1, 2
	EXEC dbo.addMarks @schemaName, 1, 3
	EXEC dbo.addMarks @schemaName, 1, 4
	EXEC dbo.addMarks @schemaName, 1, 5
	EXEC dbo.addMarks @schemaName, 1, 6
	EXEC dbo.addMarks @schemaName, 1, 7
	EXEC dbo.addMarks @schemaName, 1, 8
	EXEC dbo.addMarks @schemaName, 1, 9

	-- Add 5 marks each (in addMarks) for student 2 CourseModule 1-9
	EXEC dbo.addMarks @schemaName, 2, 1
	EXEC dbo.addMarks @schemaName, 2, 2
	EXEC dbo.addMarks @schemaName, 2, 3
	EXEC dbo.addMarks @schemaName, 2, 4
	EXEC dbo.addMarks @schemaName, 2, 5
	EXEC dbo.addMarks @schemaName, 2, 6
	EXEC dbo.addMarks @schemaName, 2, 7
	EXEC dbo.addMarks @schemaName, 2, 8
	EXEC dbo.addMarks @schemaName, 2, 9

	-- Add 5 marks each (in addMarks) for student 3 CourseModule 1-9
	EXEC dbo.addMarks @schemaName, 3, 1
	EXEC dbo.addMarks @schemaName, 3, 2
	EXEC dbo.addMarks @schemaName, 3, 3
	EXEC dbo.addMarks @schemaName, 3, 4
	EXEC dbo.addMarks @schemaName, 3, 5
	EXEC dbo.addMarks @schemaName, 3, 6
	EXEC dbo.addMarks @schemaName, 3, 7
	EXEC dbo.addMarks @schemaName, 3, 8
	EXEC dbo.addMarks @schemaName, 3, 9
GO 


-- Create view to list class marks - chapter 3
Create procedure dbo.createView @schemaName varchar(30)
AS
	DECLARE @sql Nvarchar(max);
	SET @sql = N'
		IF OBJECT_ID('''+ @schemaName +'.classMarksView'', ''V'') IS NOT NULL
		DROP VIEW Auckland_Park.classMarksView'

	EXEC sp_executesql @sql

	SET @sql = N'
		CREATE VIEW ' + @schemaName + '.classMarksView 
		AS
		Select ' + @schemaName + '.ClassMarks_tbl.*,
			   ' + @schemaName + '.StudentInfo_tbl.StudentName,
			   ' + @schemaName + '.StudentInfo_tbl.StudentSurname,
			   ' + @schemaName + '.Parents_tbl.ParentName,
			   ' + @schemaName + '.Parents_tbl.ParentSurname
		
		from ' + @schemaName + '.ClassMarks_tbl

			inner join ' + @schemaName + '.StudentInfo_tbl 
			on  ' + @schemaName + '.ClassMarks_tbl.StudentNumber =
			' + @schemaName + '.StudentInfo_tbl.StudentNumber 

			inner join ' + @schemaName + '.Parents_tbl 
			on  ' + @schemaName + '.StudentInfo_tbl.ParentID =
			' + @schemaName + '.Parents_tbl.ParentID
		;'

	EXEC sp_executesql @sql
GO



-- Loop through list of campuses
DECLARE @pos INT
DECLARE @len INT
DECLARE @schemaName varchar(30)
set @pos = 0
set @len = 0
DECLARE @schemaList varchar(8000)
SET @schemaList = 'Auckland_Park,Bloemfontein,Boksburg,Cape_Town,Durban,Nelspruit,Polokwane,Potchefstroom,Port_Elizabeth,Pretoria,Randburg,Sandton,Roodepoort,Stellenbosch,Vereeniging,'

WHILE CHARINDEX(',', @schemaList, @pos+1)>0
BEGIN
    set @len = CHARINDEX(',', @schemaList, @pos+1) - @pos
    set @schemaName = SUBSTRING(@schemaList, @pos, @len)
    

	-- Call the stored procedure to create the schema, tables and data
	EXEC dbo.createTbls @schemaName


	-- Create view to list class marks
	EXEC dbo.createView @schemaName

	-- Update loop counter
    set @pos = CHARINDEX(',', @schemaList, @pos+@len) +1
END
GO

Create procedure dbo.topTwo
AS
	-- Generate a temp table in tempdb. 
	-- Then loop through campuses and add their top 2 records to the temp table.
	DECLARE @pos INT
	DECLARE @len INT
	DECLARE @schemaName varchar(30)
	set @pos = 0
	set @len = 0
	DECLARE @schemaList varchar(300)
	DECLARE	@sql NVarchar(max)
	SET @schemaList = 'Auckland_Park,Bloemfontein,Boksburg,Cape_Town,Durban,Nelspruit,Polokwane,Potchefstroom,Port_Elizabeth,Pretoria,Randburg,Sandton,Roodepoort,Stellenbosch,Vereeniging,'

	-- Drop temp table
	IF OBJECT_ID('tempdb.dbo.#temp', 'U') IS NOT NULL
	DROP TABLE #temp;

	Create Table #temp
	(
		Campus NVarChar(30),
		StudentNumber int,
		CourseID int,
		Mark int
	)

	-- Loop through schemaList
	WHILE CHARINDEX(',', @schemaList, @pos+1)>0
	BEGIN
		set @len = CHARINDEX(',', @schemaList, @pos+1) - @pos
		set @schemaName = SUBSTRING(@schemaList, @pos, @len)

		-- Add to temp table
		SET @sql = N'
			INSERT INTO #temp(Campus, StudentNumber, CourseID, Mark)
			SELECT TOP 2 
				'''+@schemaName+''',
				'+@schemaName+'.ClassMarks_tbl.StudentNumber,
				'+@schemaName+'.ClassMarks_tbl.CourseID,
				'+@schemaName+'.ClassMarks_tbl.Mark 
			FROM '+@schemaName+'.ClassMarks_tbl
			order by Mark DESC
		';
		EXEC sp_executesql @sql

		-- Update loop counter
		set @pos = CHARINDEX(',', @schemaList, @pos+@len) +1
	END

	-- Display the temp table
	select * from #temp order by Campus, Mark DESC
GO
-- Example use of the stored procedure
-- This line can be removed in production
EXEC dbo.topTwo
GO



CREATE FUNCTION dbo.ufn_CourseAverage (@schemaName nvarchar(30))
RETURNS TABLE  
AS  
RETURN   
(  
	select course.CourseID, course.CourseName, avg(marks.mark) AS 'Average'
	from Auckland_Park.CourseInfo_tbl AS course
		JOIN Auckland_Park.CourseInfo_tbl AS modules
		ON course.CourseID = modules.CourseID 
		JOIN Auckland_Park.ClassMarks_tbl AS marks
		ON modules.CourseID = marks.CourseModuleID--?? there is no course module
	group by course.CourseID, course.CourseName
);  
GO

SELECT * FROM dbo.ufn_CourseAverage ('Boksburg');
GO


-- Create a procedure to create the ArchiveMarks tables
Create procedure dbo.ArchiveMarksTables @schemaName varchar(30)
AS
	DECLARE @sql varchar(max)

	-- Drop table ArchiveMarks in passed campus
	SET @sql = 
		'DROP TABLE IF EXISTS ' + @schemaName + '.ArchiveMarks;'
	EXEC(@sql);

	-- Create ArchiveMarks table in currrent campus, based on design of ClassMarks_tbl
	SET @sql = 
		'SELECT * INTO ' + @schemaName + '.ArchiveMarks FROM ' + @schemaName + 
		'.ClassMarks_tbl WHERE 1 = 0;'
	EXEC(@sql);

	-- Recreate the primary key - without being an identity - so that it can store
	-- the deleted record's ClassMarkID (and not auto-increment on its own)
	SET @sql = 'ALTER TABLE ' + @schemaName + '.ArchiveMarks DROP COLUMN ClassMarkID;'
	EXEC(@sql);
		
	SET @sql = 
	'ALTER Table ' + @schemaName + '.ArchiveMarks 
		ADD ClassMarkID int not null primary key;'
	EXEC(@sql);

GO

/* Chapter 9 */
Create procedure dbo.ArchiveMarksTriggers @schemaName varchar(30)
AS
	DECLARE @sql NVarChar(max)
	SET @sql =
	'CREATE TRIGGER '+@schemaName+'.Marks_BeforeDelete
		ON '+@schemaName+'.ClassMarks_tbl
		FOR DELETE
	AS
	  BEGIN
		INSERT INTO '+@schemaName+'.ArchiveMarks(StudentNumber, CourseID, Mark, ClassMarkID)
		   SELECT d.StudentNumber, d.CourseID, d.Mark, d.ClassMarkID
		   FROM deleted d 
	  END';
	EXEC sp_executesql @sql
	GO

GO

-- Execute ArchiveMarksTrigger
-- Loop through campuses to drop and create Archive table
DECLARE @pos INT
DECLARE @len INT
DECLARE @schemaName varchar(30)
set @pos = 0
set @len = 0
DECLARE @schemaList varchar(300)
DECLARE	@sql NVarchar(max)
SET @schemaList = 'Auckland_Park,Bloemfontein,Boksburg,Cape_Town,Durban,Nelspruit,Polokwane,Potchefstroom,Port_Elizabeth,Pretoria,Randburg,Sandton,Roodepoort,Stellenbosch,Vereeniging,'

WHILE CHARINDEX(',', @schemaList, @pos+1)>0
BEGIN
	set @len = CHARINDEX(',', @schemaList, @pos+1) - @pos
	set @schemaName = SUBSTRING(@schemaList, @pos, @len)
    
	-- Drop and create ArchiveMarks table in current campus
	exec ArchiveMarksTables @schemaName;

	-- Create Trigger in current campus
	exec ArchiveMarksTriggers @schemaName;

	-- Update loop counter
	set @pos = CHARINDEX(',', @schemaList, @pos+@len) +1
END

-- Test Archive trigger
Delete from Auckland_Park.ClassMarks_tbl
Where ClassMarkID = 4;
Select * from Auckland_Park.ArchiveMarks;
  
