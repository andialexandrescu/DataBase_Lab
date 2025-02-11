set serveroutput on;
set verify off;

accept p_sal prompt 'Introduceti salariul: ';

declare
    v_nume employees.last_name%type;
    v_count number;
begin
    select last_name, count(*)
    into v_nume, v_count
    from employees
    where salary = &p_sal
    group by last_name;

    if v_count = 1
        then
            dbms_output.put_line('Salariatul care are salariul '||&p_sal||' este: '||v_nume);
    end if;

exception
    when no_data_found then
        dbms_output.put_line('Nu exista salariati care sa castige acest salariu');
    when too_many_rows then
        dbms_output.put_line('Exista mai multi salariati care castiga acest salariu');
end;
/
set verify on;
set serveroutput off;

set serveroutput on;
set verify off;

accept p_cod prompt 'Introduceti codul departamentului: ';
accept p_nou_nume prompt 'Introduceti noul nume al departamentului: ';

declare
    v_nume departments.department_name%type;
begin
    select department_name
    into v_nume 
    from departments
    where department_id = &p_cod;
    
    dbms_output.put_line('Departamentul '||v_nume||' a fost gasit');
    
    -- schema hr e creata local
    update departments
    set department_name = '&p_nou_nume'
    where department_id = &p_cod;
    
    dbms_output.put_line('Numele departamentului a fost actualizat cu succes');

exception
    when no_data_found then
        dbms_output.put_line('Departamentul cu codul '||&p_cod||' nu exista');
    when others then
        dbms_output.put_line('A aparut o eroare: '||sqlerrm);
end;
/
set verify on;
set serveroutput off;

set serveroutput on;

accept p_loc prompt 'Introduceti locatia: ';
accept p_cod prompt 'Introduceti codul departamentului: ';

declare
    v_nume_loc departments.department_name%type;
    v_nume_cod departments.department_name%type;
begin
    begin
        select department_name
        into v_nume_loc
        from departments
        where location_id = &p_loc;
        dbms_output.put_line('Departamentul din locatia specificata este: '||v_nume_loc);
    exception 
        when no_data_found then 
            dbms_output.put_line('Comanda select pentru locatie nu returneaza nimic');
        when too_many_rows then
            dbms_output.put_line('Comanda select pentru locatie returneaza prea multe departamente cu aceeasi locatie');
    end;

    begin
        select department_name 
        into v_nume_cod
        from departments 
        where department_id = &p_cod;
        dbms_output.put_line('Departamentul cu codul specificat este: '||v_nume_cod);
    exception 
        when no_data_found then 
            dbms_output.put_line('Comanda select pentru cod nu returneaza nimic');
    end;

end;
/


