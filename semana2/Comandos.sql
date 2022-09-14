select * from colaborador;
select * from dependente;
select * from atribuicao;
select * from departamento;
select * from endereco;
select * from telefone_colaborador;
select * from papel;
select * from projeto;

/*-------------------------Crie uma consulta que liste a sigla e o nome do departamento-------------------------;
 Ordene o resultado pelo nome.*/

select sigla,nome from departamento
order by nome asc;

/*-------------------------Crie uma consulta que liste:-------------------------
nome do colaborador;
nome do dependente;
data de nascimento do dependente;
parentesco do dependente.
Ordene o resultado pelo nome do colaborador e pelo nome do dependente.*/

select colaborador.nome as 'Nome Colaborador', dependente.nome as 'Nome Dependente',dependente.data_nascimento,dependente.parentesco
from colaborador,dependente
where colaborador.matricula = dependente.colaborador
order by colaborador.nome,dependente.nome;

/*-------------------------Adiconar um novo colaborador-------------------------*/

insert into papel values
(8,'Especialista de Negócios');

insert into projeto values
(5,'BI','I123','2022-09-02',null);


insert into colaborador values
('N999','Fulano de Tal','109.129.039-39','fulano@email.com','fulano@corp.com',5000,'DEPTI','71222-700','Casa 88');

insert into telefone_colaborador values
('N999','(61)9 9999-9999','M');

select * from telefone_colaborador
where colaborador = 'N999';

insert into atribuicao values
(5,'N999',8);

select * from atribuicao
where colaborador = 'N999';

/*-------------------------Deletar o departamento SECAP-------------------------*/
select * from colaborador
where departamento = 'SECAP';

delete from atribuicao 
  where colaborador in ('H123', 'M123', 'R123', 'W123');
  
delete from telefone_colaborador 
  where colaborador in ('H123', 'M123', 'R123', 'W123');
  
delete from dependente
  where colaborador in ('H123', 'M123', 'R123', 'W123');

update departamento 
   set chefe = 'A123'
 where sigla = 'SECAP';
 
delete from colaborador 
  where departamento = 'SECAP';
 
delete from departamento 
 where sigla = 'SECAP';




