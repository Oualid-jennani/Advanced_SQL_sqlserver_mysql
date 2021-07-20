DROP SCHEMA IF EXISTS AMIS; 
CREATE SCHEMA AMIS; 
USE AMIS;

CREATE TABLE PERSONNE(
       idPersonne INT primary key, 
       nomPersonne TEXT,
       age INT); 
       
CREATE TABLE AMI(
       idPersonne1 INT, 
       idPersonne2 INT, 
       primary key (idPersonne1, idPersonne2), 
       foreign key (idPersonne1) 
       	       references Personne(idPersonne),
       foreign key (idPersonne2) 
       	       references Personne(idPersonne)
       ); 

CREATE TABLE FAMILLE (
       idPersonne1 INT, 
       idPersonne2 INT,
       primary key (idPersonne1, idPersonne2), 
       foreign key (idPersonne1) 
       	       references Personne(idPersonne),
       foreign key (idPersonne2) 
       	       references Personne(idPersonne)
);

insert into PERSONNE values (1, 'Elvia', 19);
insert into PERSONNE values (2, 'Farouk', 19);
insert into PERSONNE values (3, 'Sam', 19);
insert into PERSONNE values (4, 'Tiffany', 19);
insert into PERSONNE values (5, 'Nadia', 14);
insert into PERSONNE values (6, 'Chris', 12);
insert into PERSONNE values (7, 'Kris', 10);
insert into PERSONNE values (8, 'Bethany', 16);
insert into PERSONNE values (9, 'Louis', 17);
insert into PERSONNE values (10, 'Austin', 22);
insert into PERSONNE values (11, 'Gabriel', 21);
insert into PERSONNE values (12, 'Jessica', 20);
insert into PERSONNE values (13, 'John', 16);
insert into PERSONNE values (14, 'Alfred', 19);
insert into PERSONNE values (15, 'Samantha', 17);
insert into PERSONNE values (16, 'Craig', 17);

insert into AMI values (1, 3);
insert into AMI values (1, 2);
insert into AMI values (2, 4);
insert into AMI values (3, 9);
insert into AMI values (4, 9);
insert into AMI values (2, 6);
insert into AMI values (6, 7);
insert into AMI values (6, 10);
insert into AMI values (6, 13);
insert into AMI values (7, 5);
insert into AMI values (7, 8);
insert into AMI values (5, 8);
insert into AMI values (9, 11);
insert into AMI values (9, 12);
insert into AMI values (11, 12);
insert into AMI values (12, 15);
insert into AMI values (10, 15);
insert into AMI values (15, 13);
insert into AMI values (13, 16);
insert into AMI values (16, 14);

insert into FAMILLE values(2, 4);
insert into FAMILLE values(4, 2);
insert into FAMILLE values(6, 4);
insert into FAMILLE values(11, 9);
insert into FAMILLE values(9, 7);
insert into FAMILLE values(8, 7);
insert into FAMILLE values(10, 13);
insert into FAMILLE values(12, 15);
insert into FAMILLE values(15, 12);







/**********************************************************************************************/
/*1*/
select nomPersonne from PERSONNE where 
idPersonne in (select a.idPersonne1 from AMI a inner join PERSONNE p on p.idPersonne = a.idPersonne2 and p.nomPersonne = "Samantha")
or
idPersonne in (select a.idPersonne2 from AMI a inner join PERSONNE p on p.idPersonne = a.idPersonne1 and p.nomPersonne = "Samantha");




/*2*/
/********* amis jeunes d'elvia **********/
select nomPersonne,age from PERSONNE where
(
idPersonne in (select a.idPersonne1 from AMI a inner join PERSONNE p on p.idPersonne = a.idPersonne2 and p.nomPersonne = "Farouk")
or
idPersonne in (select a.idPersonne2 from AMI a inner join PERSONNE p on p.idPersonne = a.idPersonne1 and p.nomPersonne = "Farouk")
)
and age < (select age from PERSONNE where nomPersonne = "Farouk");

