# 175. Combine Two Tables
# Create tables
Create table If Not Exists Person (personId int, firstName varchar(255), lastName varchar(255));
Create table If Not Exists Address (addressId int, personId int, city varchar(255), state varchar(255));
Truncate table Person;
insert into Person (personId, lastName, firstName) values ('1', 'Wang', 'Allen');
insert into Person (personId, lastName, firstName) values ('2', 'Alice', 'Bob');
Truncate table Address;
insert into Address (addressId, personId, city, state) values ('1', '2', 'New York City', 'New York');
insert into Address (addressId, personId, city, state) values ('2', '3', 'Leetcode', 'California');

#S1
select FirstName,LastName,City,state
from Person left join Address
on Person.PersonId=Address.PersonId;

#######################################################################################################

# 181. Employees Earning More Than Their Managers
# Create tables
Create table If Not Exists Employee (id int, name varchar(255), salary int, managerId int);
Truncate table Employee;
insert into Employee (id, name, salary, managerId) values ('1', 'Joe', '70000', '3');
insert into Employee (id, name, salary, managerId) values ('2', 'Henry', '80000', '4');
insert into Employee (id, name, salary, managerId) values ('3', 'Sam', '60000', 'None');
insert into Employee (id, name, salary, managerId) values ('4', 'Max', '90000', 'None');

#S1
SELECT Employee
FROM 
(SELECT A.name as Employee, A.salary as emp_salary,B.name as Manager,B.salary as man_salary
FROM Employee as A 
LEFT JOIN Employee as B
ON A.managerId=B.id) as C
WHERE emp_salary>man_salary;

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
Create table If Not Exists Person (id int, email varchar(255));
Truncate table Person;
insert into Person (id, email) values ('1', 'a@b.com');
insert into Person (id, email) values ('2', 'c@d.com');
insert into Person (id, email) values ('3', 'a@b.com');

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
Create table If Not Exists Customers (id int, name varchar(255));
Create table If Not Exists Orders (id int, customerId int);
Truncate table Customers;
insert into Customers (id, name) values ('1', 'Joe');
insert into Customers (id, name) values ('2', 'Henry');
insert into Customers (id, name) values ('3', 'Sam');
insert into Customers (id, name) values ('4', 'Max');
Truncate table Orders;
insert into Orders (id, customerId) values ('1', '3');
insert into Orders (id, customerId) values ('2', '1');

#S1
SELECT name as Customers
FROM Customers LEFT JOIN Orders ON Customers.id=Orders.customerId
WHERE Orders.id is NULL;

#S2
SELECT name as Customers 
FROM Customers 
WHERE id NOT IN (select customerId from Orders);

#S3
#Use NOT EXIST + WHERE
select Name as Customers
from customers c
where not exists (select * from Orders o where o.CustomerId=c.id);


#######################################################################################################
#196. Delete Duplicate Emails
#Create Table
Create table If Not Exists Person (Id int, Email varchar(255));
Truncate table Person;
insert into Person (id, email) values ('1', 'john@example.com');
insert into Person (id, email) values ('2', 'bob@example.com');
insert into Person (id, email) values ('3', 'john@example.com');
insert into Person (id, email) values ('4', 'john@example.com');

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
delete p1 from Person p1, Person p2 where p1.email = p2.email and p1.id > p2.id;


#######################################################################################################
#197. Rising Temperature
#Create table
Create table If Not Exists Weather (id int, recordDate date, temperature int);
Truncate table Weather;
insert into Weather (id, recordDate, temperature) values ('1', '2015-01-01', '10');
insert into Weather (id, recordDate, temperature) values ('2', '2015-01-02', '25');
insert into Weather (id, recordDate, temperature) values ('3', '2015-01-03', '20');
insert into Weather (id, recordDate, temperature) values ('4', '2015-01-04', '30');

#S1
SELECT A.id as id
FROM Weather as A INNER JOIN
Weather as B ON
DATEDIF(A.recordDate,B.recordDate)=1 and A.Temperature>B.Temperature;

#S2
#Another way to get yesterday''s date is using SUBDATE(current_date,1)
SELECT Weather.Id 
FROM   Weather 
       JOIN Weather AS w 
         ON w.RecordDate = SUBDATE(Weather.RecordDate, 1) 
WHERE  Weather.Temperature > w.Temperature;


#######################################################################################################
#511.Game Play Analysis I
#Create Table
Create table If Not Exists Activity (player_id int, device_id int, event_date date, games_played int);
Truncate table Activity;
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-01', '5');
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-05-02', '6');
insert into Activity (player_id, device_id, event_date, games_played) values ('2', '3', '2017-06-25', '1');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '1', '2016-03-02', '0');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '4', '2018-07-03', '5');

#S1
SELECT player_id, min(event_date) as first_login
FROM Activity
GROUP BY player_id;

