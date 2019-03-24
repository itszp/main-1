-- All restaurants in Central area
select rname
from Restaurants natural join Outlets
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
from Restaurants
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