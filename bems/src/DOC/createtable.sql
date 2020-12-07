CREATE TABLE TB_DEVICE
( 
	C_MASTER    VARCHAR2 (2) NOT NULL,
	C_SLAVE     VARCHAR2 (2) NOT NULL,
	C_NAME      VARCHAR2 (80) NOT NULL,
	I_ORDER     NUMBER   (3) NOT NULL,
	C_IPADDRESS VARCHAR2 (16),
	C_PORT      VARCHAR2 (5)
);

COMMENT ON TABLE BEMSDB.TB_DEVICE IS '장치테이블' ;
COMMENT ON COLUMN BEMSDB.TB_DEVICE.C_MASTER IS '상위코드' ;
COMMENT ON COLUMN BEMSDB.TB_DEVICE.C_SLAVE IS '하위코드' ;
COMMENT ON COLUMN BEMSDB.TB_DEVICE.C_NAME IS '명칭' ;
COMMENT ON COLUMN BEMSDB.TB_DEVICE.I_ORDER IS '순번' ;
COMMENT ON COLUMN BEMSDB.TB_DEVICE.C_IPADDRESS IS 'IP주소' ;
COMMENT ON COLUMN BEMSDB.TB_DEVICE.C_PORT IS '포트번호' ;

ALTER TABLE BEMSDB.TB_DEVICE ADD(
	PRIMARY KEY (C_MASTER,C_SLAVE, i_order));
	
	
CREATE TABLE TB_HISTORY
( 
	T_DATETIME  TIMESTAMP,
	C_MASTER    VARCHAR2 (2) NOT NULL,
	C_SLAVE     VARCHAR2 (2) NOT NULL,
	I_W_NOW		NUMBER(8,2),
	I_KWH_NOW	NUMBER(8,2)
);


COMMENT ON TABLE BEMSDB.TB_HISTORY IS '이력테이블' ;
COMMENT ON COLUMN BEMSDB.TB_HISTORY.T_DATETIME IS '시간' ;
COMMENT ON COLUMN BEMSDB.TB_HISTORY.C_MASTER IS '상위코드' ;
COMMENT ON COLUMN BEMSDB.TB_HISTORY.C_SLAVE IS '하위코드' ;
COMMENT ON COLUMN BEMSDB.TB_HISTORY.I_W_NOW IS '와트' ;
COMMENT ON COLUMN BEMSDB.TB_HISTORY.I_KWH_NOW IS 'KWH' ;

ALTER TABLE BEMSDB.TB_HISTORY ADD(
	PRIMARY KEY (T_DATETIME,C_MASTER,C_SLAVE));
	
CREATE TABLE TB_WATER
( 
	C_YYYYMM  	VARCHAR2 (6) NOT NULL,
	I_USE		NUMBER(8,2),
	I_USE_PAY	NUMBER(10,2)
);


COMMENT ON TABLE BEMSDB.TB_WATER IS '수도사용량테이블' ;
COMMENT ON COLUMN BEMSDB.TB_WATER.C_YYYYMM IS '년월' ;
COMMENT ON COLUMN BEMSDB.TB_WATER.I_USE IS '사용량_단위는평방미터' ;
COMMENT ON COLUMN BEMSDB.TB_WATER.I_USE_PAY IS '사용금액' ;

ALTER TABLE BEMSDB.TB_WATER ADD(
	PRIMARY KEY (C_YYYYMM));

CREATE TABLE TB_GAS
( 
	C_YYYYMM  	VARCHAR2 (6) NOT NULL,
	I_USE		NUMBER(8,2),
	I_USE_PAY	NUMBER(10,2)
);


COMMENT ON TABLE BEMSDB.TB_GAS IS '가스사용량테이블' ;
COMMENT ON COLUMN BEMSDB.TB_GAS.C_YYYYMM IS '년월' ;
COMMENT ON COLUMN BEMSDB.TB_GAS.I_USE IS '사용량_단위는평방미터' ;
COMMENT ON COLUMN BEMSDB.TB_GAS.I_USE_PAY IS '사용금액' ;

