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




-- Criar consulta que liste nome e o salário do colaborador com o maior salário.

select nome, salario  from brh.colaborador
where salario = (select Max(salario) from brh.colaborador);

/*Criar uma consulta que liste a matrícula, nome, salário, e nível de senioridade do colaborador.
    A senioridade dos colaboradores determina a faixa salarial:
        Júnior: até R$ 3.000,00;
        Pleno: R$ 3.000,01 a R$ 6.000,00;
        Sênior: R$ 6.000,01 a R$ 20.000,00;
        Corpo diretor: acima de R$ 20.000,00.*/
        
    
select matricula,nome,salario,
(case when salario <=3000 then 'Júnior'
    when salario > 3000 and salario <=6000 then 'Pleno'
    when salario > 6000 and salario <= 20000 then 'Sênior'
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
    --Regras de aceitação
        -- * No relatório deve ter somente colaboradores com 2 ou mais dependentes.
        -- * Ordenar consulta pela quantidade de dependentes em ordem decrescente, e colaborador crescente.
        
select c.nome,
 count (*) as Quantidade_Dependentes
from brh.colaborador c
    inner join brh.dependente d
on c.matricula = d.colaborador 
 group by c.nome
having count(*) >= 2
order by count(*) desc,c.nome asc;


/* Criar consulta que liste o CPF do dependente, o nome do dependente, a data de nascimento (formato brasileiro), parentesco, matrícula do colaborador, a idade do dependente e sua faixa etária.
    Regras de aceitação
        Se o dependente tiver menos de 18 anos, informar a faixa etária Menor de idade;
        Se o dependente tiver 18 anos ou mais, informar faixa etária Maior de idade;
        Ordenar consulta por matrícula do colaborador e nome do dependente.*/

select cpf,
  nome,
  to_char(data_nascimento,'DD-MM-YYYY') as data,
  parentesco,
  colaborador,
 nvl(floor((months_between(sysdate,data_nascimento)/12)),0) as idade,
 CASE 
    when nvl(floor((months_between(sysdate,data_nascimento)/12)),0) > 18 then 'Maior de idade'
      else 'Menor de idade' 
 END as Faixa_Etária
from brh.dependente;


/*O usuário quer saber quanto é a mensalidade que cada colaborador deve pagar ao plano de saúde. As regras de pagamento são:

Cada nível de senioridade tem um percentual de contribuição diferente:
    Júnior paga 1% do salário;
    Pleno paga 2% do salário;
    Sênior paga 3% do salário;
    Corpo diretor paga 5% do salário.
    
Cada tipo de dependente tem um valor adicional diferente:
    Cônjuge acrescenta R$ 100,00 na mensalidade;
    Maior de idade acrescenta R$ 50,00 na mensalidade;
    Menor de idade acrescenta R$ 25,00 na mensalidade.*/
    
select matricula,nome,salario,senioridade,
    (CASE
     when senioridade = 'Júnior' then salario*0.01
     when senioridade = 'Pleno' then salario*0.02      -- CRIEI UMA VW DESSE SELECT
     when senioridade = 'Sênior' then salario*0.03
     else salario*0.05
    END) as total
from brh.vw_senioridade;

select colaborador,
    SUM((CASE
        WHEN faixa_etária = 'Menor de idade' and parentesco = 'Filho(a)' then 25
        WHEN faixa_etária = 'Maior de idade' and parentesco = 'Filho(a)' then 50   -- CRIEI UMA VW DESSE SELECT
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



/*O usuário quer paginar a listagem de colaboradores em páginas de 10 registros cada. Há 26 colaboradores na base, então há 3 páginas:
    Página 1: da Ana ao João (registros 1 ao 10);
    Página 2: da Kelly à Tati (registros 11 ao 20); e
    Página 3: do Uri ao Zico (registros 21 ao 26).
        Crie uma consulta que liste a segunda página.*/
        
select * from(
    select rownum as linha ,c.* 
     from brh.colaborador c
    order by nome)
where linha >10 and linha<=20;








































