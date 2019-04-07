//Global variables
var rid;
var outid;
var Number_Outlets;
var rid_rate;
var rname_rate;

//------------------//

const sql_query = require('../sql');
const passport = require('passport');
const bcrypt = require('bcrypt');
const uuid = require('uuidv4');

const { Pool } = require('pg');
const pool = new Pool ({
	user: 'postgres',
	host: 'localhost',
	database: 'postgres',
	password: 'matthewng1996',
	port: 5432,
});

const round = 10;
const salt = bcrypt.genSaltSync(round);

function initRouter(app) {
	
	//---------GET FUNCTIONS------------//
	app.get('/', index);
	app.get('/signup', passport.antiMiddleware(), signup);
	app.get('/login', login);
	app.get('/for_restaurants', newRestaurants);
	app.get('/profile', passport.authMiddleware(), profile);
	app.get('/reservationHistory', passport.authMiddleware(), reservationHistory);
	app.get('/select', selectRestaurant);
	app.get('/for_restaurants/outlets', newOutlets);
	app.get('/menu', newMenu);
	app.get('/ratings', passport.authMiddleware(), show_all_restaurants);
	app.get('/ratings/rateRestaurant', passport.authMiddleware(), rateRestaurant);
	
			//---------LOGOUT GET-----------------//
	app.get('/logout', passport.authMiddleware(), logout);
	
	//--------------------------------------------------------//
	
	
	//---------POST FUNCTIONS-----------//
	app.post('/register_user', passport.antiMiddleware(), register_user);
	app.post('/update_password', passport.authMiddleware(), update_password);
	app.post('/update_phoneno', passport.authMiddleware(), update_phoneno);
	app.post('/for_restaurants', register_restaurant);
	app.post('/for_restaurants/outlets', register_outlet);
	app.post('/for_restaurants/outlets', register_branches);
	app.post('/for_restaurants/outlets', register_cuisines);
	app.post('/reservationHistory',reservationHistory);
	app.post('/add_menu', register_menu);
	app.post('/filterParameter', filterParameter);
	app.post('/reserveRestaurant', reserveRestaurant);
	app.post('/booked', booked);
	app.post('/ratings', rate_the_restaurant);
	app.post('/ratings/rateRestaurant', update_ratings);
	
			//---------LOGIN POST-------------------//
	app.post('/login', passport.authenticate('local', {
		successRedirect: '/profile',
		failureRedirect: '/' //Or '/login' (SEE HOW)
	}));
	//--------------------------------------------------------------//
}

//-------------------ROUTES----------------------------//
function index(req, res, next) {
	if (req.isAuthenticated()){
		res.render('loggedinindex', { page: 'Home', menuId: 'home' , user: req.session.username, auth: true});
	} else {
		res.render('index', { page: 'Home', menuId: 'home' , auth: false});
	}
}

function newMenu(req, res, next) {
	res.render('menu', {page: 'Menu'});
}

function newRestaurants(req, res, next) {
	res.render('new_restaurants', {page: 'Restaurants'});
}

function newOutlets(req, res, next){
	res.render('new_outlets', {page: 'Outlets'});
}


function rateRestaurant(req, res, next){
	console.log(rname_rate);
	res.render('rateRestaurantLoggedIn', {page: 'Rate', auth: true, title: rname_rate});	
}

function rate_the_restaurant(req, res, next){
	var tmp_str;
	tmp_str = (req.body.selectBtn).split(",");
	rid_rate = tmp_str[0];
	rname_rate = tmp_str[1];
	
	console.log(rid_rate);
	console.log(rname_rate);
	rateRestaurant(req,res,next);
}

function show_all_restaurants(req, res, next){
	pool.query(sql_query.query.display_res_and_avgRating, (err, data) => {
		if(err || !data.rows || data.rows.length == 0){
			console.log(err)
			console.log("could be empty");
			dataR = [];
		}
		else{
			dataR = data.rows;
		}
		res.render('ratingsLoggedIn', { page: 'ratings', auth: true, dataR: dataR});
	});
}

