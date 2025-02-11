declare
    cursor c_job is
        select j.job_id, j.job_title, count(employee_id) as nr
        from employees e
        join jobs j on(e.job_id = j.job_id)
        group by j.job_id, job_title;
    
    cursor c_top_employees (titlu jobs.job_title%type) is-- param
        select e.last_name, e.salary
        from employees e
        join jobs j on(e.job_id = j.job_id)
        where j.job_title = titlu
        order by e.salary desc;

    v_job_id jobs.job_id%type;
    v_job_title jobs.job_title%type;
    v_name employees.last_name%type;
    v_salary employees.salary%type;
    v_rank number := 0;
    v_prev_salary number := null;
begin
    for j in c_job loop
        v_job_title := j.job_title;
        dbms_output.put_line('Job '||j.job_id||' '||v_job_title||' cu '||j.nr||' angajati');

        if j.nr = 0
        then
            dbms_output.put_line('Job fara angajati');
        else
            open c_top_employees(v_job_title);
            loop
                fetch c_top_employees into v_name, v_salary;
                exit when c_top_employees%notfound;

                if v_prev_salary is null or v_salary != v_prev_salary
                    then-- incrementare cand e cazul si gestionare pt cazul de egalitate
                        v_rank := v_rank + 1;--  nu incrementez v_rank daca au acelasi salariu
                end if;

                if v_rank <= 5
                    then
                        dbms_output.put_line(v_rank||': '||v_name||' cu salariul '||v_salary);
                else
                    exit;
                end if;
    
                v_prev_salary := v_salary;
            end loop;
            close c_top_employees;
    
            v_rank := 0;-- urm job
            v_prev_salary := null;-- reinit doar pt urmatorul job (nu vreau prev_salary de la jobul anterior)
        end if;
    end loop;
end;
/