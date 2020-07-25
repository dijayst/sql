----------------------------------------   TESTING   ----------------------------------------------------------
				-- This Script is created to test main project in a TrialDB

CREATE DATABASE TrialDB;




---------------------------------------- CODE SNIPPET ---------------------------------------------------------
-----------------------------------------CODE SNIPPET ---------------------------------------------------------


-- This table below is same with that we have within our main project, but instead of using
-- Constraint to check for things which will be allowed into categoryName column, we use
-- triggers. 

-- This test is made so that we can send a user defined message is invalid input is entered
-- by users.



CREATE TABLE TestCategoryTableWithTrig (

	categoryID		int NOT NULL IDENTITY( 1000, 1 ) PRIMARY KEY,
	categoryName	char( 15  ) NOT NULL,
	categoryDesc	char( 255 ) NOT NULL

);


CREATE TRIGGER chkTrg ON TestCategoryTableWithTrig
FOR  INSERT AS
DECLARE @catName char( 15 )
SELECT @catName = categoryName FROM inserted 
IF ( @catname != 'Household' OR @catName != 'Sports' OR @catName != 'Accessories' OR @catName != 'Clothing' )
	BEGIN
		PRINT @catName + ' is not a valid item' 
		ROLLBACK Transaction
	END
	RETURN




INSERT INTO TestCategoryTableWithTrig( categoryName, categoryDesc )
VALUES ('Computers', 'Computer is an electronic machine which can process data' ) ;





----------------------------------------SNIPPET ENDS ---------------------------------------------------------
----------------------------------------SNIPPET ENDS ---------------------------------------------------------







---------------------------------- TESTING Items.productCategory ---------------------------------------------





-- Testing Items.productCategory
-- There is a check constraint in this table which helps to validate the kind of values
-- that can be inserted into categoryName. The values that the categoryName column can
-- accept are :::
-- 'Households', 'Sports', 'Accessories', and 'Clothing' anything else
-- wouldn't be accepted


-- Test will Fail

INSERT INTO Items.ProductCategory( categoryName, categoryDesc )
VALUES('Computers', 'Computer is an electronic machine which can process data');



-- Test will Pass

INSERT INTO Items.ProductCategory( categoryName, categoryDesc )
VALUES ('Sports', 'Jersey');



-- Validate Insertion

SELECT categoryID, categoryName, categoryDesc FROM Items.ProductCategory;







------------------------------- TESTING Supplier.SupplierDetails ---------------------------------------------



-- Testing Table Supplier.SupplierDetails
-- There is a check constriant in this table which helps to validate phone number.
-- It gives a pattern that a phone number should hold, if inserted phone does not
-- follow the given pattern is will not allow insertion into that column
-- Phone number should follow this pattern below:::
--
-- 11-111-1111-111-111



-- Test should Fail

INSERT INTO Supplier.SupplierDetails (firstName, lastName, address, country, phoneNumber )
VALUES ( 'Prince', 'Agbonze', '14 Ige Street, Iyana, Lagos', 'Nigeria', '090-34-5041-63' ) ;



-- Test should Pass

INSERT INTO Supplier.SupplierDetails (firstName, lastName, address, country, phoneNumber )
VALUES ( 'Prince', 'Agbonze', '14 Ige Street, Iyana, Lagos', 'Nigeria', '11-111-1111-111-111') ;




-- Validate Insertion

SELECT supplierID, firstName, lastName, address, country, phoneNumber
FROM Supplier.SupplierDetails;








------------------------------- TESTING Items.ItemDetails -------------------------------------------------

-- Testing Table  Items.ItemDetails
-- There are two foreign keys in this table, one for supplier and one for category
-- If values inserted for this two foreign key does not exist in thier table 
-- insertion should fail.
-- There is also a check constraint which checks to see that values inserted are 
-- greater than 0. the following columns below have such a constraint:::
--
-- quantityInHand, unitPrice, reorderQuantity, reorderLevel



