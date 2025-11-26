select * from customer limit 10;
--1.total revenue geenrated by male vs female customers?
select gender,sum(purchase_amount) as revenue from customer
group by gender order by revenue desc;

--2.which customer used a discount but still spend more than the average purchase amount?
select customer_id,purchase_amount from customer
where discount_applied='Yes' and purchase_amount >= (select avg(purchase_amount) from customer)
--3.which are the top 5 products with the highest average review rating
select item_purchased,ROUND(avg(review_rating::NUMERIC),2) as rating from customer group by item_purchased order by rating desc limit 5;

--4Compare the avergae purchase amounts b/w stamdard and express shipping.
select shipping_type, ROUND(avg(purchase_amount::NUMERIC),2) from customer where shipping_type in ('Express', 'Free Shipping') group by shipping_type;

--3which are the top 5 products with the highest average review rating?
select item_purchased, AVG(review_rating) as rating from customer group by item_purchased order by avg(review_rating) desc limit 5;

--5.Do subscrbed customers spend more?compare average spend and total revenue b/w subscribers and non-subscribers?

select subscription_status ,COUNT(customer_id) ,AVG(purchase_amount) as average_spend,SUM(purchase_amount) as revenue from customer group by subscription_status order by revenue desc; 

--6.which 5 products have the highest percentage of purchases with discounts applied?

select item_purchased ,round(100*SUM(CASE WHEN discount_applied ='Yes' Then 1 else 0 end)/Count(*),2) as discount_rate from customer group by item_purchased order by discount_rate desc limit 5;


--7.Segment customers into new,returning and loyal based on their total number of previous purchases,and show the count of each segment.
with customer_type as ( select customer_id,previous_purchases,
CASE 
    WHEN previous_purchases = 1 then 'New '
	WHEN previous_purchases between 2 and 10 then 'Returning'
	else
	'loyal'
	end as customer_segment from customer)


select customer_segment , count(*) as "number of customers" from customer_type group by customer_segment

--8.what are the three top most purchased products within each category?

with item_counts as (select category,
item_purchased,
count(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id)Desc) as item_rank 
FROM customer group by category,item_purchased)

select item_rank,category,item_purchased,total_orders from item_counts
where item_rank<=3;

--9 are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
select subscription_status,
count(customer_id) as repeat_buyers
from customer where previous_purchases>5 group by subscription_status  

--10.what is the revenue contribution of eaxh age group 
select age_group,SUM(purchase_amount) as revenue from customer group by age_group order by revenue desc;