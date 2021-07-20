create database EmpDept

use EmpDept

create table Client (
numC smallint identity primary key ,
nom varchar(20),
prenom  varchar(20),
adress varchar(50),
numEmp smallint ,
)
create table Emp (
numEmp smallint identity primary key ,
nom varchar(20),
prenom varchar(20),
salaire smallint ,
prime tinyint ,
numDept smallint ,
)
create table Dept (
numDept smallint identity primary key ,
libelle varchar(20),
chef smallint,
)
---------------------constraint-------------------------
alter table Client
add constraint FK_numClient foreign key (numEmp) references Emp(numEmp)
alter table Emp
add constraint FK_numEmp foreign key (numDept) references Dept(numDept)
alter table Dept
add constraint FK_chef foreign key (chef) references Emp(numEmp)

---------------------insertion des valeurs---------------------------------
insert into Client (nom,prenom,adress) values ('anass','talbi','a54')
insert into Client (nom,prenom,adress)values ('omar','degh','ar68')
insert into Client (nom,prenom,adress)values ('faraji','hicham','y65')
insert into Client (nom,prenom,adress)values ('med','khonji','u45')

---------------------------------------------------------------------------
insert into Emp (nom,prenom,salaire,prime)values ('amali','hosam',15000,100)
insert into Emp (nom,prenom,salaire,prime)values ('malika','ngin',16000,200)
insert into Emp (nom,prenom,salaire,prime)values ('jihane','ngin',16000,200)
insert into Emp (nom,prenom,salaire,prime)values ('talbi','jalal',13000,150)
insert into Emp (nom,prenom,salaire,prime)values ('hanane','karmo',11000,90)
--------------------------------------------------------------------------

insert into Dept (libelle)values('devlopement')
insert into Dept (libelle)values('mecatronique')
insert into Dept (libelle)values('electronic')
----------------------------------------------------------------------------

                      --- 1 = procedure  = get info 
create proc getinfo @n int 
as
 begin 
     
       select nom , prenom , salaire,prime , libelle  from Emp e left outer  join  Dept d on e.numDept = d.numDept  where e.numEmp = @n
 end
 Exec getinfo 1
                     ----2 procedure = get nbr
----------------------idee--------------------------------
select  nom , prenom ,salaire from Emp order by salaire desc
select COUNT(numEmp) from Emp
----------------------------------------------------------
create proc getnbr @nbr int
as
  begin
  if(@nbr != 0 and @nbr <=4)begin 
           ---------------declaration des variables-----------------------------------------------------------------------
		   declare @nom varchar(20)
		   declare @prenom varchar(20)
		   declare @salaire int
		   declare @numEmp int
		   declare @cmp int 
		   set @cmp = 1
		   declare @helptable table (numEmp int,nom varchar(20),prenom varchar(20),salaire int)
          ---------------------------declaration d un cursor qui va insert les employee avec order by ---------------------
		  declare c cursor  for select numEmp, nom , prenom ,salaire from Emp  order by salaire desc 
		  open c 
		       fetch next from c  into @numEmp , @nom ,@prenom,@salaire
			       while @@FETCH_STATUS = 0 begin  
				                                   if(@cmp <= @nbr)
												   insert into @helptable values (@numEmp,@nom,@prenom,@salaire)  
												   fetch next from c  into @numEmp,@nom ,@prenom,@salaire
												   set @cmp = @cmp + 1 
				                            end 
		  close c
		  deallocate c
		  --------------------------------------------------------------------------------------------------------------------
		  ---------------------------- affichage des employee-----------------------------------------------------------------
		  select * from @helptable

       end else begin select ERROR_MESSAGE() end
  end
  select * from Emp
  exec getnbr 2
 ---- drop proc getnbr

  -------------------------- 3  procedure de deppartement ----------------------------------
  ----------------------------idee----------------------------------------------------------
   select libelle, nom, prenom from Dept d inner join Emp e on d.numDept = e.numDept 
   select nom from Emp
  ------------------------------------------------------------------------------------------
  create proc PS 
  as 
          -------------------declaration des variables-----------------------------------
		  declare @libelle varchar(50)
		  declare @numDept smallint
		  declare @deptnum smallint 
		  declare @nom varchar(20)
		  declare @prenom varchar(20) 
		  set @deptnum = 1 
		  begin
		         declare loopdept cursor  for select libelle , numDept from Dept 
				 open loopdept
				       fetch next from loopdept into @libelle , @numDept
					   while @@FETCH_STATUS = 0 
										begin 
										   select @libelle as 'departement : '
										       declare loopemp cursor for select nom,prenom ,numDept from Emp
											   open loopemp 
											         fetch next from loopemp into @nom,@prenom,@numDept
													    while @@FETCH_STATUS = 0 
																 begin
																  if(@deptnum = @numDept)begin select @nom as 'nom' ,@prenom as 'prenom'   end
																  fetch next from loopemp into @nom,@prenom,@numDept
																 end
																 close loopemp
																 deallocate loopemp
                                                       set @deptnum = @deptnum +1 
                                           fetch next from loopdept into @libelle , @numDept
					      
										end
			      close loopdept
				  deallocate loopdept

			    
		  end

		exec PS

		------------------------procedure add starts *** ----------------------------------------------
		
		alter table Emp
		add STARS varchar(50)
		create proc addStars
		as
				begin
				      declare @cmp smallint
					  declare @salaire int
					  declare @STARS varchar(50)
					  declare @nom varchar(20)
		              declare @prenom varchar(20)
					  declare @numEmp smallint 
					  set @numEmp = 0
					  declare loopemp cursor for select numEmp, nom ,prenom , salaire from Emp
					  open loopemp 
					          fetch next from loopemp into @numEmp, @nom ,@prenom,@salaire
							  while @@FETCH_STATUS = 0
										 begin 
										      set @cmp = 0 
											  set @STARS = ''
											  while (@cmp <= @salaire / 1000)begin set @STARS = @STARS +'*' set @cmp += 1  end
											  update Emp  set STARS = @STARS  where numEmp = @numEmp
											  fetch next from loopemp into @numEmp, @nom ,@prenom,@salaire
										 end
										  select * from Emp
				       close loopemp
					   deallocate loopemp
		           
				end

				select * from Emp
				exec addStars
			drop proc addStars 

