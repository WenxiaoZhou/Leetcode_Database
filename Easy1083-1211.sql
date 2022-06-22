#######################################################################################################
#1083. Sales Analysis II 
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
# MYSQL does not accept EXCEPT
SELECT DISTINCT(buyer_id)
FROM Sales s LEFT JOIN Product p
ON s.product_id = p.product_id
WHERE p.product_name = 'S8'
AND buyer_id NOT IN
(SELECT buyer_id
FROM Sales s LEFT JOIN Product p
ON s.product_id = p.product_id
WHERE p.product_name = 'iPhone'
);

#S2
SELECT buyer_id
FROM Sales as S 
LEFT JOIN Product as P 
USING (product_id)
GROUP BY buyer_id 
HAVING sum(CASE WHEN p.product_name='S8' THEN s.quantity ELSE 0 END)>0 
 AND 
       sum(CASE WHEN p.product_name='iPhone' THEN s.quantity ELSE 0 END)=0;



#######################################################################################################
#1083. Sales Analysis III 
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
SELECT distinct P.product_id,P.product_name
FROM Product P left join Sales S
ON (P.product_id=S.product_id)
WHERE sale_date between '2019-01-01' and '2019-03-31' 
  and p.product_id not in (SELECT product_id FROM Sales WHERE sale_date>'2019-03-31' or sale_date<'2019-01-01');

#S2
SELECT P.product_id,P.product_name
FROM Product P
JOIN Sales S on P.product_id=S.product_id
GROUP BY product_id
HAVING sum(CASE WHEN (YEAR(S.sale_date)=2019 AND MONTH(S.sale_date)>=1 and MONTH(S.sale_date)<=3) 
             THEN 1 ELSE 0 END)>=1
        and
        sum(CASE WHEN (YEAR(S.sale_date)!=2019 or (Year(S.sale_date)=2019 and MONTH(S.sale_date)>=4))
              THEN 1 ELSE 0 END)=0;


