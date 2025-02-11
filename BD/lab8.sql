-- angajatii cu salariu maxim din fiecare departament
select *
from employees
where (department_id, salary) in (  select department_id, max(salary)
                                    from employees
                                    group by department_id );
                                   
select count(*)
from employees;

select count(department_id) -- exista un departament null
from employees;

select max(salary), min(salary), sum(salary) as "suma", round(avg(salary), 2) as "rotunjire"
from employees;

select avg(nvl(commission_pct, 0)), sum(commission_pct)/count(*)
from employees;

select max(salary), min(salary), sum(salary), j.job_title
from employees e
join jobs j on (e.job_id = j.job_id)
group by j.job_id, j.job_title;

select distinct manager_id
from employees
where manager_id is not null;

select count(distinct manager_id)
from employees;

-- ex 16 fara subcerere necorelata
select d.department_name, l.city, count(employee_id), avg(e.salary)
from employees e
join departments d on (d.department_id = e.department_id)
join locations l on (l.location_id = d.location_id)
group by department_name, l.city;

-- ex 16 cu subcerere necorelata
-- vezi poza 18 aprilie 11:45
-- 