function update_ratings(req, res, next){
	var ratingscore;
	var review;
	var ratingid = uuid();
	var rid = rid_rate;
	
	ratingscore = req.body.selected_rating;
	review = req.body.review;
	console.log(rid);
	console.log(ratingscore);
	console.log(review);
	
	pool.query(sql_query.query.add_ratings,[ratingid, rid, ratingscore, review], (err, data) => {
		if(err) {
			console.error ("Error in updating ratings (Guest)", err);
		}
		else {
			console.log("Added ratings successfully!");
			res.redirect('/');
		}
	});
}

//---------------RESTAURANT REGISTRATION-----------------//
function register_restaurant(req, res, next){
	rid = uuid();
	var ratingid = uuid();
	var rname = req.body.Restaurant_Name;
	Number_Outlets = req.body.Number_Outlets;
	
	pool.query(sql_query.query.add_restaurant, [rid, rname], (err, data) => {
		if(err){
			console.error("Error in registering restaurant");
			res.redirect('/for_restaurants');
		} else {
			console.log("RID BEFORE PASS: " + rid);
			pool.query(sql_query.query.add_ratings, [ratingid, rid, 0, null], (err, data) => {
				if(err){
					console.log("Failed to initialise ratings");
				}
			});
			res.redirect('/menu');
		}		
	});
}

function register_menu(req, res, next) {
	
	var fname = req.body.fname;
	var price = req.body.price;
	
	pool.query(sql_query.query.add_food, [rid, fname, price], (err,data) => {
		if(err){
			console.error("Error in registering restaurant");
			res.redirect('/for_restaurants');
		}
	});
	
	if(req.body.submit_another == "yes"){
		console.log("checkbox checked");
		res.redirect('/menu');
	}
	else{
		console.log("checkbox unchecked");
		res.redirect('/for_restaurants/outlets');
	}
}

function register_outlet(req, res, next){
	
	outid = uuid();
	var	postalCode = req.body.postal_code;
	var unitNo = req.body.unit_number;
	var area = req.body.area;
	var totalSeats = req.body.total_seats;
	var openingTime = req.body.opening_time;
	var closingTime = req.body.closing_time;
	
	pool.query(sql_query.query.add_outlet, [outid, rid, openingTime, closingTime, totalSeats], (err, data) => {
		if(err){
			console.error("Error in adding outlet");
		}
		register_cuisines(req, res, next);
		register_branches(postalCode, unitNo, area, req, res, next);
	});
	
}

function register_branches(postalCode, unitNo, area, req, res, next){
	pool.query(sql_query.query.add_branches, [rid, outid, postalCode, unitNo, area], (err, data) => {
		if(err){
				console.log(err);
				console.error("Error in adding branches");
		}
	});
	if(req.body.submit_another == "yes"){
		console.log("checkbox checked");
		res.redirect('/for_restaurants/outlets');
	}
	else{
		console.log("checkbox unchecked");
		res.redirect('/');
	}
		
}

function register_cuisines(req, res, next){
	//Note this is not add into cuisine table but serves table.
	var cuisine = req.body.cuisinetype;
	console.log('cuisine is ' + cuisine);
	pool.query(sql_query.query.add_serves, [rid, cuisine], (err, data) => {
		if(err){
				console.error("Error in adding cuisinetype");
		}
	});
}

//----------------------------------------------------------------//


function basic(req, res, page, other) {
	var info = {
		page: page,
		user: req.user.username,
		fullname: req.user.fullname,
		phoneno : req.user.phoneno
	};
	if(other) {
		for(var fld in other) {
			info[fld] = other[fld];
		}
	}
	res.render(page, info);
}

function query(req, fld) {
	return req.query[fld] ? req.query[fld] : '';
}

function msg(req, fld, pass, fail) {
	var info = query(req, fld);
	return info ? (info =='pass' ? pass : fail) : '';
}

