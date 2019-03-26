DELETE FROM Preferences;
DELETE FROM Points;
DELETE FROM Reservations;
DELETE FROM Food;
DELETE FROM Seats;
DELETE FROM Ratings;
DELETE FROM Branches;
DELETE FROM Outlets;
DELETE FROM Serves;
DELETE FROM Restaurants;
DELETE FROM Cuisines;
DELETE FROM Members;
DELETE FROM Guests;
DELETE FROM Users;


INSERT INTO Users (userid, username, userpassword, fullname, phoneNo) VALUES
(1, 'itszp', 'password', 'Zack Tay', '92210389'), 
(2, 'anyhowtouch', 'password', 'Monica Cheng', '83321345'),
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
('Japanese'),
('Buffet');

INSERT INTO Restaurants (rid, rname) VALUES
(1, 'HaiDiLao'),
(2, 'FatBoys'),
(3, 'VeggieBurgs'),
(4, 'GenkiGenki'),
(5, 'MosBurger'),
(6, 'ShabuShabu');


INSERT INTO Serves (rid, cuisineType) VALUES
(1, 'Chinese'),
(2, 'Western'),
(3, 'Vegetarian'),
(4, 'Japanese'),
(5, 'FastFood'),
(6, 'Chinese'),
(6, 'Buffet');

INSERT INTO  Outlets (outid, rid, totalSeats, openingTime, closingTime) VALUES
(1, 1, 100, '12:00', '23:00'),
(2, 2, 40, '14:00', '22:00'),
(3, 3, 30, '10:00', '21:00'),
(4, 4, 50, '11:00', '22:00'),
(5, 5, 40, '09:00', '22:00'),
(6, 5, 40, '09:00', '22:00'),
(7, 1, 80, '12:00', '23:00'),
(8, 6, 80, '11:00', '22:00');


INSERT INTO  Branches (outid, rid, area, unitNo, postalCode) VALUES
(1, 1, 'Central', '03-01', '012422'),
(2, 2, 'West', '01-11', '364323'),
(3, 3, 'East', '04-01', '511387'),
(4, 4, 'East', '03-43', '431760'),
(5, 5, 'Central', '01-31', '310213'),
(6, 5, 'North', '02-16', '221638'),
(7, 1, 'South', '04-11', '512318'),
(8, 6, 'Central', '03-11', '021568');

INSERT INTO Ratings (rid, userid, ratingscore, review) VALUES
(1, 1, 5, 'World-class service'),
(2, 1, 3, 'Decent burgers for its price'),
(3, 1, 3, 'So-so food'),
(4, 1, 4, 'Fresh sashimi and decent staff service'),
(5, 1, 5, 'I LOVE MOS BURGER'),
(2, 2, 5, 'Really love how thick the beef patties are!'),
(4, 2, 3, 'Good sushi but not worth the wait..'),
(5, 3, 4, 'MosBurger milkshakes are the best but abit pricey'),
(1, 2, 4, 'Not cheap but worth every penny');

INSERT INTO Seats (outid, openingHour, openingDate, seatsAvailable) VALUES
(1, '12:00', '24-03-2019', 100),
(1, '13:00', '24-03-2019', 100),
(1, '14:00', '24-03-2019', 100),
(1, '15:00', '24-03-2019', 100),
(1, '16:00', '24-03-2019', 100),
(1, '17:00', '24-03-2019', 100),
(1, '18:00', '24-03-2019', 100),
(1, '19:00', '24-03-2019', 100),
(1, '20:00', '24-03-2019', 100),
(1, '21:00', '24-03-2019', 100),
(1, '22:00', '24-03-2019', 100),

(7, '12:00', '24-03-2019', 100),
(7, '13:00', '24-03-2019', 100),
(7, '14:00', '24-03-2019', 100),
(7, '15:00', '24-03-2019', 100),
(7, '16:00', '24-03-2019', 100),
(7, '17:00', '24-03-2019', 100),
(7, '18:00', '24-03-2019', 100),
(7, '19:00', '24-03-2019', 100),
(7, '20:00', '24-03-2019', 100),
(7, '21:00', '24-03-2019', 100),
(7, '22:00', '24-03-2019', 100),