#S2
#Window Function faster
WITH added_row_number AS
( SELECT *, ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date ASC) AS row_number
FROM Activity );

SELECT player_id, event_date as first_login
FROM added_row_number
WHERE row_number = 1;


#######################################################################################################
#512.Game Play Analysis I
#Create Table
Create table If Not Exists Activity (player_id int, device_id int, event_date date, games_played int);
Truncate table Activity;
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-01', '5');
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-05-02', '6');
insert into Activity (player_id, device_id, event_date, games_played) values ('2', '3', '2017-06-25', '1');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '1', '2016-03-02', '0');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '4', '2018-07-03', '5');

#S1
SELECT A.player_id,A.device_id
FROM Activity as A 
INNER JOIN 
(SELECT player_id,min(event_date) as Date FROM Activity GROUP BY player_id) as B 
ON A.player_id=B.player_id;

#S2
SELECT DISTINCT player_id, device_id
FROM
(SELECT *, RANK() OVER (PARTITION BY player_id ORDER BY event_date ASC) as rnk
FROM Activity) as temp
WHERE rnk = 1;

#S3
SELECT DISTINCT player_id,
 FIRST_VALUE(device_id) OVER(PARTITION BY player_id ORDER BY event_date ASC) AS device_id
FROM Activity;


#######################################################################################################
#577. Employee Bonus
#Create Table
Create table If Not Exists Employee (empId int, name varchar(255), supervisor int, salary int);
Create table If Not Exists Bonus (empId int, bonus int);
Truncate table Employee;
insert into Employee (empId, name, supervisor, salary) values ('3', 'Brad', 'None', '4000');
insert into Employee (empId, name, supervisor, salary) values ('1', 'John', '3', '1000');
insert into Employee (empId, name, supervisor, salary) values ('2', 'Dan', '3', '2000');
insert into Employee (empId, name, supervisor, salary) values ('4', 'Thomas', '3', '4000');
Truncate table Bonus;
insert into Bonus (empId, bonus) values ('2', '500');
insert into Bonus (empId, bonus) values ('4', '2000');

#S1
#Do not foget to add contion when bonus is NULL
SELECT A.name,B.bonus
FROM Employee as A LEFT JOIN
Bonus as B ON
A.empId=B.empId
WHERE bonus<1000 or bonus is NULL;


#######################################################################################################
#584. Find Customer Referee
#Create Table
Create table If Not Exists Customer (id int, name varchar(25), referee_id int);
Truncate table Customer;
insert into Customer (id, name, referee_id) values ('1', 'Will', 'None');
insert into Customer (id, name, referee_id) values ('2', 'Jane', 'None');
insert into Customer (id, name, referee_id) values ('3', 'Alex', '2');
insert into Customer (id, name, referee_id) values ('4', 'Bill', 'None');
insert into Customer (id, name, referee_id) values ('5', 'Zack', '1');
insert into Customer (id, name, referee_id) values ('6', 'Mark', '2');

#S1
# != is as same as <>
SELECT name 
FROM Customer 
WHERE  referee_id!=2 or referee_id IS NULL;



#######################################################################################################
#586. Customer Placing the Largest Number of Orders
#Create Table;
Create table If Not Exists orders (order_number int, customer_number int);
Truncate table orders;
insert into orders (order_number, customer_number) values ('1', '1');
insert into orders (order_number, customer_number) values ('2', '2');
insert into orders (order_number, customer_number) values ('3', '3');
insert into orders (order_number, customer_number) values ('4', '3');

#S1
SELECT customer_number
FROM Orders 
GROUP BY customer_number
ORDER BY count(*) DESC
LIMIT 1;

#S2
#Use Window Function
SELECT customer_number
FROM (SELECT *, COUNT(order_number)OVER(Partition by customer_number) as number_of_orders FROM orders) as temp
ORDER BY number_of_orders
DESC LIMIT 1;



#######################################################################################################
#595. Big Countries
#Create Table
Create table If Not Exists World (name varchar(255), continent varchar(255), area int, population int, gdp int);
Truncate table World;
insert into World (name, continent, area, population, gdp) values ('Afghanistan', 'Asia', '652230', '25500100', '20343000000');
insert into World (name, continent, area, population, gdp) values ('Albania', 'Europe', '28748', '2831741', '12960000000');
insert into World (name, continent, area, population, gdp) values ('Algeria', 'Africa', '2381741', '37100000', '188681000000');
insert into World (name, continent, area, population, gdp) values ('Andorra', 'Europe', '468', '78115', '3712000000');
insert into World (name, continent, area, population, gdp) values ('Angola', 'Africa', '1246700', '20609294', '100990000000');

#S1
SELECT name, population, area
FROM World
WHERE area>=3000000 or 
  population >=25000000;

