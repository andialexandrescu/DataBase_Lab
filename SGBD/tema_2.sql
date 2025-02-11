drop sequence seq_exc_aal;
drop table excursie_aal;

create or replace type tip_orase_aal as varray(100) of varchar2(50);-- colectie varray
--create or replace type tip_orase_aal as table of varchar2(50);-- nested table E3

create sequence seq_exc_aal
start with 1000
increment by 5
maxvalue 9999
nocycle
nocache;

select seq_exc_aal.nextval
from dual;

create table excursie_aal
(
    cod_excursie number(4) primary key,
    denumire varchar2(100),-- nu conteaza cerinta varchar2(20)
    orase tip_orase_aal,
    status varchar2(15)
);

insert into excursie_aal values (seq_exc_aal.currval, 'Circuit Spania, Portugalia Gibraltar', tip_orase_aal('Barcelona', 'Costa', 'Brava', 'Valencia', 'Alicante', 'Granada', 'Gibraltar', 'Sevilla', 'Cordoba', 'Sintra', 'Lisabona', 'Porto', 'Salamanca', 'Segovia', 'Madrid'), 'disponibila');
insert into excursie_aal values (seq_exc_aal.nextval, '1 Decembrie Salonic, Targul de Craciun Trikala', tip_orase_aal('Veliko Tarnovo', 'Salonic', 'Litochoro', 'Trikala', 'Sofia'), 'disponibila');
insert into excursie_aal values (seq_exc_aal.nextval, 'Cehia si castelele ei', tip_orase_aal('Viena', 'Praga', 'Karlstejn', 'Dresda', 'Karlovy Vary', 'Brno', 'Budapesta'), 'anulata');
insert into excursie_aal values (seq_exc_aal.nextval, 'Revelion in Bosnia si Croatia', tip_orase_aal('Belgrad', 'Sarajevo', 'Mostar', 'Blagaj', 'Medugorje', 'Split', 'Trogir', 'Dubrovnik', 'Nis'), 'disponibila');
insert into excursie_aal values (seq_exc_aal.nextval, 'Circuit Piata de Craciun la Budapesta, Viena', tip_orase_aal('Budapesta', 'Viena'), 'disponibila');

declare-- adaug Bratislava la final
    v_orase tip_orase_aal;
    nume_oras varchar2(20);
begin
    nume_oras := '&nume'; 
    
    select orase
    into v_orase
    from excursie_aal
    where cod_excursie = 1020;

    v_orase.extend;
    v_orase(v_orase.count) := nume_oras;-- varray si nested table E3

    update excursie_aal
    set orase = v_orase, denumire = denumire||' si '||nume_oras
    where cod_excursie = 1020;
    
    commit;
end;
/

declare-- vreau Praga pe poz a doua
    v_orase tip_orase_aal;
    nume_oras varchar2(20);
    v_index integer := 2;-- indexarea incepe de la 1
begin
    nume_oras := '&nume';

    select orase
    into v_orase
    from excursie_aal
    where cod_excursie = 1020;
    
    dbms_output.put_line('Numarul oraselor existente inainte de inserare: '||v_orase.count);
    v_orase.extend;
    dbms_output.put_line('Numarul oraselor existente dupa inserare: '||v_orase.count);
    for i in reverse v_index+1..v_orase.count loop
        dbms_output.put_line('Indexul curent i: '||i);
        dbms_output.put_line('Mutam orasul de la indexul '||(i-1)||': '||v_orase(i-1)||' la indexul '||i);
        v_orase(i) := v_orase(i-1);
    end loop;
    
    v_orase(v_index) := nume_oras;
    dbms_output.put_line('Orasul a fost inserat la indexul '||v_index||': '||v_orase(v_index));

    update excursie_aal
    set orase = v_orase, denumire = 'Circuit piata de craciun la Budapesta, '||nume_oras||' Viena si Bratislava'
    where cod_excursie = 1020;
    
    commit;
end;
/

declare-- interschimb Praga cu Bratislava 2 <-> 4
    v_orase tip_orase_aal;
    nume_oras1 varchar2(50);
    nume_oras2 varchar2(50);
    v_index1 integer := -1;
    v_index2 integer := -1;
begin
    nume_oras1 := '&nume1';
    nume_oras2 := '&nume2';

    select orase
    into v_orase
    from excursie_aal
    where cod_excursie = 1020;

    for i in 1 .. v_orase.count loop-- varray si nested table E3
        if v_orase(i) = nume_oras1
            then
                v_index1 := i;
        elsif v_orase(i) = nume_oras2
            then
                v_index2 := i;
        end if;
    end loop;

    if v_index1 = -1 or v_index2 = -1
        then
            raise no_data_found;
    end if;

    -- inversarea oraselor pt poz v_index1 si v_index2
    declare
        aux varchar2(50);
    begin
        aux := v_orase(v_index1);
        
        v_orase(v_index1) := v_orase(v_index2);
        v_orase(v_index2) := aux;
    end;

    update excursie_aal
    set orase = v_orase
    where cod_excursie = 1020;
    
    dbms_output.put_line('(Orasele 1.'||nume_oras1||' si 2.'||nume_oras2||' au fost inversate)');

    commit;
