CREATE OR REPLACE FUNCTION func_checkSeats()
RETURNS TRIGGER AS 
$$
DECLARE totalSeats integer;
        seatsTaken integer;
BEGIN 
    SELECT seatsAvailable INTO totalSeats
    FROM Seats 
    WHERE NEW.outid = Seats.outid 
    AND NEW.rsvHour = Seats.openingHour
    AND NEW.rsvdate = Seats.openingDate;

    SELECT sum(seatsAssigned) INTO seatsTaken
    FROM Reservations
    WHERE New.outid = Reservations.outid
    AND NEW.rsvHour = Reservations.rsvHour
    AND NEW.rsvdate = Reservations.rsvDate;

    IF (seatsTaken + NEW.seatsAssigned > totalSeats) THEN
        RAISE NOTICE 'Insufficient seats for reservation.';
        RETURN NULL;
    ELSE
        RETURN (NEW.rsvid, NEW.userid, NEW.outid, NEW.rsvDate, NEW.rsvHour, NEW.seatsAssigned);
    END IF;
END;
$$
LANGUAGE plpgsql;

drop trigger if exists seats_check on reservations;

CREATE TRIGGER seats_check
BEFORE INSERT OR UPDATE 
ON Reservations
FOR EACH ROW
EXECUTE PROCEDURE func_checkSeats();