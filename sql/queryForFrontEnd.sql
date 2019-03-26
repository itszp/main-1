-- 1
select r.rname,o.area,o.totalseats,o.openingtime,o.closingtime 
from outlets o 
inner join restaurants r on r.rid=o.rid order by r.rname;

-- 2 
CREATE OR REPLACE FUNCTION checkUserNameAndPassword (checkUserName varchar(50),	 checkUserPassword  varchar(100), paswordCheck boolean) 
RETURNS varchar as $paswordCheck$
DECLARE count NUMERIC ;
      
   BEGIN
      
      select count(*) as count from users where userName = checkUserName and userPassword =checkUserPassword;
      IF count > 0 THEN
			RETURN false ;
		ELSE
			RETURN true ;
		END IF;
   END; $paswordCheck$
LANGUAGE plpgsql;

-- 3
CREATE OR REPLACE FUNCTION checkDuplicateUserName() RETURNS TRIGGER AS $checkDuplicateWhenInsert$
DECLARE count NUMERIC ;
   begin
	   select count(*) into count from users where userName =new.userName;
	   IF count > 0 THEN
			RETURN NULL ;
		ELSE
			RETURN NEW ;
		END IF;
   END;
$checkDuplicateWhenInsert$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS checkDuplicateWhenInsert on "users";
CREATE  TRIGGER checkDuplicateWhenInsert before INSERT ON users
FOR EACH ROW EXECUTE PROCEDURE checkDuplicateUserName();




-- 4

insert into users (username,userpassword, fullname,phoneno) values('','','',1) ;

insert into members (userid) select currval(pg_get_serial_sequence('users','userid'));

insert into preferences (prefid, area, maxprice, minscore,userid,cuisinetype)
values (1,'',1,1,(select currval(pg_get_serial_sequence('users','userid'))),'');

--5 and 9 
select * from ratings;

insert into reservations (rsvdate, rsvhour,numofpeople) values ('','',1);
insert into points (pointnumber, rsvid, userid) values (1,((select currval(pg_get_serial_sequence('users','userid')))), 1);
insert into reserves (seatassigned, outid,openinghour, openingdate) values (1,'','',1);


insert into ratings (review, userid, rid, ratingsscore) values ('',1,1,1);


-- 7
select r.rname,o.area,o.totalseats,o.openingtime,o.closingtime, max(price) 
, avg(ratingscore)
from outlets o 
inner join restaurants r on r.rid=o.rid 
inner join ratings ra on ra.rid=r.rid
inner join food f on f.rid=r.rid
where area in (select area from preferences where userid = 1)

group by  r.rname,o.area,o.totalseats,o.openingtime,o.closingtime
having  max(price)  >=  (select maxprice from preferences where userid = 1) or 
  avg(ratingscore)  >=  (select minscore from preferences where userid = 1) 
order by r.rname;
-- 8

select r.rname,o.area,o.totalseats,o.openingtime,o.closingtime 
from outlets o 
inner join restaurants r on r.rid=o.rid 
where r.cuisinetype in ('','')
order by r.rname;

-- 10




