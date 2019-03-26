const sql = {};


//NOTE TO END QUERY WITH , UNLESS IT'S THE LAST QUERY
sql.query = {
	add_user: 'INSERT INTO users (userid, username, userpassword, fullname, phoneno) VALUES ($1,$2,$3,$4, $5)',
	userpass: 'SELECT * FROM users WHERE username = $1'
	
}

module.exports = sql