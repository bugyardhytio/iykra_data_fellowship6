-- Count film with description contains "Astronaut"
select count(*) 
from film 
where "description" 
like '%stronaut%'


-- Count film with rating R and replacement cost between 5 and 15
select count(*) 
from film 
where rating = 'R' and replacement_cost between 5 and 15


-- How many payments did each staff member handle? And how much was the total amount processed by each staff member?
select staff.first_name, staff.last_name, count(*), sum(amount) 
from payment 
left join staff on payment.staff_id = staff.staff_id 
group by payment.staff_id, staff.first_name, staff.last_name 


-- Corporate headquarters is auditing the store! They want to know the average replacement cost of movies by rating!
select rating, avg(replacement_cost) 
from film
group by rating


-- We want to send coupons to the 5 customers who have spent the most amount of money. Get the customer name, email and their spent amount!
select concat(customer.first_name, ' ', customer.last_name), customer.email, sum(amount) as spent_amount
from payment 
left join customer on payment.customer_id = customer.customer_id
group by customer.first_name, customer.last_name, customer.email, payment.customer_id
order by sum(amount) desc
limit 5


-- How many copies of each movie in each store, do we have?
select film.title, inventory.store_id, count(*) 
from inventory
left join film on inventory.film_id = film.film_id 
group by inventory.film_id, inventory.store_id, film.title


-- We want to know what customers are eligible for our platinum credit card. 
-- The requirements are that the customer has at least a total of 40 transaction payments. 
-- Get the customer name, email who are eligible for the credit card! 
select concat(customer.first_name, ' ', customer.last_name) as name, customer.email, transaction
from (
	select count(*) as transaction, customer_id 
	from payment
	group by customer_id
	order by transaction desc
	) as foo
left join customer on foo.customer_id = customer.customer_id
where foo.transaction >= 40