const sql = {};


//NOTE TO END QUERY WITH , UNLESS IT'S THE LAST QUERY
sql.query = {
	add_user: 'INSERT INTO users (userid, username, userpassword, fullname, phoneno) VALUES ($1,$2,$3,$4, $5)',
	userpass: 'SELECT * FROM users WHERE username = $1',
	update_password: 'UPDATE users SET userpassword=$2 WHERE username=$1',
	update_phoneno: 'UPDATE users SET phoneno = $2 WHERE username=$1',
	add_member: 'INSERT INTO members (userid) VALUES ($1)',
	add_guest: 'INSERT INTO guests (userid) VALUES ($1)',
	insert_into_reservation: 'INSERT INTO Reservations (rsvid, userid, outid, rsvDate, rsvHour, seatsAssigned) VALUES ($1, $2, $3, $4, $5, $6)',
	search_id: 'SELECT userid FROM users WHERE username = $1',
	hours: 'SELECT rid, openingTime, closingTime FROM outlets WHERE outid = $1',
	select_info: 'SELECT * FROM OutletInfo o WHERE o.outid = $1;',
	getHistory: 'SELECT r.outid,r.userid,r.rsvdate, r.rsvhour, r.seatsAssigned, o.rname, o.area FROM Reservations r INNER JOIN outletInfo o ON r.outid = o.outid WHERE userid = $1',
	
	//Gerald
	add_restaurant: 'INSERT INTO Restaurants(rid, rname)VALUES($1,$2)',
	add_outlet: 'INSERT INTO Outlets(outid, rid, openingTime, closingTime, totalSeats)VALUES($1,$2,$3,$4,$5)',
	add_branches: 'INSERT INTO Branches(rid, outid, postalCode, unitNo, area)VALUES($1,$2,$3,$4,$5)',
	add_food: 'INSERT INTO food (rid, fname, price) VALUES ($1, $2, $3)',
	add_serves:	'INSERT INTO serves(rid, cuisinetype) VALUES ($1, $2)',
	add_serves:	'INSERT INTO serves(rid, cuisinetype) VALUES ($1, $2)',
	add_ratings: 'INSERT INTO ratings(ratingid, rid, ratingscore, review) VALUES ($1, $2, $3, $4)',
	
	//HZ
	
	search_Restaurants : 'select distinct rname from Restaurants',
	search_Restaurants_area : 'select distinct area from restaurants r left join branches b on r.rid=b.rid',
	search_data : 'select * from OutletInfo;',
	search_filter_all:'select * from OutletInfo where area = $1 and rname = $2;',
	search_filter_only_area:'select * from OutletInfo where area = $1;',
	search_filter_only_name:'select * from OutletInfo where rname = $1;',
	
	//ZACK
	// Restaurants & Outlets queries
	display_res_and_avgRating: 'select R.rid as rid, R.rname as rname, case when count(*) > 1 then sum(ratingscore)/(count(*)-1) else 0 end as averageScore from Restaurants R natural join Ratings RT group by R.rid, R.rname;',
	display_res_reviews: 'select R.rname, RT.review from Restaurants R natural join Ratings RT where R.rname = $1;',
	display_res_and_avgprice: 'select rname, avg(price) as averagePrice from Restaurants natural join Food group by rname1;',
	display_res_and_maxprice: 'select rname, max(price) as maxPrice from Restaurants natural join Food group by rname;',
	
	// User points queries
	display_all_user_points: 'select userid, sum(pointNumber) from points group by userid',
	display_user_total_points: 'select userid, sum(pointNumber) from points where userid = $1',
	
}

module.exports = sql