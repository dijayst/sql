
-- CREATING PROJECT DATABASE

CREATE DATABASE ShopHeree;
drop DATABASE ShopHeree;
use  ShopHeree;

-- CREATING SCHEMA

CREATE SCHEMA Items ;
CREATE SCHEMA Supplier ;
CREATE SCHEMA HumanResources ;
CREATE SCHEMA Transactions ;



CREATE TABLE Items.ProductCategory (

	categoryID		int NOT NULL IDENTITY( 1000, 1 ) PRIMARY KEY,
	categoryName	char( 15  ) NOT NULL CONSTRAINT chkCatName CHECK (
		categoryName IN ('Household', 'Sports', 'Accessories', 'Clothing' )),
	categoryDesc	char( 255 ) NOT NULL

);


insert into Items.ProductCategory values('Clothing', 'Men and Women Wears')
insert into Items.ProductCategory values('Accessories', 'Jewelries')
insert into Items.ProductCategory values('Sports', 'Football kits, Basketball kits')
insert into Items.ProductCategory values('Household', 'Home Appliances')



CREATE TABLE Supplier.SupplierDetails(

	supplierID		int NOT NULL IDENTITY( 100, 1 ) PRIMARY KEY,
	firstName		char( 30 ) NOT NULL,
	lastName		char( 30 ) NOT NULL,
	address			char( 60 ) NOT NULL,
	country			char( 25 ) NOT NULL,
	----------phoneNumber		char( 19 ) CONSTRAINT chkPhoneNum CHECK ( phoneNumber LIKE 
	------	'[0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]' )

);


insert into Supplier.SupplierDetails values('Tosin','Olubiyi','Okere Kelvin cresent Abuja','Nigeria')
insert into Supplier.SupplierDetails values('Joe', 'Richard', 'Ademola Adetokumbo crecent Abuja','Nigeria')
insert into Supplier.SupplierDetails values('Maryam','Musa','Asokoro Accra', 'Ghana')
insert into Supplier.SupplierDetails values('Sara', 'Michael','Bamako','Mali')




CREATE TABLE Items.ItemDetails (
	
	itemID			int NOT NULL IDENTITY( 1000, 1 ) PRIMARY KEY,
	itemName		char( 30 ) NOT NULL,
	itemDesc		char( 255 ) NOT NULL,
	quantityInHand	int CONSTRAINT chkQtyHand CHECK ( quantityInHand > 0 ),
	unitPrice		money NOT NULL CONSTRAINT	chkUnitPrice CHECK ( unitPrice > 0 ),
	reorderQuantity int NOT NULL CONSTRAINT chkReorderQty CHECK ( reorderQuantity > 0 ),
	reorderLevel	int NOT NULL CONSTRAINT chkReorderLvl CHECK ( reorderLevel > 0 ),
	categoryID		int NOT NULL,
	supplierID		int NOT NULL,

	FOREIGN KEY ( categoryID ) REFERENCES Items.ProductCategory( categoryID ),
	FOREIGN KEY ( supplierID ) REFERENCES Supplier.SupplierDetails( supplierID )

);


CREATE TABLE HumanResources.Employee(
	
	employeeID		int NOT NULL IDENTITY( 10000, 1 ) PRIMARY KEY,
	firstName		char( 30 ) NOT NULL,
	lastName		char( 30 ) NOT NULL,
	address			char( 60 ) NOT NULL,
	country			char( 25 ) NOT NULL,
	phoneNumber		char( 19 ) CONSTRAINT chkPhoneNum CHECK ( phoneNumber LIKE 
		'[0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]' )

);

insert into HumanResources.Employee values('Michael','Etim','Abuja',08097120291)
 insert into HumanResources.Employee values('Frank','A.C','Lagos',08067178291)
 insert into HumanResources.Employee values('Hadiza','Baba','Maiduguri',080875678260)
 insert into HumanResources.Employee values('Ndbisi','Okarfo','Imo',08033720276)
 insert into HumanResources.Employee values('Ahmed','Y.D','Suleja',08055903225)
 insert into HumanResources.Employee values('Fatimah','Suleiman','Jos',08035701249)
 




