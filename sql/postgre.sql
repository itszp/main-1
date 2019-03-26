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
