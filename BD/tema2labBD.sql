with salarii_departamente as(
    select d.department_id, d.department_name, e.last_name, e.salary as salariu_maxim, count(*) as nr_ang_salariu_maximn
    from departments d
    join employees e on(e.department_id = d.department_id)
    group by d.department_id, d.department_name, e.salary, e.last_name -- daca intr-un departament ar exista mai mult de un angajat cu salariu maxim, s-ar afisa mai mult de un rezultat pentru acelasi department_id (nu e cazul aici)
    having e.salary = (  
                        select max(e2.salary)
                        from employees e2
                        where e2.department_id = d.department_id
                        )
    order by salariu_maxim desc
)
select department_id, department_name, last_name, salariu_maxim, nr_ang_salariu_maximn
from salarii_departamente
union all -- fara union all si cu o incercare de join pt departments nu s-ar fi afisat decat niste departamente in care lucreaza cel putin un angajat, motiv pentru care nvl si decode nu ar fi mers
select d.department_id, d.department_name, 'Angajat inexistent momentan', 0, 0 -- determinarea departementelor in care nu lucreaza niciun angajat
from departments d -- doar pt corelare
where not exists (
                    select 1
                    from employees e
                    where e.department_id = d.department_id
                );

select d.manager_id, d.department_name, e.first_name || ' ' || e.last_name as nume_complet -- manageri departamente
from departments d
join employees e on(e.employee_id = d.manager_id)
where --d.manager_id is not null -- exista departamente care nu sunt administrate, nu e o conditie necesara in acest caz
e.salary > (
                    select avg(e2.salary)
                    from employees e2
                    where e2.manager_id in(     
                                                select e3.employee_id -- se verifica apartenenta manager_id in subcererea corelata pt a determina un average de salariu pentru subordonati
                                                from employees e3
                                                where e2.manager_id = e3.employee_id and e3.phone_number like '%67%'
                                            )
                );

select d.department_id, d.department_name
from departments d
join employees e on(d.department_id = e.department_id) -- doar pentru a afisa numele departamentului
where e.manager_id in ( -- corelare sef direct
                            select e2.employee_id
                            from employees e2
                            where e.manager_id = e2.employee_id and length(replace(e.phone_number, '.', '')) = 10
                        )
group by d.department_id, d.department_name -- grupare pt a vedea avg(e.salary) in functie de departament
having round(avg(e.salary), 2) > ( -- intreaga firma
                            select round(avg(salary), 2)
                            from employees
                    );
                    
-- sapt 12 division lab
select distinct a.employee_id
from works_on a
where not exists (
                        (
                            select p2.project_id -- toate proiectele pe care lucreaza angajatul (in mod implicit daca lucreaza si la proiectul 2, inseamna ca diferenta dintre multimi nu e vida, deci nu respecta criteriul)
                            from project p2
                            join works_on b on(b.project_id = p2.project_id)
                            where b.employee_id = a.employee_id
                       )
                       minus
                       ( -- proiecte nelivrate la deadline per angajat dar si overall (delivery date e stabilita ca fiind data cei mai inaintata la care un angajat termina de lucrat la proiect)
                            select p.project_id
                            from project p
                            where a.end_date > p.deadline and p.delivery_date > p.deadline
                        )
                );