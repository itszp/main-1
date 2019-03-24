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
