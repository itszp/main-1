drop table if exists Restaurants, Outlets, Ratings, Cuisines
cascade;
drop table if exists Reservations, Points, Users, Members, Guests 
cascade;
drop table if exists  Preferences, Food, Seats, Serves, Branches, Opens
cascade;

create table Members
(
    userid integer,
    primary key (userid)
);

create table Guests
(
    userid integer,
    primary key (userid)
);

create table Cuisines
(
    cuisineType varchar (64),
    primary key (cuisineType)
);

create table Restaurants
(
    rid integer,
    rname varchar (64) not null,
    primary key (rid)
);

create table Serves 
(
    rid integer,
    cuisineType varchar(64),
    primary key (rid, cuisineType),
    foreign key (rid) references Restaurants,
    foreign key (cuisineType) references Cuisines
);

create table Food
(
    rid integer,
    fname varchar (64) not null,
    price numeric(8, 2) not null,
    primary key (rid,fname),
    foreign key (rid) references Restaurants on delete cascade
);

create table Users
(
    userid integer,
    username varchar(64) unique not null,
    userpassword varchar(64) not null,
    fullName varchar (64) not null,
    phoneNo varchar (32) unique not null,
    primary key (userid)
);

create table Outlets
(
    outid integer,
    rid integer not null,
    openingTime time not null,
    closingTime time not null,
    totalSeats integer not null,
    primary key (outid),
    foreign key (rid) references Restaurants
);

create table Branches
( 
    rid integer,
    outid integer,
    postalCode varchar(6) not null,
    unitNo varchar(16),
    area varchar(128) not null,
    primary key (rid, outid),
    foreign key (rid) references Restaurants,
    foreign key (outid) references Outlets
    
);

create table Opens
(
    outid integer,
    openingDate date,
    primary key (outid, openingDate),
    foreign key (outid) references Outlets
);

create table Seats
(
    outid integer not null,
    openingHour time not null,
    openingDate date not null,
    seatsAvailable integer,
    primary key (outid, openingHour, openingDate),
    foreign key (outid, openingDate) references Opens
);

create table Reservations
(
    rsvid integer,
    userid integer,
    outid integer not null,
    rsvDate date not null,
    rsvHour time not null,
    seatsAssigned integer not null,
    primary key (rsvid),
    foreign key (userid) references Users
);

create table Points
(
    pid serial,
    pointNumber integer not null,
    rsvid integer references Reservations,
    userid integer references Members,
    primary key (pid)
);

create table Ratings
(
    ratingid serial,
    userid integer,
    rid integer,
    ratingscore integer not null,
    review varchar(1024),
    primary key (ratingid),
    foreign key (userid) references Users,
    foreign key (rid) references Restaurants
);

create table Preferences
(
    userid integer,
    area varchar(64),
    maxPrice numeric(8, 2),
    avgPrice numeric(8, 2),
    minScore integer,
    primary key (userid),
    foreign key (userid) references Members
); 


-- Updates Seats Based on Opens
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

    RETURN NULL;
END;
$$
LANGUAGE plpgsql;

drop trigger if exists create_Seats on Opens;

CREATE TRIGGER create_Seats
AFTER INSERT
ON Opens
FOR EACH ROW
EXECUTE PROCEDURE func_createSeats();


-- trigger to check available seats and valid time before insert into reservations
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
    ELSIF (NEW.rsvDate < current_date) THEN 
        RAISE NOTICE 'Unable to make reservation on an earlier date.';
        RETURN NULL;
    ELSIF (new.rsvDate = current_date and NEW.rsvHour < current_time + '1hour'::interval) THEN
        RAISE NOTICE 'Please make booking at least one hour in advance.';
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



-- trigger to give points
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
       	RETURN NULL;
        
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


-- trigger to upgrade guest to member. new member gets 30 points.
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