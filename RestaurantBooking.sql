drop table if exists Restaurants, SellFood, Addresses, Branches, Rating, Cuisine cascade;
drop table if exists Serves, Reservation, Reserves, Points,GivesPoint, Users, Customers, Administrators cascade;
drop table if exists  UserHasPoints, Prefers, MakeReservation, Rates cascade;

create table Restaurants (
rid integer,
rname varchar,		
totalSeats integer
primary key (rid)
);

create table Food (
fname varchar,
price numeric(38, 2),
rid integer references Restaurants on delete cascade,
primary key (rid,fname)
);

create table Addresses (
postalCode integer,
unitNo varchar(10),
area varchar(100),
streetName varchar(50),
primary key (postalCode, unitNo)
);

create table Branches (
rid integer,
openingTime time,
closingTime time,
postalCode integer,
unitNo varchar(10),
foreign key (postalCode, unitNo) references Addresses (postalCode, unitNo),
foreign key (rid) references Restaurants,
primary key (postalCode, unitNo, rid),
unique (postalCode, unitNo)
);

create table Ratings (
ratingid integer,
userid integer,
rid integer,
review varchar,
primary key (ratingid)
foreign key (userid) references Users,
foreign key (rid) references Restaurant
);

create table Reservation (
rsvid integer,
rsvDate date,
rsvTime time,
numOfPeople integer,
status varchar,
userid integer,
pid integer,
primary key (rsvid),
foreign key userid references Users
foreign key pid references Points
); 

create table Reserves (
rid integer
rsvid integer
reservesDate date,
seatsAvailable integer,
rsvid integer references Reservation,
rid integer references Restaurants,
primary key (rsvid, rid)); 

create table Cuisine (
cuisineType varchar primary key);

create table Serves (
cuisineType varchar references Cuisine,
rid integer references Restaurants,
primary key (cuisineType, rid)); 


create table Points (
pid serial primary key,
pointNumber date); 

create table GivesPoint (
pid integer references Points,
rsvid integer references Reservation,
primary key (pid, rsvid)); 

create table Users (
username varchar primary key,
userPassword varchar); 

create table Customers (
username varchar primary key references Users on delete cascade,
cname varchar,
phoneNo varchar); 

create table Administrators (
username varchar primary key references Users on delete cascade,
aname varchar,
phoneNo varchar); 

create table UserHasPoints (
pid integer references Points,
userName varchar references Users,
primary key (pid, userName)); 

create table Prefers (
maxPrice integer,
arealocation varchar,
cuisineType varchar references Cuisine,
userName varchar references Users,
primary key (cuisineType, userName)); 


create table MakeReservation (
username varchar references Users,
rsvid integer references Reservation,
primary key (username, rsvid)); 
