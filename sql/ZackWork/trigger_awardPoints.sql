CREATE OR REPLACE FUNCTION func_awardPoints()
RETURNS TRIGGER AS
$$
DECLARE isMember integer;
begin
    SELECT count(*) INTO isMember  
    FROM Members
    WHERE NEW.userid = Members.userid;

    IF (isMember = 1) THEN
        INSERT INTO Points (pointNumber, rsvid, userid)
        VALUES (10, NEW.rsvid, NEW.userid);
        RAISE NOTICE '10 points awarded.';
       	return null;
        
    ELSE
        RETURN NULL;
    END IF;
end;
$$
LANGUAGE plpgsql;

drop trigger if exists award_points on reservations;
CREATE TRIGGER award_points
AFTER INSERT
ON Reservations
FOR EACH ROW
EXECUTE PROCEDURE func_awardPoints();