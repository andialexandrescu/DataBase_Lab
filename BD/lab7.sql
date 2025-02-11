select e.first_name, e.last_name, e.department_id, j.job_title
from employees e
join jobs j on (j.job_id = e.job_id)
where (salary, nvl(commission_pct,0)) in ( select salary,nvl (commission_pct,0)
                                    from employees e
                                    join departments d on (d.department_id = e.department_id)
                                    join locations l on (l.location_id = d.location_id)
                                    where lower(l.city) = 'oxford'
                                    );
                                    
-- angajatii care au salariul egal cu media oricariu salariu per job si care lucreaza intr-un departament cu un angajat cu litera t

select e.employee_id, e.last_name, e.first_name, e.department_id, e.salary
from employees e
where (e.salary, e.job_id) = any ( select (j.min_salary+j.max_salary)/2, job_id
                                from jobs j )
and e.department_id in ( select distinct employee_id
                        from employees
                        where lower(last_name) like '%t%');
                        
select e.first_name, e.salary, d.department_name
from employees e
left join departments d on (e.department_id = d.department_id)
where commission_pct is not null
and e.manager_id in (select employee_id
                    from employees
                    where commission_pct is not null);

select min(salary)
from employees;

select employee_id, salary
from employees
where salary = (select min(salary)
from employees);

select department_id, max(salary)
from employees
group by department_id; -- max salary se aplica in interiorul fiecarei diviziuni de departamente in parte

select e.employee_id, e.last_name, e.department_id, e.salary
from employees e
where e.salary in (select max(salary)
                   from employees
                   group by department_id);

select                    