ALTER TABLE BEMSDB.TB_GAS ADD(
	PRIMARY KEY (C_YYYYMM));

	
CREATE TABLE TB_CO2
( 
	T_DATETIME  TIMESTAMP,
	C_MASTER    VARCHAR2 (2) NOT NULL,
	C_SLAVE     VARCHAR2 (2) NOT NULL,
	I_CO2		NUMBER(8,2),
	I_TEMP		NUMBER(8,2),
	I_HUMI		NUMBER(8,2)
);


COMMENT ON TABLE BEMSDB.TB_CO2 IS 'CO2테이블' ;
COMMENT ON COLUMN BEMSDB.TB_CO2.T_DATETIME IS '시간' ;
COMMENT ON COLUMN BEMSDB.TB_CO2.C_MASTER IS '상위코드' ;
COMMENT ON COLUMN BEMSDB.TB_CO2.C_SLAVE IS '하위코드' ;
COMMENT ON COLUMN BEMSDB.TB_CO2.I_CO2 IS 'CO2량' ;
COMMENT ON COLUMN BEMSDB.TB_CO2.I_TEMP IS '온도' ;
COMMENT ON COLUMN BEMSDB.TB_CO2.I_HUMI IS '습도' ;

ALTER TABLE BEMSDB.TB_CO2 ADD(
	PRIMARY KEY (T_DATETIME,C_MASTER,C_SLAVE));
	
CREATE TABLE TB_TEMPERATURE
( 
	T_DATETIME  TIMESTAMP,
	I_TEMP			NUMBER(8,2),
	I_HUMI			NUMBER(8,2),
	C_CONDITION	VARCHAR2(40)
);

COMMENT ON TABLE BEMSDB.TB_TEMPERATURE IS '외기온도테이블' ;
COMMENT ON COLUMN BEMSDB.TB_TEMPERATURE.T_DATETIME IS '시간' ;
COMMENT ON COLUMN BEMSDB.TB_TEMPERATURE.I_TEMP IS '온도' ;
COMMENT ON COLUMN BEMSDB.TB_TEMPERATURE.I_HUMI IS '습도' ;
COMMENT ON COLUMN BEMSDB.TB_TEMPERATURE.C_CONDITION IS '날씨' ;
ALTER TABLE BEMSDB.TB_TEMPERATURE ADD(
	PRIMARY KEY (T_DATETIME));

CREATE TABLE TB_ELECTRIC
( 
	C_YYYYMM  	VARCHAR2(6),
	C_MASTER    VARCHAR2 (2) NOT NULL,
	C_SLAVE     VARCHAR2 (2) NOT NULL,
	I_KWH		NUMBER(8,2),
	I_PAY		NUMBER(10,2)
);

COMMENT ON TABLE BEMSDB.TB_ELECTRIC IS '전력월간테이블' ;
COMMENT ON COLUMN BEMSDB.TB_ELECTRIC.C_YYYYMM IS '시간' ;
COMMENT ON COLUMN BEMSDB.TB_ELECTRIC.C_MASTER IS '마스터코드' ;
COMMENT ON COLUMN BEMSDB.TB_ELECTRIC.C_SLAVE IS 'slave코드' ;
COMMENT ON COLUMN BEMSDB.TB_ELECTRIC.I_KWH IS 'KWH사용량' ;
COMMENT ON COLUMN BEMSDB.TB_ELECTRIC.I_PAY IS '금액' ;

ALTER TABLE BEMSDB.TB_ELECTRIC ADD(
	PRIMARY KEY (C_YYYYMM, C_MASTER, C_SLAVE));
	

CREATE TABLE TB_BULLETIN
( 
	C_YYYYMM  	VARCHAR2(6),
	I_KWH		NUMBER(8,2),
	I_PAY		NUMBER(10,2)
);

