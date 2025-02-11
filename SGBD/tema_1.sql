select to_char(r.book_date, 'dd-mon-yy'), count(r.book_date) as nr_imprumuturi
from rental r
where r.book_date between to_date('01-nov-24', 'dd-mon-yy') and to_date('30-nov-24', 'dd-mon-yy')
group by to_char(r.book_date, 'dd-mon-yy')
order by 1;

create table noiembrie_imprumuturi (
    id number primary key,
    data date,
    numar_imprumuturi number
);
drop table noiembrie_imprumuturi;
declare
    v_data date;
    v_numar_imprumuturi number;
begin
    for i in 0..29 loop
        v_data := to_date('01-nov-' || to_char(sysdate, 'yyyy'), 'dd-mon-yy') + i;
        
        select count(r.book_date) 
        into v_numar_imprumuturi
        from rental r
        where to_char(r.book_date, 'dd-mon-yy') = to_char(v_data, 'dd-mon-yy');
        
        insert into noiembrie_imprumuturi (id, data, numar_imprumuturi)
        values (i, v_data, v_numar_imprumuturi);
    end loop;
    
    commit;
end;
/

declare
    v_nume varchar2(50);
    v_membru_count integer;
    v_filme_imprumutate integer;
begin
    v_nume := '&nume_membru';-- midori

    select count(*) into v_membru_count
    from member
    where first_name = v_nume or last_name = v_nume;

    if v_membru_count = 0 then
        dbms_output.put_line('nu exista nici un membru cu numele '||v_nume);
    elsif v_membru_count > 1 then
        dbms_output.put_line('exista mai multi membri cu numele '||v_nume);
    else
        select count(distinct r.title_id)
        into v_filme_imprumutate
        from rental r
        join member m on r.member_id = m.member_id
        where m.first_name = v_nume or m.last_name = v_nume;
        dbms_output.put_line(v_nume||' a imprumutat urmatorul numar de filme: '||v_filme_imprumutate);
    end if;
end;
/

declare
    v_nume varchar2(50);
    v_membru_count integer;
    v_filme_imprumutate integer;
    v_total_filme integer;
    v_procent_imprumutate number;
begin
    v_nume := '&nume_membru';

    select count(*) into v_membru_count
    from member
    where first_name = v_nume or last_name = v_nume;

    if v_membru_count = 0 then
        dbms_output.put_line('nu exista nici un membru cu numele ' || v_nume);
    elsif v_membru_count > 1 then
        dbms_output.put_line('exista mai multi membri cu numele ' || v_nume);
    else
        select count(distinct r.title_id)
        into v_filme_imprumutate
        from rental r
        join member m on r.member_id = m.member_id
        where m.first_name = v_nume or m.last_name = v_nume;

        dbms_output.put_line(v_nume || ' a imprumutat urmatorul numar de filme: ' || v_filme_imprumutate);

        select count(*) into v_total_filme
        from title;

        v_procent_imprumutate := (v_filme_imprumutate / v_total_filme) * 100;

        if v_procent_imprumutate > 75 
            then
                dbms_output.put_line(v_nume || ' este in categoria 1 (>75% din titlurile existente)');
        elsif v_procent_imprumutate > 50
            then
                dbms_output.put_line(v_nume || ' este in categoria 2 (>50% din titlurile existente)');
        elsif v_procent_imprumutate >= 25
            then
                dbms_output.put_line(v_nume || ' este in categoria 3 (>25% din titlurile existente)');
        else
            dbms_output.put_line(v_nume || ' este in categoria 4 (<25% din titlurile existente)');
        end if;
    end if;
end;
/

create table member_aal as
select member_id, 
       first_name, 
       last_name, 
       address, 
       city, 
       phone, 
       join_date, 
       0 as discount
from member;

drop table member_aal;

declare
    v_membru_id number;
    v_nume varchar2(100);
    v_filme_imprumutate integer;
    v_total_filme integer;
    v_procent_imprumutate number;
    v_discount number;
begin
    v_membru_id := &membru_id;

    select first_name || ' ' || last_name 
    into v_nume
    from member
    where member_id = v_membru_id
    and rownum = 1;

    if v_nume is null then
        dbms_output.put_line('nu exista membru cu id-ul ' || v_membru_id);
    else
        select count(distinct r.title_id) into v_filme_imprumutate
        from rental r
        where r.member_id = v_membru_id;

        select count(*) into v_total_filme
        from title;

        v_procent_imprumutate := (v_filme_imprumutate / v_total_filme) * 100;

        if v_procent_imprumutate > 75 then
            v_discount := 10;
        elsif v_procent_imprumutate > 50 then
            v_discount := 5;
        elsif v_procent_imprumutate > 25 then
            v_discount := 3;
        else
            v_discount := 0;
        end if;

        update member_aal
        set discount = v_discount
        where member_id = v_membru_id;

        if sql%rowcount > 0 then
            dbms_output.put_line('discount-ul membrului '||v_nume||' a fost actualizat la '||v_discount||'%');
        else
            dbms_output.put_line('nu s-a putut actualiza discount-ul pentru membrul '||v_nume);
        end if;
    end if;
end;
/












