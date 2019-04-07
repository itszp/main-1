CREATE OR REPLACE FUNCTION func_createSeats()
RETURNS TRIGGER AS 
$$
DECLARE openHour time;
        closingHour time;
        numOfSeats integer;

BEGIN
    SELECT openingTime INTO openHour
    FROM Outlets 
    WHERE NEW.outid = Outlets.outid;

    SELECT closingTime INTO closingHour
    FROM Outlets 
    WHERE NEW.outid = Outlets.outid;

    SELECT totalSeats INTO numOfSeats
    FROM Outlets 
    WHERE NEW.outid = Outlets.outid;

    WHILE (openHour < closingHour) LOOP
        INSERT INTO Seats(outid, openingHour, openingDate, seatsAvailable)
        VALUES (NEW.outid, openHour, NEW.openingDate, numOfSeats);
        
        SELECT openHour + '1hour'::interval INTO openHour;
    END loop;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

drop trigger if exists create_Seats on Opens;

CREATE TRIGGER create_Seats
AFTER INSERT
ON Opens
FOR EACH ROW
EXECUTE PROCEDURE func_createSeats();