function reservationHistory (req, res, next) {
	var username = req.session.passport.user;
	
	pool.query(sql_query.query.search_id,[username], (err, data) => {
		if (err) {
			console.error("Cannot find username", err);
			res.redirect('/profile');
		} else {
			var user = data.rows;
			var userid = user[0].userid;
			pool.query(sql_query.query.getHistory, [userid], (err, data) => {
				if (err || !data.rows || data.rows.length == 0) {
					console.log(err);
					console.error("No reservation made");
					dataView = [];
				} else {
					dataView = data.rows;
				}
				res.render('reservationHistory', {page: 'reservationHistory', auth: true, dataView:dataView});
			});
		}	
	});
}
	
function profile(req, res, next) {
	basic(req, res, 'profile', { info_msg: msg(req, 'info', 'Information updated successfully', 'Error in updating information'), pass_msg: msg(req, 'pass', 'Password updated successfully', 'Error in updating password'), auth: true });
}

function update_password(req, res, next) {
	var username = req.user.username;
	console.log(username);
	var password = bcrypt.hashSync(req.body.password, salt);
	pool.query(sql_query.query.update_password, [username, password], (err, data) => {
		if(err) {
			console.error("Error in update pass");
			res.redirect('/profile?pass=fail');
		} else {
			res.redirect('/profile?pass=pass');
		}
	});
}

function update_phoneno(req, res, next) {
	var username = req.user.username;
	console.log(username);
	var phoneno = req.body.phoneno
	pool.query(sql_query.query.update_phoneno, [username, phoneno], (err, data) => {
		if(err) {
			console.error("Error in update phoneno");
			res.redirect('/profile?phone=fail');
		} else {
			res.redirect('/profile?phone=pass');
		}
	});
}
//--------------SEARCH--------------//
function filterParameter(req, res, next){

	var dataRestaurantSelect = req.body.dataRestaurantSelect;
	var dataRestaurantAreaSelect = req.body.dataRestaurantAreaSelect;

	pool.query(sql_query.query.search_Restaurants,  (err, data) => {
		if(err || !data.rows || data.rows.length == 0) {
			dataRestaurant = [];
		} else {
			dataRestaurant = data.rows;
		}
		pool.query(sql_query.query.search_Restaurants_area, (err, data) => {
			if(err || !data.rows || data.rows.length == 0) {
				console.log("EMPTY restaurant query");
				console.log(err);
				dataRestaurantArea = [];
			} else {

				dataRestaurantArea = data.rows;
			}
			if(dataRestaurantSelect !="" && dataRestaurantAreaSelect !=""){
				pool.query(sql_query.query.search_filter_all,[dataRestaurantSelect, dataRestaurantAreaSelect], (err, data) => {
					if(err || !data.rows || data.rows.length == 0) {
						console.log("EMPTY query LINE 1");
						console.log(err);
						dataView = [];
					} else {
						dataView = data.rows;
					}
					if (req.isAuthenticated()){
						res.render('selectRestaurantLoggedIn', { page: 'selectRestaurant', auth: true, dataRestaurant: dataRestaurant,dataRestaurantArea: dataRestaurantArea,dataView: dataView});
					} else {
						res.render('selectRestaurant', { page: 'selectRestaurant', auth: false, dataRestaurant: dataRestaurant,dataRestaurantArea: dataRestaurantArea,dataView: dataView});
					}
				});
			}else if(dataRestaurantSelect =="" && dataRestaurantAreaSelect !=""){
				pool.query(sql_query.query.search_filter_only_area,[dataRestaurantAreaSelect], (err, data) => {
					if(err || !data.rows || data.rows.length == 0) {
						console.log("EMPTY query LINE 2");
						console.log(err);
						dataView = [];
					} else {
						dataView = data.rows;
					}
					if (req.isAuthenticated()){
						res.render('selectRestaurantLoggedIn', { page: 'selectRestaurant', auth: true, dataRestaurant: dataRestaurant,dataRestaurantArea: dataRestaurantArea,dataView: dataView});
					} else {
						res.render('selectRestaurant', { page: 'selectRestaurant', auth: false, dataRestaurant: dataRestaurant,dataRestaurantArea: dataRestaurantArea,dataView: dataView});
					}
				});
			}else if(dataRestaurantSelect !="" && dataRestaurantAreaSelect ==""){
				pool.query(sql_query.query.search_filter_only_name,[dataRestaurantSelect], (err, data) => {
					if(err || !data.rows || data.rows.length == 0) {
						console.log("EMPTY query LINE 3");
						console.log(err);
						dataView = [];
					} else {
						dataView = data.rows;
					}
					if (req.isAuthenticated()){
						res.render('selectRestaurantLoggedIn', { page: 'selectRestaurant', auth: true, dataRestaurant: dataRestaurant,dataRestaurantArea: dataRestaurantArea,dataView: dataView});
					} else {
						res.render('selectRestaurant', { page: 'selectRestaurant', auth: false, dataRestaurant: dataRestaurant,dataRestaurantArea: dataRestaurantArea,dataView: dataView});
					}
				});
			}else{
				pool.query(sql_query.query.search_data, (err, data) => {
					if(err || !data.rows || data.rows.length == 0) {
						console.log("EMPTY query LINE 4");
						console.log(err);
						dataView = [];
					} else {
						dataView = data.rows;
					}
					if (req.isAuthenticated()){
						res.render('selectRestaurantLoggedIn', { page: 'selectRestaurant', auth: true, dataRestaurant: dataRestaurant,dataRestaurantArea: dataRestaurantArea,dataView: dataView});
					} else {
						res.render('selectRestaurant', { page: 'selectRestaurant', auth: false, dataRestaurant: dataRestaurant,dataRestaurantArea: dataRestaurantArea,dataView: dataView});
					}
				});
			}
		});
	});
}