#S2
#Use UNION instead of OR 
SELECT name, population, area
FROM world
WHERE area >= 3000000
UNION
SELECT name, population, area
FROM world
WHERE population >= 25000000;


#######################################################################################################
#596. Classes More Than 5 Students
#Create Table
Create table If Not Exists Courses (student varchar(255), class varchar(255));
Truncate table Courses;
insert into Courses (student, class) values ('A', 'Math');
insert into Courses (student, class) values ('B', 'English');
insert into Courses (student, class) values ('C', 'Math');
insert into Courses (student, class) values ('D', 'Biology');
insert into Courses (student, class) values ('E', 'Math');
insert into Courses (student, class) values ('F', 'Computer');
insert into Courses (student, class) values ('G', 'Math');
insert into Courses (student, class) values ('H', 'Math');
insert into Courses (student, class) values ('I', 'Math');

#S1
SELECT class, COUNT(DISTINCT student)
FROM Courses
GROUP BY class
HAVING COUNT(DISTINCT student)>=5;

#S2
SELECT
    class
FROM
    (SELECT class, COUNT(DISTINCT student) AS num
    FROM courses
    GROUP BY class) AS temp_table
WHERE num >= 5;


#######################################################################################################
#597. Friend Requests I: Overall Acceptance Rate 
#Create Table
Create table If Not Exists FriendRequest (sender_id int, send_to_id int, request_date date);
Create table If Not Exists RequestAccepted (requester_id int, accepter_id int, accept_date date);
Truncate table FriendRequest;
insert into FriendRequest (sender_id, send_to_id, request_date) values ('1', '2', '2016/06/01');
insert into FriendRequest (sender_id, send_to_id, request_date) values ('1', '3', '2016/06/01');
insert into FriendRequest (sender_id, send_to_id, request_date) values ('1', '4', '2016/06/01');
insert into FriendRequest (sender_id, send_to_id, request_date) values ('2', '3', '2016/06/02');
insert into FriendRequest (sender_id, send_to_id, request_date) values ('3', '4', '2016/06/09');
Truncate table RequestAccepted;
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '2', '2016/06/03');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('2', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/09');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/10');

#S1
with accepted
as
(select count(distinct requester_id,accepter_id) as nr
from RequestAccepted),

sent as
(select count(distinct sender_id,send_to_id) as na
from FriendRequest)

select coalesce(round(nr/na,2),0.00) as accept_rate
from accepted,sent;

#S2
#More Concise;
SELECT ROUND(
     IFNULL(
          (SELECT COUNT(*) FROM (SELECT DISTINCT requester_id,accepter_id FROM RequestAccepted) as A )
          /
          (SELECT COUNT(*) FROM (SELECT DISTINCT sender_id,send_to_id FROM FriendRequest) as B),
          0)
          ,2) as accept_rate;


#######################################################################################################
#603. Consecutive Available Seats
#Create Table
Create table If Not Exists Cinema (seat_id int primary key auto_increment, free bool);
Truncate table Cinema;
insert into Cinema (seat_id, free) values ('1', '1');
insert into Cinema (seat_id, free) values ('2', '0');
insert into Cinema (seat_id, free) values ('3', '1');
insert into Cinema (seat_id, free) values ('4', '1');
insert into Cinema (seat_id, free) values ('5', '1');

#S1
SELECT seat_id
FROM Cinema
WHERE free=1 AND
  (seat_id-1 in (SELECT seat_id FROM cinema WHERE free=1) OR 
  (seat_id+1 in (SELECT seat_id FROM cinema WHERE free=1)))
ORDER BY seat_id;

#S2 
#Using self join and abs()
select distinct a.seat_id
from cinema as A join cinema as B 
on abs(a.seat_id-b.seat_id)=1 and a.free=true and b.free=true
order by a.seat_id;

#S3
select distinct a.seat_id from
    cinema a join cinema b on a.seat_id = b.seat_id + 1 
             or a.seat_id = b.seat_id-1
    where a.free = 1 and b.free = 1
   order by a.seat_id;


