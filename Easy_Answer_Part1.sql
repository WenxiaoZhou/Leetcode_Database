# 175. Combine Two Tables
# Create tables
Create table If Not Exists Person (personId int, firstName varchar(255), lastName varchar(255))
Create table If Not Exists Address (addressId int, personId int, city varchar(255), state varchar(255))
Truncate table Person
insert into Person (personId, lastName, firstName) values ('1', 'Wang', 'Allen')
insert into Person (personId, lastName, firstName) values ('2', 'Alice', 'Bob')
Truncate table Address
insert into Address (addressId, personId, city, state) values ('1', '2', 'New York City', 'New York')
insert into Address (addressId, personId, city, state) values ('2', '3', 'Leetcode', 'California')

#S1
select FirstName,LastName,City,state
from Person left join Address
on Person.PersonId=Address.PersonId;

#######################################################################################################

# 181. Employees Earning More Than Their Managers
# Create tables
Create table If Not Exists Employee (id int, name varchar(255), salary int, managerId int)
Truncate table Employee
insert into Employee (id, name, salary, managerId) values ('1', 'Joe', '70000', '3')
insert into Employee (id, name, salary, managerId) values ('2', 'Henry', '80000', '4')
insert into Employee (id, name, salary, managerId) values ('3', 'Sam', '60000', 'None')
insert into Employee (id, name, salary, managerId) values ('4', 'Max', '90000', 'None')

#S1
SELECT Employee
FROM 
(SELECT A.name as Employee, A.salary as emp_salary,B.name as Manager,B.salary as man_salary
FROM Employee as A 
LEFT JOIN Employee as B
ON A.managerId=B.id) as C
WHERE emp_salary>man_salary

#S2
#SELF JOIN Employee Table first and find the matching between id column and manager_id column
SELECT a.Name AS 'Employee' 
FROM Employee as A, Employee as B
WHERE a.ManagerId=B.id and A.Salary>B.Salary;

#S3
#Directly using JOIN to link tables together, ON can specify more than one condition
SELECT
     a.NAME AS Employee
FROM Employee AS a JOIN Employee AS b
     ON a.ManagerId = b.Id
     AND a.Salary > b.Salary;

#######################################################################################################

#182. Duplicate Emails
#Create table 
Create table If Not Exists Person (id int, email varchar(255))
Truncate table Person
insert into Person (id, email) values ('1', 'a@b.com')
insert into Person (id, email) values ('2', 'c@d.com')
insert into Person (id, email) values ('3', 'a@b.com')

#S1
SELECT Email
FROM (SELECT email,count(*) as counts from Person group by email) as A 
WHERE counts>=2;

#S2
#An easier solution is to use group by + having condition
SELECT Email FROM Person 
GROUP BY Email
HAVING count(email)>1;

#S3
#A simple SELF JOIN is enough
SELECT DISTINCT p1.Email
FROM Person p1, Person p2
WHERE p1.Email = p2.Email and p1.id != p2.id;


#######################################################################################################
#183. Customers Who Never Order
#Create table
Create table If Not Exists Customers (id int, name varchar(255))
Create table If Not Exists Orders (id int, customerId int)
Truncate table Customers
insert into Customers (id, name) values ('1', 'Joe')
insert into Customers (id, name) values ('2', 'Henry')
insert into Customers (id, name) values ('3', 'Sam')
insert into Customers (id, name) values ('4', 'Max')
Truncate table Orders
insert into Orders (id, customerId) values ('1', '3')
insert into Orders (id, customerId) values ('2', '1')

#S1
SELECT name as Customers
FROM Customers LEFT JOIN Orders ON Customers.id=Orders.customerId
WHERE Orders.id is NULL

#S2
SELECT name as Customers 
FROM Customers 
WHERE id NOT IN (select customerId from Orders)

#S3
#Use NOT EXIST + WHERE
select Name as Customers
from customers c
where not exists (select * from Orders o where o.CustomerId=c.id)


#######################################################################################################
#196. Delete Duplicate Emails
#Create Table
Create table If Not Exists Person (Id int, Email varchar(255))
Truncate table Person
insert into Person (id, email) values ('1', 'john@example.com')
insert into Person (id, email) values ('2', 'bob@example.com')
insert into Person (id, email) values ('3', 'john@example.com')
insert into Person (id, email) values ('4', 'john@example.com')

#S1
#sort id in each email address, then delete those that are not the first id 
DELETE FROM Person WHERE ID NOT IN
 (SELECT * FROM (SELECT MIN(Id)
                 FROM Person 
                 GROUP BY Email) as p);

#S2
DELETE p1 FROM Person p1 INNER JOIN Person p2
WHERE p1.email=p2.email AND p1.id>p2.id;

