drop table if exists Restaurants, SellFood, Addresses, Branches, Rating, Cuisine cascade;
drop table if exists Serves, Reservation, Reserves, Points,GivesPoint, Users, Customers, Administrators cascade;
drop table if exists  UserHasPoints, Prefers, MakeReservation, Rates cascade;

create table Restaurants (
rid integer,
rname varchar (50) not null,		
totalSeats integer not null,
cuisineType varchar(50) not null,
primary key (rid)
foreign key (cuisineType) references Cuisines
);

create table Food (
rid integer,
fname varchar (50) not null,
price numeric(38, 2) not null,
primary key (rid,fname),
foreign key (rid) references Restaurants on delete cascade
);

create table Addresses (
postalCode integer not null,
unitNo varchar(10) not null,
area varchar(100) not null,
streetName varchar(50) not null,
primary key (postalCode, unitNo)
);

create table Branches (
rid integer,
openingTime time not null,
closingTime time not null,
postalCode integer,
unitNo varchar(10),
primary key (postalCode, unitNo, rid),
foreign key (postalCode, unitNo) references Addresses (postalCode, unitNo),
foreign key (rid) references Restaurants,
unique (postalCode, unitNo)
);

create table Ratings (
ratingid integer,
review varchar(255),
userid integer,
rid integer,
ratingscore integer not null,
primary key (ratingid)
foreign key (userid) references Users,
foreign key (rid) references Restaurants
);

create table Reservations (
rsvid integer,
rsvDate date not null,
rsvTime time not null,
numOfPeople integer not null,
userid integer,
pid integer,
primary key (rsvid),
foreign key userid references Users
foreign key pid references Points
); 

create table Users (
userid integer,
username varchar(50) unique not null,
userpassword varchar(100) not null,
fullName varchar (50) not null,
phoneNo varchar unique not null,
primary key (userid)
);

create table Reserves (
seatsAvailable integer not null, 
rdate date not null,
rid integer,
rsvid integer,
rid integer references Restaurants,
rsvid integer references Reservation,
primary key (rsvid, rid, rdate)
); 

create table Points (
pid integer,
pointNumber integer not null,
rsvid integer references Reservations,
userid integer references Members,
primary key (pid)
unique (pid, userid, rsvid)
); 

create table Cuisines (
cuisineType varchar (50),
primary key (cuisideType)
);

create table Preferences (
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

create table Members (
userid integer,
primary key (userid)
);

create table Guests (
userid integer,
primary key (userid)
);
