-- All restaurants in Central area
select rname
from Restaurants natural join Outlets
where area = 'Central';
