select avg(salary) as average, department_id
from employees
group by department_id;
--v1
select max(sal_mediu)
from ( select department_id, avg(salary) sal_mediu
        from employees
        group by department_id );
--v2
select max(avg(salary))
from employees
group by department_id;

select department_id, avg(salary)
from employees
group by department_id
having avg(salary) = (  select max(avg(salary))
                        from employees
                        group by department_id);    
--ex3 lab7                        
select d.department_id, d.department_name, min(salary)
from employees e
join departments d on (d.department_id = e.department_id)
group by d.department_id, d.department_name
having avg(salary) = (  select max(avg(salary))
                        from employees
                        group by department_id);                 
--ex4 lab7
--a)
select d.department_id, d.department_name
from employees e
join departments d on (e.department_id = d.department_id)
group by d.department_id, d.department_name
having count(*)<4;

select count(*)
from (select d.department_id, d.department_name
        from employees e
        join departments d on (e.department_id = d.department_id)
        group by d.department_id, d.department_name
        having count(*)<4);
--b)
select d.department_id, d.department_name
from employees e
join departments d on (e.department_id = d.department_id)
group by d.department_id, d.department_name
having count(*) = (select max(count(*))
                    from employees
                    group by department_id);
--12

--nvl(sum(salary), 0)
select job_id, sum(decode(department_id, 30, salary, 0)) as suma_salarii_dept30, sum(decode(department_id, 50, salary, 0)) as suma_salarii_dept50, sum(decode(department_id, 80, salary, 0)) as suma_salarii_dept80
from employees
group by job_id;

select count(*) as nr_ang_total, sum(decode(to_char(hire_date, 'yyyy'), 1997, 1, 0)) as nr_ang_an_1997, sum(decode(to_char(hire_date, 'yyyy'), 1998, 1, 0)) as nr_ang_an_1998, sum(decode(to_char(hire_date, 'yyyy'), 1999, 1, 0)) as nr_ang_an_1999
from employees;
--group by job_id;


                                            
                                                       