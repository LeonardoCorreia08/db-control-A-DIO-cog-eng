/*
    RELAÇÃO DE AUTORIZAÇÕES DOS SISTEMAS (login_autorizacao)
    ==============================================================
    Classificação das funcionalidades do sistemas que poderão ser 
    liberadas ou bloqueadas de acordo com os privilégios (autorizações)
    Exemplo:
    Cadastro de vendedores
    Cadastro de clientes
    Cadastro de produtos
    Pedido de venda
    Faturamento de pedido
    Relatório de contas a pagar
    etc...
*/
CREATE TABLE login_autorizacao (
    id_autorizacao integer unsigned auto_increment,
    classificacao varchar(100),
    descricao varchar(200),
    ativo boolean default true,
    versao integer default 0,
    criado_em timestamp default current_timestamp,
    atualizado_em timestamp default current_timestamp on update current_timestamp,
    primary key (id_autorizacao)
) engine=innoDB;


/*
    PERFIL DE USUÁRIOS (login_perfil)
    =======================================
    Grupo de usuários do sistema. 
    Podendo ser agrupados por setor, função, módulos, etc...
    Exemplo:
    ADMINISTRADOR
    USUARIO
    ATENDENTE
    FISCAL
    MARKETING
    etc...
*/
CREATE TABLE login_perfil (
  id_perfil int(10) unsigned NOT NULL AUTO_INCREMENT,
  descricao varchar(20) DEFAULT NULL,
  notificar_inclusao_usuario tinyint(4) DEFAULT '0',
  ativo tinyint(1) DEFAULT '1',
  versao int(11) DEFAULT '0',
  criado_em timestamp default current_timestamp,
  atualizado_em timestamp default current_timestamp on update current_timestamp,
  PRIMARY KEY (id_perfil)
) ENGINE=InnoDB;

/*
    OPERAÇÕES POR PERFIL (login_perfil_autorizacao)
    ============================================
    Relação das operações disponíveis por perfil (grupo) de usuários.
    Informação necessária na autorização das funcionalidades.
    Exemplo:
    +----------------+-----------------------------------------------------+
    | P E R F I L    | O P E R A Ç Ã O (privilégios)                       | 
    +----------------+-----------------------------------------------------+
    | MASTER         | Todas as operações                                  | 
    +----------------+-----------------------------------------------------+
    | ADMINISTRADOR  | Manutenção de usuários, Cancelamento de Venda, ...  |
    +----------------+-----------------------------------------------------+
    | VENDEDOR       | Cadastro cliente, pedido de venda, orçamento...     | 
    +----------------+-----------------------------------------------------+
    | etc...         | ...                                                 |
    +----------------+-----------------------------------------------------+
*/
CREATE TABLE login_perfil_autorizacao (
    id_perfil integer unsigned not null,
    id_autorizacao integer unsigned not null,
    primary key (id_perfil, id_autorizacao)
) engine=innoDB;

ALTER TABLE login_perfil_autorizacao ADD CONSTRAINT fk_perfil_autorizacao_perfil
    FOREIGN KEY (id_perfil) REFERENCES login_perfil (id_perfil) ON DELETE CASCADE;

ALTER TABLE login_perfil_autorizacao ADD CONSTRAINT fk_perfil_autorizacao_autorizacao
    FOREIGN KEY (id_autorizacao) REFERENCES login_autorizacao (id_autorizacao) ON DELETE CASCADE;


/*
    RELAÇÃO DE USUÁRIOS (login_usuario)
    ========================================
    Usuários com autorização de uso do sistema.
*/
CREATE TABLE login_usuario (
    id_usuario integer unsigned auto_increment,
    nome varchar(100) not null,
    login varchar(30) not null unique,
    email varchar(255) not null unique,
    senha varchar(255) not null,
    ativo boolean default true,
    versao integer default 0,
    criado_em timestamp default current_timestamp,
    atualizado_em timestamp default current_timestamp on update current_timestamp,
    primary key (id_usuario)
) engine=innoDB;


/*
    USUÁRIOS POR PERFIL (login_usuario_perfil)
    ==========================================
    Relação de usuários agrupados por perfil.
    Exemplo:
    +----------------+-----------------------------------------------------+
    | P E R F I L    | U S U Á R I O S                                     | 
    +----------------+-----------------------------------------------------+
    | MASTER         | Leo, Bru                                            | 
    +----------------+-----------------------------------------------------+
    | ADMINISTRADOR  | Leonardo, Bruna, Art, ...                           |
    +----------------+-----------------------------------------------------+
    | VENDEDOR       | Pamêlla, Maria, Lais, Nathalia, Thamy, ...          | 
    +----------------+-----------------------------------------------------+
    | etc...         | ...                                                 |
    +----------------+-----------------------------------------------------+
*/
CREATE TABLE login_usuario_perfil (
    id_usuario integer unsigned,
    id_perfil integer unsigned,
    primary key (id_usuario, id_perfil)
) engine=innoDB;

ALTER TABLE login_usuario_perfil ADD CONSTRAINT fk_usuario_perfil_usuario
    FOREIGN KEY (id_usuario) REFERENCES login_usuario (id_usuario) ON DELETE CASCADE;

ALTER TABLE login_usuario_perfil ADD CONSTRAINT fk_usuario_perfil_perfil
    FOREIGN KEY (id_perfil) REFERENCES login_perfil (id_perfil) ON DELETE CASCADE;