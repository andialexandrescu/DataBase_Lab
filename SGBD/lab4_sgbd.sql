declare
    cod_a employees.employee_id%type := &p_cod;
    cod_d departments.department_id%type := &p_dept;
    procent number := &p_procent;
    aux_cod_a integer;
    aux_cod_d integer;
begin
    select count(*) into aux_cod_a
    from employees
    where employee_id = cod_a;
    select count(*) into aux_cod_d
    from departments
    where department_id = cod_d;
    case when aux_cod_a = 1 and aux_cod_d = 1
        then update employees
            set department_id = cod_d,
                salary = salary + (procent*salary)/100
            where employee_id = cod_a;
            dbms_output.put_line('succes');
        else dbms_output.put_line('actualizare nerealizata');
    end case;
    dbms_output.put_line(cod_a);
    dbms_output.put_line(cod_d);
end;
/

--nume ang, dep ang; daca nu lucreaza mesaj; "ang nu lucreaza"
declare
    minim number := 1;
    maxim number := 1;
    aux_nu_exista integer;
    type angajat_afisare is record(nume employees.last_name%type, prenume employees.first_name%type, departament departments.department_name%type);
    ang angajat_afisare;
begin
    select min(employee_id) into minim
    from employees;
    select max(employee_id) into maxim
    from employees;
    
    loop
        select count(*) into aux_nu_exista
        from employees
        where employee_id = minim;
        if aux_nu_exista > 0 then
            select e.first_name, e.last_name, d.department_name into ang
            from employees e
            join departments d on(e.department_id = d.department_id)
            where employee_id = minim;
            minim := minim + 1;
            
            if ang.departament is NULL
                then dbms_output.put_line('Angajatul ' || ang.nume || ' ' || ang.prenume || 'nu lcreaza in niciun departament');
            else
                dbms_output.put_line('Angajatul ' || ang.nume || ' ' || ang.prenume || ' cu departamentul ' || ang.departament);
                exit when minim > maxim;
            end if;
        elsif aux_nu_exista = 0
            then minim := minim + 1;
        end if;
    end loop;
end;
/
