delete from serves;
delete from branches;
delete from outlets;
delete from food;
delete from ratings;
delete from restaurants;
delete from users;

CREATE VIEW OutletInfo (rname, outid, area, totalSeats, openingTime, closingTime, maxPrice) as 
    with RestaurantMaxMenu as (
        select R.rid, R.rname, max(price) as maxPrice
        from Restaurants R natural join Food
        group by R.rid
    )

    select R.rname, O.outid, B.area, O.totalseats, O.openingtime, O.closingtime, maxPrice
    from Outlets O natural join Restaurants R natural join Branches B join RestaurantMaxMenu RMax on R.rid = Rmax.rid;

create table Members
(
    userid uuid,
    primary key (userid)
);

create table Guests
(
    userid uuid,
    primary key (userid)
);

create table Cuisines
(
    cuisineType varchar (64),
    primary key (cuisineType)
);

insert into Cuisines values ('Western');
insert into Cuisines values ('Japanese');
insert into Cuisines values ('Korean');
insert into Cuisines values ('Fast Food');
insert into Cuisines values ('Chinese');
insert into Cuisines values ('Thai');
insert into Cuisines values ('Buffet');
insert into Cuisines values ('Steamboat');

create table Restaurants
(
    rid uuid,
    rname varchar (64) not null,
    primary key (rid)
);

create table Serves 
(
    rid uuid,
    cuisineType varchar(64),
    primary key (rid, cuisineType),
    foreign key (rid) references Restaurants,
    foreign key (cuisineType) references Cuisines
);

create table Food
(
    rid uuid,
    fname varchar (64) not null,
    price numeric(8, 2) not null,
    primary key (rid,fname),
    foreign key (rid) references Restaurants on delete cascade
);

create table Users
(
    userid uuid,
    username varchar(64) unique not null,
    userpassword varchar(64) not null,
    fullName varchar (64) not null,
    phoneNo varchar (32) unique not null,
    primary key (userid)
);

create table Outlets
(
    outid uuid,
    rid uuid not null,
    openingTime time not null,
    closingTime time not null,
    totalSeats integer not null,
    primary key (outid),
    foreign key (rid) references Restaurants
);

create table Branches
( 
    rid uuid,
    outid uuid,
    postalCode varchar(6) not null,
    unitNo varchar(16),
    area varchar(128) not null,
    primary key (rid, outid),
    foreign key (rid) references Restaurants,
    foreign key (outid) references Outlets
    
);

create table Seats
(
    outid uuid not null,
    openingHour time not null,
    openingDate date not null,
    seatsAvailable integer,
    primary key (outid, openingHour, openingDate),
    foreign key (outid) references Outlets
);

create table Reservations
(
    rsvid uuid,
    userid uuid,
    outid uuid not null,
    rsvDate date not null,
    rsvHour time not null,
    seatsAssigned integer not null,
    primary key (rsvid),
    foreign key (userid) references Users
);

create table Points
(
    pid uuid,
    pointNumber integer not null,
    rsvid uuid references Reservations,
    userid uuid references Members,
    primary key (pid)
);

create table Ratings
(
    ratingid uuid,
    rid uuid,
    ratingscore integer not null,
    review varchar(1024),
    primary key (ratingid),
    foreign key (rid) references Restaurants
);


create table Preferences
(
    userid uuid,
    area varchar(64),
    maxPrice numeric(8, 2),
    avgPrice numeric(8, 2),
    minScore integer,
    primary key (userid),
    foreign key (userid) references Members
);

CREATE OR REPLACE FUNCTION func_checkSeats()
RETURNS TRIGGER AS 
$$
	DECLARE totalSeats integer;
			seatsTaken integer;
	BEGIN 
		SELECT seatsAvailable INTO totalSeats
		FROM Seats 
		WHERE NEW.outid = Seats.outid 
		AND NEW.rsvHour = Seats.openinghour
		AND NEW.rsvdate = Seats.openingdate;

		SELECT sum(seatsAssigned) INTO seatsTaken
		FROM Reservations
		WHERE New.outid = Reservations.outid
		AND NEW.rsvhour = Reservations.rsvhour
		AND NEW.rsvdate = Reservations.rsvdate;

		IF (seatsTaken + NEW.seatsAssigned > totalSeats) THEN
			RAISE NOTICE 'Insufficient seats for reservation.';
			RETURN NULL;
		ELSE
			RETURN (NEW.rsvid, NEW.userid, NEW.outid, NEW.rsvdate. NEW.rsvhour, NEW.seatsassigned);
		END IF;
	END; 
$$ LANGUAGE plpgsql;

CREATE TRIGGER seats_check
	BEFORE INSERT OR UPDATE 
	ON Reservations
	FOR EACH ROW
	EXECUTE PROCEDURE func_checkSeats(); 
