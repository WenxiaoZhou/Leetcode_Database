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


#######################################################################################################
#627. Swap Salary
#Create Table 
Create table If Not Exists Salary (id int, name varchar(100), sex char(1), salary int);
Truncate table Salary;
insert into Salary (id, name, sex, salary) values ('1', 'A', 'm', '2500');
insert into Salary (id, name, sex, salary) values ('2', 'B', 'f', '1500');
insert into Salary (id, name, sex, salary) values ('3', 'C', 'm', '5500');
insert into Salary (id, name, sex, salary) values ('4', 'D', 'f', '500');

#S1 
update salary set 
   sex = IF (sex = "m", "f", "m");

#S2 
update salary 
set 
 sex=CASE sex WHEN 'm' THEN 'f'
              ELSE 'm'
      END;



#######################################################################################################
#1050. Actors and Directors Who COoperated At Least Three Times 
#Create Table 
Create table If Not Exists ActorDirector (actor_id int, director_id int, timestamp int);
Truncate table ActorDirector;
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '0');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '1');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '2');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '2', '3');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '2', '4');
insert into ActorDirector (actor_id, director_id, timestamp) values ('2', '1', '5');
insert into ActorDirector (actor_id, director_id, timestamp) values ('2', '1', '6');

#S1 
SELECT actor_id, director_id
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(*)>=3;

#S2 
SELECT DISTINCT actor_id,director_id
FROM (
  SELECT actor,director_id,COUNT(timestamp) OVER(PARTITION BY actor_id,director_id) as number_of_times
  FROM ActorDirector) AS temp
WHERE number_of_times>=3;


