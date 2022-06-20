# 584. Find Customer Referee
#Create Table
Create table If Not Exists Customer (id int, name varchar(25), referee_id int);
Truncate table Customer;
insert into Customer (id, name, referee_id) values ('1', 'Will', 'None');
insert into Customer (id, name, referee_id) values ('2', 'Jane', 'None');
insert into Customer (id, name, referee_id) values ('3', 'Alex', '2');
insert into Customer (id, name, referee_id) values ('4', 'Bill', 'None');
insert into Customer (id, name, referee_id) values ('5', 'Zack', '1');
insert into Customer (id, name, referee_id) values ('6', 'Mark', '2');

# != is as same as <>, remember not forget referee_id is NULL
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
SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(DISTINCT student)>=5;



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
with accepted as
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
     (SELECT count(distinct requester_id,accepter_id) as A FROM RequestAccepted)/
       (SELECT COUNT(distinct sender_id,send_to_id) as B FROM FriendRequest),0),2)
       as accept_rate;



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
SELECT name 
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
from triangle;

#S4 
SELECT *, 
  IF(2*GREATEST(x,y,z) < x+y+z, 'Yes', 'No') AS triangle
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
ON A.x!=B.x;

#S2
#You don''t need abs() function if you just invert the subtraction.; 
# Using LAG with MS SQL Server, the solution is not O(n^2);

select min(dif) as shortest from
(select x-lag(x) OVER (order by x) dif FROM point) as point2;
