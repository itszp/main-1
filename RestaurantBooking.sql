drop table if exists Restaurants, SellFood, Addresses, Branches, Rating, Cuisine cascade;
drop table if exists Serves, Reservation, Reserves, Points,GivesPoint, Users, Customers, Administrators cascade;
drop table if exists  UserHasPoints, Prefers, MakeReservation, Rates cascade;

create table Restaurants (
rid serial primary key,
rname varchar,		
totalSeats integer);

create table SellFood (
fname varchar,
price numeric,
restid integer references Restaurants on delete cascade,
primary key (restid,fname));

create table Addresses (
postalCode integer,
unitNo varchar(10),
arealocation date,
streetName date,
primary key (postalCode, unitNo));

create table Branches (
openingTime time,
closingTime time,
postalCode integer,
unitNo varchar(10),
FOREIGN KEY (postalCode, unitNo) REFERENCES Addresses (postalCode, unitNo),
rid integer references Restaurants,
primary key (postalCode, unitNo, rid));

create table Rating (
ratingid serial primary key,
review varchar);

create table Cuisine (
cuisineType varchar primary key);

create table Serves (
cuisineType varchar references Cuisine,
rid integer references Restaurants,
primary key (cuisineType, rid)); 

create table Reservation (
rsvid serial primary key,
reservationDate date,
reservationtime time,
numOfDiner integer,
status varchar); 

create table Reserves (
reservesDate date,
seatsAvailable integer,
rsvid integer references Reservation,
rid integer references Restaurants,
primary key (rsvid, rid)); 

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

create table Rates (
username varchar references Users,
rsvid integer references Reservation,
ratingid integer references Rating,
primary key (username, rsvid, ratingid)); 
