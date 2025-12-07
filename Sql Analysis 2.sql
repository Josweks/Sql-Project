-- 1) Table Sample

select * from products;

-- 2) Row Count

SELECT count(*) as row_count FROM Findout.products;

-- 3) Checking for duplicate values.

select ID,count(*) as duplicate_value_count
from products
group by id;

-- 4) Distinct counts for columns

select distinct * from products;

-- 5) Getting familiar with date type

select * from INFORMATON_SCHEMA.Columns
where TABLE_NAME LIKE 'findout.PRODUCTS';

-- 6) Inspecting data for NA values

select count(*) as Null_Count from products
where id like '%null%';

-- 7) Analyze transaction status and currency used

select Transaction,Currency,count(Transaction) as Trans_count from sale
where Transaction = 'completed' and Currency = 'USD'
group by Transaction;

-- 8) Join two tables,make a report about the sale on a certain dates and what channel was used.

select p.product_name,p.category,s.sale_date,s.channel
from products P join sale S
on P.id = S.id
where sale_date between '2025-07-21 10:20:00' 
and '2025-10-10 09:15:00' 
and channel = 'online' 
or channel = 'in_store'
group by p.product_name,p.category,s.sale_date,s.channel;

-- 9) Nummeric summary for unit_price column.

select customer_id,
avg(unit_price) as avg_unit_price,
max(quantity) as max_quantity_sold,
sum(total_price) as sum_total_price
from sale
group by customer_id
order by max_quantity_sold;


-- 10) Join tables,report the maximum quantity sold >= 200 and the region.

select p.product_name,p.category,
s.customer_id, max(quantity) as max_quantity_sold,
s.region,s.notes
from products p join sale s
on p.id = s.id
group by p.product_name,p.category,
s.customer_id,
s.region,s.notes 
having max(quantity)>= 200;

-- 11) Report the number of electronics in the category columns.

select count(category) as Number_of_Electronics
from products
where category ='electronics'
group by category;

-- 12) Select from the table where discount was <= 5 and what currency was used.

select *
from products
where id in (
select id from sale  
where currency = 'EUR' and discount <=5);

select *
from sale
where Total_Price <= (select max(total_price) 
from sale 
HAVING channel = 'wholesale')
order by Total_Price desc ;


-- 13) Extracting data on sales for a particular period of time.

select * from products
where ID in (
select ID from sale 
where sale_date 
between '2025-10-10 09:15:00' 
and '2025-10-11 14:30:00');

-- 14) Under product_name sort out articles that cost > 80 and stock > 70 or
-----  unit__price > 100 and cost > 50.

select *,
case
	when product_name = 'Nimbus Smartwatch' then
		 case when cost > 80 and stock > 70 then 'Expensive'
         else 'Afordable'
         end
	when product_name = 'Aurora Wireless Headphones' then     
         case when unit_price > 100 and cost > 50 then 'Very expensive'
         else 'Best Price'
         end
end as Expensive_Articles
from products
where product_name = 'Aurora Wireless Headphones' or product_name = 'Nimbus Smartwatch';

-- 15) Create a procedure use category column select unit_price > 100 and stock > 100.

delimiter $$
CREATE PROCEDURE summary3(
)
begin
    select * from products
    where category = 'electronics' and unit_price > 100 and stock < 100;
end $$
delimiter ;

call summary3()

-- 16) Combine two tables create a procedure sort out all completed transaction.

delimiter $$
create procedure summary4(
)
begin
    select
    a.category,
    b.sale_date,
    b.transaction
    from products a join sale b
    on a.id = b.id
    where transaction = 'completed';
end $$
delimiter ;

call summary4();

-- 17) Use Common Table Expression (CTE) to query the date.

with cust_info as (
select p.product_name,p.category,s.sale_date,p.cost from products p
join sale s
on p.id = s.id
)
select * from cust_info;


with cte as (
select * from products
where category = 'electronics' and cost > 100
)

select * from cte;

-- 18) Rank the number of Electronics in the Category column.

select *,
row_number() over(partition by p.category order by p.id desc) as Quantity_Count
from products p join sale s
on p.id = s.id
where category = 'electronics';








    

         