#S3
#Notice that delete + database name rather the certain rows
delete p1 from Person p1, Person p2 where p1.email = p2.email and p1.id > p2.id


#######################################################################################################
#197. Rising Temperature
#Create table
Create table If Not Exists Weather (id int, recordDate date, temperature int)
Truncate table Weather
insert into Weather (id, recordDate, temperature) values ('1', '2015-01-01', '10')
insert into Weather (id, recordDate, temperature) values ('2', '2015-01-02', '25')
insert into Weather (id, recordDate, temperature) values ('3', '2015-01-03', '20')
insert into Weather (id, recordDate, temperature) values ('4', '2015-01-04', '30')

#S1
SELECT A.id as id
FROM Weather as A INNER JOIN
Weather as B ON
DATEDIF(A.recordDate,B.recordDate)=1 and A.Temperature>B.Temperature

#S2
#Another way to get yesterday''s date is using SUBDATE(current_date,1)
SELECT Weather.Id 
FROM   Weather 
       JOIN Weather AS w 
         ON w.RecordDate = SUBDATE(Weather.RecordDate, 1) 
WHERE  Weather.Temperature > w.Temperature 


#######################################################################################################
#511.Game Play Analysis I
#Create Table
Create table If Not Exists Activity (player_id int, device_id int, event_date date, games_played int)
Truncate table Activity
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-01', '5')
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-05-02', '6')
insert into Activity (player_id, device_id, event_date, games_played) values ('2', '3', '2017-06-25', '1')
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '1', '2016-03-02', '0')
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '4', '2018-07-03', '5')

#S1
SELECT player_id, min(event_date) as first_login
FROM Activity
GROUP BY player_id;

#S2
#Window Function faster
WITH added_row_number AS
( SELECT *, ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date ASC) AS row_number
FROM Activity )

SELECT player_id, event_date as first_login
FROM added_row_number
WHERE row_number = 1;


#######################################################################################################
#512.Game Play Analysis I
#Create Table
Create table If Not Exists Activity (player_id int, device_id int, event_date date, games_played int)
Truncate table Activity
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-01', '5')
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-05-02', '6')
insert into Activity (player_id, device_id, event_date, games_played) values ('2', '3', '2017-06-25', '1')
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '1', '2016-03-02', '0')
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '4', '2018-07-03', '5')

#S1
SELECT A.player_id,A.device_id
FROM Activity as A 
INNER JOIN 
(SELECT player_id,min(event_date) as Date FROM Activity GROUP BY player_id) as B 
ON A.player_id=B.player_id

#S2
SELECT DISTINCT player_id, device_id
FROM
(SELECT *, RANK() OVER (PARTITION BY player_id ORDER BY event_date ASC) as rnk
FROM Activity) as temp
WHERE rnk = 1

#S3
SELECT DISTINCT player_id,
 FIRST_VALUE(device_id) OVER(PARTITION BY player_id ORDER BY event_date ASC) AS device_id
FROM Activity


#######################################################################################################
#577. Employee Bonus
#Create Table
Create table If Not Exists Employee (empId int, name varchar(255), supervisor int, salary int)
Create table If Not Exists Bonus (empId int, bonus int)
Truncate table Employee
insert into Employee (empId, name, supervisor, salary) values ('3', 'Brad', 'None', '4000')
insert into Employee (empId, name, supervisor, salary) values ('1', 'John', '3', '1000')
insert into Employee (empId, name, supervisor, salary) values ('2', 'Dan', '3', '2000')
insert into Employee (empId, name, supervisor, salary) values ('4', 'Thomas', '3', '4000')
Truncate table Bonus
insert into Bonus (empId, bonus) values ('2', '500')
insert into Bonus (empId, bonus) values ('4', '2000')

#S1
#Do not foget to add contion when bonus is NULL
SELECT A.name,B.bonus
FROM Employee as A LEFT JOIN
Bonus as B ON
A.empId=B.empId
WHERE bonus<1000 or bonus is NULL

#######################################################################################################
#584. Find Customer Referee
#Create Table
Create table If Not Exists Customer (id int, name varchar(25), referee_id int)
Truncate table Customer
insert into Customer (id, name, referee_id) values ('1', 'Will', 'None')
insert into Customer (id, name, referee_id) values ('2', 'Jane', 'None')
insert into Customer (id, name, referee_id) values ('3', 'Alex', '2')
insert into Customer (id, name, referee_id) values ('4', 'Bill', 'None')
insert into Customer (id, name, referee_id) values ('5', 'Zack', '1')
insert into Customer (id, name, referee_id) values ('6', 'Mark', '2')

#S1
# != is as same as <>
SELECT name 
FROM Customer 
WHERE  referee_id!=2 or referee_id IS NULL



