#######################################################################################################
#1113. Reported Posts
#Create Table 
Create table If Not Exists Actions (user_id int, post_id int, action_date date, action ENUM('view', 'like', 'reaction', 'comment', 'report', 'share'), extra varchar(10));
Truncate table Actions;
insert into Actions (user_id, post_id, action_date, action, extra) values ('1', '1', '2019-07-01', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('1', '1', '2019-07-01', 'like', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('1', '1', '2019-07-01', 'share', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('2', '4', '2019-07-04', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('2', '4', '2019-07-04', 'report', 'spam');
insert into Actions (user_id, post_id, action_date, action, extra) values ('3', '4', '2019-07-04', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('3', '4', '2019-07-04', 'report', 'spam');
insert into Actions (user_id, post_id, action_date, action, extra) values ('4', '3', '2019-07-02', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('4', '3', '2019-07-02', 'report', 'spam');
insert into Actions (user_id, post_id, action_date, action, extra) values ('5', '2', '2019-07-04', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('5', '2', '2019-07-04', 'report', 'racism');
insert into Actions (user_id, post_id, action_date, action, extra) values ('5', '5', '2019-07-04', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('5', '5', '2019-07-04', 'report', 'racism');

#S1 
SELECT extra as report_reason, count(DISTINCT post_id) as report_count
FROM Actions 
WHERE action_date='2019-07-05' and action="report"
GROUP BY extra; 


#S2 
select extra as report_reason, COUNT(distinct post_id) as report_count
from actions
where action_date = date_add('2019-07-05', INTERVAL -1 DAY)
and action = 'report'
and extra is not null
group by extra;


#######################################################################################################
#1141. User Activity for the Past 30 Days I 
#Create Table 
Create table If Not Exists Activity (user_id int, session_id int, activity_date date, activity_type ENUM('open_session', 'end_session', 'scroll_down', 'send_message'));
Truncate table Activity;
insert into Activity (user_id, session_id, activity_date, activity_type) values ('1', '1', '2019-07-20', 'open_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('1', '1', '2019-07-20', 'scroll_down');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('1', '1', '2019-07-20', 'end_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('2', '4', '2019-07-20', 'open_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('2', '4', '2019-07-21', 'send_message');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('2', '4', '2019-07-21', 'end_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('3', '2', '2019-07-21', 'open_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('3', '2', '2019-07-21', 'send_message');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('3', '2', '2019-07-21', 'end_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('4', '3', '2019-06-25', 'open_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('4', '3', '2019-06-25', 'end_session');

#S1 
SELECT activity_date as day, COUNT(DISTINCT user_id) as active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date
HAVING count(activity_type)>=1;

#notice that having statement can be deleted since it count function only keeps ones that are larger than 0


#S2 
#Use DATEDIFF function to represent a period of 30 days 
SELECT activity_date AS day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE DATEDIFF("2019-07-27",activity_date)<30
GROUP BY activity_date;


#######################################################################################################
#1142. User Activity for the Past 30 Days II 
#Create Table 
Create table If Not Exists Activity (user_id int, session_id int, activity_date date, activity_type ENUM('open_session', 'end_session', 'scroll_down', 'send_message'));
Truncate table Activity;
insert into Activity (user_id, session_id, activity_date, activity_type) values ('1', '1', '2019-07-20', 'open_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('1', '1', '2019-07-20', 'scroll_down');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('1', '1', '2019-07-20', 'end_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('2', '4', '2019-07-20', 'open_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('2', '4', '2019-07-21', 'send_message');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('2', '4', '2019-07-21', 'end_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('3', '2', '2019-07-21', 'open_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('3', '2', '2019-07-21', 'send_message');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('3', '2', '2019-07-21', 'end_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('4', '3', '2019-06-25', 'open_session');
insert into Activity (user_id, session_id, activity_date, activity_type) values ('4', '3', '2019-06-25', 'end_session');

#S1
SELECT ifnull(round(avg(counts),2),0.00) as average_sessions_per_user
FROM (
    SELECT user_id, count(distinct session_id) as counts
FROM Activity
WHERE datediff('2019-07-27',activity_date)<30
GROUP BY user_id
    ) as t


#######################################################################################################
#1148. Article Views I 
#Create Table 
Create table If Not Exists Views (article_id int, author_id int, viewer_id int, view_date date);
Truncate table Views;
insert into Views (article_id, author_id, viewer_id, view_date) values ('1', '3', '5', '2019-08-01');
insert into Views (article_id, author_id, viewer_id, view_date) values ('1', '3', '6', '2019-08-02');
insert into Views (article_id, author_id, viewer_id, view_date) values ('2', '7', '7', '2019-08-01');
insert into Views (article_id, author_id, viewer_id, view_date) values ('2', '7', '6', '2019-08-02');
insert into Views (article_id, author_id, viewer_id, view_date) values ('4', '7', '1', '2019-07-22');
insert into Views (article_id, author_id, viewer_id, view_date) values ('3', '4', '4', '2019-07-21');
insert into Views (article_id, author_id, viewer_id, view_date) values ('3', '4', '4', '2019-07-21');

#S1 
SELECT distinct author_id as id
FROM Views 
WHERE author_id=viewer_id
order by id



#######################################################################################################
#1173. Immediate Food Delivery I 
#Create Table 
Create table If Not Exists Delivery (delivery_id int, customer_id int, order_date date, customer_pref_delivery_date date);
Truncate table Delivery;
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('1', '1', '2019-08-01', '2019-08-02');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('2', '5', '2019-08-02', '2019-08-02');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('3', '1', '2019-08-11', '2019-08-11');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('4', '3', '2019-08-24', '2019-08-26');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('5', '4', '2019-08-21', '2019-08-22');
insert into Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) values ('6', '2', '2019-08-11', '2019-08-13');

#S1
with imme as 
(SELECT count(*) as immediate FROM Delivery WHERE order_date=customer_pref_delivery_date),
allorder as 
(SELECT count(*) as alls FROM Delivery)
SELECT round(immediate/alls*100,2) as immediate_percentage 
FROM imme,allorder

#S2 
WITH div_table as
(
  SELECT CASE
  WHEN order_date=customer_pref_delivery_date THEN 1
  WHEN order_date<>customer_pref_delivery_date THEN 0
  END AS div_cnt
  FROM Delivery
)
SELECT ROUND((SUM(div_cnt)/COUNT(*))*100,2) AS immediate_percentage
FROM div_table;


#S3 
#There is no need of using "FROM clause"
select round(100*(select distinct count(delivery_id) from Delivery
where order_date = customer_pref_delivery_date
)/(select distinct count(delivery_id) from Delivery
),2) as immediate_percentage;

#S4
select round(sum(order_date=customer_pref_delivery_date)/count(delivery_id)*100,2) as immediate_percentage 
from Delivery;


#######################################################################################################
#1179. Reformat Department Table 
#Create Table 
Create table If Not Exists Department (id int, revenue int, month varchar(5));
Truncate table Department;
insert into Department (id, revenue, month) values ('1', '8000', 'Jan');
insert into Department (id, revenue, month) values ('2', '9000', 'Jan');
insert into Department (id, revenue, month) values ('3', '10000', 'Feb');
insert into Department (id, revenue, month) values ('1', '7000', 'Feb');
insert into Department (id, revenue, month) values ('1', '6000', 'Mar');

#S1 
###################### Useful method of turning long format to wide format
SELECT id, 
  max(case when month='Jan' then revenue else null end) as Jan_Revenue,
  max(case when month='Feb' then revenue else null end) as Feb_Revenue,
  max(case when month='Mar' then revenue else null end) as Mar_Revenue, 
  max(case when month='Apr' then revenue else null end) as Apr_Revenue,
  max(case when month='May' then revenue else null end) as May_Revenue, 
  max(case when month='Jun' then revenue else null end) as Jun_Revenue, 
  max(case when month='Jul' then revenue else null end) as Jul_Revenue, 
  max(case when month='Aug' then revenue else null end) as Aug_Revenue, 
  max(case when month='Sep' then revenue else null end) as Sep_Revenue, 
  max(case when month='Oct' then revenue else null end) as Oct_Revenue, 
  max(case when month='Nov' then revenue else null end) as Nov_Revenue, 
  max(case when month='Dec' then revenue else null end) as Dec_Revenue
FROM Department
GROUP BY id;



#######################################################################################################
#1211. Queries Quality and Percentage 
#Create Table 
Create table If Not Exists Queries (query_name varchar(30), result varchar(50), position int, rating int);
Truncate table Queries;
insert into Queries (query_name, result, position, rating) values ('Dog', 'Golden Retriever', '1', '5');
insert into Queries (query_name, result, position, rating) values ('Dog', 'German Shepherd', '2', '5');
insert into Queries (query_name, result, position, rating) values ('Dog', 'Mule', '200', '1');
insert into Queries (query_name, result, position, rating) values ('Cat', 'Shirazi', '5', '2');
insert into Queries (query_name, result, position, rating) values ('Cat', 'Siamese', '3', '3');
insert into Queries (query_name, result, position, rating) values ('Cat', 'Sphynx', '7', '4');

#S1
WITH Queries2 AS (SELECT query_name, position, rating,
    CASE WHEN rating<3 THEN 1
    ELSE 0 END AS bull 
FROM Queries)

SELECT DISTINCT query_name, 
        ROUND(AVG(rating/position) OVER(PARTITION BY query_name),2) AS quality,
        ROUND((SUM(bull) OVER(PARTITION BY query_name))/(COUNT(*) OVER(PARTITION BY query_name)), 4)*100 
           AS poor_query_percentage
FROM Queries2

#S2
SELECT query_name, 
  ROUND(IFNULL(SUM(rating/position)/COUNT(*),0),2) as quality,
  ROUND(AVG(IF(rating<3,1,0))*100,2) as poor_query_percentage
FROM Queries
GROUP BY query_name;

