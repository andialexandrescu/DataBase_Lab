SELECT last_name, salary, department_id 
FROM employees e WHERE salary > (SELECT AVG(salary) 
                                FROM employees
                                WHERE department_id = e.department_id);

select d.department_name, d.department_id, count(*), round(avg(e.salary), 2)
from employees e
join departments d on(d.department_id = e.department_id)
group by d.department_name, d.department_id;

select e.last_name, e.first_name, aux.medie, aux.nr_ang
from employees e, ( select d2.department_name, d2.department_id as dept_id, count(*) as nr_ang, round(avg(e2.salary), 2) as medie
                    from employees e2
                    join departments d2 on(d2.department_id = e2.department_id)
                    group by d2.department_name, d2.department_id) aux
where e.department_id = aux.dept_id
and salary > (SELECT AVG(salary) 
                FROM employees
                WHERE department_id = e.department_id);

-- poza ora 10:37 16  mai

select e.last_name, e.first_name, d.department_name
from employees e
join departments d on (d.department_id = e.department_id)
and e.hire_date = ( select min(e1.hire_date)
                    from employees e1
                    where e.department_id = e1.department_id);

select d.department_id, d.department_name
from departments d
where not exists (select e.employee_id
                from employees e
                where e.department_id = d.department_id);

// subordonatii directi ai lui Steven King                
select e1.employee_id
from employees e1, employees e2
where e1.manager_id = e2.employee_id and initcap(e2.first_name) = 'Steven' and initcap(e2.last_name) = 'King';

with 
    subord_directi as (select e1.employee_id, e1.last_name, e1.first_name, e1.hire_date
                        from employees e1, employees e2
                        where e1.manager_id = e2.employee_id and initcap(e2.first_name) = 'Steven' and initcap(e2.last_name) = 'King'),
    select e1.hire_date                
    from subord_directi; -- ne e bine vezi ultima poza de la lab

