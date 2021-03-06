

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
insert into 储蓄账户 values ('0000088888','储蓄账户',3141592,to_date('2020/01/01','yyyy/mm/dd'),to_date('2021/07/01','yyyy/mm/dd'),0.123,'人民币');
insert into 储蓄账户 values ('0000088886','储蓄账户',459244,to_date('2019/01/01','yyyy/mm/dd'),to_date('2021/05/23','yyyy/mm/dd'),0.122,'美元');
insert into 储蓄账户 values ('0000088236','储蓄账户',7194,to_date('2019/09/11','yyyy/mm/dd'),to_date('2021/01/31','yyyy/mm/dd'),0.110,'日元');
insert into 储蓄账户 values ('0000123834','储蓄账户',31249,to_date('2017/11/21','yyyy/mm/dd'),to_date('2021/06/02','yyyy/mm/dd'),0.122,'英镑');
insert into 储蓄账户 values ('8900135834','储蓄账户',0.09,to_date('2020/03/21','yyyy/mm/dd'),to_date('2021/07/02','yyyy/mm/dd'),0.022,'人民币');
insert into 储蓄账户 values ('8214578346','储蓄账户',100.23,to_date('2020/03/29','yyyy/mm/dd'),to_date('2021/02/02','yyyy/mm/dd'),0.022,'人民币');

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
insert into 员工 values ('350203199702148964','城南支行','黄昵莘','15759263846','上海市浦东区',to_date('2017/09/18','yyyy/mm/dd'),'01');
insert into 员工 values ('350203199304147824','城南支行','刘文','18051262200','合肥市蜀山区',to_date('2019/10/08','yyyy/mm/dd'),'02');
insert into 员工 values ('25030319570823007X','城北支行','朱启问','18989211660','合肥市包河区',to_date('2020/03/31','yyyy/mm/dd'),'03');
insert into 员工 values ('25030319570813017X','东渡支行','罗昇','13983316234','广州市天河区',to_date('2018/04/01','yyyy/mm/dd'),'04');
insert into 员工 values ('620313198911213693','西北支行','郑广飒','13623316711','广州市越秀区',to_date('2019/12/04','yyyy/mm/dd'),'05');
insert into 员工 values ('122213199010013621','西北支行','李安韵','13809745112','厦门市湖里区',to_date('2020/12/04','yyyy/mm/dd'),'05');
insert into 员工 values ('118213197610213650','东渡支行','杨淼','15909745742','厦门市集美区',to_date('2020/11/04','yyyy/mm/dd'),'04');
insert into 员工 values ('098213197812210610','城北支行','唐三','15172310086','北京市朝阳区',to_date('2019/10/30','yyyy/mm/dd'),'03');
insert into 员工 values ('409123200001092112','城南支行','陆登佩','15342110390','重庆市江北区',to_date('2018/01/31','yyyy/mm/dd'),'02');

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
insert into 部门 values ('01','城南支行','信贷部','零售业务','350203199702148964');
insert into 部门 values ('02','城南支行','金融市场部','企业金融','350203199304147824');
insert into 部门 values ('03','城北支行','投资银行部','企业金融','25030319570823007X');
insert into 部门 values ('04','东渡支行','财富管理部','零售业务','25030319570813017X');
insert into 部门 values ('05','西北支行','综合管理部','零售业务','620313198911213693');

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
insert into 客户 values ('350212199206027512','350203199702148964','郑浩澜','18206037668','北京市东城区','胡毅翔','15394463896','alphaboy@mail.ustc.edu.cn','父亲');
insert into 客户 values ('320312199302282434','350203199304147824','杨正渤','18206023668','北京市东城区','胡毅翔','15394463896','alphaboy@mail.ustc.edu.cn','父亲');
insert into 客户 values ('350212199812021142','25030319570823007X','董天睿','18268249520','合肥市瑶海区','李兰','17392378332','Alan@mail.ustc.edu.cn','母亲');
insert into 客户 values ('350212198810223019','620313198911213693','雷希','18106059420','合肥市政务区','雷克曼','17013737373','lkm@163.com','父亲');
insert into 客户 values ('350212199812023452','118213197610213650','包温德','18206012376','重庆市南山区','韩金龙','18559232378','as@mail.ustc.edu.cn','父亲');
insert into 客户 values ('521836198609023672','409123200001092112','李家瑞','18206037668','北京市东城区','胡毅翔','15394463896','alphaboy@mail.ustc.edu.cn','父亲');




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
insert into 拥有账户 values ('城南支行','350212199206027512','0000088888','储蓄账户');
insert into 拥有账户 values ('城南支行','320312199302282434','0000088886','储蓄账户');
insert into 拥有账户 values ('城北支行','350212199812021142','0000088236','储蓄账户');
insert into 拥有账户 values ('西北支行','350212198810223019','0000123834','储蓄账户');
insert into 拥有账户 values ('东渡支行','350212199812023452','8900135834','储蓄账户');
insert into 拥有账户 values ('城南支行','521836198609023672','8214578346','储蓄账户');

insert into 拥有账户 values ('城南支行','350212199206027512','8888600001','支票账户');
insert into 拥有账户 values ('城北支行','350212199812021142','8888600002','支票账户');
insert into 拥有账户 values ('西北支行','350212198810223019','8888600003','支票账户');
insert into 拥有账户 values ('东渡支行','350212199812023452','8888600004','支票账户');
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
insert into 支票账户 values ('8888600001','支票账户',213,to_date('2019/01/31','yyyy/mm/dd'),to_date('2021/03/31','yyyy/mm/dd'),15);
insert into 支票账户 values ('8888600002','支票账户',2013,to_date('2020/09/29','yyyy/mm/dd'),to_date('2021/02/17','yyyy/mm/dd'),195);
insert into 支票账户 values ('8888600003','支票账户',23013,to_date('2020/03/03','yyyy/mm/dd'),to_date('2021/05/06','yyyy/mm/dd'),2098);
insert into 支票账户 values ('8888600004','支票账户',39621,to_date('2021/01/12','yyyy/mm/dd'),to_date('2021/04/12','yyyy/mm/dd'),3999);

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
insert into 支行 (支行名,支行城市,资产) values ('城北支行','合肥',1099967);
insert into 支行 (支行名,支行城市,资产) values ('城南支行','北京',10299237);
insert into 支行 (支行名,支行城市,资产) values ('东渡支行','厦门',30934967);
insert into 支行 (支行名,支行城市,资产) values ('西北支行','西安',8992347);

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

alter table 贷款
   add constraint FK_贷款_发放_支行 foreign key (支行名)
      references 支行 (支行名);