CREATE TABLE Transactions.OrderDetails(
	
	purchaseOrderID		int NOT NULL IDENTITY( 1000, 1 ) PRIMARY KEY,
	orderDate			datetime NOT NULL CONSTRAINT chkOrderDate CHECK (
		orderDate = GETDATE( )) DEFAULT GETDATE(),
	quantityOrdered		int NOT NULL CONSTRAINT chkQtyOrdered CHECK ( quantityOrdered > 0 ),
	quantityReceived	int NULL CONSTRAINT chkQtyReceived CHECK ( quantityReceived > 0 ),
	unitPrice			money NOT NULL CONSTRAINT chkUnitPrice CHECK ( unitPrice > 0 ),
	orderStatus			char( 10 ) NOT NULL CONSTRAINT chkOrderStatus CHECK ( orderStatus IN ('InTransit', 'Received', 'Cancelled' )),
	receivingDate		datetime Null,

	-- creating constraints that will be run against column of same table
	CONSTRAINT qtyReceived_notGreaterThan_qtyOrdered CHECK ( quantityReceived <= quantityOrdered ),
	CONSTRAINT recDate_GreaterThan_orderDate CHECK ( receivingDate > orderDate ),

	-- foreign key
	refItemID			int NOT NULL FOREIGN KEY REFERENCES Items.ItemDetails( itemID ),
	employeeID			int NOT NULL FOREIGN KEY REFERENCES HumanResources.Employee( employeeID )

);

 insert into Transactions.OrderDetails values(3, '2012-08-31 15:24:11.360', '2012-10-12', 1, 10, 12, 5000, 'Road', 'Pending') 
  insert into Transactions.OrderDetails values(1, '2012-07-01 ', '2012-09-19', 3, 35, 40, 45000, 'Sail', 'Pending') 
  insert into Transactions.OrderDetails values(4, '2012-08-31 ', '2012-08-31', 2, 8, 15, 1000, 'Road', 'Delivered') 
  insert into Transactions.OrderDetails values(2, '2012-06-15', '2012-10-03', 4, 23, 10, 25000, 'Road', 'Pending') 





-- This trigger is meant to run automatic addition update on Items.ItemDetails quantityInHand 
-- column each time the quantityReceivedColumn of Transactions.OrderDetails has a value inserted to it

CREATE TRIGGER updateQtyINHandTrig 
ON Transactions.OrderDetails 
FOR INSERT AS

	BEGIN
		DECLARE @id int
		DECLARE @qtyRcv int
		SELECT @id = refItemID FROM INSERTED
		SELECT @qtyRcv = quantityReceived FROM INSERTED
		UPDATE Items.ItemDetails
		SET quantityInHand = quantityInHand + @qtyRcv
		WHERE Items.ItemDetails.itemID = @id
	END



-- Creating indexes to Speedup  Query Execution 

CREATE INDEX order_index ON Transactions.OrderDetails( orderDate, refItemID );



-- creating stored procedure which will output current month orders 
-- this statement "DATENAME( mm, orderDate ) " means::
--
-- we want each month's name from the orderDate i.e if the month is numeric 1 it will output
-- January
-- 
-- this statement MONTH( orderDate ) = MONTH( GETDATE() ) means we want to get the month 
-- from orderDate that's equal to the current month datetime
--
-- ( following DRY principle )

CREATE PROCEDURE orderInCurrentMonth_proc
  AS
	BEGIN

		SELECT purchaseOrderID, DATENAME(mm, orderDate) as 'orderMonth', quantityOrdered, quantityReceived, unitPrice, orderStatus, receivingDate, refItemID, employeeID  
		FROM Transactions.OrderDetails
		WHERE MONTH( orderDate ) = MONTH(GETDATE());

	END
	



-- creating stored procedure which will output orders older than two years 

CREATE PROCEDURE ordersOlderThanTwoYears_proc
  AS
	BEGIN
		
		SELECT purchaseOrderID, DATENAME(yy, orderDate) as 'orderYear', quantityOrdered, quantityReceived, unitPrice, orderStatus, receivingDate, refItemID, employeeID
		FROM Transactions.OrderDetails
		WHERE  orderDate  <= DATEADD(year, -2, GETDATE());

	END



-- creating stored procedure which will extract the details of the top 5 supplier
-- to whom the maximum number of orders have been placed in the current month

