create database Hollywood_2;

use Hollywood_2;

create table Film(
idFilm int auto_increment primary key,
titre varchar(30) not null,
realisateur varchar(30) not null,
anne year
);

create table Acteur(
idActeur int auto_increment primary key,
nom varchar(30) not null
);


create table Filmographie(
idActeur int,
idFilm int,
rool varchar(30),
salaire smallint,
FOREIGN KEY (idActeur) REFERENCES  Acteur(idActeur),
FOREIGN KEY (idFilm) REFERENCES  Film(idFilm),
primary key(idActeur,idFilm)
);


insert into Film(titre,realisateur,anne)values('Les évades','Darabont','1994'),('Le Parrain','Copola','1972'),('Le Parrain2','Copolla','1974'),
("L'odyssée de pi",'Ang lee','2013'),('Chocolat','hallstrom','2000'),('Scaface','Da palma','1983'),('Rango','Verbinski','2011');

insert into Acteur(nom)values('johny Deep'),('AL Pacino'),('Suraj Sharma'),('Suraj Sharma'),('Brad Pitt'),('Edward Norton');

insert into Filmographie(idActeur,idFilm,rool,salaire)values(1,5,'Roux',5000),(1,7,'Rango',10000),(2,2,'Micheal Corleone',10000),(2,3,'Micheal Corleone',20000),(2,6,'Tony Montana',15000),(3,4,'PI',20000);



/*1*/
select f.titre from Film f inner join Filmographie fg on f.idFilm = fg.idFilm 
inner join Acteur a on a.idActeur = fg.idActeur where a.nom ='johny Deep';

/*2*/
select f.anne,fg.rool from Film f inner join Filmographie fg on f.idFilm = fg.idFilm 
inner join Acteur a on a.idActeur = fg.idActeur where a.nom ='johny Deep';

/*3*/
select f.titre, f.anne from Film f where realisateur = (select  realisateur from Film where titre = 'Le Parrain');

/*4*/
select * from film where titre like 'Le%'  or titre like '%de%';

/*5*/
select * from film order by anne desc;

/*6*/
select count(*)as "Nombre acteur" from Filmographie fg , Film f where f.idFilm = fg.idFilm and f.titre = "L'odyssée de pi";

/*7*/
select idActeur,nom from Acteur where idActeur not in (select distinct  idActeur from Filmographie);

/*8*/
select distinct a.nom ,(select sum(salaire)/count(idActeur) from Filmographie where idActeur = a.idActeur )as"Moyenne" from Acteur a , Filmographie fg where a.idActeur = fg.idActeur ;

/*9*/ 
select distinct  CONCAT(a1.nom," - ",a2.nom) as "paires"  from  Filmographie fg1 ,Filmographie fg2 ,Acteur a1 ,Acteur a2
 where fg1.idActeur = a1.idActeur and fg2.idActeur = a2.idActeur  
 and  fg1.idActeur <> fg2.idActeur and fg1.idActeur > fg2.idActeur 
 and fg1.salaire = fg2.salaire;
 
/*10*/
select salaire*9 as "salaire en dirhams" from Filmographie;
 




