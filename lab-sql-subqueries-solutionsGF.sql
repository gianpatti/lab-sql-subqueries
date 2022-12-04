
-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?

select count(*) from inventory
where film_id in (
select film_id from film 
where title in ('Hunchback Impossible') );

-- 2. List all films whose length is longer than the average of all the films.

select title, length from film
where length> (select avg(length) from film);


-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.

select first_name, last_name from actor
where actor_id in (
	select actor_id from film_actor
	where film_id in (
		select film_id from film
		where title in ('Alone Trip')));

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select title from film
where film_id in (
	select film_id from film_category
    where category_id in (
		select category_id from category
        where name in ('Family') ) );

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

select first_name, email from customer
where address_id in (
	select address_id from address
    where city_id in (
		select city_id from city
        where country_id in (
			select country_id from country
            where country in ('Canada') ) ) );
            
select first_name, email from customer
join address using(address_id)
join city using(city_id)
join country using(country_id)
where country in ('Canada');

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

select title from film
where film_id in (
	select film_id from film_actor
    where actor_id in (
		select actor_id from (select actor_id, count(film_id) as film_count from film_actor	group by actor_id ) a1
		where a1.film_count in (
			select max(a2.film_count) from (select count(film_id) as film_count from film_actor	group by actor_id ) a2
        )
    )
);

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select title from film
where film_id in (
	select film_id from inventory
    where inventory_id in (
		select inventory_id from rental
        where customer_id in (
			select customer_id 
			from (select customer_id, sum(amount) as total_payment from payment	group by customer_id ) a1
			where a1.total_payment in (
				select max(a2.total_payment) from (select sum(amount) as total_payment from payment	group by customer_id ) a2
			)
		)
	)
);

-- 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.

select customer_id, a1.total_payment from (select customer_id, sum(amount) as total_payment from payment group by customer_id ) a1
where a1.total_payment > (select avg(a2.total_amount) from (select sum(amount) total_amount from payment group by customer_id) a2)
order by a1.total_payment desc;
