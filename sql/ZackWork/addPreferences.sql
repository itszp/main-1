DELETE FROM Preferences;

INSERT INTO Preferences (userid, area, cuisineType, maxPrice, minScore) VALUES
(1, 'CENTRAL', null, null, 3),
(1, 'WEST', null, null, null),
(2, 'EAST', 'Japanese', null, null);
 