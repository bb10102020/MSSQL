/*
一、請將Schdb_1.mdf附加至執行個體(instance)中。請注意下列條件：（5分）
	1.	資料庫名稱『SchDB』。
	2.	資料檔位置『D:\DB\』。
*/
use master
go
sp_attach_db schdb,'D:\DB\schdb_1.mdf'
go

/*
二、請在該資料庫中新增1個檔案群組『G1』，
並在該群組中新增1個資料檔『Schdb_2.ndf』，
初始為20MB，自動成長50MB。（5分）
*/
use SchDB
go

alter database schdb add filegroup G1
go

alter database schdb 
add file
	(name=schdb_2,
	filename='C:\DB\Schdb_2.ndf',
	size=20MB,
	filegrowth=50MB)to filegroup G1
go

/*
三、『SchDB』資料庫關聯表(ERD)及作業需求如下：
*/

--1.請為『班級』建立主鍵(PK)及外來鍵(FK)以符合上圖關聯架構（8分）
alter table 班級 add constraint PK_班級_教編課編學員 Primary KEY (課程編號,教授編號,學號)
go
alter table 班級 add constraint FK_班級_教編 Foreign KEY (教授編號) references 教授(教授編號)
go
alter table 班級 add constraint FK_班級_課編 Foreign KEY (課程編號) references 課程(課程編號)
go
alter table 班級 add constraint FK_班級_學號 Foreign KEY (學號) references 學生(學號)
go


--2.請建立『教室』資料表至『G1』群組，並存入以下資料。（5分）
create table 教室
( 教室編號 nchar(5) primary key,
  教室     nvarchar(10)	not null) on G1
go

insert 教室 
values	('100-M','一般教室1'),
		('180-M','一般教室2'),
		('221-S','特殊教室1'),
		('321-M','一般教室3'),
		('327-S','特殊教室1'),
		('380-L','專業教室1'),
		('500-K','專業教室2'),
		('622-G','專業教室3')
GO

--3.請為『員工』資料表建立『電話』不允許為NULLL的檢查條件
alter table 員工 with nocheck add constraint CK_員工_電話 CHECK (電話 is not null)
go


--4.請將課程『計算概論』改為『計算機概論』。（2分）
select * from 課程 where 名稱='計算概論'
go
update 課程 set 名稱='計算機概論' where 課程編號='CS101'
go

--5.移除『G1』群組。
sp_helpdb schdb
TRUNCATE TABLE 教室
GO
drop TABLE  教室
go
alter database schdb remove file schdb_2
go

sp_helpfilegroup G1
alter database schdb remove FILEGROUP G1
go


--每題２分（單資料源）
--一、查詢【學生】資料表的所有學生的學號、姓名和生日，若無資料請以『未提供』顯示
SELECT 學號, 姓名, isnull(cast(生日 as nvarchar(10)),'未提供') 生日 FROM 學生
GO
--二、計算每位員工的薪水淨額(收入-支出)
SELECT 身份證字號, 姓名,薪水-保險-扣稅 AS 薪水淨額 FROM 員工
GO
--三、計算學生的年齡，若無資料請以『未提供』顯示
SELECT 學號, 姓名, GETDATE() AS 今天,isnull(cast(DATEDIFF(year, 生日, GETDATE()) as nvarchar(10)) ,'未提供') AS 年齡 
FROM 學生
GO
--四、找出薪水最高的前3名員工
SELECT TOP 3 薪水,* FROM 員工 ORDER BY  1  DESC
GO
--五、找出薪水最低的前10%名員工
SELECT TOP 10 PERCENT WITH TIES 薪水,* FROM 員工 ORDER BY 1
GO
--六、在【課程】資料表找出學分數最少的3筆課程記錄資料，但若有相同學分數的記錄也一併顯出來
SELECT TOP 3 WITH TIES * FROM 課程 ORDER BY 學分
GO
--七、在【學生】資料表找出所有女同學的資料。
SELECT  *  FROM 學生 WHERE 性別 = '女'
GO
--八、在【班級】資料表計算有幾位學生上CS203的課。
SELECT 課程編號, COUNT(*) FROM 班級 
WHERE 課程編號 = 'CS203' GROUP BY 課程編號
GO
--九、在【班級】資料表找出教授I002共教幾門課。
SELECT COUNT(*) 課數 FROM 班級 WHERE 教授編號='I002' 
GO
--十、在【班級】資料表找出超過3位學生上課的課程。
SELECT 課程編號, COUNT(*) 人數 FROM 班級 GROUP BY 課程編號
HAVING COUNT(*) >= 3
GO
--十一、查詢【員工】資料表所有員工的保險總和與平均
SELECT SUM(保險), AVG(保險) FROM 員工
GO
--十二、查詢【班級】資料表中，上課教室是在二樓的資料(教室第2碼代表樓層)
SELECT DISTINCT 課程編號, 上課時間, 教室  FROM 班級  WHERE 教室 LIKE '_2%'
GO
--十三、找出1990年2月到1990年10月出生的學生
SELECT * FROM 學生 WHERE 生日 BETWEEN '1990-2-1' AND '1990-10-31'
GO
SELECT * FROM 學生 
WHERE  DATEFROMPARTS ( YEAR(生日), MONTH(生日), DAY(生日)) >= '1990-01-01' AND  DATEFROMPARTS ( YEAR(生日), MONTH(生日), DAY(生日)) <= '1990-10-31'
GO

