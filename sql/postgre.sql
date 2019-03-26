CREATE TABLE users (
	userid		   uuid PRIMARY KEY,
	username   varchar(64)  UNIQUE NOT NULL,
	userpassword   varchar(64) NOT NULL,
	--status     varchar(6)  NOT NULL,
	fullname   varchar(128) NOT NULL,
	phoneno	   varchar(64)
);

