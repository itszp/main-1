DELETE FROM Reservations;

INSERT INTO Reservations (rsvid, userid, outid, rsvdate, rsvHour, numOfPeople) VALUES
(1, 1, 1, '24-03-2019', '20:00', 25), 
(2, 2, 1, '24-03-2019', '20:00', 5),
(3, 3, 4, '24-03-2019', '14:00', 2);