create database EFM
USE EFM
--1--
create table stagiaire (IdStg smallint primary key identity, Nom varchar(20), prenom varchar(20),idf smallint foreign key references filiere(idf) , tAbs smallint) 
create table filiere(idf smallint primary key identity ,nomF varchar(20))
create table module(idm smallint primary key identity,nomM varchar(20),NBHeure smallint )
create table fil_modul(idf smallint foreign key references filiere(idf),idm smallint foreign key references module(idm),primary key ( idf,idm ))
create table absence(idabs smallint primary key identity ,dateabs date ,IdStg smallint foreign key references stagiaire (IdStg),idm smallint foreign key references module(idm) ,typABS varchar(20))


--2--
alter table module 
add constraint c1 check(NBheure >0 )



--3--
select count(*)as'nombre abs' from stagiaire s inner join absence a on a.IdStg=s.IdStg group by s.IdStg


--4--
select sum(m.NBHeure) as'nombre heure total' from module m inner join fil_modul fm on m.idm =fm.idm inner join filiere f on f.idf = fm.idf where f.nomF='tdi'


--5--
go
create proc NBabsence @idstg smallint , @d1 date ,@d2 date
as
begin
select count(*)as'nombre abs' from stagiaire s inner join absence a on a.IdStg=s.IdStg where s.idstg = @idstg and a.dateabs between @d1 and @d2
end





--6--
go
create proc nbABS_nonJ @nomf varchar(20)
as
begin

select s.IdStg, count(*) as'nombre abs' from stagiaire s inner join filiere f on f.idf =s.idf inner join  absence ab on ab.IdStg=s.IdStg where f.nomF=@nomf and ab.typABS ='non justifièe' group by s.IdStg

end
exec nbABS_nonJ 'tdi'





--7--
go
create trigger tri1
on absence for insert
as
begin
begin tran tr
declare @idstg smallint ,@idm smallint
set @idstg =(select IdStg from inserted)
set @idm =( select idm from inserted )

if ( @idm not in (select fl.idm from  stagiaire s inner join   fil_modul fl  on fl.idf = s.idf where s.IdStg=@idstg))
 rollback tran 
else
commit tran tr 
end




--8--
go
create trigger tri2
on absence for insert
as 
begin
declare @idstg smallint
set @idstg =(select IdStg from inserted)
 update stagiaire set tAbs = tAbs+1 where IdStg=@idstg
end




--9--
go
Create Function funcalc (@idStagiaire int)
Returns int
As
Begin
 Declare @n int, @resultat int
 Select @n=( select count(idabs) From absence Where IdStg=@idStagiaire and typABS= 'non justifiée')
 Set @resultat = 20 - @n
 If @resultat < 0
 Set @resultat =0
 Return @resultat
End




--10--
go
Create procedure limteAbs @idModule int
As
begin
Declare @limite decimal
Select @limite = 0.3 * NBHeure From Module Where idm=@idModule
Select nom,prenom From Stagiaire S inner join absence A ON S.IdStg=A.IdStg Where
idm=@idModule Having 2.5*count(idabs) > @limite
end



--11--
Select distinct S.nom, S.prenom From Stagiaire S, absence A1, Absence A2 Where A1.IdStg=
S.IdStg and A2.IdStg= S.IdStg and A2.dateabs > A1.dateAbs and DATEDIFF(day,A1.dateabs, A2.dateabs) <= 15


