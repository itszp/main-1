delete from Users;
delete from Members;
delete from Guests;

INSERT INTO Users (userid, username, userpassword, fullname, phoneNo) VALUES
(1, 'itszp', 'password', 'Zack Tay', '92210389'), 
(2, 'anyhowtouch', 'password', 'Monica Cheng',' 83321345'),
(3, 'guest1', 'password', 'Lim Ko Pi', '63335333');

INSERT INTO Members (userid) VALUES
(1),
(2);

INSERT INTO Guests (userid) VALUES
(3);