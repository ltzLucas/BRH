create database brh;
use brh;

create table COLABORADOR (
matricula varchar(10) not null,
nome varchar(100) not null,
cpf varchar(15) not null,
email_pessoal varchar (100) not null,
email_corporativo varchar (100) not null,
salario float not null,
departamento varchar(50) not null,
cep varchar(15) not null,
complemento_endereco varchar(50) not null
);

alter table colaborador add constraint pk_colaborador
primary key (matricula);

alter table colaborador add constraint fk_endereco
foreign key (cep)
references endereco (cep);

alter table colaborador add constraint fk_departamento
foreign key (departamento)
references departamento(sigla);
/*-----------------------------------------------------------------*/
create table PAPEL (
id int not null,
nome varchar (50)
);

alter table papel add constraint pk_papel
primary key (id);

alter table papel
modify column id int auto_increment;
/*-----------------------------------------------------------------*/
create table DEPARTAMENTO (
sigla varchar (10) not null,
nome varchar (50) not null,
chefe varchar (100) not null,
departamento_superior varchar (15) not null
);

desc departamento;

alter table departamento
modify column departamento_superior varchar(15);

alter table departamento add constraint pk_departamento
primary key (sigla);

alter table departamento add constraint fk_colaborador_chefe
foreign key (chefe)
references colaborador(matricula);

/*-----------------------------------------------------------------*/
create table ENDERECO (
cep varchar (15) not null,
uf char(2) not null,
cidade varchar(50) not null,
bairro varchar(50) not null,
logradouro varchar(50) not null
);

alter table endereco add constraint pk_endereco
primary key (cep);
/*-----------------------------------------------------------------*/
create table TELEFONE_COLABORADOR (
colaborador varchar(15) not null,
numero varchar(15) not null,
tipo char (1)
);

alter table telefone_colaborador add constraint fk_colaborador_matricula
foreign key (colaborador)
references colaborador (matricula);

/*-----------------------------------------------------------------*/
create table PROJETO (
id int not null,
nome varchar (50) not null,
responsavel varchar (50) not null,
inicio date,
fim date
);
alter table projeto add constraint pk_projeto
primary key (id);

alter table projeto add constraint fk_colaborador
foreign key (responsavel)
references colaborador (matricula);

/*-----------------------------------------------------------------*/
create table DEPENDENTE (
cpf varchar(15) not null,
colaborador varchar (15) not null,
nome varchar (100),
parentesco varchar (50),
data_nascimento date
);

alter table dependente add constraint pk_dependente
primary key (cpf);

alter table dependente add constraint fk_colaborador_dependente
foreign key (colaborador)
references colaborador(matricula);
/*-----------------------------------------------------------------*/
create table ATRIBUICAO (
projeto int, 
colaborador varchar(15), 
papel int
);

alter table ATRIBUICAO add constraint fk_pojeto_atribuicao
foreign key (projeto)
references projeto(id);

alter table ATRIBUICAO add constraint fk_papel_atribuicao
foreign key (papel)
references papel(id);

alter table ATRIBUICAO add constraint fk_colaborador_atribuicao
foreign key (colaborador)
references colaborador(matricula);

/*-----------------------------------------------------------------*/