--十四、學生已經修了CS101、CS222、CS100和CS213等四門課，請幫學生查詢看看還有什麼課程可以修
SELECT * FROM 課程 WHERE 課程編號 NOT IN ('CS101', 'CS222', 'CS100', 'CS213')
GO
--十五、請找出住在桃園，但卻沒有留電話的員工
select * from 員工 where 城市='桃園' AND 電話 is null
go
--十六、查詢【課程】資料表的課程編號欄位包含'2'的字串，以及課程名稱欄位有'程式'的字串或學分大於等於4的資料
SELECT * FROM 課程
WHERE 課程編號 LIKE '%2%'  AND (名稱 LIKE '%程式%' OR  學分>=4)
go
--十七、請找出淨收入低於40000元的員工
select * from 員工 where (薪水-保險-扣稅)<40000
go
--十八、請統計【員工】資料表中，每個城市中的員工數、薪水總額及平均薪資
SELECT 城市,SUM(薪水) AS 薪水總額, avg(薪水) AS 薪水平均 ,count(身份證字號) 員工數
FROM 員工  group by 城市 
GO
--十九、請用【班級】資料表找出只有教授1門課程的教授
select 教授編號,count(distinct 課程編號) 教授課程數量 
FROM 班級 
group by 教授編號 having count(distinct 課程編號)=1
go

--二十、使用Grouping sets計算教授I001和I003教授課程的學生數、小計和總計
SELECT 教授編號, 課程編號, COUNT(學號) AS 總數  FROM 班級 
WHERE 教授編號 IN ('I001', 'I003')
GROUP BY GROUPING SETS ((教授編號, 課程編號),教授編號,())
GO

--每題２分（多資料源）
--一、請找出淨收入最高的教師
SELECT  TOP 1  T.教授編號,E.姓名,E.薪水-E.保險-E.扣稅 淨收入 
FROM  教授 T  INNER JOIN 員工 E  ON T.身份證字號 = E.身份證字號
ORDER  BY  淨收入  DESC
GO
--二、請提供一份依學號遞增排序的學生修業課程資料，資料需包含學號、學生姓名、修業課程、授課教授、上課教室及上課時間
SELECT 學生.學號,學生.姓名,班級.課程編號,課程.名稱,班級.教授編號,員工.姓名,班級.教室,班級.上課時間 
FROM 學生 INNER JOIN 班級 ON 學生.學號 = 班級.學號  
		  INNER JOIN 課程 ON 班級.課程編號 = 課程.課程編號 
		  INNER JOIN 教授 ON 班級.教授編號 = 教授.教授編號 
		  INNER JOIN 員工 ON 員工.身份證字號 = 教授.身份證字號 
ORDER BY  學生.學號
GO
--三、查詢100-M、221-S、500-K等教室所開設的課程與上課時間
SELECT DISTINCT 班級.教室,班級.課程編號,課程.名稱,班級.上課時間 
FROM  班級 INNER JOIN 課程 ON 班級.課程編號 = 課程.課程編號
WHERE 教室 IN ('100-M' ,'221-S' , '500-K')
GO
--四、統計每一門課程的修課人數，並以課程名稱遞增排序
SELECT O.課程編號,O.名稱, COUNT(C.課程編號)  修課人數
FROM 課程 O  LEFT  JOIN 班級 C  ON  C.課程編號 = O.課程編號 
GROUP BY O.課程編號,O.名稱
ORDER BY  O.名稱
GO
--五、找出修課人數低於3人的課程名稱
SELECT O.課程編號,O.名稱, COUNT(C.課程編號)  修課人數
FROM 課程 O  LEFT  JOIN 班級 C  ON  C.課程編號 = O.課程編號 
GROUP BY O.課程編號,O.名稱
HAVING  COUNT(C.課程編號) < 3
GO
--六、找出學生與員工同名同姓的名字
SELECT 姓名 FROM 學生  INTERSECT SELECT 姓名 FROM 員工
GO
--七、使用子查詢找出薪水超過5萬的員工資料
SELECT 高薪員工.姓名, 高薪員工.電話, 高薪員工.薪水 
FROM (SELECT 身份證字號, 姓名, 電話, 薪水 FROM 員工 WHERE 薪水>50000) AS 高薪員工 
GO
--八、請使用子查詢找出薪水高於平均值的員工資料
SELECT * FROM  員工 WHERE 薪水>(SELECT AVG(薪水) FROM 員工)
GO
--九、請計算學生張無忌本學期的選課數(請寫出使用子查詢及內部合併查詢的語法)
SELECT COUNT(*) AS 上課數 FROM 班級 WHERE 學號 = (SELECT 學號 FROM 學生 WHERE 姓名='張無忌')
GO
SELECT COUNT(*) AS 上課數 FROM 班級 C JOIN 學生 S ON C.學號=S.學號 WHERE  S.姓名 = '張無忌'
GO
--十、請找出學號S004沒有上的課程清單
SELECT * FROM 課程 WHERE 課程編號 NOT IN (SELECT 課程編號 FROM 班級 WHERE 學號='S004')
GO