#######################################################################################################
#607. Sales Person
#Create Table 
Create table If Not Exists SalesPerson (sales_id int, name varchar(255), salary int, commission_rate int, hire_date date);
Create table If Not Exists Company (com_id int, name varchar(255), city varchar(255));
Create table If Not Exists Orders (order_id int, order_date date, com_id int, sales_id int, amount int);
Truncate table SalesPerson;
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('1', 'John', '100000', '6', '4/1/2006');
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('2', 'Amy', '12000', '5', '5/1/2010');
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('3', 'Mark', '65000', '12', '12/25/2008');
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('4', 'Pam', '25000', '25', '1/1/2005');
insert into SalesPerson (sales_id, name, salary, commission_rate, hire_date) values ('5', 'Alex', '5000', '10', '2/3/2007');
Truncate table Company;
insert into Company (com_id, name, city) values ('1', 'RED', 'Boston');
insert into Company (com_id, name, city) values ('2', 'ORANGE', 'New York');
insert into Company (com_id, name, city) values ('3', 'YELLOW', 'Boston');
insert into Company (com_id, name, city) values ('4', 'GREEN', 'Austin');
Truncate table Orders;
insert into Orders (order_id, order_date, com_id, sales_id, amount) values ('1', '1/1/2014', '3', '4', '10000');
insert into Orders (order_id, order_date, com_id, sales_id, amount) values ('2', '2/1/2014', '4', '5', '5000');
insert into Orders (order_id, order_date, com_id, sales_id, amount) values ('3', '3/1/2014', '1', '1', '50000');
insert into Orders (order_id, order_date, com_id, sales_id, amount) values ('4', '4/1/2014', '1', '4', '25000');

#S1 
SELECT 
FROM SalesPerson 
WHERE sales_id NOT IN (SELECT sales_id FROM Orders
                       WHERE  com_id in (SELECT com_id FROM Company WHERE name='RED'));

#S2
#Using OUTER JOIN and NOT IN 
SELECT s.name
FROM salesperson s
WHERE s.sales_id NOT IN (
  SELECT o.sales_id FROM orders O 
  LEFT JOIN 
  Company C ON O.com_id=C.com_id
  WHERE c.name='RED');


#######################################################################################################
#610. Triangle Judgement
#Create Table
Create table If Not Exists Triangle (x int, y int, z int);
Truncate table Triangle;
insert into Triangle (x, y, z) values ('13', '15', '30');
insert into Triangle (x, y, z) values ('10', '20', '15');

#S1 
select x,y,z, IF(x+y>z and y+z>x and z+x>y, 'Yes','No') as triangle
from Triangle;

#S2
select x,y,z,
  case when x+y>z and x+z>y and z+y>x then 'Yes' else 'No' END as 'triangle'
from triangle;

#S3
SELECT *,
(case when x+y>z and abs(x-y)<z
then 'yes'
else 'no'
end) as triangle
from triangle

#S4 
SELECT 
    *, IF(2*GREATEST(x,y,z) < x+y+z, 'Yes', 'No') AS triangle
FROM triangle;



#######################################################################################################
#613. Shortest Distance in a Line
#Create Table
Create Table If Not Exists Point (x int not null);
Truncate table Point;
insert into Point (x) values ('-1');
insert into Point (x) values ('0');
insert into Point (x) values ('2');

#S1
#SELF JOIN and min Function
SELECT min(abs(A.x-B.x)) as shortest 
FROM point A 
INNER JOIN point B 
ON A.x!=B.x

#S2
#You don''t need abs() function if you just invert the subtraction.; 
# Using LAG with MS SQL Server, the solution is not O(n^2);

select min(dif) as shortest from
(select x-lag(x) OVER (order by x) dif FROM point) as point2


#######################################################################################################
#619. Biggest Single Number 
#Create Table 
Create table If Not Exists MyNumbers (num int);
Truncate table MyNumbers;
insert into MyNumbers (num) values ('8');
insert into MyNumbers (num) values ('8');
insert into MyNumbers (num) values ('3');
insert into MyNumbers (num) values ('3');
insert into MyNumbers (num) values ('1');
insert into MyNumbers (num) values ('4');
insert into MyNumbers (num) values ('5');
insert into MyNumbers (num) values ('6');

#S1 
#the max() function will take care of the null condition, there is no need to add IFNULL function 
SELECT max(num) as num
FROM (SELECT num 
      FROM MyNumbers
      GROUP BY num
      HAVING COUNT(num)=1) AS t;



#######################################################################################################
#620. Not Boring Movies
#Create Table 
Create table If Not Exists cinema (id int, movie varchar(255), description varchar(255), rating float(2, 1));
Truncate table cinema;
insert into cinema (id, movie, description, rating) values ('1', 'War', 'great 3D', '8.9');
insert into cinema (id, movie, description, rating) values ('2', 'Science', 'fiction', '8.5');
insert into cinema (id, movie, description, rating) values ('3', 'irish', 'boring', '6.2');
insert into cinema (id, movie, description, rating) values ('4', 'Ice song', 'Fantacy', '8.6');
insert into cinema (id, movie, description, rating) values ('5', 'House card', 'Interesting', '9.1');

#S1 
SELECT id,movie,description,rating 
FROM Cinema 
WHERE id%2<>0 and description!="boring"
ORDER BY rating DESC;

#S2 
#improve the efficiency;
# where description <> 'boring' and id%2=1 -->>135ms
# where description != 'boring' and id%2=1 -->>125ms
# where description != 'boring' and mod(id,2)=1 -->>110ms
# where description <> 'boring' and mod(id,2)=1 -->>108ms











































