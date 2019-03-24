DELETE FROM Restaurants;
DELETE FROM Cuisines;

INSERT INTO Cuisines (cuisineType) VALUES
('Chinese'), 
('Western'),
('Vegetarian'),
('FastFood'),
('Japanese');


INSERT INTO Restaurants (rid, rname, totalSeats, cuisineType) VALUES
(1, 'HaiDiLao', 100, 'Chinese'),
(2, 'FatBoys', 30, 'Western'),
(3, 'VeggieBurgs', 30, 'Vegetarian'),
(4, 'GenkiGenki', 50, 'Japanese'),
(5, 'MosBurger', 50, 'FastFood');