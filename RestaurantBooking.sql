CREATE TABLE Customers (
	username 		VARCHAR(50),
	password		VARCHAR(100),
	cname			VARCHAR(50),
	phoneNo			VARCHAR(20),
	PRIMARY KEY (username)
);

CREATE TABLE Administators (
	username 		VARCHAR(50),
	password		VARCHAR(100),
	aname			VARCHAR(50),
	phoneNo			VARCHAR(20),
	PRIMARY KEY (username)
);