/********* amis jeunes tout les personnes **********/
select distinct p1.nomPersonne as "personne",p1.age,p2.nomPersonne as "amis jeunes",p2.age from PERSONNE p1 , PERSONNE p2
where 
(
p2.idPersonne in (select idPersonne2 from AMI where idPersonne1 = p1.idPersonne)
or
p2.idPersonne in (select idPersonne1 from AMI where idPersonne2 = p1.idPersonne)
)
and p1.age > p2.age group by p1.nomPersonne,p1.age,p2.nomPersonne,p2.age;




/*3*/
select distinct p.nomPersonne,p.age from PERSONNE p, AMI a where (p.idPersonne = a.idPersonne1 or p.idPersonne = a.idPersonne2)
and (select age from PERSONNE where idPersonne = a.idPersonne1) = (select age from PERSONNE where idPersonne = a.idPersonne2);




/*4*/
select  nomPersonne from PERSONNE where 
idPersonne in(
	select f.idPersonne1 from FAMILLE f group by f.idPersonne1 having  count(*) >= 2
)
or 
idPersonne in(
	select f.idPersonne2 from FAMILLE f group by f.idPersonne2 having  count(*) >= 2
)
or 
idPersonne in(
	select p.idPersonne  from Personne p group by  p.idPersonne having 
    (select count(idPersonne1) from FAMILLE where idPersonne1 =  p.idPersonne) = 1
    and 
    (select count(idPersonne2) from FAMILLE where idPersonne2 =  p.idPersonne) = 1
    and 
    (select idPersonne2 from FAMILLE where idPersonne1 =  p.idPersonne) <> (select idPersonne1 from FAMILLE where idPersonne2 =  p.idPersonne)
);

/*5*/
select p.nomPersonne  from Personne p where 
(select count(idPersonne1) from FAMILLE where idPersonne1 =  p.idPersonne) = 0
and 
(select count(idPersonne2) from FAMILLE where idPersonne2 =  p.idPersonne) = 0;




/*6*/
select p1.idPersonne,p1.nomPersonne,p2.idPersonne,p2.nomPersonne from PERSONNE p1, PERSONNE p2 , FAMILLE f 
where p1.idPersonne = f.idPersonne1 and p2.idPersonne = f.idPersonne2 and p1.idPersonne > p2.idPersonne
and not exists
(
		select idPersonne from PERSONNE ,AMI a where
        (
		(idPersonne = a.idPersonne1 and a.idPersonne2 = p1.idPersonne )
		or
		(idPersonne = a.idPersonne2 and a.idPersonne1 = p1.idPersonne )
        )
        and 
        idPersonne in 
        (
		select idPersonne from PERSONNE ,AMI a where 
		(idPersonne = a.idPersonne1 and a.idPersonne2 = p2.idPersonne )
		or
		(idPersonne = a.idPersonne2 and a.idPersonne1 = p2.idPersonne )
		)
);




/*7*/
select (select count(*) from PERSONNE)-(select count(*) from PERSONNE where age >= 21) as "différence" ;



/*8*/
select nomPersonne  from PERSONNE p where 
(
	select count(*) from PERSONNE ,AMI a where
	(
	(idPersonne = a.idPersonne1 and a.idPersonne2 = p.idPersonne )
	or
	(idPersonne = a.idPersonne2 and a.idPersonne1 = p.idPersonne )
	)
	
) > 0
and 
(
	select count(*) from PERSONNE ,FAMILLE f where
	(
	(idPersonne = f.idPersonne1 and f.idPersonne2 = p.idPersonne )
	or
	(idPersonne = f.idPersonne2 and f.idPersonne1 = p.idPersonne )
	)
	
) > 0;




/*9*/
select nomPersonne , (
	select count(*) from PERSONNE ,AMI a where
	(
		(idPersonne = a.idPersonne1 and a.idPersonne2 = p.idPersonne )
		or
		(idPersonne = a.idPersonne2 and a.idPersonne1 = p.idPersonne )
	)
    /
    (select sum(countP) from
	(
		select count(idPersonne) as countP from PERSONNE ,AMI a 
        where idPersonne = a.idPersonne1 or idPersonne = a.idPersonne2 group by idPersonne
	) as PersonneCount)
    
) as "moyenne d'amis" from PERSONNE p;




