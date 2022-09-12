--  DDL語法練習
/*
建立資料庫TestDB,資料庫要有三個檔案群組(含預設群組),每群組需有二個資料檔,
每個資料檔初始容量30MB,每次成長30%,最大限制2G,
建立兩個記錄檔,初始容量10MB,成長10MB,最大限制2G,
資料檔請存D:\DataBase目錄,記錄檔請存D:\DBLog目錄
*/
create database TestDB
on  (name = testdb_1, 
	filename = 'd:\DataBase目錄\testdb_1.mdf' ,
	size = 30mb,
	maxsize = 2gb,
	filegrowth = 30%),
	
	(name = testdb_2, 
	filename = 'd:\DataBase目錄\testdb_2.ndf' ,
	size = 30mb,
	maxsize = 2gb,
	filegrowth = 30%),

FILEGROUP G1
	( name =g1_1, 
	filename = 'd:\DataBase目錄\g1_1.ndf' ,
	size = 30mb,
	maxsize = 2gb,
	filegrowth = 30%),

	( name =g1_2, 
	filename = 'd:\DataBase目錄\g1_2.ndf' ,
	size = 30mb,
	maxsize = 2gb,
	filegrowth = 30%),

FILEGROUP G2
	( name =g2_1, 
	filename = 'd:\DataBase目錄\g2_1.ndf' ,
	size = 30mb,
	maxsize = 2gb,
	filegrowth = 30%),

	( name =g2_2, 
	filename = 'd:\DataBase目錄\g2_2.ndf' ,
	size = 30mb,
	maxsize = 2gb,
	filegrowth = 30%)

log on (name = testdb_LOG_1, 
	filename = 'd:\DBLog目錄\testdb_LOG_1.ldf',
	size = 10mb,
	maxsize = 2gb,
	filegrowth = 10mb),

	(name = testdb_LOG_2, 
	filename = 'd:\DBLog目錄\testdb_LOG_2.ldf',
	size = 10mb,
	maxsize = 2gb,
	filegrowth = 10mb)
GO

--卸離資料庫
sp_detach_db  TESTDB
GO

--附加資料庫
CREATe DATAbase testDB on 
(filename = 'd:\DataBase目錄\testdb_1.mdf')
for attach

--在Primary群組裡新增一個資料檔案 DB3.NDF
alter database testdb add file
(name = db3, 
	filename = 'd:\DataBase目錄\db3.ndf' ,
	size = 30mb,
	maxsize = 2gb,
	filegrowth = 30%) 

--刪除資料檔案 DB3.NDF
alter database testdb remove file db3 

--請新增一個檔案群組G3
alter database testdb add filegroup G3

--新增一個資料檔案G3_DB1
alter database testdb add file
(name = G3_DB1, 
	filename = 'd:\DataBase目錄\G3_DB1.ndf' ,
	size = 30mb,
	maxsize = 2gb,
	filegrowth = 30%) to filegroup G3

--將檔案群組G3修改為Default群組
alter database testdb MODIFY filegroup G3 DEFAULT

--將Primary群組裡的資料檔案的不限制最大值
alter database testdb MODIFY file
    (name = testdb_1, 
	maxsize = unlimited)

alter database testdb MODIFY file	
	(name = testdb_2, 
	maxsize = unlimited)

--新增一個記錄檔DB_Log_3,檔案大小500MB
alter database testdb add file	
(name = DB_Log_3, 
	filename = 'd:\DataBase目錄\DB_Log_3.ndf' ,
	size = 500mb) 