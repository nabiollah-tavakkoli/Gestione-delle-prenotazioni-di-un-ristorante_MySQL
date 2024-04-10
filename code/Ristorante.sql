####################################################################################
####                             Creazione database                             ####
####################################################################################

DROP DATABASE IF EXISTS Ristorante;
CREATE DATABASE IF NOT EXISTS Ristorante;
USE Ristorante;

/*per evitare l'errore di INSERT si usa: set global local_infile=true;*/

-- Se ci sono i VdIR , i DROP vengono fatti in modo BOTTOM_UP

DROP TABLE IF EXISTS Ordinazione;
DROP TABLE IF EXISTS Prenotazionie;
DROP TABLE IF EXISTS Tavolo;
DROP TABLE IF EXISTS Telefono;
DROP TABLE IF EXISTS Cameriere; 
DROP TABLE IF EXISTS Menu;
DROP TABLE IF EXISTS Cliente;

CREATE TABLE IF NOT EXISTS Cliente(
Codice_fiscale VARCHAR(20) PRIMARY KEY,
Nome VARCHAR(20) NOT NULL,
Cognome VARCHAR(20) NOT NULL
)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS Menu(
Alimento VARCHAR(30) PRIMARY KEY,
Prezzo DOUBLE,
Kcal INT,
Descrizione VARCHAR(60),
Portata ENUM('Antipasto','Primo','Secondo','Contorno','Dessert','Bevanda')
)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS Cameriere(
IdCameriere SMALLINT AUTO_INCREMENT PRIMARY KEY,
Nome VARCHAR(20),
Cognome VARCHAR(20),
Stipendio DOUBLE,
PartTime BOOLEAN
)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS Telefono(
Numero INT(20) PRIMARY KEY,
IdCameriere SMALLINT,
FOREIGN KEY (IdCameriere) REFERENCES Cameriere(IdCameriere) ON UPDATE CASCADE ON DELETE CASCADE
)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS Tavolo(
CodTavolo CHAR(2) PRIMARY KEY,
NumPosti INT,
IdCameriere SMALLINT,
FOREIGN KEY (IdCameriere) REFERENCES Cameriere(IdCameriere) ON UPDATE CASCADE ON DELETE CASCADE
)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS Prenotazione(
CodTavolo CHAR(2) ,
Data DATE,
FasciaOraria ENUM('12:00-13:00','13:30-14:30','20:00-21:00','21:30-22:30','23:00-24:00'),
Codice_fiscale VARCHAR(20) NOT NULL,
PRIMARY KEY(Data , FasciaOraria , CodTavolo),
FOREIGN KEY (CodTavolo) REFERENCES Tavolo(CodTavolo) ON UPDATE CASCADE ,
FOREIGN KEY (Codice_fiscale) REFERENCES Cliente(Codice_fiscale) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS Ordinazione(
CodTavolo CHAR(2),
Alimento VARCHAR(30),
Data DATE,
FasciaOraria ENUM('12:00-13:00','13:30-14:30','20:00-21:00','21:30-22:30','23:00-24:00'),
Quantita INT,
Note VARCHAR(40),
PRIMARY KEY(Alimento , Data , FasciaOraria , CodTavolo),
FOREIGN KEY (Alimento) REFERENCES Menu(Alimento) ON UPDATE CASCADE,
FOREIGN KEY (Data , FasciaOraria) REFERENCES Prenotazione(Data , FasciaOraria) ON UPDATE CASCADE,
FOREIGN KEY (CodTavolo) REFERENCES Tavolo(CodTavolo) ON UPDATE CASCADE
)ENGINE=INNODB;



####################################################################################
###                                 Popolamento                                  ###
####################################################################################
set global local_infile = 1;

LOAD DATA LOCAL INFILE 'DatiCliente.txt'
INTO TABLE Cliente 
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '$'
LINES TERMINATED BY '\n'
IGNORE 4 LINES;

select* from Cliente;

# LOCAL DATA INFILE 'DatiMenu.in' into table Menu;
INSERT INTO Menu VALUES 
('Polpette di melanzane', 8.00, 250, 'Pangrattato, Melanzane, Uova, Aglio, Olio di semi', 'Antipasto'),
('Mozzarella in carrozza', 5.00, 300, 'Mozzarella di bufala, Pane bianco in cassetta, Uova', 'Antipasto'),
('Patate al forno', 5.00, 350, 'Patate, Rosmarino, Aglio, Olio extravergine di oliva', 'Contorno'),
('Genovese', 10.00, 250, 'Ziti, Manzo, Vino bianco, Sedano, Cipolle dorate', 'primo'),
('Canederli alla tirolese', 20.00, 700, 'Pane raffermo, Speck, Uova, Cipolle bianche, Burro', 'primo'),
('Mandilli de saea', 8.00, 300, 'Fazzoletti di Seta conditi con pesto genovese', 'primo'),
('Spaghetti alle vongole', 18.00, 400, 'Spaghetti, Vongole, Aglio, Prezzemolo', 'primo'),
('Chili con carne', 15.00, 350, 'Manzo, Brodo di carne, Passata di pomodoro, Fagioli neri', 'secondo'),
('Cotoletta alla palermitana', 8.00, 375, 'Petto di pollo, Pangrattato, Pecorino, Prezzemolo', 'secondo'),
('Tiramisù', 15.00, 250, 'Savoiardi, Uova, Mascarpone, Caffè, Cacao amaro', 'Dessert'),
('Torta tenerina', 17.00,350, 'Cioccolato fondente, Burro, Uova, Zucchero, Zucchero a velo', 'Dessert'),
('Acqua', 1.00, 0, null, 'Bevanda'),
('Brunello', 5.00, 35, 'Vino rosso', 'Bevanda'),
('Gewürztraminer', 5.00,45, 'Vino binaco', 'Bevanda');
select* from Menu;

INSERT INTO Cameriere (Nome, Cognome, Stipendio, PartTime) VALUES
('Paola', 'Rosalti', 2000.00, true),
('Mario', 'Rossi', 2000.00, true),
('Carlo', 'Bianchi', 1500.00, false),
('Maria', 'Bini', 1500.00, false);
select* from Cameriere;


LOAD DATA LOCAL INFILE 'DatiTelefono.in'
INTO TABLE Telefono 
FIELDS TERMINATED BY '-'
OPTIONALLY ENCLOSED BY '|'
LINES TERMINATED BY '\n'
IGNORE 4 LINES;

select* from Telefono;

LOAD DATA LOCAL INFILE 'DatiTavolo.txt'
INTO TABLE Tavolo 
FIELDS TERMINATED BY '-'
LINES TERMINATED BY '\n'
IGNORE 4 LINES;

select* from Tavolo;

INSERT INTO Prenotazione VALUES
('01','2021-06-06','12:00-13:00', 'ABC1'),
('02','2021-08-07','13:30-14:30', 'ABC2'),
('03','2021-06-07','20:00-21:00', 'ABC3'),
('04','2021-07-08','21:30-22:30', 'XYZ1'),
('05','2021-05-09','23:00-24:00', 'XYZ2'),
('08','2021-05-09','23:00-24:00', 'XYZ3');
select* from Prenotazione;

INSERT INTO Ordinazione values
('01', 'Canederli alla tirolese','2021-06-06','12:00-13:00', 2, null),
('01','Brunello','2021-06-06','12:00-13:00', 2, null),
('02', 'Polpette di melanzane','2021-08-07','13:30-14:30', 1, 'senza olio di semi'),
('02', 'Mozzarella in carrozza','2021-08-07','13:30-14:30', 1, null),
('02', 'Patate al forno','2021-08-07','13:30-14:30', 1, null),
('02', 'Genovese','2021-08-07','13:30-14:30', 1, null),
('02', 'Brunello','2021-08-07','13:30-14:30', 2, null),
('02', 'Acqua','2021-08-07','13:30-14:30', 2, 'Fredda'),
('03', 'Canederli alla tirolese','2021-06-07','20:00-21:00', 2, null),
('03', 'Spaghetti alle vongole','2021-06-07','20:00-21:00', 1, null),
('03', 'Tiramisù','2021-06-07','20:00-21:00', 1, null),
('03', 'Acqua','2021-06-07','20:00-21:00', 1, 'Fredda'),
('03', 'Gewürztraminer','2021-06-07','20:00-21:00', 2, null),
('04', 'Cotoletta alla palermitana','2021-07-08','21:30-22:30', 1, null),
('04', 'Mandilli de saea','2021-07-08','21:30-22:30', 1, null),
('04', 'Genovese','2021-07-08','21:30-22:30', 1, null),
('04', 'Torta tenerina','2021-07-08','21:30-22:30', 1, null),
('04', 'Acqua','2021-07-08','21:30-22:30', 1, 'Fredda'),
('04', 'Brunello','2021-07-08','21:30-22:30', 2, null),
('05', 'Chili con carne','2021-05-09','23:00-24:00', 1, null),
('05', 'Patate al forno','2021-05-09','23:00-24:00', 1, null),
('05', 'Acqua','2021-05-09','23:00-24:00', 2, 'Una Fredda l''altra Frizzante'),
('08', 'Chili con carne','2021-05-09','23:00-24:00', 1, null),
('08', 'Patate al forno','2021-05-09','23:00-24:00', 1, null),
('08', 'Canederli alla tirolese','2021-05-09','23:00-24:00', 2, null),
('08', 'Spaghetti alle vongole','2021-05-09','23:00-24:00', 1, null),
('08', 'Acqua','2021-05-09','23:00-24:00', 2, 'Fredda'),
('08', 'Brunello','2021-05-09','23:00-24:00', 2, null);
select* from Ordinazione;

####################################################################################
####                                Interrogazioni                             #####
####################################################################################

# 1_Contare il numero dei 'Primi' Ordinati dai clienti
-- SENZA exists
select O.Alimento, Portata, quantita from Menu M natural join Ordinazione O where Portata = 'Primo';
select SUM(quantita) as Total_PRIMI from Menu M natural join Ordinazione O where Portata = 'Primo';

-- CON exists
SELECT sum(Quantita) AS Total_PRIMI FROM Ordinazione AS O WHERE EXISTS (SELECT * FROM Menu AS M WHERE O.Alimento = M.Alimento AND Portata = 'Primo');


--------------------------------------------------------------------------------------------
# 2_Trovare CodTavolo , Alimento , Quantità del Ordinazione con il PrzCopertoUnitario più alto
create view PrezziUnitari as
select codTavolo , SUM(quantita * prezzo) as PrzCopertoUnitario from Ordinazione natural join Menu 
group by CodTavolo order by CodTavolo;

select * from  PrezziUnitari;

select CodTavolo, Alimento, quantita from Ordinazione where CodTavolo not in 
(select CodTavolo from PrezziUnitari where PrzCopertoUnitario < 
(select max(PrzCopertoUnitario) from  PrezziUnitari));



--------------------------------------------------------------------------------------------
# 3_ Tramite l'uso di una Procedura
-- Dato il 'codice Fiscale ' del Cliente stampare lo SCONTRINO contenente il codice del tavolo , gli Alimenti ordinati con quantita e prezzo (per ciascuno),  e il Prezzo Totale da pagare
DELIMITER $$
DROP PROCEDURE IF EXISTS Scontrino $$
CREATE PROCEDURE Scontrino(IN cf VARCHAR(20), OUT total DOUBLE)
BEGIN

DECLARE temp INT;
select PrzCopertoUnitario into Temp from Cliente C natural join Prenotazione natural join PrezziUnitari where C.codice_fiscale = cf;

select codice_fiscale, CodTavolo, Alimento, quantita, Prezzo
from  Ordinazione natural join Prenotazione natural join Cliente C natural join Menu
where C.codice_fiscale = cf;

SET total = temp;
END $$
DELIMITER ;

CALL Scontrino('ABC1',@m);
SELECT @m AS Totale_in_Euro;

CALL Scontrino('ABC2',@m);
SELECT @m AS Totale_in_Euro;

CALL Scontrino('ABC3',@m);
SELECT @m AS Totale_in_Euro;

--------------------------------------------------------------------------------------------
# 4_ Tramite l'uso di una Procedura
-- Dato il 'codice Fiscale ' del Cliente stampare lo SCONTRINO contenente il codice del tavolo , gli Alimenti ordinati (separati dalla virgola) con quantita  e il Prezzo Totale da pagare
DELIMITER $$
DROP PROCEDURE IF EXISTS Scontrino2 $$
CREATE PROCEDURE Scontrino2(IN cf VARCHAR(20))
BEGIN

DECLARE temp INT;
select PrzCopertoUnitario into Temp from Cliente C natural join Prenotazione natural join PrezziUnitari where C.codice_fiscale = cf;

select codice_fiscale, CodTavolo, group_concat(Alimento , ' ( ', quantita ,' )' order by Alimento separator ' , ' ) as Alimenti_Ordinati, PrzCopertoUnitario as Totale_in_Euro
from  Ordinazione natural join PrezziUnitari natural join Prenotazione natural join Cliente C natural join Menu
where C.codice_fiscale = cf;

END $$
DELIMITER ;

CALL Scontrino2('ABC1');
CALL Scontrino2('ABC2');
CALL Scontrino2('ABC3');

--------------------------------------------------------------------------------------------
# 5_ Tramite l'uso di una Procedura
-- Stampare tutti gli Alimenti con Kcal < 'n' e Prezzo < 'pre'
DELIMITER $$
DROP PROCEDURE IF EXISTS AlimentoConKcalBasso $$
CREATE PROCEDURE AlimentoConKcalBasso(IN Pre DOUBLE , IN n Double)
COMMENT 'Restituisce Alimenti con Kcal e Prezzo richiesto'

BEGIN
DECLARE a varchar(30) ;
DECLARE cal DOUBLE DEFAULT 0 ;

SELECT COUNT(*) INTO cal 
FROM Menu WHERE Prezzo < pre AND  Kcal < n;

  IF(cal!=0) 
   THEN SELECT *
   FROM Menu WHERE Prezzo < pre AND  Kcal < n order by Kcal  , Prezzo ASC;
  ELSE SELECT 'Non esiste' AS Result;
  END IF;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS AlimentoConKcalBasso;
CALL AlimentoConKcalBasso(20,400);
CALL AlimentoConKcalBasso(20,250);

--------------------------------------------------------------------------------------------
# 6_ Tramite l'uso di Funzione
-- Dato 'IdCameriere' , Aumentare lo stipendio del cameriere corrispondente di 10% se è partTime, altrimenti 20%
DELIMITER $$
DROP FUNCTION IF EXISTS Raise $$
CREATE FUNCTION Raise(Id INT)
RETURNS VARCHAR(20)
DETERMINISTIC

BEGIN
DECLARE msg VARCHAR(20) ;
DECLARE pt INT ;
DECLARE salario DOUBLE DEFAULT 0 ;

SELECT PartTime INTO pt 
FROM Cameriere WHERE IdCameriere = Id;

SELECT Stipendio INTO salario 
FROM Cameriere WHERE IdCameriere = Id;

  IF(pt!=0) THEN 
   UPDATE Cameriere SET Stipendio = salario *1.1 WHERE IdCameriere = Id;
   SET msg = CONCAT('Nuovo salario = ', salario *1.1);
  ELSE 
   UPDATE Cameriere SET Stipendio = salario *1.2 WHERE IdCameriere = Id;
   SET msg = CONCAT('Nuovo salario = ', salario *1.2);
  END IF;
  
  RETURN msg;
END $$
DELIMITER ;

SELECT Raise(2) as nouvo_salario;
SELECT Raise(4) as nouvo_salario;

 --------------------------------------------------------------------------------------------
# 7_ Tramite l'uso di una Procedura
-- Trovare la lista degli Alimenti non ordinati e ordinati in un dato giorno
DELIMITER $$
DROP PROCEDURE IF EXISTS AlimentiDiUnGiorno $$
CREATE PROCEDURE AlimentiDiUnGiorno(d date)

BEGIN

declare temp varchar(255);
declare temp2 varchar(255);

create table Alimenti (
Non_ordinati VARCHAR(255),
Ordinati VARCHAR(255)
)ENGINE=INNODB;

select group_concat(Alimento order by Alimento separator ' ,\n') into temp 
from Menu where Alimento not in(select Alimento from Ordinazione where data = d);

select group_concat(Distinct Alimento order by Alimento separator ' ,\n') into temp2
from Ordinazione where data = d;

insert into Alimenti values (temp, temp2);

select * from Alimenti;
drop table Alimenti;
END $$
DELIMITER ;

call AlimentiDiUnGiorno('2021-05-09');
call AlimentiDiUnGiorno('2021-08-07');

--------------------------------------------------------------------------------------------
# 8_Tramite l'uso di una vista,
-- trovare i piatti che sono stati ordinati in maggiore quantità(con e senza usare le funzioni aggregate)
CREATE VIEW OrdinatiDiPiù 
AS SELECT Alimento as Alimento2, quantita as quantita2 FROM Ordinazione ;

SELECT distinct Alimento , quantita FROM Ordinazione
WHERE quantita NOT IN 
(SELECT quantita FROM Ordinazione join OrdinatiDiPiù on quantita < quantita2);

-- Con le funzioni aggregate
SELECT distinct Alimento, quantita from Ordinazione 
where quantita = (SELECT max(quantita) FROM Ordinazione)
order by Alimento;

--------------------------------------------------------------------------------------------
# 9_ Tramite l'uso di TRIGGER
-- Se viene aggiunto un nuovo cameriere ed il suo stipendio è null(zero) allora:
-- calcolare lo stipendio medio ed assegnarlo a tale cameriere
drop TRIGGER StipendioDefault;
DELIMITER $$
CREATE TRIGGER StipendioDefault
before insert ON Ristorante.Cameriere
FOR EACH ROW

begin

declare stip decimal(6,2) default 0;
select avg(stipendio) into stip from Cameriere where Stipendio IS NOT NULL; 

 if((New.Stipendio = 0) OR (NEW.Stipendio IS NULL)) then
   SET new.stipendio = stip ;
end if;

 end $$
DELIMITER ;

INSERT INTO Cameriere (Nome, Cognome, Stipendio, PartTime) VALUES
('Nabi', 'Tav', 0, true);
INSERT INTO Cameriere (Nome, Cognome,PartTime) VALUES
('Nabi2', 'Tav2', true);
select * from Cameriere;

--------------------------------------------------------------------------------------------
# 10_ Tramite l'uso di TRIGGER
-- impedisce l'inserimento degli alimenti che possono scatenare alcune reazioni allergiche
-- cioè gli alimenti contenenti 'glutine', 'arachidi', 'soia'
DELIMITER $$
CREATE TRIGGER EliminaAllergeni
before insert ON Ristorante.Menu
FOR EACH ROW

begin
declare msg varchar(500);
if (New.Descrizione  like '%glutine%' or New.Descrizione like '%arachidi%' or New.Descrizione like '%soia%')then
select concat('Non può inserire: ' , UPPER(NEW.Alimento) , '   perchè può scatenare reazioni allergiche') into msg;
 signal sqlstate '45000'
 set message_text = msg;
end if;
 end $$
DELIMITER ;


INSERT INTO Menu VALUES 
('Torta al burro d’arachidi2', 25, 300, 'burro di arachidi , latte, uova', 'dessert');
DROP TRIGGER IF EXISTS EliminaAllergeni;
select * from menu;

