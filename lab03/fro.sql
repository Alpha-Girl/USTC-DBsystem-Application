/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     2018/6/12 23:25:30                           */
/*==============================================================*/


alter table 储蓄账户
   drop FOREIGN KEY FK_储蓄账户_分为_账户;

alter table 员工
   drop FOREIGN KEY FK_员工_工作_支行;

alter table 客户
   drop FOREIGN KEY FK_客户_负责_员工;

alter table 拥有账户
   drop FOREIGN KEY FK_YY_zh;

alter table 拥有账户
   drop FOREIGN KEY FK_YY_kh;

alter table 拥有账户
   drop FOREIGN KEY FK_YY_ww;

alter table 拥有贷款
   drop FOREIGN KEY FK_YY_ss;

alter table 拥有贷款
   drop FOREIGN KEY FK_dk_kh;

alter table 支付情况
   drop FOREIGN KEY FK_zf_dk;

alter table 支票账户
   drop FOREIGN KEY FK_支票账户_分为2_账户;

alter table 贷款
   drop FOREIGN KEY FK_贷款_发放_支行;

drop table 储蓄账户;

ALTER TABLE 员工 drop index 工作_FK;

drop table 员工;

ALTER TABLE 客户 drop index 负责_FK;

drop table 客户;

ALTER TABLE 拥有账户 drop index 拥有账户3_FK2;

ALTER TABLE 拥有账户 drop index 拥有账户3_FK;

ALTER TABLE 拥有账户 drop index 拥有账户_FK;

drop table 拥有账户;

ALTER TABLE 拥有贷款 drop index 拥有贷款2_FK;

ALTER TABLE 拥有贷款 drop index 拥有贷款_FK;

drop table 拥有贷款;

ALTER TABLE 支付情况 drop index 逐次支付_FK;

drop table 支付情况;

drop table 支票账户;

drop table 支行;

drop table 账户;

ALTER TABLE 贷款 drop index 发放_FK;

drop table 贷款;

/*==============================================================*/
/* Table: 储蓄账户                                                  */
/*==============================================================*/

create table 储蓄账户 
(
   账户号                  char(100)        not null,
   账户类型                 char(20)         not null,
   余额                   FLOAT,
   开户日期                 DATE,
   最近访问日期               DATE,
   利率                   FLOAT,
   货币类型                 char(10),
   constraint PK_储蓄账户 primary key (账户号, 账户类型)
);

/*==============================================================*/
/* Table: 员工                                                    */
/*==============================================================*/

create table 员工 
(
   身份证号                 CHAR(18)             not null,
   支行名                  char(100),
   姓名                   char(20),
   电话号码                 char(20),
   家庭住址                 char(100),
   开始工作日期               DATE,
   constraint PK_员工 primary key (身份证号)
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
   姓名                   char(20),
   联系电话                 char(20),
   家庭住址                 char(100),
   联系人姓名         char(20),
   联系人手机号               char(20),
   联系人Email     char(100),
   与客户关系                char(100),
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
   支行名                  char(100)        not null,
   身份证号                 CHAR(18)             not null,
   账户号                  char(100)        not null,
   账户类型                 char(20)         not null,
   constraint PK_拥有账户 primary key (支行名, 身份证号, 账户号, 账户类型),
   constraint AK_UQKEY1_拥有账户 unique (支行名, 身份证号, 账户类型)
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
   账户号                  char(100)        not null,
   账户类型                 char(20)         not null,
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
   支行名                  char(100)        not null,
   资产                   FLOAT,
   constraint PK_支行 primary key (支行名)
);

/*==============================================================*/
/* Table: 账户                                                    */
/*==============================================================*/
create table 账户 
(
   账户号                  char(100)        not null,
   账户类型                 char(20)         not null,
   余额                   FLOAT,
   开户日期                 DATE,
   最近访问日期               DATE,
   constraint PK_账户 primary key (账户号, 账户类型)
);

/*==============================================================*/
/* Table: 贷款                                                    */
/*==============================================================*/
create table 贷款 
(
   贷款号                  CHAR(100)            not null,
   支行名                  char(100),
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

alter table 储蓄账户
   add constraint FK_储蓄账户_分为_账户 foreign key (账户号, 账户类型)
      references 账户 (账户号, 账户类型);

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

alter table 拥有账户
   add constraint FK_YY_ww foreign key (账户号, 账户类型)
      references 账户 (账户号, 账户类型);

alter table 拥有贷款
   add constraint FK_YY_ss foreign key (贷款号)
      references 贷款 (贷款号);

alter table 拥有贷款
   add constraint FK_dk_kh foreign key (身份证号)
      references 客户 (身份证号);

alter table 支付情况
   add constraint FK_zf_dk foreign key (贷款号)
      references 贷款 (贷款号);

alter table 支票账户
   add constraint FK_支票账户_分为2_账户 foreign key (账户号, 账户类型)
      references 账户 (账户号, 账户类型);

alter table 贷款
   add constraint FK_贷款_发放_支行 foreign key (支行名)
      references 支行 (支行名);

