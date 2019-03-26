drop table if exists Restaurants, Outlets, Ratings, Cuisines
cascade;
drop table if exists Reservations, Points, Users, Members, Guests 
cascade;
drop table if exists  Preferences, Food, Seats, Serves
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
    cuisineType varchar (50),
    primary key (cuisineType)
);

create table Restaurants
(
    rid integer,
    rname varchar (50) not null,
    primary key (rid)
);

create table Serves 
(
    rid integer,
    cuisineType varchar(50),
    primary key (rid, cuisineType),
    foreign key (rid) references Restaurants,
    foreign key (cuisineType) references Cuisines
);

create table Food
(
    rid integer,
    fname varchar (50) not null,
    price numeric(38, 2) not null,
    primary key (rid,fname),
    foreign key (rid) references Restaurants on delete cascade
);

create table Users
(
    userid integer,
    username varchar(50) unique not null,
    userpassword varchar(100) not null,
    fullName varchar (50) not null,
    phoneNo varchar unique not null,
    primary key (userid)
);

create table Outlets
(
    outid integer,
    rid integer not null,
    postalCode varchar(6) not null,
    unitNo varchar(10),
    area varchar(100) not null,
    openingTime time not null,
    closingTime time not null,
    totalSeats integer not null,
    primary key (outid),
    foreign key (rid) references Restaurants,
    unique (postalCode, unitNo)
);

create table Seats
(
    outid integer not null,
    openingHour time not null,
    openingDate date not null,
    seatsAvailable integer,
    primary key (outid, openingHour, openingDate),
    foreign key (outid) references Outlets
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
    pid integer,
    pointNumber integer not null,
    rsvid integer references Reservations,
    userid integer references Members,
    primary key (pid),
    unique (pid, userid, rsvid)
);

create table Ratings
(
    ratingid serial,
    userid integer,
    rid integer,
    ratingscore integer not null,
    review varchar(255),
    primary key (ratingid),
    foreign key (userid) references Users,
    foreign key (rid) references Restaurants
);

create table Preferences
(
    prefid integer,
    area varchar(50) not null,
    maxPrice integer not null,
    minScore integer not null,
    userid integer not null,
    cuisineType varchar(50) not null,
    primary key (prefid),
    foreign key (cuisineType) references Cuisines,
    foreign key (userid) references Members,
    unique (prefid, userid, area)
); 
