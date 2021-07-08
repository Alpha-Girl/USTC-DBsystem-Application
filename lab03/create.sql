/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/*==============================================================*/
alter table 部门
   drop constraint FK_部门_员工_经理;

alter table 部门
   drop constraint FK_部门_支行;

alter table 员工
   drop constraint FK_员工_部门_经理;

alter table 拥有账户
   drop constraint UQKEY_拥有账户;

alter table 员工
   drop constraint FK_员工_工作_支行;

alter table 客户
   drop constraint FK_客户_负责_员工;

alter table 拥有账户
   drop constraint FK_YY_zh;

alter table 拥有账户
   drop constraint FK_YY_kh;

alter table 拥有贷款
   drop constraint FK_YY_ss;

alter table 拥有贷款
   drop constraint FK_dk_kh;

alter table 支付情况
   drop constraint FK_zf_dk;

alter table 贷款
   drop constraint FK_贷款_发放_支行;

drop table 储蓄账户 cascade constraints;

drop index 工作_FK;

drop table 员工 cascade constraints;

drop index 负责_FK;

drop table 客户 cascade constraints;

drop index 拥有账户3_FK2;

drop index 拥有账户3_FK;

drop index 拥有账户_FK;

drop table 拥有账户 cascade constraints;

drop index 拥有贷款2_FK;

drop index 拥有贷款_FK;

drop table 拥有贷款 cascade constraints;

drop index 逐次支付_FK;

drop table 支付情况 cascade constraints;

drop table 支票账户 cascade constraints;

drop table 支行 cascade constraints;

drop index 发放_FK;

drop table 贷款 cascade constraints;

drop table 部门 cascade constraints;
/*==============================================================*/
/* Table: 储蓄账户                                              */
/*==============================================================*/
create table 储蓄账户 
(
   账户号                  VARCHAR2(100)        not null,
   账户类型                 VARCHAR2(20)         not null,
   余额                   FLOAT,
   开户日期                 DATE,
   最近访问日期               DATE,
   利率                   FLOAT,
   货币类型                 VARCHAR2(10),
   constraint PK_储蓄账户 primary key (账户号, 账户类型)
);

/*==============================================================*/
/* Table: 员工                                                    */
/*==============================================================*/
create table 员工 
(
   身份证号                 CHAR(18)             not null,
   支行名                  VARCHAR2(100),
   姓名                   VARCHAR2(20),
   电话号码                 VARCHAR2(20),
   家庭住址                 VARCHAR2(1000),
   开始工作日期               DATE,
   部门号                     VARCHAR(18),
   constraint PK_员工 primary key (身份证号)
);

/*==============================================================*/
/* Table: 部门                                                    */
/*==============================================================*/
create table 部门 
(
   部门号                 VARCHAR(18)             not null,
   支行名                  VARCHAR2(100),
   部门名称                VARCHAR2(100),
   部门类型                   VARCHAR2(20),
   部门经理身份证号                 CHAR(18),
   constraint PK_部门 primary key (部门号)
);

/*==============================================================*/
/* Index: 工作_FK                                                 */
/*==============================================================*/
create index 工作_FK on 员工 (
   支行名 ASC
);

/*==============================================================*/
/* Table: 客户                                                    */
/*==============================================================*/
create table 客户 
(
   身份证号                 CHAR(18)             not null,
   员工_身份证号              CHAR(18),
   姓名                   VARCHAR2(20),
   联系电话                 VARCHAR2(20),
   家庭住址                 VARCHAR2(1000),
   联系人姓名                VARCHAR2(20),
   联系人手机号               VARCHAR2(20),
   "联系人E-mail"          VARCHAR2(100),
   与客户关系                VARCHAR2(1000),
   constraint PK_客户 primary key (身份证号)
);




/*==============================================================*/
/* Index: 负责_FK                                                 */
/*==============================================================*/
create index 负责_FK on 客户 (
   员工_身份证号 ASC
);

/*==============================================================*/
/* Table: 拥有账户                                                  */
/*==============================================================*/
create table 拥有账户 
(
   支行名                  VARCHAR2(100)        not null,
   身份证号                 CHAR(18)             not null,
   账户号                  VARCHAR2(100)        not null,
   账户类型                 VARCHAR2(20)         not null,
   constraint PK_拥有账户 primary key (支行名, 身份证号, 账户号, 账户类型),
   constraint AK_UQKEY1_拥有账户 unique (支行名, 身份证号, 账户类型),
   constraint UQKEY_拥有账户 unique (账户号)
);