#######################################################################################################
#1068. Product Sales Analysis I 
#Create Table 
Create table If Not Exists Sales (sale_id int, product_id int, year int, quantity int, price int);
Create table If Not Exists Product (product_id int, product_name varchar(10));
Truncate table Sales;
insert into Sales (sale_id, product_id, year, quantity, price) values ('1', '100', '2008', '10', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('2', '100', '2009', '12', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('7', '200', '2011', '15', '9000');
Truncate table Product;
insert into Product (product_id, product_name) values ('100', 'Nokia');
insert into Product (product_id, product_name) values ('200', 'Apple');
insert into Product (product_id, product_name) values ('300', 'Samsung');

#S1 
SELECT B.product_name, A.year, A.price
FROM Sales A
INNER JOIN Product B
ON A.product_id=B.product_id;


#######################################################################################################
#1069. Product Saless Analysis II 
#Create Table 
Create table If Not Exists Sales (sale_id int, product_id int, year int, quantity int, price int);
Create table If Not Exists Product (product_id int, product_name varchar(10));
Truncate table Sales;
insert into Sales (sale_id, product_id, year, quantity, price) values ('1', '100', '2008', '10', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('2', '100', '2009', '12', '5000');
insert into Sales (sale_id, product_id, year, quantity, price) values ('7', '200', '2011', '15', '9000');
Truncate table Product;
insert into Product (product_id, product_name) values ('100', 'Nokia');
insert into Product (product_id, product_name) values ('200', 'Apple');
insert into Product (product_id, product_name) values ('300', 'Samsung');

#S1 
SELECT product_id,sum(quantity) as total_quantity
FROM Sales 
GROUP BY Aproduct_id;


#######################################################################################################
#1075. Project Employees I 
#Create Table 
Create table If Not Exists Project (project_id int, employee_id int);
Create table If Not Exists Employee (employee_id int, name varchar(10), experience_years int);
Truncate table Project;
insert into Project (project_id, employee_id) values ('1', '1');
insert into Project (project_id, employee_id) values ('1', '2');
insert into Project (project_id, employee_id) values ('1', '3');
insert into Project (project_id, employee_id) values ('2', '1');
insert into Project (project_id, employee_id) values ('2', '4');
Truncate table Employee;
insert into Employee (employee_id, name, experience_years) values ('1', 'Khaled', '3');
insert into Employee (employee_id, name, experience_years) values ('2', 'Ali', '2');
insert into Employee (employee_id, name, experience_years) values ('3', 'John', '1');
insert into Employee (employee_id, name, experience_years) values ('4', 'Doe', '2');

#S1 
SELECT A.project_id,ROUND(AVG(experience_years),2) as average_years
FROM Project as A 
LEFT JOIN Employee as B 
USING (employee_id)
GROUP BY A.project_id;

#S2 
SELECT distinct(project_id), ROUND(AVG(experience_years) OVER (PARTITION BY project_id),2) as average_years
FROM Project p LEFT JOIN Employee e
ON p.employee_id = e.employee_id;



#######################################################################################################
#1076. Project Employees II 
#Create Table 
Create table If Not Exists Project (project_id int, employee_id int);
Create table If Not Exists Employee (employee_id int, name varchar(10), experience_years int);
Truncate table Project;
insert into Project (project_id, employee_id) values ('1', '1');
insert into Project (project_id, employee_id) values ('1', '2');
insert into Project (project_id, employee_id) values ('1', '3');
insert into Project (project_id, employee_id) values ('2', '1');
insert into Project (project_id, employee_id) values ('2', '4');
Truncate table Employee;
insert into Employee (employee_id, name, experience_years) values ('1', 'Khaled', '3');
insert into Employee (employee_id, name, experience_years) values ('2', 'Ali', '2');
insert into Employee (employee_id, name, experience_years) values ('3', 'John', '1');
insert into Employee (employee_id, name, experience_years) values ('4', 'Doe', '2');

#S1
WITH counting as (
    SELECT project_id,COUNT(*) as counts
    FROM Project
    GROUP BY project_id
    ORDER BY counts DESC
)
SELECT project_id
FROM counting
WHERE counts in (SELECT max(counts) as maxi FROM counting);

#S2 
SELECT project_id
FROM (
  SELECT project_id,
         RANK() OVER (ORDER BY COUNT(DISTINCT p.employee_id) DESC) as rnk 
  FROM project p 
  GROUP BY project_id
) t1 
WHERE t1.rnk=1;

#S3
SELECT project_id
FROM Project
GROUP BY Project_id
HAVING COUNT(employee_id)=(
     SELECT count(employee_id) as cnt
     FROM Project
     GROUP BY Project_id
     ORDER BY cnt desc
     LIMIT 1);

#notice that the below part of code would only return 1 id
#select project_id
#from Project
#group by project_id
#order by count(*) DESC
#limit 1;



#######################################################################################################
#1082. Sales Analysis I 
#Create Table 
Create table If Not Exists Product (product_id int, product_name varchar(10), unit_price int);
Create table If Not Exists Sales (seller_id int, product_id int, buyer_id int, sale_date date, quantity int, price int);
Truncate table Product;
insert into Product (product_id, product_name, unit_price) values ('1', 'S8', '1000');
insert into Product (product_id, product_name, unit_price) values ('2', 'G4', '800');
insert into Product (product_id, product_name, unit_price) values ('3', 'iPhone', '1400');
Truncate table Sales;
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('1', '1', '1', '2019-01-21', '2', '2000');
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('1', '2', '2', '2019-02-17', '1', '800');
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('2', '2', '3', '2019-06-02', '1', '800');
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('3', '3', '4', '2019-05-13', '2', '2800');

#S1
SELECT seller_id
FROM Sales 
GROUP BY seller_id
HAVING sum(price)=(
    SELECT SUM(price) OVER(PARTITION BY seller_id) as price
    FROM Sales
    ORDER BY price DESC
    LIMIT 1
);

#S2
SELECT seller_id
FROM (
       SELECT seller_id,
            RANK() OVER(ORDER BY SUM(price) DESC) as rnk
       FROM Sales
       GROUP BY seller_id
) t1
WHERE t1.rnk=1;