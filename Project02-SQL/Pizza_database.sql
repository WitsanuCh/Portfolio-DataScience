--Create Table
--Table 1 customer_info
create table customer_info (
  customer_id integer primary key,
  customer_name text,
  customer_gender text,
  customer_age integer,
  customer_email text,
  customer_phone text,
  customer_postcode text
);

--Insert Table
--Table 1 customer_info
insert into customer_info values
(1, 'Ngor' , 'M', '27', 'ngor@gmail.com', '0812345678', '11120'),
(2, 'May', 'F', '27', 'may@gmail.com', '0812345679', '11120'),
(3, 'Pakbung', 'F', '23', 'pakbung@gmail.com', '0812345670', '13240'),
(4, 'Pook', 'F', '35', 'pook@gmail.com', '0812345671', '12210'),
(5, 'Aun', 'M', '38', 'aun@gmail.com', '0812345672', '13220'),
(6, 'Stang', 'F', '33', 'stang@gmai.com', '0812345673', '11350'),
(7, 'Ize', 'F', '31', 'ize@gmail.com', '0812345674', '11220'),
(8, 'tri', 'M', '19', 'tri@gmail.com', '0812345675', '11120');

--Create Table
--Table 2 customer_order
create table customer_order (
  order_id integer primary key,
  customer_id integer,
  order_date text,
  pizza_id text,
  size_id text
);

--Insert Table
--Table 2 customer_order
  insert into customer_order values
  (1, 5, '2023-01-01', 8, 4),
  (2, 7, '2023-01-01', 2, 2),
  (3, 1, '2023-01-08', 8, 3),
  (4, 2, '2023-01-08', 4, 1),
  (5, 4, '2023-01-14', 1, 2),
  (6, 8, '2023-01-15', 2, 3),
  (7, 3, '2023-01-17', 7, 1),
  (8, 6, '2023-01-17', 8, 2),
  (9, 5, '2023-01-20', 3, 3),
  (10, 7, '2023-01-22', 2, 1),
  (11, 1, '2023-01-23', 3, 2),
  (12, 5, '2023-01-30', 7, 3),
  (13, 2, '2023-02-07', 3, 1),
  (14, 4, '2023-02-07', 3, 2),
  (15, 8, '2023-02-08', 8, 3),
  (16, 5, '2023-02-11', 6, 4),
  (17, 7, '2023-02-12', 6, 1),
  (18, 1, '2023-02-14', 3, 2),
  (19, 2, '2023-02-14', 3, 1),
  (20, 5, '2023-02-17', 5, 3),
  (21, 8, '2023-02-25', 8, 2),
  (22, 3, '2023-03-01', 1, 3),
  (23, 6, '2023-03-03', 8, 1),
  (24, 5, '2023-03-05', 5, 3),
  (25, 7, '2023-03-06', 6, 1),
  (26, 1, '2023-03-10', 3, 2),
  (27, 2, '2023-03-10', 1, 1),
  (28, 5, '2023-03-13', 7, 4),
  (29, 8, '2023-03-15', 2, 2),
  (30, 3, '2023-03-16', 7, 3),
  (31, 6, '2023-03-18', 2, 1),
  (32, 5, '2023-03-21', 6, 3),
  (33, 7, '2023-03-22', 3, 1),
  (34, 1, '2023-03-24', 8, 2),
  (35, 2, '2023-03-24', 4, 1),
  (36, 5, '2023-03-27', 7, 3),
  (37, 8, '2023-03-29', 3, 2);

--Create Table
--Table 3 pizza
create table pizza (
  pizza_id integer primary key,
  pizza_name text
);

--Insert Table
--Table 3 pizza
insert into pizza values
(1, 'Margherita Pizza'),
(2, 'Pepperoni Pizza'),
(3, 'Hawaiian Pizza'),
(4, 'Vegetarian Pizza'),
(5, 'Meat Lovers Pizza'),
(6, 'BBQ Chicken Pizza'),
(7, 'Supreme Pizza'),
(8, 'Seafood Pizza');

--Create Table
--Table 4 pizza_size
create table pizza_size (
  size_id integer primary key,
  size_name text,
  price_size real
);

--Insert Table
--Table 4 pizza_size
insert into pizza_size values 
(1, 'Small', 30),
(2, 'Medium', 50),
(3, 'Large', 70),
(4, 'Extra', 100);

.mode box
select * from customer_info;
select * from customer_order;
select * from pizza;
select * from pizza_size;

--Query 
--What is the most popular pizza ?(join 2 table + aggregate functions)
select 
  pizza_name,
  count(*) as count_pizza
from pizza as piz
join customer_order as cus_or
on piz.pizza_id = cus_or.pizza_id
group by pizza_name
order by count_pizza desc; 

--top 3 spender (join 3 table + aggregate functions)
select
  customer_name,
  sum(price_size) as total
from customer_info as cus_in
join customer_order as cus_or on cus_in.customer_id = cus_or.customer_id
join pizza_size as piz_si on cus_or.size_id = piz_si.size_id
group by customer_name
order by total desc limit 3;


--The total revenue of each month (subquery/with)
with sub as (
        select 
              order_date,
              price_size,
            case
              when strftime('%m', order_date) = '01' then 'January'
              when strftime('%m', order_date) = '02' then 'February'
              when strftime('%m', order_date) = '03' then 'March'
            end as month  
    from customer_order as cus_or
    join pizza_size as piz_si on cus_or.size_id = piz_si.size_id
    group by 1,2,3, strftime( '%m', order_date)
  )

select 
  month,
  sum(price_size) as total_revenue
  
from sub
group by strftime("%m", order_date);
