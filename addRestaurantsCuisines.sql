DELETE FROM Restaurants;
DELETE FROM Cuisines;

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