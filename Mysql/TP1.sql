create database Hollywood;

use Hollywood;

create table Film(
idFilm int auto_increment primary key,
titre varchar(30) not null
);
insert into Film(titre)values('Les évades'),('Le Parrain'),('La vie d PI');
select *from film;

insert into Film(titre)values('Chocolat'),('Scarface'),('Rango');
select *from film;
select titre from film;

create table Acteur(
idActeur int auto_increment primary key,
nom varchar(30) not null,
prenom varchar(30) not null
);


insert into Acteur(nom,prenom)values('Deep','johny'),('Pacino','AL'),('Sharma','Suraj');
select nom from Acteur;


create table Filmographie(
idActeur int,
idFilm int,
FOREIGN KEY (idActeur) REFERENCES  Acteur(idActeur),
FOREIGN KEY (idFilm) REFERENCES  Film(idFilm),
primary key(idActeur,idFilm)
);

insert into Filmographie(idActeur,idFilm)values(1,4),(1,6),(2,2),(3,3);


