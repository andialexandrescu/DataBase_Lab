DECLARE 
  x      NUMBER(1) := 5; 
  y      x%TYPE  := NULL; 
BEGIN 
  IF x <> y THEN  
      DBMS_OUTPUT.PUT_LINE ('valoare <> null este = true'); 
    ELSE  
      DBMS_OUTPUT.PUT_LINE ('valoare <> null este != true'); 
  END IF; 
   
  x := NULL;  
  IF x = y THEN  
       DBMS_OUTPUT.PUT_LINE ('null = null este = true'); 
    ELSE  
       DBMS_OUTPUT.PUT_LINE ('null = null este != true'); 
  END IF; 
END; 
/ 

--Pt un id citit de la tastatura afisati numele, departamentul si nr de joburi pe care a lucrat acesta
declare
    id_ang employees.employee_id%type := &p_cod;
    type info_ang is record(nume employees.last_name%type NOT NULL default 'test', dep departments.department_name%type,
                            nr_joburi integer);
    angajat info_ang;
begin
    select e.last_name, d.department_name, count(*)
    into angajat
    from employees e, job_history jh, departments d
    where e.department_id=d.department_id(+) 
    and e.employee_id = jh.employee_id(+)
    and e.employee_id=id_ang
    group by d.department_name,e.last_name;
    dbms_output.put_line('Angajatul cu numele '||angajat.nume||' se afla in departamentul '||
    angajat.dep||' si a ocupat '||angajat.nr_joburi||' joburi.');
end;
/


--Sa se afiseze o lista cu numele angajatilor, numele proiectelor pe care acesta a lucrat
declare
    type info_work is record(nume_proiect projects.project_name%type, 
                            start_proiect work.start_work%type,
                            end_proiect work.end_work%type);
    type proiecte is table of info_work index by binary_integer;
    type info_angajat is record(nume_angajat employees.last_name%type,
                                proiecte_angajat proiecte);
    type lista_angajati is table of info_angajat index by binary_integer;
    
    lista_mea lista_angajati;
begin
    select last_name --???eroare
    bulk collect into lista_mea.nume_angajat
    from employees;
end;
/