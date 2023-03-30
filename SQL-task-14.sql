create database task14
use task14

--a. Create a table Hobbies (HobbyID(pk), HobbyName(uk)) 
create table Hobbies (HobbyID int primary key, HobbyName varchar(25)unique);
--SELECT QUERY
select * from Hobbies
--1. insert records into the table using a stored procedure.
CREATE PROCEDURE sp_hobbies(@HobbyID int,@HobbyName varchar(25))
AS  
BEGIN
insert into Hobbies values(@HobbyID,@HobbyName);
END; 
exec sp_hobbies 103,'Reading Books';
--DROP PROCEDURE
drop procedure sp_hobbies
--TRUNCATE TABLE
truncate table Hobbies

--2. insert duplicate records into the table and show the working of exception handling using Try/catch blocks.
create procedure sp_exphand(@HobbyID int,@HobbyName varchar(25))
as 
begin 
declare @final int
set @final = 0
begin try
if @HobbyID > 200
RAISERROR ('Hobby ID must be less than 200',16,1)
set @final= @HobbyID 
print 'The Hobby ID is: '+cast(@final as varchar)+' => Entered successfully '+'And Hobby name is: '+@HobbyName;
end try
begin catch
print error_number()
print error_message()
print error_severity()
print error_state()
end catch
end 
--EXECUTING 
exec sp_exphand 106,'Riding Bikes'
exec sp_exphand 201,'Playing cards'
--DROP PROCEDURE 
drop procedure sp_exphand
--3. Store the error details in an errorbackup table.
create table error_backup_tbl(ErrorID        INT IDENTITY(1, 1),
          UserName       VARCHAR(100),
          ErrorNumber    INT,
          ErrorState     INT,
          ErrorSeverity  INT,
          ErrorLine      INT,
          ErrorProcedure VARCHAR(MAX),
          ErrorMessage   VARCHAR(MAX),
          ErrorDateTime  DATETIME)
alter procedure sp_error_tbl(@HobbyID int,@HobbyName varchar(25))
as
begin
begin try
insert into Hobbies
select @HobbyID,@HobbyName
end try
begin catch
insert into error_backup_tbl values
 (SUSER_SNAME(),
   ERROR_NUMBER(),
   ERROR_STATE(),
   ERROR_SEVERITY(),
   ERROR_LINE(),
   ERROR_PROCEDURE(),
   ERROR_MESSAGE(),
   GETDATE());
end catch
end
exec sp_error_tbl 105,'cubes';

select * from error_backup_tbl;

select * from Hobbies;

--DROP TABLE
drop table error_backup_tbl;
          
--b. Create a procedure to accept 2 numbers, if the numbers are equal then calculate the product else use RAISERROR to show the working of exception handling.
alter procedure sp_product (@num1 int,@num2 int)
as
begin
declare @output int
set @output=@num1*@num2
begin try
if @num1 = @num2
print 'The product of two numbers is: '+ cast(@output as varchar)
else 
raiserror('Enter same values',16,1)
end try
begin catch
print error_number()
print error_message()
print error_severity()
print error_state()
end catch
end 
--EXECUTING PROCEDURE
exec sp_product 1,1;
--c. Create a table Friends(id(identity), name (uk)) and insert records into the table using a stored procedure.
--Note: insert the names which start only with A,D,H,K,P,R,S,T,V,Y ELSE using THROW give the error details.
create table Friends1(id int identity(1,1), name varchar(25) unique);

ALTER PROCEDURE sp_frnd(@Name varchar(25))
AS  
BEGIN
IF(@name like '[ADHKPRSTVY]%')
insert into FRIENDS1 values(@Name)
ELSE 
throw 50070,'ERROR:=> PLEASE ENTER VALUES ACCORING TO THE PATTERN',1
END

EXEC sp_frnd 'ZARSHAN'
SELECT * FROM FRIENDS1