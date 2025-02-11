declare
    id_ang employees.employee_id%type := &p_cod;
    type info_ang is record(nume employees.last_name%type NOT NULL DEFAULT 'test', dep departments.department_name%type, nr_joburi integer);
    angajat info_ang;
begin
    select e.last_name, d.department_name, count(*)
    into angajat
    from employees e
    left join departments d on(d.department_id = e.department_id)
    left join job_history jh on(jh.department_id = d.department_id)
    where e.employee_id = id_ang
    group by e.last_name, d.department_name;
    dbms_output.put_line('Angajatul pe nume ' || angajat.nume || ' lucreaza in departamentul ' || angajat.dep || ' si are ' || angajat.nr_joburi || ' joburi');
end;
/

--numele tuturor angajatilor, numele proiecteleor pe care fiecare a lucrat (vector)
declare
    nume employees.last_name%type;
    type info_work is record(nume_proiect projects.project_name%type, start_proiect work.start_work%type, final_proiect work.end_work%type);
    type proiecte is table of info_work index by binary_integer;
    type info_angajat is record(nume_angajat employees.last_name%type, proiecte_angajat proiecte);
    type lista_angajati is table of info_angajat index by binary_integer;
    lista_mea lista_angajati;
begin
    select *
    bulk collect into lista_mea
    from employees e
    join work w on(e.employee_id = w.employee_id)
    join projects p on(w.project_id = p.project_id);
end;
/

declare
    type info_work is record (nume projects.project_name%type, inceput work.start_work%type, sfarsit work.end_work%type);
    type proiecte is table of info_work index by binary_integer;
    type info_ang is record (
        nume_angajat employees.last_name%type, 
        proiecte_angajat proiecte
    );
    type lista_angajati is table of info_ang index by binary_integer;
    lista lista_angajati;
    type proiecte_temp is table of info_work;
    type lista_nume_angajati is table of employees.last_name%type index by binary_integer;
    lista_nume lista_nume_angajati;
    proiecte_temp_lista proiecte_temp;
begin
 
    select last_name
    bulk collect into lista_nume
    from employees;
    
    for i in 1 .. lista_nume.count loop
        lista(i).nume_angajat := lista_nume(i);
    end loop;
    
    for i in 1 .. lista_nume.count loop
 
        select p.project_name, w.start_work, w.end_work
        bulk collect into proiecte_temp_lista
        from employees e 
        join work w on e.employee_id = w.employee_id 
        join projects p on p.project_id = w.project_id
        where e.last_name = lista(i).nume_angajat;
 
        lista(i).proiecte_angajat := proiecte();
 
        for j in 1 .. proiecte_temp_lista.count loop
            lista(i).proiecte_angajat(j) := proiecte_temp_lista(j);
        end loop;
    end loop;
 
    for i in 1..lista.count loop
        if (lista(i).proiecte_angajat.count >= 1) then
            dbms_output.put_line(lista(i).nume_angajat || ': ');
            for j in 1..lista(i).proiecte_angajat.count loop
                dbms_output.put('     ' || lista(i).proiecte_angajat(j).nume);
                dbms_output.put('     ' || lista(i).proiecte_angajat(j).inceput);
                dbms_output.put('     ' || lista(i).proiecte_angajat(j).sfarsit);
                dbms_output.put_line('');
            end loop;
        end if;
    end loop;
end;

DECLARE
type info_work is record(nume_proiect projects.project_name%type, start_proiect work.start_work%type, end_proiect work.end_work%type);
type proiecte is table of info_work index by binary_integer;
type info_angajati is record (nume_angajat employees.last_name%type, proiecte_angajat proiecte);
type lista_angajati is table of info_angajati index by binary_integer;
lista_mea lista_angajati;

i INTEGER :=0;
j INTEGER :=0;

type angajat_particular is record (
        nume employees.last_name%type,
        cod employees.employee_id%type
    );
