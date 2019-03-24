DELETE FROM Ratings;
DELETE FROM Restaurants;
DELETE FROM Cuisines;
delete from Users;
delete from Members;
delete from Guests;
delete from Outlets;
delete from Ratings;


INSERT INTO Users (userid, username, userpassword, fullname, phoneNo) VALUES
(1, 'itszp', 'password', 'Zack Tay', '92210389'), 
(2, 'anyhowtouch', 'password', 'Monica Cheng',' 83321345'),
(3, 'guest1', 'password', 'Lim Ko Pi', '63335333');

INSERT INTO Members (userid) VALUES
(1),
(2);

INSERT INTO Guests (userid) VALUES
(3);

INSERT INTO Cuisines (cuisineType) VALUES
('Chinese'), 
('Western'),
('Vegetarian'),
('FastFood'),
('Japanese');

INSERT INTO Restaurants (rid, rname, cuisineType) VALUES
(1, 'HaiDiLao', 'Chinese'),
(2, 'FatBoys', 'Western'),
(3, 'VeggieBurgs', 'Vegetarian'),
(4, 'GenkiGenki', 'Japanese'),
(5, 'MosBurger', 'FastFood');

INSERT INTO  Outlets (outid, rid, totalSeats, area, unitNo, postalCode, openingTime, closingTime) VALUES
(1, 1, 100, 'Central', '03-01', '012422', '12:00', '23:00'),
(2, 2, 40, 'West', '01-11', '364323', '14:00', '22:00'),
(3, 3, 30, 'East', '04-01', '511387', '10:00', '21:00'),
(4, 4, 50, 'East', '03-43', '431760', '11:00', '22:00'),
(5, 5, 40, 'Central', '01-31', '310213', '09:00', '22:00'),
(6, 5, 40, 'North', '02-16', '221638', '09:00', '22:00'),
(7, 1, 80, 'South', '04-11', '512318', '12:00', '23:00');

INSERT INTO Ratings (rid, userid, ratingscore, review) VALUES
(1, 1, 5, 'World-class service'),
(2, 1, 3, 'Decent burgers for its price'),
(3, 1, 3, 'So-so food'),
(4, 1, 4, 'Fresh sashimi and decent staff service'),
(5, 1, 5, 'I LOVE MOS BURGER'),
(2, 2, 5, 'Really love how thick the beef patties are!'),
(4, 2, 3, 'Good sushi but not worth the wait..'),
(5, 3, 4, 'MosBurger milkshakes are the best but abit pricey'),
(5, 2, 4, 'Not cheap but worth every penny');