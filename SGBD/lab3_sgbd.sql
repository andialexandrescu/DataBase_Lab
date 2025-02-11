VARIABLE g_mesaj VARCHAR2(50) 
BEGIN :g_mesaj := 'Invat PL/SQL'; 
END;
/
PRINT g_mesaj

BEGIN 
    DBMS_OUTPUT.PUT_LINE('Invat PL/SQL'); 
END; 
/

declare
    nume varchar2(35);
    prenume varchar2(35);
begin 
    dmbs_output.put_line(nume, " ", prenume);
end;
/

declare
    nume_departament departments.department_name%type;
begin
    select department_name
    into nume_departament
    from departments
    where department_id = 100;
    dmbs_output.put_line(nume_departament);
end;
/

variable rezultat varchar2(35)
declare 
    v_dep departments.department_name%type;
    nr_ang integer;
begin
    select d.department_name, count(e.employee_id)
    into v_dep, nr_ang
    from departments d
    join employees e on(e.department_id = d.department_id)
    where rownum = 1
    group by d.department_name
    having count(*) = (
                        select min(count(*))
                        from employees
                        group by department_id
                        );
    dbms_output.put_line('Departamentul cu cel mai putini angajati este ' || v_dep || ' si are ' || nr_ang || ' angajati');
    :rezultat := v_dep;
end;
/
print rezultat;

--se citeste de la tastatura id-ul unui departament, daca dept are mai mult de 10 ang sa se afiseze numele ang cu cel mai mare salariu, daca dept are mai putin de 5 ang, sa se afiseze numele ang cu cel mai mic salariu, altfel sa se afiseze si cel mai mare si cel mai mic salariu din dept
set verify off
declare
    v_cod department.department_id%type := &dep_cod;
    nr_ang integer;
    v_nume employees.last_name%type;
begin
    select count(*)
    into nr_ang
    from employees
    where d.department_id = v_cod
    if nr_ang > 10
        then
            select last_name into v_nume
            from employees
            where department_id = v_cod and salary = (select max(salary) from employees where department_id = v_cod);
        else if nr_ang < 5
            then
                select last_name into v_nume
                from employees
                where department_id = v_cod and salary = (select min(salary) from employees where department_id = v_cod);
        else
            dbms_output.put_line('de terminat');
    end if;
    dbms_output.put_line(v_nume);
end;
/
set verify on
            
    
    