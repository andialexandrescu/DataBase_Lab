--Laborator 1 Recapitulare SQL

--1.

--a) SQL*Plus --> SELECT * FROM .... ->nu acceseaza baza de date,ci oracle

--b) COUNT,MIN,MAX,etc.. -> intorc un singur rezultat

--c) Functiile de grup nu iau in considerare valorile null

--COUNT(EMPLOYEE_ID)-mult mai optim fiindca nu mai ia toate coloanele in considerare(elimina valorile nule)


--2.

--b) O tabela poate avea o singura cheia primara,insa in componenta ei
--poate avea mai multe coloane

--d) cheia primara nu poate avea valori nule sau duplicate

--3.
-- a) nu doar one-to-many ,ci si one-to-one

--b)
--departamentul-->parinte
--employee-->copil

--c)
--sterg copil si de-abia dupa parintele
--FK nu poate fi NULL

--d)FK in Copil este PK in Parinte

--4.

--a) fals

--b) fals

--c) fals

--d) adevar

--5.

--Orice modificare aspura lui View se propaga in tabele
--de baza

--a) fals

--b)fals,View nu stocheaza datele,ci doar ci le aduce din tabele

--c) adevarat

--d) fals

--6
--In SELECT  nu pot avea o subcerere care returneaza mai mult de o linie

--7
--raspuns:1
--se executa mai intai subcererea din where,iar dupa nu se mai
--executa FROM

--8
--c)


--9
--c)



--Sa se afiseze pentru fiecare angajat suma totala incasata per fiecare job

SELECT
E.EMPLOYEE_ID,SUM(E.SALARY),SUM(E.SALARY+E.SALARY*NVL(COMMISSION_PCT,0))
FROM EMPLOYEES E
GROUP BY E.EMPLOYEE_ID;

--Sa se afiseze numele angajatilor care lucreaza in prezent la un proiect la care nu au mai lucrat in trecut

SELECT
*
FROM EMPLOYEES E
WHERE E.JOB_ID  NOT IN(
SELECT 
    J.JOB_ID
FROM JOB_HISTORY J
WHERE E.EMPLOYEE_ID=J.EMPLOYEE_ID
);