function selectRestaurant(req, res, next) {
	pool.query(sql_query.query.search_Restaurants, (err, data) => {
		if(err || !data.rows || data.rows.length == 0) {
			console.log("EMPTY restaurant query");
			console.log(err);
			dataRestaurant = [];
		} else {
			dataRestaurant = data.rows;
		}
		pool.query(sql_query.query.search_Restaurants_area, (err, data) => {
			if(err || !data.rows || data.rows.length == 0) {
				console.log("NO Restaurant AREA");
				console.log(err);
				dataRestaurantArea = [];
			} else {

				dataRestaurantArea = data.rows;
			}
			pool.query(sql_query.query.search_data, (err, data) => {
				if(err || !data.rows || data.rows.length == 0) {
					console.log("NO DATA")
					console.log(err);
					dataView = [];
				} else {
					dataView = data.rows;
				}
				if (req.isAuthenticated()){
					res.render('selectRestaurantLoggedIn', { page: 'selectRestaurant', auth: true,dataRestaurant: dataRestaurant,dataRestaurantArea: dataRestaurantArea,dataView: dataView});
				} else {
					res.render('selectRestaurant', { page: 'selectRestaurant', auth: false, dataRestaurant: dataRestaurant,dataRestaurantArea: dataRestaurantArea,dataView: dataView});
				}
			});
		});
	});

}

//--------------RESERVE RESTAURANTS FUNCTION(S)-------------//
function reserveRestaurant (req, res, next) {
	
	outid = req.body.selectBtn;
	
	pool.query(sql_query.query.select_info,[outid], (err, data) => {
		if(err){
			console.error('Unable to get opening/closing hours');
			res.redirect('/select?reserve=fail');
		} else {
			dataInfo = data.rows;
			console.log(dataInfo);
			var latestBookingHr = dataInfo[0].closingtime;
			var latesttimeSplit = latestBookingHr.split(':');
			var lastHr = latesttimeSplit[0];
			var earliestBookingHr = dataInfo[0].openingtime;
			var earliesttimeSplit = earliestBookingHr.split(':');
			var earliestHr = earliesttimeSplit[0];
			var noOfHours = lastHr - earliestHr;
		}
		
		if(req.isAuthenticated()){
			res.render('reservationLoggedIn', {page: 'Reservation', auth: true, dataInfo:dataInfo, earliestHr:earliestHr, noOfHours:noOfHours});
		} else {
			res.render('reservation', {page: 'Reservation', auth:false, dataInfo:dataInfo, earliestHr:earliestHr, noOfHours:noOfHours});
		}
	});
}

