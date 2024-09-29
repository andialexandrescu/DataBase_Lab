--  ex1
--1 FINAL
-----
select l.city, l.location_id
from employees e
right join jobs j on (e.job_id = j.job_id)
right join departments d on (e.department_id = d.department_id)
right join locations l on (d.location_id = l.location_id)
right join countries c on (l.country_id = c.country_id)
where lower(j.job_title) like '%clerk' or (substr(c.country_name, 4, 1) = 'a' or substr(c.country_name, 5, 1) = 'a');
-----

--  ex2 a
select last_name || ' ' || first_name, hire_date
from employees
where hire_date > to_date('29-OCT-1993')
order by hire_date;
         
--subcerere             
select e.last_name || ' ' || e.first_name, j.job_title, d.department_name
from employees e
join jobs j on (e.job_id = j.job_id)
join departments d on (e.department_id = d.department_id)
where e.hire_date > to_date('29-OCT-1993')
and e.job_id in (   select job_id
                    from employees
                    where job_id = e.job_id or department_id = e.department_id
                )
and e.department_id in (    select department_id
                            from employees
                            where job_id = e.job_id or department_id = e.department_id   
                        )        
order by d.department_name desc, j.job_name desc;    

select j.job_id, j.job_title, jh.start_date, jh.end_date
from jobs j
join job_history jh on (j.job_id = jh.job_id)
where jh.start_date > to_date('29-OCT-1993') and jh.end_date is not null;

select d.department_id, d.department_name, jh.start_date, jh.end_date
from departments d
join job_history jh on (jh.department_id = d.department_id)
where jh.start_date > to_date('29-OCT-1993') and jh.end_date is not null;


--2a) FINAL
-----
select e.last_name|| ' ' ||e.first_name as full_name, j.job_title, d.department_name -- avand nevoie de titlu si nume in loc de id-uri pt jobs si departments, trebuie facut join pe baza acestor chei
from employees e
join jobs j on (e.job_id = j.job_id) -- inner join
join departments d on (e.department_id = d.department_id)
--join job_history jh on (jh.department_id = e.department_id and jh.job_id = e.job_id) -- gresit deoarece folosind acest join, se vor afisa toate schimbarile de departament sau job pt angajati, adica un angajat poate aparea de mai multe ori in lista rezultatelor, ceea ce nu este dorit
where e.job_id in (   -- angajati din trecut
                    -- subcerere care returneaza job-urile la care anumiti angajati au inceput sa lucreze dupa 29 octombrie 1993
                    -- ca sa fie un job de interes, inseamna ca trebuie sa existe cel putin un angajat care a inceput sa lucreze dupa data specificata cu acel job
                    select distinct job_id
                    from job_history
                    where start_date > to_date('29-OCT-1993', 'DD-MM-YYYY') and end_date is not null -- ma asigur ca nu mai e angajat
                )
and e.department_id in (    -- and pt ca lucreaza 'intr-un departament si pe un job ...'
                            select distinct department_id
                            from job_history
                            where start_date > to_date('29-OCT-1993', 'DD-MM-YYYY') and end_date is not null
                        )
--and jh.end_date is null -- angajat in prezent (daca cerinta ar fi fost mai restrictiva, ar fi avut sens acel join cu job_history jh), altfel nu am nevoie de acest lucru                  
order by d.department_name desc, j.job_title desc; -- 2 criterii
-----

-- var gresita pt ca se afiseaza duplicate
select e.employee_id, e.last_name, e.first_name, j.job_title, e.job_id, d.department_name, e.department_id, jh.start_date, jh.end_date
from employees e
join jobs j on (e.job_id = j.job_id) 
join departments d on (e.department_id = d.department_id)
join job_history jh on (jh.job_id = e.job_id and jh.department_id = e.department_id)
where (e.job_id, e.department_id) in (   
                    select job_id, department_id
                    from job_history
                    where start_date > '29-OCT-1993' and end_date is not null
                )
order by d.department_name desc, j.job_title desc;