-------------------------------------------------------------------------------------------------------------------
---------------------------------procedure afficher nb emp qui travaille dans chaque dappartement ------------------

create proc PSDept @n int ,@pp int output 
as                       
                        
						declare @numDept int
						declare @cmp int	
						set @cmp = 0
						begin
						     if(@n = 0 or @n > 4)begin set @pp = 1 end
						     declare c cursor for select numDept  from Emp 
							 open c 
							 fetch next from c into @numDept  
							 while @@FETCH_STATUS = 0 
							 begin
									 if(@n = @numDept)begin 
									  set @cmp = @cmp + 1 
									  set @pp = 2
									  end

									 fetch next from c into @numDept 
							 end

							 close c 
							 deallocate c
							 
							 select @cmp  as 'nombre d employee dans ce departement' ,@pp as 'return'
							 
						end

DECLARE @p  int 
exec PSDept 3 , @p output
drop proc PSDept

go
-------------------------------------------------------les fonctions------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
----1-----
create function DrE (@numdept smallint)
returns table 
as
return (select nom , prenom from Emp where numDept = @numdept)
go

select * FROM EmpDept.dbo.DrE(1)

go
----2----
create function rS ()
returns int
as
begin
return (select max(salaire) from Emp)
end
go

DECLARE @R int
set @R = EmpDept.dbo.rS()
select @R
go
----3----
create function rRevnu(@numEmp smallint)
returns int 
as
begin
      declare @salaire smallint
	  declare @prime smallint
	  declare @revenu smallint

         declare c cursor for select salaire , prime from Emp where @numEmp = numEmp
		 open c
		 fetch next from c into @salaire ,@prime
		 while @@FETCH_STATUS =0
						 begin
						 fetch next from c into @salaire ,@prime
						 set @revenu = @salaire + @prime 	
						 end
		 close c
		 deallocate c
		 return(@revenu)
end 

return 

go

    declare @revenu smallint 
	set @revenu = EmpDept.dbo.rRevnu(1)
	select @revenu
go
-----4-----

DECLARE @R int
set @R = EmpDept.dbo.rS()
select *from Emp where EmpDept.dbo.rS()= Emp.salaire

----5----
go





----6----
go





go

