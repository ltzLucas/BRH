select * from brh.atribuicao;
select * from brh.colaborador;
select * from brh.departamento;
select * from brh.dependente;
select * from brh.endereco;
select * from brh.papel;
select * from brh.projeto;
select * from brh.telefone_colaborador;


-- Criar uma consulta que liste os dependentes que nasceram em abril, maio ou junho, ou tenha a letra "h" no nome.
    -- 1. Ordene primeiramente pelo nome do colaborador, depois pelo nome do dependente.
    
select c.nome as colaborador,
    d.nome as dependente,
    d.data_nascimento,
    d.cpf,
    d.parentesco
from brh.dependente d
inner join brh.colaborador c
on c.matricula = d.colaborador
WHERE to_char(data_nascimento,'MM') = 4 or  -- ou Where to_char(data_nascimento,'MM') in (4,5,6)
    to_char(data_nascimento,'MM') = 5 or
    to_char(data_nascimento,'MM') = 6 or
    (d.nome like '%h%' or d.nome like '%H%')  -- ou usar um lower/upper : lower(d.nome like ' %h% ')         / upper(d.nome like ' %H%')
order by c.nome,d.nome;




-- Criar consulta que liste nome e o sal�rio do colaborador com o maior sal�rio.

select nome, salario  from brh.colaborador
where salario = (select Max(salario) from brh.colaborador);

/*Criar uma consulta que liste a matr�cula, nome, sal�rio, e n�vel de senioridade do colaborador.
    A senioridade dos colaboradores determina a faixa salarial:
        J�nior: at� R$ 3.000,00;
        Pleno: R$ 3.000,01 a R$ 6.000,00;
        S�nior: R$ 6.000,01 a R$ 20.000,00;
        Corpo diretor: acima de R$ 20.000,00.*/
        
    
select matricula,nome,salario,
(case when salario <=3000 then 'J�nior'
    when salario > 3000 and salario <=6000 then 'Pleno'
    when salario > 6000 and salario <= 20000 then 'S�nior'
    else 'Corpo diretor'
end) as Senioridade
from brh.colaborador
order by Senioridade,nome;


-- Criar consulta que liste o nome do departamento, nome do projeto e quantos colaboradores daquele departamento fazem parte do projeto.
    
select dep.nome as Nome_Departamento,
    p.nome as Projeto,
    count (*) as Quantidade
from brh.colaborador c
 inner join brh.departamento dep
on c.departamento = dep.sigla
 inner join brh.atribuicao atrib
on c.matricula = atrib.colaborador
 inner join brh.projeto p
on atrib.projeto = p.id
group by dep.nome,p.nome
order by dep.nome,p.nome;



-- Criar consulta que liste nome do colaborador e a quantidade de dependentes que ele possui.
    --Regras de aceita��o
        -- * No relat�rio deve ter somente colaboradores com 2 ou mais dependentes.
        -- * Ordenar consulta pela quantidade de dependentes em ordem decrescente, e colaborador crescente.
        
select c.nome,
 count (*) as Quantidade_Dependentes
from brh.colaborador c
    inner join brh.dependente d
on c.matricula = d.colaborador 
 group by c.nome
having count(*) >= 2
order by count(*) desc,c.nome asc;


/* Criar consulta que liste o CPF do dependente, o nome do dependente, a data de nascimento (formato brasileiro), parentesco, matr�cula do colaborador, a idade do dependente e sua faixa et�ria.
    Regras de aceita��o
        Se o dependente tiver menos de 18 anos, informar a faixa et�ria Menor de idade;
        Se o dependente tiver 18 anos ou mais, informar faixa et�ria Maior de idade;
        Ordenar consulta por matr�cula do colaborador e nome do dependente.*/

select cpf,
  nome,
  to_char(data_nascimento,'DD-MM-YYYY') as data,
  parentesco,
  colaborador,
 nvl(floor((months_between(sysdate,data_nascimento)/12)),0) as idade,
 CASE 
    when nvl(floor((months_between(sysdate,data_nascimento)/12)),0) > 18 then 'Maior de idade'
      else 'Menor de idade' 
 END as Faixa_Et�ria
from brh.dependente;


/*O usu�rio quer saber quanto � a mensalidade que cada colaborador deve pagar ao plano de sa�de. As regras de pagamento s�o:

Cada n�vel de senioridade tem um percentual de contribui��o diferente:
    J�nior paga 1% do sal�rio;
    Pleno paga 2% do sal�rio;
    S�nior paga 3% do sal�rio;
    Corpo diretor paga 5% do sal�rio.
    
Cada tipo de dependente tem um valor adicional diferente:
    C�njuge acrescenta R$ 100,00 na mensalidade;
    Maior de idade acrescenta R$ 50,00 na mensalidade;
    Menor de idade acrescenta R$ 25,00 na mensalidade.*/
    
select matricula,nome,salario,senioridade,
    (CASE
     when senioridade = 'J�nior' then salario*0.01
     when senioridade = 'Pleno' then salario*0.02      -- CRIEI UMA VW DESSE SELECT
     when senioridade = 'S�nior' then salario*0.03
     else salario*0.05
    END) as total
from brh.vw_senioridade;

select colaborador,
    SUM((CASE
        WHEN faixa_et�ria = 'Menor de idade' and parentesco = 'Filho(a)' then 25
        WHEN faixa_et�ria = 'Maior de idade' and parentesco = 'Filho(a)' then 50   -- CRIEI UMA VW DESSE SELECT
        else 100
    END)) as PAGAR 
from brh.vw_faixa_etaria
group by colaborador
order by colaborador;



select f.colaborador,
     s.total + f.pagar as TOTAL
from brh.mw_seniorpagar s
inner join brh.mw_faixapagar f
on f.colaborador = s.matricula;



/*O usu�rio quer paginar a listagem de colaboradores em p�ginas de 10 registros cada. H� 26 colaboradores na base, ent�o h� 3 p�ginas:
    P�gina 1: da Ana ao Jo�o (registros 1 ao 10);
    P�gina 2: da Kelly � Tati (registros 11 ao 20); e
    P�gina 3: do Uri ao Zico (registros 21 ao 26).
        Crie uma consulta que liste a segunda p�gina.*/
        
select * from(
    select rownum as linha ,c.* 
     from brh.colaborador c
    order by nome)
where linha >10 and linha<=20;








