end;
/

declare-- sterg Bratislava care dupa interschimare e pe a doua poz
    v_orase tip_orase_aal;
    v_index integer := 0;
    nume_oras varchar2(50);
    v_orase_nou tip_orase_aal := tip_orase_aal();
begin
    nume_oras := '&nume';

    select orase
    into v_orase
    from excursie_aal
    where cod_excursie = 1020;

    for i in 1..v_orase.count loop
        if v_orase(i) = nume_oras
            then
                v_index := i;
                exit;
        end if;
    end loop;
    
    -- v_orase fara orasul de pe poz v_index, se creeaza un nou array fara el
    if v_index > 0
        then
            v_orase_nou.extend(v_orase.count - 1);-- mai putin cu un element
    
            -- se copiaza tot cu exceptia celui care trebuie sters
            for i in 1..v_orase.count loop
                if i < v_index
                    then
                        v_orase_nou(i) := v_orase(i);
                elsif i > v_index
                    then
                        v_orase_nou(i - 1) := v_orase(i);-- toate elementele (dupa cel sters) trebuie shiftate la stanga
                end if;
            end loop;
    
            update excursie_aal
            set orase = v_orase_nou
            where cod_excursie = 1020;
    
            commit;
    else
        dbms_output.put_line('Nu a fost gasit orasul '||nume_oras);
    end if;
    
end;
/

-- afisarea nr orase si a numelui oraselor
declare
    v_nume varchar2(50);
    v_orase tip_orase_aal;
    v_cod_excursie number(4) := &cod_excursie;
    v_numar_orase integer;
begin
    select orase, denumire
    into v_orase, v_nume
    from excursie_aal
    where cod_excursie = v_cod_excursie;
    
    v_numar_orase := v_orase.count;
    
    dbms_output.put_line('Numarul de orase vizitate in excursia numita '||v_nume||': '||v_numar_orase);
    
    for i in 1 .. v_orase.count loop
        dbms_output.put_line('Orasul '||i||': '||v_orase(i));
    end loop;
    
exception
    when no_data_found then
        dbms_output.put_line('Nu exista o excursie cu acest cod');
end;
/

-- afisare orase vizitate pentru fiecare excursie
declare
    v_orase tip_orase_aal;
    v_cod_excursie excursie_aal.cod_excursie%type;
    
    -- cursor pt selectarea excursiilor
    cursor c_excursii is
        select cod_excursie, denumire, orase, status
        from excursie_aal;
    v_rec c_excursii%rowtype;-- salvez rezultatele cursorului
begin
    open c_excursii;
    loop
        fetch c_excursii into v_rec;
        exit when c_excursii%notfound;
        
        v_orase := v_rec.orase;-- de tip tip_orase_aal
        v_cod_excursie := v_rec.cod_excursie;

        dbms_output.put_line('Excursia cu codul: '||v_cod_excursie);
        for i in 1 .. v_orase.count loop
            dbms_output.put_line('Orasul '||i||': '||v_orase(i));
        end loop;

        dbms_output.put_line('  ');
    end loop;
    close c_excursii;

end;
/

-- update status la anulata pt excursii cu cele mai putine orase viz din array-ul orase
declare
    v_min_orase integer := 999;
    
    -- cursor pt excursii si numarul de orase pt fiecare din ele
    v_cod_exc excursie_aal.cod_excursie%type;
    v_orase tip_orase_aal;
    cursor c_nr is
        select cod_excursie, orase from excursie_aal;
        
    v_cod_excursie excursie_aal.cod_excursie%type; -- din cursor c_excursii
    cursor c_excursii is-- cursor pt excursii
        select cod_excursie
        from excursie_aal
        where (select count(*) from table(orase)) = v_min_orase;-- corespondenta care e facuta mai tarziu pt v_min_orase

begin
    open c_nr;
    loop
        fetch c_nr into v_cod_exc, v_orase;
        exit when c_nr%notfound;

        declare
            nr integer := v_orase.count;-- nr de orase pt excursia curenta
        begin
            if nr < v_min_orase then
                v_min_orase := nr;
            end if;
        end;
    end loop;
    close c_nr;

    -- folosesc v_min_orase
    open c_excursii;
    loop
        fetch c_excursii into v_cod_excursie;
        exit when c_excursii%notfound;
        
        update excursie_aal
        set status = 'anulata'
        where cod_excursie = v_cod_excursie;

        dbms_output.put_line('Excursia cu codul '||v_cod_excursie||' a fost anulata pt ca avea minimul de '||v_min_orase||' orase de vizitat');
    end loop;
    close c_excursii;

end;
/
 