type angajat is table of angajat_particular index by binary_integer;
ang angajat;

type proiect_particular is record( nume_proiect projects.project_name%type, start_proiect work.start_work%type, end_proiect work.end_work%type, cod_angajat employees.employee_id%type);
type proiect is table of proiect_particular index by binary_integer;
pr proiect;

BEGIN
    select unique e.first_name||' '||e.last_name, e.employee_id bulk collect into ang from employees e, work w where w.employee_id=e.employee_id;
    select p.project_name, w.start_work, w.end_work, w.employee_id bulk collect into pr from projects p, work w where p.project_id=w.project_id;
    FOR k IN ang.first .. ang.last LOOP
        i:=i+1;
        lista_mea(i).nume_angajat:=ang(k).nume;
        j:=0;
        FOR m IN pr.first .. pr.last LOOP
            IF (pr(m).cod_angajat=ang(k).cod) THEN
               j:=j+1;
               lista_mea(i).proiecte_angajat(j).nume_proiect:=pr(m).nume_proiect;
               lista_mea(i).proiecte_angajat(j).start_proiect:=pr(m).start_proiect;
               lista_mea(i).proiecte_angajat(j).end_proiect:=pr(m).end_proiect;
            END IF;
        END LOOP;    
    END LOOP;    
        
    FOR x IN lista_mea.FIRST .. lista_mea.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('Nume Angajat: ' || lista_mea(x).nume_angajat);
        FOR y IN lista_mea(x).proiecte_angajat.FIRST .. lista_mea(x).proiecte_angajat.LAST LOOP
            DBMS_OUTPUT.PUT_LINE('Nume_proiect: ' || lista_mea(x).proiecte_angajat(y).nume_proiect);
            DBMS_OUTPUT.PUT_LINE('    Start_proiect: ' || TO_CHAR(lista_mea(x).proiecte_angajat(y).start_proiect, 'YYYY-MM-DD'));
            DBMS_OUTPUT.PUT_LINE('    End_proiect:' || TO_CHAR(lista_mea(x).proiecte_angajat(y).end_proiect, 'YYYY-MM-DD'));
        END LOOP;
        DBMS_OUTPUT.NEW_LINE;
     END LOOP;
END;
/

--ex1 lab 2
declare
    type coduri is varray(5) of employees.salary%type;
    v coduri := coduri();
    ct employees.salary%type;
    contor number := 0;
    maxim number:=0;
    TYPE tablou_imbricat IS TABLE OF employees.employee_id%type; 
    t tablou_imbricat := tablou_imbricat();
    t2 tablou_imbricat := tablou_imbricat();
begin
    
    for i in 1..5 loop
        v.extend;
        
        select salary
        into ct
        from (
        select salary 
        --into ct 
        from (
                    select distinct salary
                    from employees
                    where commission_pct is NULL
                    order by salary asc )
        where rownum<=i
        
        minus 
        
                select salary 
        --into ct 
        from (
                    select distinct salary
                    from employees
                    where commission_pct is NULL
                    order by salary asc )
        where rownum<=i-1);
        v(i):= ct;
    end loop;
    for i in 1..5 loop
        dbms_output.put_line(v(i)||' ');
    end loop;
    
    for i in 1..5 loop
        select count(employee_id)
        into contor
        from employees
        where salary = v(i) and commission_pct is NULL;
        
        if maxim<=5 then
            maxim:=maxim+contor;
            select employee_id 
            bulk collect into t2 
            from employees
            where salary = v(i) and commission_pct is NULL;
            
            for j in t2.first..t2.last loop
                t.extend;
                t(t.last):=t2(j);
            end loop;
        end if;
        
    end loop;
    for i in t.first..t.last loop
        dbms_output.put_line(t(i)||' ');
    end loop;
end;
/


select distinct salary from employees
where employee_id in  (
132 ,128, 
136, 
127, 
135, 
119, 
131, 
140, 
144, 
182, 
191); 

