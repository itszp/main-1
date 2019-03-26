const sql = {};


//NOTE TO END QUERY WITH , UNLESS IT'S THE LAST QUERY
sql.query = {
	add_user: 'INSERT INTO users (userid, username, userpassword, fullname, phoneno) VALUES ($1,$2,$3,$4, $5)',
	userpass: 'SELECT * FROM users WHERE username = $1',

	// Restaurants & Outlets queries
	display_res_and_avgRating: 'select R.rname, avg(ratingscore) as averageScore from Restaurants R natural join Ratings RT group by R.rname',
	display_res_reviews: 'select R.rname, RT.review from Restaurants R natural join Ratings RT where R.rname = $1',
	display_res_and_avgprice: 'select rname, avg(price) as averagePrice from Restaurants natural join Food group by rname1',
	display_res_and_maxprice: 'select rname, max(price) as maxPrice from Restaurants natural join Food group by rname',
	
	filter_res_cuisines: 'select rname from Restaurants natural join Serves where cuisineType = $1',
	filter_outlet_area: 'select outid from Outlets natural join Branches where area = $1',
	filter_outlet_date: 'select outid from Outlets natural join Seats where openingDate = $1',

	// Reservations queries
	make_rsv: 'INSERT INTO Reservations (rsvid, userid, outid, rsvdate, rsvHour, numOfPeople) VALUES ($1,$2,$3,$4,$5,$6)',

	// User points queries
	display_all_user_points: 'select userid, sum(pointNumber) from points group by userid',
	display_user_total_points: 'select userid, sum(pointNumber) from points where userid = $1',
	
	
	// User preferences queries
	display_user_preferences: 'select * from preferences where userid = $1'


	
}

module.exports = sql