# 1. Drop column picture from staff.

alter table sakila.staff
drop column picture;
select * from sakila.staff;

SET GLOBAL sql_mode='';

# 2.  A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
insert into sakila.staff(first_name,last_name)
values ('Tammy', 'Sanders');


select * 
from sakila.customer;

select * 
from sakila.customer
where last_name = 'Sanders';

insert into sakila.staff(first_name,last_name,address_id, store_id, username)
values ('Tammy', 'Sanders', 79, 2, 'Tammy');

select * 
from sakila.customer;


# 3.  Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. 
# You can use current date for the rental_date column in the rental table. 
# Hint: Check the columns in the table rental and see what information you would need to add there. You can query those pieces of information. For eg., you would notice that you need customer_id information as well. 
# To get that you can use the following query:

SELECT customer_id FROM sakila.customer
WHERE first_name = 'CHARLOTTE' AND last_name = 'HUNTER';

SELECT *
FROM sakila.rental;

INSERT INTO sakila.rental(rental_id, first_name,last_name,address_id, store_id, username)
VALUES (, 'Sanders', 79, 2, 'Tammy');

#  Use similar method to get inventory_id, film_id, and staff_id.
SELECT *
FROM sakila.inventory
WHERE film_id = 1 and store_id = 1;

select inventory_id from sakila.inventory
where film_id = 1;

SELECT *
FROM sakila.film
WHERE film.title like '%DINOSAUR';

SELECT *
FROM sakila.staff
WHERE first_name = 'MIKE';

SELECT *
FROM sakila.rental
WHERE inventory_id = 2 OR inventory_id = 1 OR inventory_id = 3 OR inventory_id = 4;

insert into sakila.rental(rental_date, inventory_id, customer_id, staff_id)
values (curdate(),2,130,1);

select * 
from sakila.rental
order by rental_id desc;

# 4. Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date for the users that would be deleted. Follow these steps:

# 4.1 Check if there are any non-active users
select * 
from sakila.customer
WHERE active = 0;

# 4.2 Create a table backup table as suggested

CREATE TABLE customer_backup (
  customer_id smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  store_id int(11) DEFAULT NULL,
  first_name text,
  last_name text,
  email text,
  address_id int(11) UNIQUE NOT NULL,
  create_date int(11) NOT NULL,
  last_update int(11) NOT NULL,
  CONSTRAINT PRIMARY KEY (customer_id)
  );
select * from customer_backup;  
  
alter table customer_backup
add column active tinyint(1) after address_id;
select * from customer_backup;  

ALTER TABLE customer_backup
MODIFY create_date datetime;

ALTER TABLE customer_backup
MODIFY last_update timestamp;

  
# 4.3 Insert the non active users in the table backup table
INSERT INTO customer_backup (customer_id, store_id, first_name, last_name, email, address_id, active, create_date, last_update)
SELECT * 
FROM sakila.customer
WHERE active = 0;
select * from customer_backup;

  
# 4.4 Delete the non active users from the table customer
SET FOREIGN_KEY_CHECKS=0;
DELETE FROM sakila.customer WHERE customer.active = 0;
SET FOREIGN_KEY_CHECKS=1;
SELECT * 
FROM sakila.customer
WHERE active = 0;

#Cannot delete or update a parent row: 
# a foreign key constraint fails (`sakila`.`payment`, CONSTRAINT `fk_payment_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE)