/* sa se creeze o procedura stocata cu param de in si out care primeste
id-ul unui departament si afiseaza pe ecran o lista cu ang acelui dept, iar in
param de out va salva numarul total de ang al acestui dept, rulati procedura 
stocata atat din pl sql si sql plus sa se foloseasca ciclu cursor*/
/
create or replace procedure exer
(
    cod_dept in departments.department_id%type,
    nr out integer
)
is
    cod_ang employees.employee_id%type;
    
    cursor c_ang(id departments.department_id%type) is
        select e.employee_id
        from employees e
        join departments d on(e.department_id = d.department_id)
        where d.department_id = id;
begin
    nr := 0;
    open c_ang(cod_dept);
    loop
        fetch c_ang into cod_ang;
        exit when c_ang%notfound;
        
        dbms_output.put_line('ang: '||cod_ang);
        nr := nr + 1;
    end loop;
end;
/
declare
    nr integer;
begin
    exer(50, nr);
    dbms_output.put_line(nr);
end;
/

DECLARE
    outer_nr_total NUMBER;

    PROCEDURE proc(
        dep_id departments.department_id%TYPE,
        nr_total OUT NUMBER
    ) IS
    BEGIN
        FOR ang IN (
            SELECT first_name, last_name
            FROM employees
            WHERE department_id = dep_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(ang.first_name || ' ' || ang.last_name);
        END LOOP;

        SELECT COUNT(*)
        INTO nr_total
        FROM employees
        WHERE department_id = dep_id
        ;
    END proc;
BEGIN
    proc(100,outer_nr_total);
    DBMS_OUTPUT.PUT_LINE(outer_nr_total);
END;
/
DECLARE
    FUNCTION func (
        jid jobs.job_id%TYPE
    ) RETURN VARCHAR2 IS
        nume VARCHAR2(100);
    BEGIN
        SELECT first_name || ' ' || last_name
        INTO nume
        FROM employees
        WHERE job_id = jid
        AND salary = (
            SELECT MAX(salary)
            FROM employees
            WHERE job_id = jid
        )
        ;
        RETURN nume;
    END func;
BEGIN
    FOR job IN(
        SELECT job_title, job_id
        FROM jobs
    ) LOOP
        DBMS_OUTPUT.PUT(job.job_title || ': ');
        DBMS_OUTPUT.PUT_LINE(func(job.job_id));
    END LOOP;
END;
/
-- sa returneze pentru un job_id ang cu salariul cel mai mare
create or replace procedure exer2
(
    cod_job jobs.job_id%type
)
is
    cod_ang employees.employee_id%type;
    sal_ang employees.salary%type;
    --type angaj is table of employees.employee_id%type index by binary_integer;
    --t_angaj angaj = angaj();
    max_sal employees.salary%type;
    
    cursor c_ang(id jobs.job_id%type) is
        select e.employee_id, e.salary
        from employees e
        join job_history jh on(jh.employee_id = e.employee_id)
        join jobs j on(jh.job_id = j.job_id)
        where j.job_id = id;
begin
    select max(e.salary)
    into max_sal
    from employees e
    where job_id = cod_job;
    
    dbms_output.put_line(max_sal);
    
    open c_ang(cod_job);
    loop
        fetch c_ang into cod_ang, sal_ang;
        exit when c_ang%notfound;
        dbms_output.put_line('in cursor , sal_ang: '||sal_ang);
        if max_sal = sal_ang
            then
                dbms_output.put_line('ang: '||cod_ang||', sal: '||sal_ang);
        end if;
        
    end loop;
    
end;
/
begin
    exer2('SA_MAN');
end;
/

select *
from job_history;

select e.employee_id
from employees e
where employee_id in(select jh.employee_id
                    from job_history jh
                    where e.employee_id = jh.employee_id
                    and e.job_id != jh.job_id);