-- Test should fail because no supplier with the given id ( foreign Key test )
INSERT INTO Items.ItemDetails( itemName, itemDesc, quantityInHand, unitPrice, reorderQuantity, reorderLevel, categoryID, supplierID )
VALUES ( 'Black Stripes', 'A Jersey with black stripes', 5, 12.4, 3, 1, 1003, 101 ) ;



-- Test should fail because no category with the given id ( foreign Key test )
INSERT INTO Items.ItemDetails( itemName, itemDesc, quantityInHand, unitPrice, reorderQuantity, reorderLevel, categoryID, supplierID )
VALUES ( 'Black Stripes', 'A Jersey with black stripes', 5, 12.4, 3, 1, 2, 100 ) ;


-- Test should fail because quantityInHand is 0 ( check Constraint )
INSERT INTO Items.ItemDetails( itemName, itemDesc, quantityInHand, unitPrice, reorderQuantity, reorderLevel, categoryID, supplierID )
VALUES ( 'Black Stripes', 'A Jersey with black stripes', 0, 12.4, 3, 1, 1003, 100 ) ;


-- Test should fail because unitPrice is 0 ( check Constraint )
INSERT INTO Items.ItemDetails( itemName, itemDesc, quantityInHand, unitPrice, reorderQuantity, reorderLevel, categoryID, supplierID )
VALUES ( 'Black Stripes', 'A Jersey with black stripes', 1, 0, 3, 1, 1003, 100 ) ;


-- Test should fail because reorderQuantity is 0 ( check Constraint )
INSERT INTO Items.ItemDetails( itemName, itemDesc, quantityInHand, unitPrice, reorderQuantity, reorderLevel, categoryID, supplierID )
VALUES ( 'Black Stripes', 'A Jersey with black stripes', 1, 12.4, 0, 1, 1003, 100 ) ;


-- Test should fail because reorderLevel is 0 ( check Constraint )
INSERT INTO Items.ItemDetails( itemName, itemDesc, quantityInHand, unitPrice, reorderQuantity, reorderLevel, categoryID, supplierID )
VALUES ( 'Black Stripes', 'A Jersey with black stripes', 1, 12.4, 1, 0, 1003, 100 ) ;


-- Test should pass because insertion meets criterias 
INSERT INTO Items.ItemDetails( itemName, itemDesc, quantityInHand, unitPrice, reorderQuantity, reorderLevel, categoryID, supplierID )
VALUES ( 'Black Stripes', 'A Jersey with black stripes', 1, 12.4, 1, 3, 1003, 100 ) ;


-- validate insertion
SELECT  itemID, itemName, itemDesc, quantityInHand, unitPrice, reorderQuantity, reorderLevel, categoryID, supplierID
FROM Items.ItemDetails ;








---------------------------------- TESTING HumanResources.Employee -------------------------

-- Testing Table HumanResources.Employee
-- There is a check constriant in this table which helps to validate phone number.
-- It gives a pattern that a phone number should hold, if inserted phone does not
-- follow the given pattern is will not allow insertion into that column
-- Phone number should follow this pattern below:::
--
-- 11-111-1111-111-111
--
-- It also have a check constraint that will help to validate that Employee's 
-- firstName, lastName, address, and country should not be empty



-- Test should fail because firstName is Null ( check constraint )
INSERT INTO HumanResources.Employee( firstName, lastName, address, country, phoneNumber )
VALUES ( NULL, 'Jefferson', '12 crescent close, delhi', 'India', '11-111-1111-111-111')


-- Test should fail because lastName is Null ( check constraint )
INSERT INTO HumanResources.Employee( firstName, lastName, address, country, phoneNumber )
VALUES ( 'Greg', NULL, '12 crescent close, delhi', 'India', '11-111-1111-111-111');


-- Test should fail because address is Null ( check constraint )
INSERT INTO HumanResources.Employee( firstName, lastName, address, country, phoneNumber )
VALUES ( 'Greg', 'Jefferson', NULL, 'India', '11-111-1111-111-111');


-- Test should fail because country is Null ( check constraint )
INSERT INTO HumanResources.Employee( firstName, lastName, address, country, phoneNumber )
VALUES ( 'Greg', 'Jefferson', '12 crescent close, delhi', NULL, '11-111-1111-111-111');


