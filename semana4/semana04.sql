-- Crie a procedure brh.insere_projeto para cadastrar um novo projeto na base de dados.

select * from brh.projeto;
CREATE OR REPLACE PROCEDURE brh.insere_projeto1
    (p_nome brh.projeto.nome%type,
     p_responsavel brh.projeto.responsavel%type)
    
IS
BEGIN
    insert into brh.projeto
        (nome,responsavel,inicio)
    values
        (p_nome,p_responsavel,sysdate);
END;

begin
    brh.insere_projeto1('Primeiro teste','I123');
end;
select * from brh.projeto;

rollback;
-----------------------------------------------------------------------------------------------------------------------

-- Crie a function brh.calcula_idade que informa a idade a partir de uma data.


CREATE OR REPLACE FUNCTION brh.calcula_idade 
    (p_data_referencia  IN DATE)
    RETURN float
IS
BEGIN
    return FLOOR(months_between(sysdate,p_data_referencia) / 12);
END;

declare
    teste float;
begin
    teste := brh.calcula_idade('02-09-2002');
    dbms_output.put_line('A idade dele é :' || teste);
end;




-----------------------------------------------------------------------------------------------------------------------
-- Crie a function brh.finaliza_projeto para registrar o término da execução de um projeto.


SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION brh.finaliza_projeto
    (p_ID IN brh.projeto.id%type)
    return brh.projeto.fim%type
IS
    v_fim brh.projeto.fim%type;
    v_fim_atualizado brh.projeto.fim%type;
BEGIN
   select fim into v_fim from brh.projeto where p_ID = id;
   if v_fim is null then
   
        update brh.projeto
        set fim = sysdate
        where id = p_ID;
        
        select fim into v_fim_atualizado from brh.projeto where p_ID = id;
        return v_fim_atualizado;
    else
        return v_fim;
    end if;
END;


SET SERVEROUTPUT ON

DECLARE 
    v_teste brh.projeto.fim%type;
BEGIN
    v_teste := brh.finaliza_projeto(1);
    dbms_output.put_line('A data para o termino do projeto é :' || v_teste);
END;


-----------------------------------------------------------------------------------------------------------------------


-- Altere a procedure brh.insere_projeto para não permitir cadastrar projetos inválidos.
select * from brh.projeto;

CREATE OR REPLACE PROCEDURE brh.insere_projeto2
    (p_id in brh.projeto.id %type,
     p_nome in brh.projeto.nome %type,
     p_responsavel in brh.projeto.responsavel %type)
IS
    teste brh.projeto.nome %type;
BEGIN
    if length(p_nome) < 2  or length(p_nome) is NULL then
        raise_application_error(-20000,'Numero de caracteres invalido para o nome tente um nome maior que 2 CARACTERES');
    else
        insert into brh.projeto 
            (id,nome,responsavel,inicio)
        values
            (p_id,p_nome,p_responsavel,sysdate);
    END if;
END;


EXECUTE brh.insere_projeto2(5,'teste',NULL);

begin
    brh.insere_projeto2(10,'as','I123');
end;

select * from brh.projeto;
rollback;



---------------------------------------------------------------------------------------------------------------------------

-- Altere a função brh.calcula_idade para não permitir datas inválidas.



CREATE OR REPLACE FUNCTION brh.calcula_idade2 
    (p_data_referencia  IN DATE)
    RETURN float
IS
BEGIN
    if p_data_referencia > sysdate or p_data_referencia is NULL then
        raise_application_error(-20001,'Impossível calcular idade! Data inválida:'|| p_data_referencia);
    else 
        return FLOOR(months_between(sysdate,p_data_referencia) / 12);
    end if;
END;

declare
    teste float;
begin
    teste := brh.calcula_idade2('02-09-2025');
end;










