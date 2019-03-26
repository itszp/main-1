const sql_query = require('../sql');

const passport = require('passport');
const bcrypt = require('bcrypt');
const LocalStrategy = require('passport-local').Strategy;

const authMiddleware = require('./middleware');
const antiMiddleware = require('./antimiddle');

const { Pool } = require('pg');
const pool = new Pool({
  user: 'postgres',
	host: 'localhost',
	database: 'postgres',
	password: 'matthewng1996',
	port: 5432,
});

passport.serializeUser(function (user, cb) {
  cb(null, user.username);
})

passport.deserializeUser(function (username, cb) {
  findUser(username, cb);
})

function findUser (username, callback) {
	pool.query(sql_query.query.userpass, [username], (err, data) => {
		if(err) {
			console.error("Cannot find user");
			return callback(null);
		}
		
		if(data.rows.length == 0) {
			console.error("User does not exists?");
			return callback(null)
		} else if(data.rows.length == 1) {
			return callback(null, {
				id 			: data.rows[0].userid,
				username    : data.rows[0].username,
				passwordHash: data.rows[0].userpassword,
				fullname    : data.rows[0].fullname,
				phoneno	    : data.rows[0].phoneno
			});
		} else {
			console.error("More than one user?");
			return callback(null);
		}
	});
}

function initPassport () {
  passport.use(new LocalStrategy(
    (username, password, done) => {
      findUser(username, (err, user) => {
        if (err) {
          return done(err);
        }

        // User not found
        if (!user) {
          console.error('User not found');
          return done(null, false);
        }

        // Always use hashed passwords and fixed time comparison
        bcrypt.compare(password, user.passwordHash, (err, isValid) => {
          if (err) {
            return done(err);
          }
          if (!isValid) {
            return done(null, false);
          }
          return done(null, user);
        })
      })
    }
  ));

  passport.authMiddleware = authMiddleware;
  passport.antiMiddleware = antiMiddleware;
  passport.findUser = findUser;
}

module.exports = initPassport;