COMMENT ON TABLE BEMSDB.TB_BULLETIN IS '전기고지서상에너지사용량' ;
COMMENT ON COLUMN BEMSDB.TB_BULLETIN.C_YYYYMM IS '년월' ;
COMMENT ON COLUMN BEMSDB.TB_BULLETIN.I_KWH IS '사용량' ;
COMMENT ON COLUMN BEMSDB.TB_BULLETIN.I_PAY IS '금액' ;


CREATE TABLE TB_SUNLIGHT
( 
	C_YYYYMM  	VARCHAR2(6),
	I_KWH		NUMBER(8,2),
	I_PAY		NUMBER(10,2)
);

COMMENT ON TABLE BEMSDB.TB_SUNLIGHT IS '태양광' ;
COMMENT ON COLUMN BEMSDB.TB_SUNLIGHT.C_YYYYMM IS '년월' ;
COMMENT ON COLUMN BEMSDB.TB_SUNLIGHT.I_KWH IS '발전량' ;
COMMENT ON COLUMN BEMSDB.TB_SUNLIGHT.I_PAY IS '금액' ;

CREATE TABLE TB_SUNHEAT
( 
	C_YYYYMM  	VARCHAR2(6),
	I_KWH		NUMBER(8,2),
	I_PAY		NUMBER(10,2)
);

COMMENT ON TABLE BEMSDB.TB_SUNHEAT IS '태양열' ;
COMMENT ON COLUMN BEMSDB.TB_SUNHEAT.C_YYYYMM IS '년월' ;
COMMENT ON COLUMN BEMSDB.TB_SUNHEAT.I_KWH IS '발전량' ;
COMMENT ON COLUMN BEMSDB.TB_SUNHEAT.I_PAY IS '금액' ;

CREATE TABLE TB_GEOTHERM
( 
	C_YYYYMM  	VARCHAR2(6),
	I_KWH		NUMBER(8,2),
	I_PAY		NUMBER(10,2)
);

COMMENT ON TABLE BEMSDB.TB_GEOTHERM IS '지열' ;
COMMENT ON COLUMN BEMSDB.TB_GEOTHERM.C_YYYYMM IS '년월' ;
COMMENT ON COLUMN BEMSDB.TB_GEOTHERM.I_KWH IS '발전량' ;
COMMENT ON COLUMN BEMSDB.TB_GEOTHERM.I_PAY IS '금액' ;


CREATE TABLE TB_MGAS
( 
	C_YYYYMMDD  VARCHAR2(8),
	I_DATA		NUMBER(8,2)
);

COMMENT ON TABLE BEMSDB.TB_MGAS IS '측정가스' ;
COMMENT ON COLUMN BEMSDB.TB_MGAS.C_YYYYMMDD IS '년월일' ;
COMMENT ON COLUMN BEMSDB.TB_MGAS.I_DATA IS '가스사용량' ;

CREATE TABLE TB_MWATER
( 
	C_YYYYMMDD  VARCHAR2(8),
	I_DATA		NUMBER(8,2)
);

COMMENT ON TABLE BEMSDB.TB_MWATER IS '측정수도' ;
COMMENT ON COLUMN BEMSDB.TB_MWATER.C_YYYYMMDD IS '년월일' ;
COMMENT ON COLUMN BEMSDB.TB_MWATER.I_DATA IS '수도사용량' ;


CREATE TABLE TB_TARGETELECT
(
	C_YYYYMM  	VARCHAR2(6),
	I_DATA		NUMBER(8,2)
);
COMMENT ON TABLE BEMSDB.TB_TARGETELECT IS '목표전력' ;
COMMENT ON COLUMN BEMSDB.TB_TARGETELECT.C_YYYYMM IS '년월' ;
COMMENT ON COLUMN BEMSDB.TB_TARGETELECT.I_DATA IS '목표사용량' ;


CREATE TABLE TB_TARGETGAS
(
	C_YYYYMM  	VARCHAR2(6),
	I_DATA		NUMBER(8,2)
);
COMMENT ON TABLE BEMSDB.TB_TARGETGAS IS '목표가스' ;
COMMENT ON COLUMN BEMSDB.TB_TARGETGAS.C_YYYYMM IS '년월' ;
COMMENT ON COLUMN BEMSDB.TB_TARGETGAS.I_DATA IS '목표사용량' ;

