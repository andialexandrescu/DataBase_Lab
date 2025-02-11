create or replace procedure marire_salarii_manager(p_manager_id in number) is
    nr number;
begin
    select count(*)
    into nr
    from employees
    where manager_id = p_manager_id;

    if nr = 0 then
        dbms_output.put_line('Nu exista manager cu id-ul specificat: '||p_manager_id);
        return;
    end if;

    update employees
    set salary = salary * 1.10
    where manager_id = p_manager_id or employee_id in (select employee_id from employees where manager_id = p_manager_id);
end;
/
begin
    marire_salarii_manager(108);
    marire_salarii_manager(114);
end;
/


create or replace procedure info_angajare is
    cursor c_dept is
        select department_id, department_name
        from departments;

    cursor c_angajari (p_department_id number) is
        select to_char(hire_date, 'day') as hire_day,
               e.last_name,
               e.hire_date,
               e.salary
        from employees e
        where e.department_id = p_department_id
        order by e.hire_date;

    v_department_id departments.department_id%type;
    v_department_name departments.department_name%type;
    v_hire_day varchar2(10);
    v_last_name employees.last_name%type;
    v_hire_date employees.hire_date%type;
    v_salary employees.salary%type;
    
    type employee_rec is record (
        last_name employees.last_name%type,
        hire_date employees.hire_date%type,
        salary employees.salary%type,
        rank_position number
    );
    type table_emp is table of employee_rec index by binary_integer;
    t_emp table_emp; 

begin
    for dept in c_dept loop-- cursor ciclu
        v_department_id := dept.department_id;
        v_department_name := dept.department_name;
        dbms_output.put_line('Departamentul: ' || v_department_name);

        open c_angajari(v_department_id);
        loop
            fetch c_angajari into v_hire_day, v_last_name, v_hire_date, v_salary;
            exit when c_angajari%notfound;

            t_emp(t_emp.count + 1) := employee_rec(v_last_name, v_hire_date, v_salary, null);
        end loop;
        close c_angajari;

        if t_emp.count = 0
            then
                dbms_output.put_line('Nu sunt angajaii in departament');
                continue;-- se continua cu urm dept
        end if;

        declare
            v_prev_hire_date date := null;
            v_rank number := 0;
        begin
            for i in 1..t_emp.count loop
                if i = 1 or t_emp(i).hire_date != t_emp(i-1).hire_date
                    then
                        v_rank := i;-- rang curent
                else
                    v_rank := t_emp(i-1).rank_position;-- daca se intampla sa aiba aceeasi vechime, pastrez rangul de la ang anterior
                end if;

                t_emp(i).rank_position := v_rank;-- rang nou
                dbms_output.put_line('Pozitia '||t_emp(i).rank_position||': '||t_emp(i).last_name||' (data angajare: '||to_char(t_emp(i).hire_date, 'dd-mon-yyyy')||', salariu: '||t_emp(i).salary||')');
            end loop;
        end;
        
        t_emp.delete;-- resetez lista pt urm departament
    end loop;
end;
/
begin
    info_angajare;
end;
/