/*10*/
select
(
	(
		select count(*) from PERSONNE ,AMI a where
		(
			(idPersonne = a.idPersonne1 and nomPersonne = "Tiffany" )
			or
			(idPersonne = a.idPersonne2 and nomPersonne = "Tiffany" )
		)
    )
	+
	(
		select count(*) from PERSONNE ,AMI where 
		(
        idPersonne in (select a.idPersonne1 from PERSONNE ,AMI a where (idPersonne = a.idPersonne2 and nomPersonne = "Tiffany" ))
		or 
		idPersonne in (select a.idPersonne2 from PERSONNE ,AMI a where (idPersonne = a.idPersonne1 and nomPersonne = "Tiffany" ))
        )
        and (idPersonne1 = idPersonne or idPersonne2 = idPersonne) 
        and idPersonne1 <> (select idPersonne from PERSONNE where nomPersonne = "Tiffany")
        and idPersonne2 <> (select idPersonne from PERSONNE where nomPersonne = "Tiffany")
	)

) as "nobmre pr amis Tiffany";




/*11*/
select nomPersonne ,age from PERSONNE p
where
(
	(
		select count(*) from PERSONNE ,AMI a where
		(
			(idPersonne = a.idPersonne1 and a.idPersonne2 = p.idPersonne )
			or
			(idPersonne = a.idPersonne2 and a.idPersonne1 = p.idPersonne )
		)
    )
    =
    (
		select max(countP) from
		(
			select count(idPersonne) as countP from PERSONNE ,AMI a 
			where idPersonne = a.idPersonne1 or idPersonne = a.idPersonne2 group by idPersonne
		) as PersonneCount
    )
);




/*12*/
select distinct p1.nomPersonne as "personne",p2.nomPersonne as "famille de cette personne" from PERSONNE p1 , PERSONNE p2
where 
(
p2.idPersonne in (select idPersonne2 from FAMILLE where idPersonne1 = p1.idPersonne)
or
p2.idPersonne in (select idPersonne1 from FAMILLE where idPersonne2 = p1.idPersonne)
or
p2.idPersonne in
(
	select distinct pb.idPersonne  from PERSONNE pa , PERSONNE pb
	where 
	(
		pb.idPersonne in (select idPersonne2 from FAMILLE where idPersonne1 in (select idPersonne2 from FAMILLE where idPersonne1 = p1.idPersonne))
		or
		pb.idPersonne in (select idPersonne1 from FAMILLE where idPersonne2 in (select idPersonne2 from FAMILLE where idPersonne1 = p1.idPersonne))
    )
 )
or
p2.idPersonne in 
(
	select distinct pb.idPersonne  from PERSONNE pa , PERSONNE pb
	where 
	(
		pb.idPersonne in (select idPersonne2 from FAMILLE where idPersonne1 in (select idPersonne1 from FAMILLE where idPersonne2 = p1.idPersonne))
		or
		pb.idPersonne in (select idPersonne1 from FAMILLE where idPersonne2 in (select idPersonne1 from FAMILLE where idPersonne2 = p1.idPersonne))
    )
)
)
and p1.idPersonne <> p2.idPersonne
group by p1.nomPersonne,p2.nomPersonne;




/*13*/
select 
CONCAT("Nom : ",p1.nomPersonne,"  Age : ",p1.age) as "personne 1" ,
CONCAT("Nom : ",p2.nomPersonne,"  Age : ",p2.age) as "personne 2" ,
CONCAT("Nom : ",p3.nomPersonne,"  Age : ",p3.age) as "personne 3"  
from PERSONNE p1,PERSONNE p2,PERSONNE p3
where p1.age > p2.age and p2.age > p3.age
group by p1.nomPersonne,p2.nomPersonne,p3.nomPersonne;




/*14*/
select nomPersonne  from PERSONNE p where 
(
	select count(*) from PERSONNE ,AMI a where
	(
	(idPersonne = a.idPersonne1 and a.idPersonne2 = p.idPersonne )
	or
	(idPersonne = a.idPersonne2 and a.idPersonne1 = p.idPersonne )
	)
	
) = 0
and 
(
	select count(*) from PERSONNE ,FAMILLE f where
	(
	(idPersonne = f.idPersonne1 and f.idPersonne2 = p.idPersonne )
	or
	(idPersonne = f.idPersonne2 and f.idPersonne1 = p.idPersonne )
	)
	
) = 1 ;


/******************************************************************************************************************/



