CREATE PROCEDURE topFiveSupplierProc 
  AS
	BEGIN
		
		-- selecting top 5 suppliers and items they ordered using join where
		-- the items being selected are items whose orderdate within the 
		-- OrderDetail table falls within the current month



		select DISTINCT top 5  s.firstName, s.lastName, s.address, s.country, s.phoneNumber 
		from Supplier.SupplierDetails s join Items.ItemDetails i 
		on s.supplierID = i.supplierID  join Transactions.OrderDetails t 
		on i.itemID = t.refItemID
		where MONTH( t.orderDate ) = MONTH( GETDATE() ) AND
		t.quantityOrdered = ( select MAX( quantityOrdered ) from Transactions.OrderDetails)




		-- in the query above, we are joining three tables together ( SupplierDetails,
		-- ItemDetails, OrderDetails ).
		--
		-- we just want informations from the SupplierDetails as our result set, that's
		-- why all columns selected are from the SupplierDetails table.
		--
		-- though we want details from just the supplier table, we want the details we
		-- will be receiving to hold the maximum in quantityOrdered column of 
		-- orderDetail and also the quantityOrdered should be orders from current month.
		--
		-- we also don't want one supplier to display twice, but just one suppler hence
		-- the DISTINCT clause


	END





-- calculation of a total cost for a particular order ( simplifying regular task )

CREATE PROCEDURE totalCostProc @purchaseOrderID int 
  AS
	BEGIN

			SELECT purchaseOrderID, ( unitPrice * quantityOrdered ) AS 'Total Cost'
			FROM Transactions.OrderDetails WHERE purchaseOrderID = @purchaseOrderID;

	END



-- calculation of the total of all orders placed by a particular employee
-- in a particular month ( simplifying regular tasks )

CREATE PROCEDURE empOrderForMonth @empID int,  @month int
  AS
	BEGIN

		
		select DISTINCT employeeID, firstName, lastName,

			(
				SELECT COUNT( quantityOrdered )
				FROM Transactions.OrderDetails WHERE employeeID = @empID AND
				MONTH( orderDate ) = @month
			) AS 'Total Order'

		FROM HumanResources.Employee


	END








-- QUESTION

-- Implement an appropriate security policy on the database. For this, create logins
-- named George, John, and Sara. George is the database administrator and John and
-- Sara are database developers.




-- Creating logins and Users
--
--				Took Note on this for better understanding
--
-- Logins : to understand logins, if you know ubuntu OS so well, you'll notice 
-- that it comes with a guest user login, so you can login as a guest
-- Logging in as a guest, you will be limited to somethings within the operating
-- system. you might not be able to delete files, you might not also be able to 
-- view some files... because you are a guest, but if you login with as the rightful
-- owner of the system, you will be able to do anything that pleases you because those
-- priviledges are given you.
--
-- NOTE ======================  NOTE  ========================  NOTE ==================
--
-- Only one user can be assigned to one Login, so for each login you have to create
-- it's personal user



-- Creating Logins for Different Users

CREATE LOGIN GeorgeLogin WITH PASSWORD = 'georgeSecretKey' ;
CREATE LOGIN JohnLogin WITH PASSWORD = 'johnSecretKey' ;
CREATE LOGIN SaraLogin WITH PASSWORD = 'saraSecretKey' ;


-- Creating Users and assigning their logins

CREATE USER userGeorge FOR LOGIN GeorgeLogin ;
CREATE USER userJohn FOR LOGIN JohnLogin ;
CREATE USER userSara FOR LOGIN SaraLogin ;


-- Creating Roles

CREATE ROLE dbAdmin ;
CREATE ROLE dbDev ;


-- Adding users to Roles Created

EXECUTE sp_addrolemember dbAdmin, userGeorge ;
EXECUTE sp_addrolemember dbDev, userJohn ;
EXECUTE sp_addrolemember dbDev, userSara ;



-- Adding Securables to Role dbDev 
--
-- The roles i decided to assgin to developers in this project 
-- is the role to SELECT, INSERT and UPDATE to all tables


GRANT SELECT, INSERT, UPDATE ON Supplier.SupplierDetails TO dbDev ;
GRANT SELECT, INSERT, UPDATE ON HumanResources.Employee TO dbDev ;
GRANT SELECT, INSERT, UPDATE ON Transactions.OrderDetails TO dbDev ;
GRANT SELECT, INSERT, UPDATE ON Items.ItemDetails TO dbDev ;
GRANT SELECT, INSERT, UPDATE ON Items.ProductCategory TO dbDev ;