(2, '14:00', '24-03-2019', 100),
(2, '15:00', '24-03-2019', 100),
(2, '16:00', '24-03-2019', 100),
(2, '17:00', '24-03-2019', 100),
(2, '18:00', '24-03-2019', 100),
(2, '19:00', '24-03-2019', 100),
(2, '20:00', '24-03-2019', 100),
(2, '21:00', '24-03-2019', 100),

(3, '10:00', '24-03-2019', 100),
(3, '11:00', '24-03-2019', 100),
(3, '12:00', '24-03-2019', 100),
(3, '13:00', '24-03-2019', 100),
(3, '14:00', '24-03-2019', 100),
(3, '15:00', '24-03-2019', 100),
(3, '16:00', '24-03-2019', 100),
(3, '17:00', '24-03-2019', 100),
(3, '18:00', '24-03-2019', 100),
(3, '19:00', '24-03-2019', 100),
(3, '20:00', '24-03-2019', 100),

(4, '11:00', '24-03-2019', 100),
(4, '12:00', '24-03-2019', 100),
(4, '13:00', '24-03-2019', 100),
(4, '14:00', '24-03-2019', 100),
(4, '15:00', '24-03-2019', 100),
(4, '16:00', '24-03-2019', 100),
(4, '17:00', '24-03-2019', 100),
(4, '18:00', '24-03-2019', 100),
(4, '19:00', '24-03-2019', 100),
(4, '20:00', '24-03-2019', 100),
(4, '21:00', '24-03-2019', 100),

(5, '09:00', '24-03-2019', 100),
(5, '10:00', '24-03-2019', 100),
(5, '11:00', '24-03-2019', 100),
(5, '12:00', '24-03-2019', 100),
(5, '13:00', '24-03-2019', 100),
(5, '14:00', '24-03-2019', 100),
(5, '15:00', '24-03-2019', 100),
(5, '16:00', '24-03-2019', 100),
(5, '17:00', '24-03-2019', 100),
(5, '18:00', '24-03-2019', 100),
(5, '19:00', '24-03-2019', 100),
(5, '20:00', '24-03-2019', 100),
(5, '21:00', '24-03-2019', 100),

(6, '09:00', '24-03-2019', 100),
(6, '10:00', '24-03-2019', 100),
(6, '11:00', '24-03-2019', 100),
(6, '12:00', '24-03-2019', 100),
(6, '13:00', '24-03-2019', 100),
(6, '14:00', '24-03-2019', 100),
(6, '15:00', '24-03-2019', 100),
(6, '16:00', '24-03-2019', 100),
(6, '17:00', '24-03-2019', 100),
(6, '18:00', '24-03-2019', 100),
(6, '19:00', '24-03-2019', 100),
(6, '20:00', '24-03-2019', 100),
(6, '21:00', '24-03-2019', 100);


INSERT INTO Food (rid, fname, price) VALUES
(1, '2-soup Steamboat', 18),
(1, '1-soup Steamboat', 15),
(1, 'Premium Beef', 21),
(1, 'Premium Black Pork', 28),
(2, 'Original FatBoy Burger', 21),
(2, 'Cheese Fries', 8),
(3, 'Soya Milk', 4),
(3, 'Cheese Fries', 6),
(3, 'Eggs Benedict', 12),
(3, 'Garden Burger', 10),
(4, 'Salmon Sashimi', 8),
(4, 'Garlic Soba', 4),
(4, 'Chawanmusi', 3.50),
(4, 'Chirashi Don', 12.50),
(5, 'Chocolate Milkshake', 3),
(5, 'Vanilla Milkshake', 3),
(5, 'Edi Burger', 4.50);

INSERT INTO Reservations (rsvid, userid, outid, rsvdate, rsvHour, seatsAssigned) VALUES
(1, 1, 1, '24-03-2019', '20:00', 25), 
(2, 2, 1, '24-03-2019', '20:00', 5),
(3, 3, 4, '24-03-2019', '14:00', 2);

INSERT INTO Points (pointNumber, rsvid, userid) VALUES
(50, 1, 1),
(20, 2, 2);

INSERT INTO Preferences (userid, area, cuisineType, maxPrice, minScore) VALUES
(1, 'CENTRAL', null, null, 3),
(1, 'WEST', null, null, null),
(2, 'EAST', 'Japanese', null, null);
 


