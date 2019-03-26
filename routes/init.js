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
	
			//---------LOGOUT GET-----------------//
	app.get('/logout', passport.authMiddleware(), logout);
	
	//---------POST FUNCTIONS-----------//
	app.post('/register_user', passport.antiMiddleware(), register_user);
	//app.post('/for_restaurants', newRestaurants);
	
			//---------LOGIN POST-------------------//
	app.post('/login', passport.authenticate('local', {
		successRedirect: '/profile',
		failureRedirect: '/' //Or '/login' (SEE HOW)
	}));
	
}

//-------------------ROUTES----------------------------//
function index(req, res, next) {
	if (req.session.isAuthenticated){
		res.render('success', { page: 'Home', menuId: 'home', user: req.session.username, auth: true});
	} else {
		res.render('index', { page: 'Home', menuId: 'home' , auth: false});
	}
}

function newRestaurants(req, res, next) {
	res.render('new_restaurants', {page: 'Restaurants'});
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
					return res.redirect('/');
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