-- Adding Securables to Role dbAdmin
--
-- Roles that Admin should have, is the roles to use every command
-- including the DELETE command

GRANT SELECT, INSERT, UPDATE, DELETE  ON Supplier.SupplierDetails TO dbAdmin ;
GRANT SELECT, INSERT, UPDATE, DELETE  ON HumanResources.Employee TO dbAdmin ;
GRANT SELECT, INSERT, UPDATE, DELETE  ON Transactions.OrderDetails TO dbAdmin ;
GRANT SELECT, INSERT, UPDATE, DELETE  ON Items.ItemDetails TO dbAdmin ;
GRANT SELECT, INSERT, UPDATE, DELETE  ON Items.ProductCategory TO dbAdmin ;



-- CREATED DB Backup Using Object Explorer to view backup file
-- copy the path below and paste it in file explorer
-- C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\Backup



----------------------------------------

-- Encrypting Transations.OrderDetails
---------------------------------------

-- Implementing Column Encryption of Data
--
-- To encrypt a Column of Data, your Database needs to have a DMK( database
-- master key ) This key secures all other keys and it's the base encryption
-- key located inside of a database


CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'abcdefghijklmnopqrstuvwxyx1234567890!@#$%^&*()_+';


-- Remarks:
-- The master key must be open, and therefore decrypted before it is backed up
-- if only it is encrypted with password

OPEN MASTER KEY DECRYPTION BY PASSWORD = 'abcdefghijklmnopqrstuvwxyx1234567890!@#$%^&*()_+';


-- Recommendations:
-- It is recommended that DMK is backed up as soon as it is created, and backup
-- should be in a secure, off-site location.

-- SELECT name, is_master_key_encrypted_by_server from sys.databases

-- It's required that we always backup our DMK

BACKUP MASTER KEY TO FILE = 'database_master_key'
	ENCRYPTION BY PASSWORD = 'abcdefghijk';



-- Encrypting the data 

CREATE CERTIFICATE transactionCert  
   WITH SUBJECT = 'Transactions for an Order';  
GO  

CREATE SYMMETRIC KEY transactionKey  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE transactionCert;  
GO  

-- Create a column in which to store the encrypted data.  
ALTER TABLE Transactions.OrderDetails  
    ADD Transactions_Encrypted varbinary(128);   
GO  



-- Open the symmetric key with which to encrypt the data.  
OPEN SYMMETRIC KEY transactionKey  
   DECRYPTION BY CERTIFICATE transactionCert;  

-- Encrypt the value in column quantityOrdered using the  
-- symmetric key transactionKey.  
-- Save the result in column Transactions_Encrypted.    
UPDATE Transactions.OrderDetails  
SET Transactions_Encrypted = EncryptByKey(Key_GUID('transactionKey')  
    , CONVERT( varbinary, purchaseOrderID));  
GO  

-- Verify the encryption.  
-- First, open the symmetric key with which to decrypt the data.  

OPEN SYMMETRIC KEY transactionKey  
   DECRYPTION BY CERTIFICATE transactionCert;  
GO  

-- Now list the original card number, the encrypted card number,  
-- and the decrypted ciphertext. If the decryption worked,  
-- the original number will match the decrypted number.  

SELECT quantityOrdered, Transactions_Encrypted   
    AS 'Encrypted quantity ordered', CONVERT(varbinary,  
    DecryptByKey(Transactions_Encrypted))  
    AS 'Decrypted quantity Ordered' FROM Transactions.OrderDetails;  
GO











-------------------- ALERTS -----------------------


--==================== SNIPPET SNIPPET SNIPPET SNIPPET ==============================--

-- This snippets helps to get the total size  and free space of our db

	WITH f AS ( SELECT name, size = size/128.0 FROM sys.database_files ),
	s AS ( SELECT name, size, free = size-CONVERT(INT,FILEPROPERTY(name,'SpaceUsed'))/128.0
	  FROM f )
	SELECT name, size, free, percent_free = free * 100.0 / size FROM s;

--==================== SNIPPET SNIPPET SNIPPET SNIPPET ==============================--



-- To create an alert we'll have to create a user defined error message in sys.messages
-- which will be used by sql agent alert
-- User-defined error messages can be an integer between 50001 and 2147483647.


