CREATE OR REPLACE FUNCTION func_upgradeMember()
RETURNS TRIGGER AS 
$$
DECLARE isGuest integer;
        totalRsv integer;
BEGIN 
    SELECT count(*) INTO isGuest
    FROM Guests
    WHERE NEW.userid = Guests.userid;

    SELECT count(rsvid) INTO totalRsv
    FROM Reservations
    WHERE NEW.userid = Reservations.userid;

    IF (isGuest = 1) THEN
        IF (totalRsv = 3) THEN
            INSERT INTO Members (userid)
           	VALUES (NEW.userid);
            DELETE FROM Guests WHERE (userid = NEW.userid);
            INSERT INTO Points (pointNumber, rsvid, userid)
            VALUES (30, NEW.rsvid, NEW.userid);
            RETURN NULL;
        ELSE 
            RETURN NULL;
        END IF;
    ELSE
        RETURN NULL;
    END IF;
END;
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS upgrade_Member ON Reservations;

CREATE TRIGGER upgrade_Member
AFTER INSERT
ON Reservations
FOR EACH ROW
EXECUTE PROCEDURE func_upgradeMember();