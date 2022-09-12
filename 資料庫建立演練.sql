--  DDL�y�k�m��
/*
�إ߸�ƮwTestDB,��Ʈw�n���T���ɮ׸s��(�t�w�]�s��),�C�s�ջݦ��G�Ӹ����,
�C�Ӹ���ɪ�l�e�q30MB,�C������30%,�̤j����2G,
�إߨ�ӰO����,��l�e�q10MB,����10MB,�̤j����2G,
����ɽЦsD:\DataBase�ؿ�,�O���ɽЦsD:\DBLog�ؿ�
*/
create database TestDB
on  (name = testdb_1, 
	filename = 'd:\DataBase�ؿ�\testdb_1.mdf' ,
	size = 30mb,
	maxsize = 2gb,
	filegrowth = 30%),
	
	(name = testdb_2, 
	filename = 'd:\DataBase�ؿ�\testdb_2.ndf' ,
	size = 30mb,
	maxsize = 2gb,
	filegrowth = 30%),

FILEGROUP G1
	( name =g1_1, 
	filename = 'd:\DataBase�ؿ�\g1_1.ndf' ,
	size = 30mb,
	maxsize = 2gb,
	filegrowth = 30%),

	( name =g1_2, 
	filename = 'd:\DataBase�ؿ�\g1_2.ndf' ,
	size = 30mb,
	maxsize = 2gb,
	filegrowth = 30%),

FILEGROUP G2
	( name =g2_1, 
	filename = 'd:\DataBase�ؿ�\g2_1.ndf' ,
	size = 30mb,
	maxsize = 2gb,
	filegrowth = 30%),

	( name =g2_2, 
	filename = 'd:\DataBase�ؿ�\g2_2.ndf' ,
	size = 30mb,
	maxsize = 2gb,
	filegrowth = 30%)

log on (name = testdb_LOG_1, 
	filename = 'd:\DBLog�ؿ�\testdb_LOG_1.ldf',
	size = 10mb,
	maxsize = 2gb,
	filegrowth = 10mb),

	(name = testdb_LOG_2, 
	filename = 'd:\DBLog�ؿ�\testdb_LOG_2.ldf',
	size = 10mb,
	maxsize = 2gb,
	filegrowth = 10mb)
GO

--������Ʈw
sp_detach_db  TESTDB
GO

--���[��Ʈw
CREATe DATAbase testDB on 
(filename = 'd:\DataBase�ؿ�\testdb_1.mdf')
for attach

--�bPrimary�s�ո̷s�W�@�Ӹ���ɮ� DB3.NDF
alter database testdb add file
(name = db3, 
	filename = 'd:\DataBase�ؿ�\db3.ndf' ,
	size = 30mb,
	maxsize = 2gb,
	filegrowth = 30%) 

--�R������ɮ� DB3.NDF
alter database testdb remove file db3 

--�зs�W�@���ɮ׸s��G3
alter database testdb add filegroup G3

--�s�W�@�Ӹ���ɮ�G3_DB1
alter database testdb add file
(name = G3_DB1, 
	filename = 'd:\DataBase�ؿ�\G3_DB1.ndf' ,
	size = 30mb,
	maxsize = 2gb,
	filegrowth = 30%) to filegroup G3

--�N�ɮ׸s��G3�קאּDefault�s��
alter database testdb MODIFY filegroup G3 DEFAULT

--�NPrimary�s�ո̪�����ɮת�������̤j��
alter database testdb MODIFY file
    (name = testdb_1, 
	maxsize = unlimited)

alter database testdb MODIFY file	
	(name = testdb_2, 
	maxsize = unlimited)

--�s�W�@�ӰO����DB_Log_3,�ɮפj�p500MB
alter database testdb add file	
(name = DB_Log_3, 
	filename = 'd:\DataBase�ؿ�\DB_Log_3.ndf' ,
	size = 500mb) 