CREATE OR REPLACE FUNCTION func_checkSeats()
RETURN TRIGGER AS 
$$
DECLARE totalSeats integer;
        seatsAssigned integer;
BEGIN 
    SELECT seatsAvailable INTO totalSeats
    FROM Seats 
    WHERE NEW.outid = Seats.outid 
    AND NEW.rsvHour = Seats.openingHour
    AND NEW.rsvdate = Seats.openingDate;

    SELECT sum(seatsAssigned) INTO seatsAssigned
    FROM Reserves natural join Reservations
    WHERE New.oid = Reservations.outid
    AND NEW.rsvHour = Reservations.rsvHour
    AND NEW.rsvdate = Reservations.rsvDate;

    IF (seatsAssigned + NEW.numOfPeople > totalSeats) THEN
        RAISE NOTICE 'Insufficient seats for reservation.';
        RETURN NULL;
    ELSE
        RETURN (NEW.rsvid, NEW.oid, NEW.outid, NEW.rsvDate. NEW.rsvHour, NEW.numOfPeople);
    END IF;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER seats_check
BEFORE INSERT OR UPDATE 
ON Reservations
FOR EACH ROW
EXECUTE PROCEDURE func_checkSeats();