-- Test should fail because phoneNumber is following the valid pattern ( check constraint )
INSERT INTO HumanResources.Employee( firstName, lastName, address, country, phoneNumber )
VALUES ( 'Greg', 'Jefferson', '12 crescent close, delhi', 'India', '11-1111111-111-111');


-- Test should pass because all values are valid
INSERT INTO HumanResources.Employee( firstName, lastName, address, country, phoneNumber )
VALUES ( 'Greg', 'Jefferson', '12 crescent close, delhi', 'India', '11-111-1111-111-111');


-- Validate Insertion
SELECT employeeID, firstName, lastName, address, country, phoneNumber
FROM HumanResources.Employee;




---------------------------------- TESTING Transactions.OrderDetails -------------------------

-- Testing table Transactions.OrderDetails
--
-- This table have a date check constraint which validates that orderDate should be equivalent
-- to the current date time. it shouldn't be lesser or higher
-- column quantityOrdered cannot be null and should be greater than 0
-- column quantityReceived should be greater than 0
-- column unitPrice cannot be null and should be greater than 0
-- column orderStatus should either be 'InTransit', 'Received', or 'Cancelled'. If one of these
-- is not inserted, insertion wouldn't hold
-- This table also holds constraint between some columns one of which is
-- quantityReceived cannot be greater than quantityOrdered and
-- receivingDate should be greater than orderDate


-- Test should fail because orderDate is in the future

INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, orderStatus,
	receivingDate, refItemID, employeeID )
VALUES ( DATEADD(mm, 3, GETDATE()), 3, 3, 12.5, 'InTransit', DATEADD(mm, 3, GETDATE()), 1012, 10006 ) ;


-- Test should fail because orderDate is in the past

INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, orderStatus,
	receivingDate, refItemID, employeeID )
VALUES ( DATEADD(mm, -3, GETDATE()), 3, 3, 12.5, 'InTransit', DATEADD(mm, 3, GETDATE()), 1012, 10006 ) ;


-- Test should fail because quantityOrdered is null

INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, orderStatus,
	receivingDate, refItemID, employeeID )
VALUES ( GETDATE(), NULL, 3, 12.5, 'InTransit', DATEADD(mm, 3, GETDATE()), 1012, 1006 ) ;


-- Test should fail because quantityOrdered is 0

INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, orderStatus,
	receivingDate, refItemID, employeeID )
VALUES ( GETDATE(), 0, 3, 12.5, 'InTransit', DATEADD(mm, 3, GETDATE()), 1012, 1006 ) ;


-- Test should fail because quantityReceived is 0
-- quantity received can be NULL but if at all there is an item received,
-- it should be greater than 0

INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, orderStatus,
	receivingDate, refItemID, employeeID )
VALUES ( GETDATE(), 3, 0, 12.5, 'InTransit', DATEADD(mm, 3, GETDATE()), 1012, 1006 ) ;


-- Test should fail because unitPrice is null

INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, orderStatus,
	receivingDate, refItemID, employeeID )
VALUES ( GETDATE(), 3, 3, NULL, 'InTransit', DATEADD(mm, 3, GETDATE()), 1012, 1006 ) ;


-- Test should fail because unitPrice is 0

INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, orderStatus,
	receivingDate, refItemID, employeeID )
VALUES ( GETDATE(), 3, 3, 0, 'InTransit', DATEADD(mm, 3, GETDATE()), 1012, 1006 ) ;


-- Test should fail if orderStatus is not valid

INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, orderStatus,
	receivingDate, refItemID, employeeID )
VALUES ( GETDATE(), 3, 3, 12.5, 'InComing', DATEADD(mm, 3, GETDATE()), 1012, 1006 ) ;


-- Test should fail if quantityReceived is greater than quantityOrdered

INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, orderStatus,
	receivingDate, refItemID, employeeID )
VALUES ( GETDATE(), 3, 5, 12.5, 'InTransit', DATEADD(mm, 3, GETDATE()), 1012, 1006 ) ;