CREATE TABLE TB_TARGETWATER
(
	C_YYYYMM  	VARCHAR2(6),
	I_DATA		NUMBER(8,2)
);
COMMENT ON TABLE BEMSDB.TB_TARGETWATER IS '목표수도' ;
COMMENT ON COLUMN BEMSDB.TB_TARGETWATER.C_YYYYMM IS '년월' ;
COMMENT ON COLUMN BEMSDB.TB_TARGETWATER.I_DATA IS '목표사용량' ;

CREATE TABLE TB_TARGETELECTDaily
(
	C_YYYYMMDD  VARCHAR2(8),
	I_DATA		NUMBER(8,2)
);
COMMENT ON TABLE BEMSDB.TB_TARGETELECTDaily IS '일간목표전력' ;
COMMENT ON COLUMN BEMSDB.TB_TARGETELECTDaily.C_YYYYMMDD IS '년월일' ;
COMMENT ON COLUMN BEMSDB.TB_TARGETELECTDaily.I_DATA IS '목표사용량' ;

CREATE TABLE TB_TARGETGASDaily
(
	C_YYYYMMDD	VARCHAR2(8),
	I_DATA		NUMBER(8,2)
);
COMMENT ON TABLE BEMSDB.TB_TARGETGASDaily IS '일간목표가스' ;
COMMENT ON COLUMN BEMSDB.TB_TARGETGASDaily.C_YYYYMMDD IS '년월일' ;
COMMENT ON COLUMN BEMSDB.TB_TARGETGASDaily.I_DATA IS '목표사용량' ;

CREATE TABLE TB_TARGETWATERDaily
(
	C_YYYYMMDD  VARCHAR2(8),
	I_DATA		NUMBER(8,2)
);
COMMENT ON TABLE BEMSDB.TB_TARGETWATERDaily IS '일간목표수도' ;
COMMENT ON COLUMN BEMSDB.TB_TARGETWATERDaily.C_YYYYMMDD IS '년월일' ;
COMMENT ON COLUMN BEMSDB.TB_TARGETWATERDaily.I_DATA IS '목표사용량' ;



CREATE TABLE TB_DEVICEDESC
(
	C_MASTER  	VARCHAR2(2),
	C_SLAVE  	VARCHAR2(2),
	C_DESC		VARCHAR2(40),
	C_USEYN		CHAR(1),
	C_POINT		VARCHAR2(6),
	I_MAX		NUMBER(9,3),
	I_MIN		NUMBER(9,3)
);

ALTER TABLE BEMSDB.TB_DEVICEDESC ADD(
	PRIMARY KEY (C_MASTER, C_SALVE));
	
COMMENT ON TABLE BEMSDB.TB_DEVICEDESC IS '설비장치설명테이블' ;
COMMENT ON COLUMN BEMSDB.TB_DEVICEDESC.C_MASTER IS '마스터코드' ;
COMMENT ON COLUMN BEMSDB.TB_DEVICEDESC.C_SLAVE IS '슬레이브코드' ;
COMMENT ON COLUMN BEMSDB.TB_DEVICEDESC.C_DESC IS '설명' ;
COMMENT ON COLUMN BEMSDB.TB_DEVICEDESC.C_USEYN IS '사용유무 1:사용/0:사용안함' ;
COMMENT ON COLUMN BEMSDB.TB_DEVICEDESC.C_POINT IS '단위' ;
COMMENT ON COLUMN BEMSDB.TB_DEVICEDESC.I_MAX IS '기준상한값' ;
COMMENT ON COLUMN BEMSDB.TB_DEVICEDESC.I_MIN IS '기준하한값' ;

