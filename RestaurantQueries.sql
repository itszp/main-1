-- All restaurants in Central area
select rname
from Restaurants natural join Branches
where area = 'Central';

-- Display restaurant and their average ratings
select R.rname, avg(ratingscore) as averageScore
from Restaurants R natural join Ratings RT
group by R.rname

-- Display restaurant:HaiDiLao's reviews
select R.rname, RT.review
from Restaurants R natural join Ratings RT
where R.rname = 'HaiDiLao';

-- Filter by cuisineTypes
select rname 
from Restaurants natural join Serves
where cuisineType = 'Chinese';

-- Check seats available of outlet on openingDate
select rname, seatsAvailable, openingHour
from Restaurants natural join Outlets left join Seats on Seats.outid = Outlets.outid
where rname = 'HaiDiLao' and openingDate = '24-03-2019';

-- Show average price of restaurants
select rname, avg(price) as averagePrice
from Restaurants natural join Food
group by rname

-- Show max price of restaurants
select rname, max(price) as maxPrice
from Restaurants natural join Food
group by rname

-- get number of seats assigned at particular outlet, date and time
SELECT sum(seatsAssigned)
    FROM Reservations
    WHERE Reservations.outid = '1'
    and Reservations.rsvDate = '24-03-2019'
    and Reservations.rsvHour = '20:00';
    
-- totalSeats available at particular outlet, date and time  
SELECT seatsAvailable
    FROM Seats 
    WHERE Seats.outid = '1' 
    AND Seats.openingDate = '24-03-2019'
    AND Seats.openingHour = '20:00';