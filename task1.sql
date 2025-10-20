/* 1_query */
select name, count(film_id) as count_film_category
from category join film_category using (category_id)
group by category_id
order by 2 desc;


/* 2_query */
select first_name, last_name, count(rental_id)
from actor 
join film_actor using (actor_id)
join inventory using (film_id)
join rental using (inventory_id)
group by actor_id
order by 3 desc
limit 10;


/* 3_query */
with category_revenue as (
    select name, sum(amount) as rental_revenue
    from category 
    join film_category using (category_id)
    join inventory using (film_id)
    join rental using (inventory_id)
    join payment using (rental_id)
    group by category_id
)

select name, rental_revenue
from category_revenue
where rental_revenue = (select max(rental_revenue) from category_revenue);


/* 4_query */
select title
from film left join inventory using(film_id)
where inventory_id is null;


/* 5_query */
with child_category_ranked as (
	select 
		first_name, 
		last_name, 
		count(*) as child_films, 
		dense_rank() over (order by count(*) desc) as rank_position
	from category c
		join film_category fc on c.category_id = fc.category_id and name = 'Children'
		join film_actor using (film_id)
		join actor a using (actor_id)
	group by a.actor_id
)

select first_name, last_name, child_films
from child_category_ranked
where rank_position < 4;


/* 6_query */
select 
	city, 
	count(*) filter (where active = 1) as active_clients, 
	count(*) filter (where active = 0) as inactive_clients
from customer
join address using (address_id)
join city c using (city_id)
group by c.city_id
order by 3 desc;


/* 7_query */
(select name, round(sum(extract(epoch from (return_date - rental_date)) / 3600), 2) as time_rent
from category
join film_category using (category_id)
join inventory using (film_id)
join rental using (inventory_id)
join customer using (customer_id)
join address using (address_id)
join city using (city_id)
where return_date is not null and city like 'a%'
group by category_id
order by 2 desc
limit 1)
union all
(select name, round(sum(extract(epoch from (return_date - rental_date)) / 3600), 2) as time_rent
from category
join film_category using (category_id)
join inventory using (film_id)
join rental using (inventory_id)
join customer using (customer_id)
join address using (address_id)
join city using (city_id)
where return_date is not null and city like '%-%'
group by category_id
order by 2 desc
limit 1);