CREATE TABLE TB_ROWDATA
( 
	T_DATETIME  TIMESTAMP,
	C_MASTER    VARCHAR2 (2) NOT NULL,
	C_SLAVE     VARCHAR2 (2) NOT NULL,
	I_NUM				NUMBER(3),
	I_W_NOW		NUMBER(8,2),
	I_KWH_NOW	NUMBER(8,2)
);


COMMENT ON TABLE BEMSDB.TB_ROWDATA IS '이력테이블' ;
COMMENT ON COLUMN BEMSDB.TB_ROWDATA.T_DATETIME IS '시간' ;
COMMENT ON COLUMN BEMSDB.TB_ROWDATA.C_MASTER IS '상위코드' ;
COMMENT ON COLUMN BEMSDB.TB_ROWDATA.C_SLAVE IS '하위코드' ;
COMMENT ON COLUMN BEMSDB.TB_ROWDATA.I_NUM IS '결선번호' ;
COMMENT ON COLUMN BEMSDB.TB_ROWDATA.I_W_NOW IS '와트' ;
COMMENT ON COLUMN BEMSDB.TB_ROWDATA.I_KWH_NOW IS 'KWH' ;

ALTER TABLE BEMSDB.TB_ROWDATA ADD(
	PRIMARY KEY (T_DATETIME,C_MASTER,C_SLAVE,I_NUM));
	
CREATE TABLE TB_DATADESC
( 
	C_MASTER    VARCHAR2 (2) NOT NULL,
	C_SLAVE     VARCHAR2 (2) NOT NULL,
	C_SLAVE1    VARCHAR2 (2) NOT NULL,
	I_NUM				NUMBER(3),
	C_DESC			VARCHAR2(80)
);


COMMENT ON TABLE BEMSDB.TB_DATADESC IS '층별원별결선별구분' ;
COMMENT ON COLUMN BEMSDB.TB_DATADESC.C_MASTER IS '상위코드' ;
COMMENT ON COLUMN BEMSDB.TB_DATADESC.C_SLAVE IS '하위코드' ;
COMMENT ON COLUMN BEMSDB.TB_DATADESC.C_SLAVE1 IS '하위코드1' ;
COMMENT ON COLUMN BEMSDB.TB_DATADESC.I_NUM IS '결선번호' ;
COMMENT ON COLUMN BEMSDB.TB_DATADESC.C_DESC IS '설명' ;

ALTER TABLE BEMSDB.TB_DATADESC ADD(
	PRIMARY KEY (C_MASTER,C_SLAVE,C_SLAVE1,I_NUM));	

insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','1','4층',1,'192.168.1.74','502');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','2','4층-CO2',2,'192.168.1.9','5000');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','3','5층',1,'192.168.1.75','502');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','4','5층-CO2',1,'192.168.1.75','5000');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','4','5층-CO2',2,'192.168.1.175','5000');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','4','5층-CO2',3,'192.168.1.176','5000');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','5','6층',5,'192.168.1.76','502');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','6','6층-CO2',6,'192.168.1.76','5000');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','7','7층',7,'192.168.1.77','502');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','8','7층-CO2',8,'192.168.1.77','5000');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','9','8층',9,'192.168.1.78','502');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','10','8층-CO2',10,'192.168.1.78','5000');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','11','9층',11,'192.168.1.79','502');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','12','9층-CO2',12,'192.168.1.79','5000');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','13','10층',13,'192.168.1.80','502');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','14','10층-CO2',14,'192.168.1.80','5000');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','15','가스보일러',1,'192.168.1.81','5000');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','16','패키지에어컨',1,'192.168.1.82','5000');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','17','싱글형에어컨(냉난방)',1,'192.168.1.83','5000');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','18','싱글형에어컨(냉방)',1,'192.168.1.84','5000');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('0','19','전열환기유니트',1,'192.168.1.85','5000');

insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('1','1','냉방',1,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('1','2','난방',2,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('1','3','급탕',3,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('1','4','환기',4,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('1','5','조명',5,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('1','6','콘센트',6,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('3','1','냉방',1,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('3','2','난방',2,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('3','3','급탕',3,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('3','4','환기',4,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('3','5','조명',5,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('3','6','콘센트',6,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('5','1','냉방',1,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('5','2','난방',2,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('5','3','급탕',3,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('5','4','환기',4,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('5','5','조명',5,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('5','6','콘센트',6,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('7','1','냉방',1,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('7','2','난방',2,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('7','3','급탕',3,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('7','4','환기',4,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('7','5','조명',5,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('7','6','콘센트',6,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('9','1','냉방',1,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('9','2','난방',2,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('9','3','급탕',3,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('9','4','환기',4,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('9','5','조명',5,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('9','6','콘센트',6,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('11','1','냉방',1,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('11','2','난방',2,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('11','3','급탕',3,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('11','4','환기',4,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('11','5','조명',5,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('11','6','콘센트',6,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('13','1','냉방',1,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('13','2','난방',2,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('13','3','급탕',3,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('13','4','환기',4,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('13','5','조명',5,'','');
insert into tb_device(c_master, c_slave, c_name, i_order, c_ipaddress, c_port) values ('13','6','콘센트',6,'','');


CREATE TABLE TB_GAS2 (
	C_YYYYMMDD VARCHAR2(8)
	, C_FLOOR VARCHAR2(2)
	, I_USE NUMBER(8,2)
	, I_USE_PAY NUMBER(10,2)
	, CONSTRAINT TB_GAS2_PK PRIMARY KEY (C_YYYYMMDD, C_FLOOR)
);

COMMENT ON TABLE BEMSDB.TB_GAS2 IS '일별가스사용량정보입력' ;
COMMENT ON COLUMN BEMSDB.TB_GAS2.C_YYYYMMDD IS '년월일' ;
COMMENT ON COLUMN BEMSDB.TB_GAS2.C_FLOOR IS '층' ;
COMMENT ON COLUMN BEMSDB.TB_GAS2.I_USE IS '사용량' ;
COMMENT ON COLUMN BEMSDB.TB_GAS2.I_USE_PAY IS '사용금액' ;

CREATE TABLE TB_WATER2 (
	C_YYYYMMDD VARCHAR2(8)
	, C_FLOOR VARCHAR2(2)
	, I_USE NUMBER(8,2)
	, I_USE_PAY NUMBER(10,2)
	, CONSTRAINT TB_WATER2_PK PRIMARY KEY (C_YYYYMMDD, C_FLOOR)
);

COMMENT ON TABLE BEMSDB.TB_WATER2 IS '일별수도사용량정보입력' ;
COMMENT ON COLUMN BEMSDB.TB_WATER2.C_YYYYMMDD IS '년월일' ;
COMMENT ON COLUMN BEMSDB.TB_WATER2.C_FLOOR IS '층' ;
COMMENT ON COLUMN BEMSDB.TB_WATER2.I_USE IS '사용량' ;
COMMENT ON COLUMN BEMSDB.TB_WATER2.I_USE_PAY IS '사용금액' ;

CREATE TABLE TB_ELECTRIC2 (
	C_YYYYMMDD VARCHAR2(8)
	, C_FLOOR VARCHAR2(2)
	, I_USE NUMBER(8,2)
	, I_USE_PAY NUMBER(10,2)
	, CONSTRAINT TB_ELECTRIC2_PK PRIMARY KEY (C_YYYYMMDD, C_FLOOR)
);

COMMENT ON TABLE BEMSDB.TB_ELECTRIC2 IS '일별전기사용량정보입력' ;
COMMENT ON COLUMN BEMSDB.TB_ELECTRIC2.C_YYYYMMDD IS '년월일' ;
COMMENT ON COLUMN BEMSDB.TB_ELECTRIC2.C_FLOOR IS '층' ;
COMMENT ON COLUMN BEMSDB.TB_ELECTRIC2.I_USE IS '사용량' ;
COMMENT ON COLUMN BEMSDB.TB_ELECTRIC2.I_USE_PAY IS '사용금액' ;