-- Test should fail if orderedDate is greater than receivingDate

INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, orderStatus,
	receivingDate, refItemID, employeeID )
VALUES ( GETDATE(), 3, 3, 12.5, 'InTransit', DATEADD(mm, -1, GETDATE()), 1012, 1006 ) ;



-- Test should fail if reference to employeeID is not valid ( Foreign Key )

INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, orderStatus,
	receivingDate, refItemID, employeeID )
VALUES ( GETDATE(), 3, 3, 12.5, 'InTransit', DATEADD(mm, 1, GETDATE()), 1012, 1006 ) ;



-- Test should fail if reference to itemID is not valid ( Foreign Key )

INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, orderStatus,
	receivingDate, refItemID, employeeID )
VALUES ( GETDATE(), 3, 3, 12.5, 'InTransit', DATEADD(mm, 1, GETDATE()), 1011, 10006 ) ;


-- Test should pass if no value is inserted for orderDate

INSERT INTO Transactions.OrderDetails ( quantityOrdered, quantityReceived, unitPrice, orderStatus,
	receivingDate, refItemID, employeeID )
VALUES ( 3, 3, 12.5, 'InTransit', DATEADD(mm, 1, GETDATE()), 1012, 10006 ) ;


-- Test should pass if quantityReceived is lesser than quantityOrdered

INSERT INTO Transactions.OrderDetails ( quantityOrdered, quantityReceived, unitPrice, orderStatus,
	receivingDate, refItemID, employeeID )
VALUES ( 5, 2, 12.5, 'Received', DATEADD(mm, 1, GETDATE()), 1012, 10006 ) ;



-- validate insertion
SELECT purchaseOrderID, orderDate, quantityOrdered, quantityReceived, unitPrice, orderStatus, receivingDate, refItemID, employeeID
FROM Transactions.OrderDetails







---------------------------------- TESTING updateQtyINHandTrig  trigger -----------------------------

-- This trigger is meant to run automatic addition update on Items.ItemDetails quantityInHand 
-- column each time the quantityReceivedColumn of Transactions.OrderDetails has a value inserted to it

-- To know that test truly works, run code below and note quantityInHand value for the given itemID
--
-- SELECT  itemID, itemName, itemDesc, quantityInHand, unitPrice, reorderQuantity, reorderLevel, categoryID, supplierID
-- FROM Items.ItemDetails ;

INSERT INTO Transactions.OrderDetails ( quantityOrdered, quantityReceived, unitPrice, orderStatus,
	receivingDate, refItemID, employeeID )
VALUES ( 5, 3, 12.5, 'Cancelled', DATEADD(mm, 1, GETDATE()), 1012, 10006 ) ;


-- validate insertion

SELECT purchaseOrderID, orderDate, quantityOrdered, quantityReceived, unitPrice, orderStatus, receivingDate, refItemID, employeeID
FROM Transactions.OrderDetails




---------------------------------- TESTING orderInCurrentMonth_proc Procedure  -----------------------------

-- Testing to see if this procedure will output all order placed in current month


-- calling procedure

EXECUTE orderInCurrentMonth_proc





-------------------------------- TESTING ordersOlderThanTwoYears_proc Procedure  -----------------------------

-- Testing to see if this procedure will output orders whose date is older than 2 and more years
-- to test this, we'll have to disable our constraint( chkOrderDate ) on orderDate first, so we 
-- can insert orders whose date is older than 2 year and more. After insetion we'll enable 
-- constraint and then run our test for this procedures


-- disabling constraint

ALTER Table Transactions.OrderDetails
NOCHECK CONSTRAINT chkOrderDate;


INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, 
	orderStatus, receivingDate, refItemID, employeeID )
VALUES ( DATEADD(yy, -6, GETDATE()) ,5, 3, 12.5, 'Cancelled', DATEADD(mm, 1, GETDATE()), 1012, 10006 ) ;


INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, 
	orderStatus, receivingDate, refItemID, employeeID )
VALUES ( DATEADD(yy, -5, GETDATE()) ,5, 3, 12.5, 'Cancelled', DATEADD(mm, 1, GETDATE()), 1012, 10006 ) ;


INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, 
	orderStatus, receivingDate, refItemID, employeeID )
VALUES ( DATEADD(yy, -4, GETDATE()) ,5, 3, 12.5, 'Cancelled', DATEADD(mm, 1, GETDATE()), 1012, 10006 ) ;


INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, 
	orderStatus, receivingDate, refItemID, employeeID )
VALUES ( DATEADD(yy, -3, GETDATE()) ,5, 3, 12.5, 'Cancelled', DATEADD(mm, 1, GETDATE()), 1012, 10006 ) ;


INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, 
	orderStatus, receivingDate, refItemID, employeeID )
VALUES ( DATEADD(yy, -2, GETDATE()) ,5, 3, 12.5, 'Cancelled', DATEADD(mm, 1, GETDATE()), 1012, 10006 ) ;


-- enabling constraint
ALTER Table Transactions.OrderDetails
CHECK CONSTRAINT chkOrderDate;


-- Testing to see that constraint has been enabled

INSERT INTO Transactions.OrderDetails ( orderDate, quantityOrdered, quantityReceived, unitPrice, 
	orderStatus, receivingDate, refItemID, employeeID )
VALUES ( DATEADD(yy, -2, GETDATE()) ,5, 3, 12.5, 'Cancelled', DATEADD(mm, 1, GETDATE()), 1012, 10006 ) ;



-- calling procedure

EXECUTE ordersOlderThanTwoYears_proc ;










-------------------------------- TESTING topFiveSupplierProc Procedure  -----------------------------
--
-- Testing this procedure to see if it will output the top 5 supplier who order the most
-- within the current month

-- This procedure is tested on 
	select getdate()					-- 2018-04-30 04:39:16.997	( April )
--
--
-- To pass this same procedure, it will be tested on 
	select dateadd(dd, 1, getdate())	-- 2018-05-01 04:40:41.350	( May )
--
--
-- To see if it will output same result or none
-- if same, procedure is not working,
-- if otherwise, procedure is working

Execute topFiveSupplierProc;





-------------------------------- TESTING totalCostProc @var Procedure  -----------------------------

-- This is a parameterized procedure which takes one argument purchaseOrderID
-- This procedure is meant to display the total cost of a particular order i.e
-- total cost of the purchase order id passed as an argument


-- Viewing table to tested

SELECT purchaseOrderID, unitPrice, quantityOrdered from Transactions.OrderDetails;



-- testing for purchaseOrderID 1018
-- unitPrice = 12.50 
-- quantityOrdered = 3
--
-- unitPrice * quantityOrdered = 37.50


-- Test Pass

Execute totalCostProc 1018








-------------------------------- TESTING empOrderForMonth @var1 @var2 Procedure  -----------------------------
--
-- This procedure takes two parameter employeeID and Month.
-- This procedure is meant to output the total number of orders placed by a particular
-- employee in a specific month.
-- To test for this we have to pass in the employee's ID we want to know how many order
-- he/she has placed and also we will pass the month number 


-- viewing table to be tested

SELECT employeeID, orderDate from Transactions.OrderDetails

-- Running Test for orders placed in the Month of January

Execute empOrderForMonth 10006, 1		-- The employee with those details has no order


-- Running Test for orders placed in the Month of February

Execute empOrderForMonth 10006, 2		-- The employee with those details has no order


-- Running Test for orders placed in the Month of March

Execute empOrderForMonth 10006, 3		-- The employee with those details has no order


-- Running Test for orders placed in the Month of April 

Execute empOrderForMonth 10006, 4


-- I created table and i also inserted into in the month of April, 
-- That's why April's test is producing value for Total Orders







-------------------- TESTING to see if Logins were created Successfully  ----------------------
--
-- some logins have been created in the main project.
-- testing to see if they are available in list of logins within the db
-- 
--
-- creating already created logins to see if they are available in db
-- Logins name in this project follow a given pattern, every login 
-- is the concatenation of a User real name with the postfix Login
-- our project demand we create a login for George, John and Sara

-- Creating login for George

