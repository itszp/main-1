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


-- totalPoints of member    
select userid, sum(pointNumber) from points group by userid

-- display outlet info
with RestaurantMaxPrice as (
    select R.rid, R.rname, coalesce(max(price), 0) as maxPrice
    from Restaurants R full outer join Food on R.rid = Food.rid 
    group by R.rid
)
select R.rname, O.outid, B.area, O.totalseats, O.openingtime, O.closingtime, maxPrice
from Outlets O natural join Restaurants R natural join Branches B join RestaurantMaxPrice RMax on R.rid = Rmax.rid

-- create view of outlet info
CREATE VIEW OutletInfo (rname, outid, area, totalSeats, openingTime, closingTime, maxPrice) as 
    with RestaurantMaxMenu as (
        select R.rid, R.rname, max(price) as maxPrice
        from Restaurants R natural join Food
        group by R.rid
    )

    select R.rname, O.outid, B.area, O.totalseats, O.openingtime, O.closingtime, maxPrice
    from Outlets O natural join Restaurants R natural join Branches B join RestaurantMaxMenu RMax on R.rid = Rmax.rid;

-- use view of outlet info 
-- example of using view to filter area and rname
select * from OutletInfo 
where area = $1 or rname = $2;

select distinct r.rname,b.area,o.totalseats,o.openingtime,o.closingtime, max(price) as price, s.cuisinetype 
from outlets o  inner join restaurants r on r.rid=o.rid inner join food f on f.rid=r.rid inner join branches b on r.rid=b.rid inner join serves s on s.rid=r.rid inner join cuisines c on c.cuisinetype=s.cuisinetype 
where cuisinetype = $1 or b.area = $2 or r.rname=$3 group by  r.rname,b.area,o.totalseats,o.openingtime,o.closingtime, s.cuisinetype order by r.rname;



select * from OutletInfo where rname = 'MosBurger'
search_filterall_except_area:'select distinct r.rname,b.area,o.totalseats,o.openingtime,o.closingtime, max(price) as price, s.cuisinetype from outlets o  inner join restaurants r on r.rid=o.rid inner join food f on f.rid=r.rid inner join branches b on r.rid=b.rid inner join serves s on s.rid=r.rid inner join cuisines c on c.cuisinetype=s.cuisinetype where cuisinetype = $1 or r.rname=$2 group by  r.rname,b.area,o.totalseats,o.openingtime,o.closingtime, s.cuisinetype order by r.rname;',
	search_filterall_except_name:'select distinct r.rname,b.area,o.totalseats,o.openingtime,o.closingtime, max(price) as price, s.cuisinetype from outlets o  inner join restaurants r on r.rid=o.rid inner join food f on f.rid=r.rid inner join branches b on r.rid=b.rid inner join serves s on s.rid=r.rid inner join cuisines c on c.cuisinetype=s.cuisinetype where cuisinetype = $1 or b.area = $2 group by  r.rname,b.area,o.totalseats,o.openingtime,o.closingtime, s.cuisinetype order by r.rname;',
	search_filterall_except_cuisine:'select distinct r.rname,b.area,o.totalseats,o.openingtime,o.closingtime, max(price) as price, s.cuisinetype from outlets o  inner join restaurants r on r.rid=o.rid inner join food f on f.rid=r.rid inner join branches b on r.rid=b.rid inner join serves s on s.rid=r.rid inner join cuisines c on c.cuisinetype=s.cuisinetype where  b.area = $1 or r.rname=$2 group by  r.rname,b.area,o.totalseats,o.openingtime,o.closingtime, s.cuisinetype order by r.rname;',
	search_filter_only_area:'select distinct r.rname,b.area,o.totalseats,o.openingtime,o.closingtime, max(price) as price, s.cuisinetype from outlets o  inner join restaurants r on r.rid=o.rid inner join food f on f.rid=r.rid inner join branches b on r.rid=b.rid inner join serves s on s.rid=r.rid inner join cuisines c on c.cuisinetype=s.cuisinetype where b.area = $1 group by  r.rname,b.area,o.totalseats,o.openingtime,o.closingtime, s.cuisinetype order by r.rname;',
	search_filter_only_name:'select distinct r.rname,b.area,o.totalseats,o.openingtime,o.closingtime, max(price) as price, s.cuisinetype from outlets o  inner join restaurants r on r.rid=o.rid inner join food f on f.rid=r.rid inner join branches b on r.rid=b.rid inner join serves s on s.rid=r.rid inner join cuisines c on c.cuisinetype=s.cuisinetype where r.rname=$1 group by  r.rname,b.area,o.totalseats,o.openingtime,o.closingtime, s.cuisinetype order by r.rname;',
	search_filter_only_cuisine:'select distinct r.rname,b.area,o.totalseats,o.openingtime,o.closingtime, max(price) as price, s.cuisinetype from outlets o  inner join restaurants r on r.rid=o.rid inner join food f on f.rid=r.rid inner join branches b on r.rid=b.rid inner join serves s on s.rid=r.rid inner join cuisines c on c.cuisinetype=s.cuisinetype where s.cuisinetype = $1 group by  r.rname,b.area,o.totalseats,o.openingtime,o.closingtime, s.cuisinetype order by r.rname;',
	search_user_preferences:'select distinct r.rname,b.area,o.totalseats,o.openingtime,o.closingtime, max(price) as price, s.cuisinetype from Preferences p inner join users u on u.userid=p.userid and u.username =$1 inner join branches b on b.area=p.area inner join outlets o on o.rid=b.rid inner join restaurants r on r.rid=b.rid inner join serves s on s.rid=r.rid inner join food f on f.rid=r.rid group by  r.rname,b.area,o.totalseats,o.openingtime,o.closingtime,p.maxprice, s.cuisinetype having max(price)<= p.maxprice',
	
   