-- ex2 b
-- alte incercari
select e.last_name || ' ' || e.first_name as full_name, j.job_title, d.department_name
from employees e
join jobs j on e.job_id = j.job_id
join departments d on e.department_id = d.department_id
where e.employee_id in (
  select jh.employee_id
  from job_history jh
  where jh.start_date > to_date('29-OCT-1993')
    and jh.end_date is null
    and jh.job_id = e.job_id
    and jh.department_id = e.department_id
)
order by d.department_id desc, j.job_id desc;

select e.last_name || ' ' || e.first_name as full_name,
       j.job_title,
       d.department_name
from employees e
join jobs j on e.job_id = j.job_id
join departments d on e.department_id = d.department_id
where e.employee_id in (
  select employee_id
  from job_history
  where start_date <= sysdate
    and end_date is null
    and job_id = e.job_id
    and department_id = e.department_id
)
and e.hire_date > to_date('29-oct-1993', 'dd-mon-yyyy')
order by d.department_id desc, j.job_id desc;

--2b) FINAL
-----
select e.last_name || ' ' || e.first_name as full_name, j.job_title, d.department_name -- 
from employees e
join jobs j on (e.job_id = j.job_id)
join departments d on (e.department_id = d.department_id)
where e.employee_id in ( -- daca angajatul e conectat la job_history inseamna ca a lucrat la un job si intr-un departament in trecut
                            select distinct jh.employee_id
                            from job_history jh
                            where jh.start_date <= sysdate
                            and jh.end_date is null
                            and jh.job_id = e.job_id
                            and jh.department_id = e.department_id
                        )
and e.hire_date > to_date('29-OCT-1993')
order by d.department_id desc, j.job_title desc;
-----

select e.last_name || ' ' || e.first_name, j.job_title, d.department_name
from employees e
join jobs j on (e.job_id = j.job_id)
join job_history jh on (jh.employee_id = e.employee_id)
join departments d on (e.department_id = d.department_id)
where jh.end_date is null -- este angajat in prezent
and e.employee_id in (  select jh.employee_id
                        from job_history jh
                        where jh.start_date > to_date('29-OCT-1993') and jh.end_date is not null
                    )
and e.department_id in (    select d2.department_id
                            from employees e2
                            join departments d2 on (d2.department_id = e2.department_id)
                            join job_history jh2 on (jh2.employee_id = e2.employee_id)
                            where jh2.start_date > to_date('29-OCT-1993') and jh2.end_date is not null
                        )        
order by d.department_name desc, j.job_title desc;

-- 2b) modif (nu respecta cerinta), pt un motiv sau altul in docx e varianta gresita a exercitiului rezolvat
select e.last_name|| ' ' ||e.first_name as full_name, j.job_title, j.job_id, d.department_name, d.department_id, jh.start_date, jh.end_date
from employees e
join jobs j on (e.job_id = j.job_id)
join departments d on (e.department_id = d.department_id)
join job_history jh on (jh.job_id = e.job_id) -- apar duplicate, demonstration purposes
where e.job_id in (   
                    select distinct job_id
                    from job_history
                    where start_date > to_date('29-OCT-1993', 'DD-MM-YYYY') and end_date is not null
                )                     
order by d.department_name desc, j.job_title desc; -- 2 criterii

select *
from job_history
where start_date > to_date('29-OCT-1993', 'DD-MM-YYYY');

select distinct department_id
from job_history
where start_date > to_date('29-OCT-1993', 'DD-MM-YYYY') and end_date is not null;
-- ex2 c
-- cerinta difera doar prin acel "sau" si nu mai conteaza sortarea
--2c) FINAL
-----
select e.last_name|| ' ' ||e.first_name as full_name, j.job_title, j.job_id, d.department_name, d.department_id, jh.start_date, jh.end_date
from employees e
join jobs j on (e.job_id = j.job_id)
join departments d on (e.department_id = d.department_id)
join job_history jh on (jh.department_id = e.department_id or e.job_id = jh.job_id)
where e.job_id in (  
                    select distinct job_id
                    from job_history
                    where start_date > to_date('29-OCT-1993', 'DD-MM-YYYY') and end_date is not null
                )
or e.department_id in (    
                            select distinct department_id
                            from job_history
                            where start_date > to_date('29-OCT-1993', 'DD-MM-YYYY') and end_date is not null
                        );
-----