function booked(req, res, next) {
	console.log(outid);
	var rsvid = uuid();
	var rsvDate = req.body.rsvDate;
	var rsvHour = req.body.rsvHour;
	rsvHour+=":00:00";
	var seatsAssigned = req.body.seatsAssigned;
	
	if(!req.isAuthenticated()){
		//Variables
		var userid = uuid();
		var username = req.body.username;
		var password = bcrypt.hashSync(req.body.pswd, salt);
		var fullname = req.body.fullname;
		var phoneno = req.body.phoneno;
		
		pool.query(sql_query.query.add_guest,[userid], (err, data) => {
			if(err) {
				console.error ("Error in register (Guest)", err);
				res.redirect ('/reserveRestaurant?reg=fail');
			}
			else {
				console.log("Added guest successfully!");
				pool.query(sql_query.query.add_user,[userid, username, password, fullname, phoneno], (err, data) => {
					if(err) {
						console.error ("Error in registering guest to user", err);
						res.redirect ('/reserveRestaurant?reg=fail')
					} else {
						pool.query(sql_query.query.insert_into_reservation,[rsvid, userid, outid, rsvDate, rsvHour, seatsAssigned], (err, data) => {
							if(err) {
								console.error ("Error in register (Reserve)", err);
								res.redirect ('/reserveRestaurant?reg=fail');
							}
							else {
								console.log("Reservation (Guest) done successfully");
								res.redirect('/'); //OR res.redirect('/rating');
							}
						});
					}
				});
			}
		});
		
		
	} else { //req.isAuthenticated -> Member
		var username = req.session.passport.user;
		
		pool.query(sql_query.query.search_id,[username], (err, data) => {
			if (err) {
				console.error("Cannot find ID of member", err);
				res.redirect('/reserveRestaurant?reg=fail');
			}
			else {
				var user = data.rows;
				var userid = user[0].userid;
				console.log(userid);
				pool.query(sql_query.query.insert_into_reservation,[rsvid, userid, outid, rsvDate, rsvHour, seatsAssigned], (err, data) => {
					if(err) {
						console.error ("Error in register (Reserve)", err);
						res.redirect ('/reserveRestaurant?reg=fail');
					}
					else {
						console.log("Reservation (Member) done successfully");
						res.redirect('/'); //OR res.redirect('/rating');
					}
				});
			}
		});		
	}
}
			
//--------------LOGIN/LOGOUT FUNCTIONS------------------//
function login(req, res, next) {
	res.render('login', { title: 'Login', auth: false });
}

function signup(req, res, next) {
	res.render('signup', {title: 'Account Registration', auth: false });
}

function register_user (req, res, next) {
	var id = uuid();
	var username = req.body.username;
	var password = bcrypt.hashSync(req.body.password, salt);
	var fullname = req.body.fullname;
	var phoneno = req.body.phoneno;
	
	pool.query(sql_query.query.add_user, [id, username, password, fullname, phoneno], (err, data) => {
		if(err) {
			console.error ("Error in register", err);
			res.redirect ('/signup?reg=fail');
		} else {
			req.login({
				id : id,
				username : username,
				passwordHash : password,
				fullname : fullname,
				phoneno : phoneno
			}, function (err) {
				if(err) {
					return res.redirect('/signup?reg=fail');
				} else {
					pool.query(sql_query.query.add_guest, [id], (err, data) => {
						if(err) {
							console.error("Unable to add into guest", err);
						}
						return res.redirect('/logout');
					})
				}
			});
		}
	});
}

function logout(req, res, next) {
	req.session.destroy()
	req.logout()
	res.redirect('/')
}

module.exports = initRouter;