/*==============================================================*/
/* Index: 拥有账户_FK                                               */
/*==============================================================*/
create index 拥有账户_FK on 拥有账户 (
   支行名 ASC
);

/*==============================================================*/
/* Index: 拥有账户3_FK                                              */
/*==============================================================*/
create index 拥有账户3_FK on 拥有账户 (
   身份证号 ASC
);

/*==============================================================*/
/* Index: 拥有账户3_FK2                                             */
/*==============================================================*/
create index 拥有账户3_FK2 on 拥有账户 (
   账户号 ASC,
   账户类型 ASC
);

/*==============================================================*/
/* Table: 拥有贷款                                                  */
/*==============================================================*/
create table 拥有贷款 
(
   贷款号                  CHAR(100)            not null,
   身份证号                 CHAR(18)             not null,
   constraint PK_拥有贷款 primary key (贷款号, 身份证号)
);

/*==============================================================*/
/* Index: 拥有贷款_FK                                               */
/*==============================================================*/
create index 拥有贷款_FK on 拥有贷款 (
   贷款号 ASC
);

/*==============================================================*/
/* Index: 拥有贷款2_FK                                              */
/*==============================================================*/
create index 拥有贷款2_FK on 拥有贷款 (
   身份证号 ASC
);

/*==============================================================*/
/* Table: 支付情况                                                  */
/*==============================================================*/
create table 支付情况 
(
   贷款号                  CHAR(100),
   日期                   DATE,
   金额                   FLOAT
);

/*==============================================================*/
/* Index: 逐次支付_FK                                               */
/*==============================================================*/
create index 逐次支付_FK on 支付情况 (
   贷款号 ASC
);

/*==============================================================*/
/* Table: 支票账户                                                  */
/*==============================================================*/
create table 支票账户 
(
   账户号                  VARCHAR2(100)        not null,
   账户类型                 VARCHAR2(20)         not null,
   余额                   FLOAT,
   开户日期                 DATE,
   最近访问日期               DATE,
   透支额                  FLOAT,
   constraint PK_支票账户 primary key (账户号, 账户类型)
);

/*==============================================================*/
/* Table: 支行                                                    */
/*==============================================================*/
create table 支行 
(
   支行名                  VARCHAR2(100)        not null,
   支行城市                VARCHAR2(100),
   资产                   FLOAT,
   constraint PK_支行 primary key (支行名)
);

/*==============================================================*/
/* Table: 贷款                                                    */
/*==============================================================*/
create table 贷款 
(
   贷款号                  CHAR(100)            not null,
   支行名                  VARCHAR2(100),
   金额                   FLOAT,
   日期                   DATE,
   constraint PK_贷款 primary key (贷款号)
);

/*==============================================================*/
/* Index: 发放_FK                                                 */
/*==============================================================*/
create index 发放_FK on 贷款 (
   支行名 ASC
);
alter table 部门
   add constraint FK_部门_员工_经理 foreign key (部门经理身份证号)
      references 员工 (身份证号);

alter table 员工
   add constraint FK_员工_部门_经理 foreign key (部门号)
      references 部门 (部门号);
alter table 部门
   add constraint FK_部门_支行 foreign key (支行名)
      references 支行 (支行名);

alter table 员工
   add constraint FK_员工_工作_支行 foreign key (支行名)
      references 支行 (支行名);

alter table 客户
   add constraint FK_客户_负责_员工 foreign key (员工_身份证号)
      references 员工 (身份证号);

alter table 拥有账户
   add constraint FK_YY_zh foreign key (支行名)
      references 支行 (支行名);

alter table 拥有账户
   add constraint FK_YY_kh foreign key (身份证号)
      references 客户 (身份证号);

alter table 拥有贷款
   add constraint FK_YY_ss foreign key (贷款号)
      references 贷款 (贷款号);

alter table 拥有贷款
   add constraint FK_dk_kh foreign key (身份证号)
      references 客户 (身份证号);

alter table 支付情况
   add constraint FK_zf_dk foreign key (贷款号)
      references 贷款 (贷款号);