EXEC sp_addmessage
	@msgnum = 911421,		-- 911DBA
	@severity = 1,			-- Informational message not generated by DB Engine
	@msgtext = N'Data files are %d percent full in database %s.'

-- These declared sp_addmessage variable are it's parameters, try to change the name 
-- an error will throw up... 



-- Create SQL Agent job

IF OBJECT_ID('tempdb..#dbserversize') is NOT NULL
DROP TABLE #dbserversize;

create table #dbserversize (
	id int identity( 1, 1 )
	, databaseName sysname
	, Drive varchar( 3 )
	, logicalName sysname
	, physicalName varchar( max )
	, fileSizeMB decimal( 38, 2 )
	, spaceUsedMB decimal( 38, 2 )
	, freeSpace decimal( 38, 2 )
	, [%freeSpace] decimal( 38, 2 )
	, maxSize varchar( max )
	, growthRate varchar( max )
)

DECLARE @id int
DECLARE @threshold int
DECLARE @dbname sysname

DECLARE @sqltext nvarchar( max )
DECLARE @freespacePct int

set @threshold = 20
select @dbname = min(name) from sys.databases where database_id > 4 and state = 0
while @dbname is NOT NULL
	
	BEGIN
		select @dbname = name from sys.databases 
			where name = @dbname and database_id > 4 and state = 0

		set @sqltext = ' use ' + @dbname + ';' + '
			insert into dbo.#dbserversize select ''' + @dbname + '''
			as databaseName
			,substring([physical_name], 1, 3) as [Drive]
                ,[name] as [Logical Name]
                ,[physical_name] as [Physical Name]
                ,cast(CAST([size] as decimal(38, 2)) / 128.0 as decimal(38, 2)) as [File Size MB]
                ,cast(CAST(FILEPROPERTY([name], ''SpaceUsed'') as decimal(38, 2)) / 128.0 as decimal(38, 2)) as [Space Used MB]
                ,cast((CAST([size] as decimal(38, 0)) / 128) - (CAST(FILEPROPERTY([name], ''SpaceUsed'') as decimal(38, 0)) / 128.) as decimal(38, 2)) as [Free Space]
                ,cast(((CAST([size] as decimal(38, 2)) / 128) - (CAST(FILEPROPERTY([name], ''SpaceUsed'') as decimal(38, 2)) / 128.0)) * 100.0 / (CAST([size] as decimal(38, 2)) / 128) as decimal(38, 2)) as [%Free Space]
                ,case 
                    when cast([max_size] as varchar(max)) = - 1

					 then ''UNLIMITED''
                    else cast([max_size] as varchar(max))
                    end as [Max Size]
                ,case 
                    when is_percent_growth = 1
                        then cast([growth] as varchar(20)) + ''%''
                    else cast([growth] as varchar(20)) + ''MB''
                    end as [Growth Rate]
                from sys.database_files
                where type = 0 -- for Rows , 1 = LOG'
            --print @sqltext
            exec (@sqltext)

		 select @dbname = min(name) from sys.databases 
		 where name > @dbname and database_id > 4 and [state] = 0 
    END


	--- delete the entries that do not meet the threshold 

    delete from dbo.#dbserversize
    where [%Free Space] < @threshold;



	    --select * from dbo.#dbserversize

    --- NOW Raise errors for the databases that we got flagged up

    while exists (select null from dbo.#dbserversize)
    BEGIN

		select top 1 @id = id,
                @dbname = databaseName,
                @freespacePct = [%Free Space]
            from dbo.#dbserversize;


        RAISERROR(911421, 10,1,@freespacePct, @dbname) with LOG;

        delete from dbo.#dbserversize where id = @id;

    END


-- Creating an alert to respond to 911421 error number

USE TrialDB
GO
EXEC msdb.dbo.sp_add_alert @name=N'MDF fileDB alert', 
        @message_id=911421, 
        @severity=0, 
        @enabled=1, 
        @delay_between_responses=150000,		-- equivalent to 24hrs
        @include_event_description_in=0, 
        @job_id=N'BB23AF1D-31F3-4378-AAF5-669D63E89D44'
GO
EXEC msdb.dbo.sp_add_notification @alert_name=N'MDF file alert', @operator_name=N'Notify 911 DBA for MDF files getting full', @notification_method = 1
GO


-- View all Jobs in DB
SELECT * FROM msdb.dbo.sysjobs



-----view the tables
 select*from Items.ProductCategory;
