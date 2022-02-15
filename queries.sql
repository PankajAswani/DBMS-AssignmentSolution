# 1. Creating databse and tables

CREATE DATABASE travel_on_the_go;

USE travel_on_the_go;

CREATE TABLE passenger (
    passenger_name VARCHAR(100),
    category VARCHAR(10),
    gender CHAR(1),
    boarding_city VARCHAR(100),
    destination_city VARCHAR(100),
    distance INT,
    bus_type VARCHAR(25)
);

CREATE TABLE price (
    bus_type VARCHAR(25),
    distance INT,
    price INT
);

# 2. Inserting values

INSERT INTO passenger VALUES
	('Sejal', 'AC', 'F', 'Bengaluru', 'Chennai', 350, 'Sleeper'),
    ('Anmol', 'Non-AC', 'M', 'Mumbai', 'Hyderabad', 700, 'Sitting'),
    ('Pallavi', 'AC', 'F', 'Panaji', 'Bengaluru', 600, 'Sleeper'),
    ('Khusboo', 'AC', 'F', 'Chennai', 'Mumbai', 1500, 'Sleeper'),
    ('Udit', 'Non-AC', 'M', 'Trivandrum', 'Panaji', 1000, 'Sleeper'),
    ('Ankur', 'AC', 'M', 'Nagpur', 'Hyderabad', 500, 'Sitting'),
    ('Hemant', 'Non-AC', 'M', 'Panaji', 'Mumbai', 700, 'Sleeper'),
    ('Manish', 'Non-AC', 'M', 'Hyderabad', 'Bengaluru', 500, 'Sitting'),
    ('Piyush', 'AC', 'M', 'Pune', 'Nagpur', 700, 'Sitting');

INSERT INTO price VALUES
	('Sleeper', 350, 770),
    ('Sleeper', 500, 1100),
    ('Sleeper', 600, 1320),
    ('Sleeper', 700, 1540),
    ('Sleeper', 1000, 2200),
    ('Sleeper', 1200, 2640),
    ('Sleeper', 1500, 2700),
    ('Sitting', 500, 620),
    ('Sitting', 600, 744),
    ('Sitting', 700, 868),
    ('Sitting', 1000, 1240),
    ('Sitting', 1200, 1488),
    ('Sitting', 1500, 1860);

# 3. How many females and how many male passengers travelled for a minimum distance of 600 KMs

SELECT 
    passenger.gender, COUNT(passenger.gender) count
FROM
    passenger
WHERE
    passenger.distance >= 600
GROUP BY passenger.gender;

/*
	OUTPUT
    gender count
    M		4
	F		2
*/

# 4. Find the minimum ticket price for Sleeper Bus

SELECT 
    MIN(price.price) minimum_sleeper_price
FROM
    price
WHERE
    price.bus_type = 'Sleeper';

/*
	OUTPUT
    minimum_sleeper_price
    770
*/

# 5. Select passenger names whose names start with character 'S'

SELECT 
    passenger.passenger_name
FROM
    passenger
WHERE
    passenger_name LIKE 'S%';

/*
	OUTPUT
    passenger_name
    Sejal
*/

# 6. Calculate price charged for each passenger displaying Passenger name, Boarding City, Destination City, Bus_Type, Price in the output

SELECT 
    passenger.passenger_name,
    passenger.boarding_city,
    passenger.destination_city,
    passenger.bus_type,
    price.price
FROM
    passenger,
    price
WHERE
    passenger.bus_type = price.bus_type
        AND passenger.distance = price.distance;

/*
	OUTPUT
    passenger_name boarding_city destination_city bus_type	price
    Sejal			Bengaluru		Chennai			Sleeper	770
	Pallavi			Panaji			Bengaluru		Sleeper	1320
	Hemant			Panaji			Mumbai			Sleeper	1540
	Udit			Trivandrum		Panaji			Sleeper	2200
	Khusboo			Chennai			Mumbai			Sleeper	2700
	Manish			Hyderabad		Bengaluru		Sitting	620
	Ankur			Nagpur			Hyderabad		Sitting	620
	Piyush			Pune			Nagpur			Sitting	868
	Anmol			Mumbai			Hyderabad		Sitting	868
*/

# 7. What are the passenger name/s and his/her ticket price who travelled in the Sitting bus for a distance of 1000 KMs

SELECT 
    passenger.passenger_name, price.price
FROM
    passenger,
    price
WHERE
    passenger.bus_type = price.bus_type
        AND passenger.distance = price.distance
        AND passenger.bus_type = 'Sitting'
        AND passenger.distance = '1000';

/*
	OUTPUT
    passenger_name price
    
    [No records fetched as there is no passenger who travelled in the Sitting bus for a distance of 1000 KMs]
*/

# 8. What will be the Sitting and Sleeper bus charge for Pallavi to travel from Bangalore to Panaji

SELECT 
    price.bus_type, price.price
FROM
    price
WHERE
    price.distance = (SELECT 
            passenger.distance
        FROM
            passenger
        WHERE
            passenger.passenger_name = 'Pallavi');

/*
	OUTPUT
    bus_type price
    Sleeper  1320
	Sitting  744
*/

# 9. List the distances from the "Passenger" table which are unique (non-repeated distances) in descending order

SELECT DISTINCT
    passenger.distance
FROM
    passenger
ORDER BY passenger.distance DESC;

/*
	OUTPUT
    distance
    1500
	1000
	700
	600
	500
	350
*/

# 10. Display the passenger name and percentage of distance travelled by that passenger from the total distance travelled by all passengers without using user variables

SELECT 
    passenger.passenger_name,
    (passenger.distance / passenger_distance_sum.total_distance) * 100 distance_percentage
FROM
    passenger,
    (SELECT 
        SUM(passenger.distance) total_distance
    FROM
        passenger) passenger_distance_sum;

/*
	OUTPUT
    passenger_name distance_percentage
    Sejal			5.3435
	Anmol			10.6870
	Pallavi			9.1603
	Khusboo			22.9008
	Udit			15.2672
	Ankur			7.6336
	Hemant			10.6870
	Manish			7.6336
	Piyush			10.6870
*/

# 11. Display the distance, price in three categories in table Price - a) Expensive if the cost is more than 1000, b) Average Cost if the cost is less than 1000 and greater than 500, c) Cheap otherwise

SELECT 
    price.distance,
    price.price,
    CASE
        WHEN price.price >= 1000 THEN 'Expensive' # considering price equal or greater than 1000 as expensive, as for price 1000 it is not clear in the question
        WHEN price.price > 500 THEN 'Average Cost'
        ELSE 'Cheap'
    END price_category
FROM
    price;

/*
	OUTPUT
    distance	price	price_category
    350			770		Average Cost
    500			1100	Expensive
	600			1320	Expensive
	700			1540	Expensive
	1000		2200	Expensive
	1200		2640	Expensive
	1500		2700	Expensive
	500			620		Average Cost
	600			744		Average Cost
	700			868		Average Cost
	1000		1240	Expensive
	1200		1488	Expensive
	1500		1860	Expensive
*/