CREATE LOGIN GeorgeLogin WITH PASSWORD = '1234567890' ;



-- Creating login for John

CREATE LOGIN JohnLogin WITH PASSWORD = '1234567890' ;




-- Creating login for JohSara

CREATE LOGIN SaraLogin WITH PASSWORD = '1234567890' ;



-- listing for all available logins 

select name from TrialDB.sys.server_principals
WHERE name LIKE '%Login'




-------------------- TESTING to see if Users were created Successfully  ----------------------
--
-- some Users have been create in the main project.
-- Testing to see if they are available in list of logins within the db
--
--
-- creating already created users
-- username in this project follow a given style, each username have a
-- prefix of word user before the real name of the actual user
-- we'll be creating user George, userJohn, userSara according to the 
-- demand of ou project


-- creating user George ( test should Fail )

CREATE USER userGeorge FOR LOGIN GeorgeLogin;



-- creating user George ( test should Fail )

CREATE USER userJohn FOR LOGIN GeorgeLogin;



-- creating user George ( test should Fail )

CREATE USER userSara FOR LOGIN GeorgeLogin;



-- listing for all available users

select name from TrialDB.sys.sysusers
WHERE name LIKE 'user%';
















-------------------------------- TESTING commands Given to Each Users  -----------------------------
--
-- Database users are categorised into two roles, Admin and Developer
-- Developers are given SELECT, INSERT, UPDATE command.
-- while Admin is given SELECT, INSERT, UPDATE and DELETE
--
-- We have George as an admin while John and Sara are developers



-- =================================== ADMIN TEST ===================

-- Login to GeorgeLogin as userGeorge ( Admin )
-- I Login to George's Login through object explorer


-- Selecting from table ( testing SELECT command ) ( test pass )

SELECT * FROM HumanResources.Employee 


-- Updating a column in a table ( testing UPDATE command ) ( test pass )

UPDATE HumanResources.Employee
SET firstName = 'Nathan'
WHERE employeeID = 10006 ;


-- validating update

SELECT * FROM HumanResources.Employee ;


-- reverting to previous record 
UPDATE HumanResources.Employee
SET firstName = 'Greg'
WHERE employeeID = 10006 ;




-- Inserting to a table ( testing INSERT command ) ( test pass )

insert into Items.ProductCategory ( categoryName, categoryDesc ) 
VALUES ( 'Household', 'Appliances' ) ;



-- validating insertions

SELECT * FROM Items.ProductCategory ;




-- Deleting from a table  ( test pass )

DELETE FROM Items.ProductCategory 
WHERE categoryID = 1004 ;






-- ============================== DEVELOPER TEST 




-- Login to SaraLogin as userSara ( Developer )
-- connected to this user using object explorer

-- Selecting from table ( testing SELECT command ) ( test pass )

SELECT * FROM HumanResources.Employee 


-- Updating a column in a table ( testing UPDATE command ) ( test pass )

UPDATE HumanResources.Employee
SET firstName = 'Nathan'
WHERE employeeID = 10006 ;


-- validating update

SELECT * FROM HumanResources.Employee


-- reverting to previous record 
UPDATE HumanResources.Employee
SET firstName = 'Greg'
WHERE employeeID = 10006 ;




-- Inserting to a table ( testing INSERT command ) ( test pass )

insert into Items.ProductCategory ( categoryName, categoryDesc ) 
VALUES ( 'Household', 'Appliances' ) ;



-- validating insertions

SELECT * FROM Items.ProductCategory ;




-- Deleting from a table  ( test fail )

DELETE FROM Items.ProductCategory 
WHERE categoryID = 1006 ;






------------------------------------------- Aside Snippet -----------------------------------
--
--	This helps to view the log size of our Database

DECLARE @LogSpace TABLE (
 TrialDB VARCHAR (128),
 [LogSize] INT,
 [LogUsed] INT,
 [Status] INT);

 
 INSERT INTO @LogSpace
 EXEC ('DBCC SQLPERF (LOGSPACE)');

SELECT * FROM @LogSpace

------------------------------------- End of Aside Snippet ----------------------------------