select * from employees
where employee_id = 102; 



declare
    cod_ang employees.employee_id%type:= &p_cod;
    cod_dep departments.department_id%type:= &p_cod_dep;
    procent number:= &p_procent;
    cod_ang_aux integer;
    cod_dep_aux integer;
begin
    select count(*) into cod_ang_aux
    from employees
    where employee_id = cod_ang; 
    
    select count(*) into cod_dep_aux
    from departments
    where department_id = cod_dep;
    
    case when cod_ang_aux = 1 and cod_dep_aux = 1
        then update employees 
             set department_id = cod_dep,
                    salary = salary + salary * procent/100
             where employee_id = cod_ang;
             dbms_output.put_line('act realizata');
             
        else dbms_output.put_line('act nerealizata');
    end case;
    
end;
/

--nume ang, dep ang; daca nu lucreaza mesaj
--"ang nu lucreaza"

declare
    minim number(6);
    maxim number(6);
    aux_nu_exista integer;
    type angajat_af is record (nume employees.last_name%type, prenume employees.first_name%type, departament departments.department_name%type);
    ang angajat_af;
begin
    select min(employee_id) into minim
    from employees;
    
    select max(employee_id) into maxim
    from employees;
    
    loop
        select count(*) into aux_nu_exista
        from employees
        where employee_id = minim;
        if aux_nu_exista <> 0 then
            select first_name, last_name, department_name into ang
            from employees e left join departments d
            on e.department_id = d.department_id
            where employee_id = minim;
            minim := minim + 1;
            if ang.departament is NULL then 
                dbms_output.put_line('Angajatul '||ang.nume||' '||ang.prenume||' nu lucreaza in niciun departament');
            else
                dbms_output.put_line('Angajatul '||ang.nume||' '||ang.prenume||' lucreaza in departamentul '||ang.departament);
                exit when minim > maxim;
            end if;
            
        elsif aux_nu_exista = 0 then
            minim := minim+1;
            exit when minim > maxim;
        end if;
        
    end loop;
end;
/