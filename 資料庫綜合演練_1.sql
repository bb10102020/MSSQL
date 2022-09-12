/*
�@�B�бNSchdb_1.mdf���[�ܰ������(instance)���C�Ъ`�N�U�C����G�]5���^
	1.	��Ʈw�W�١ySchDB�z�C
	2.	����ɦ�m�yD:\DB\�z�C
*/
use master
go
sp_attach_db schdb,'D:\DB\schdb_1.mdf'
go

/*
�G�B�Цb�Ӹ�Ʈw���s�W1���ɮ׸s�աyG1�z�A
�æb�Ӹs�դ��s�W1�Ӹ���ɡySchdb_2.ndf�z�A
��l��20MB�A�۰ʦ���50MB�C�]5���^
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
�T�B�ySchDB�z��Ʈw���p��(ERD)�Χ@�~�ݨD�p�U�G
*/

--1.�Ь��y�Z�šz�إߥD��(PK)�Υ~����(FK)�H�ŦX�W�����p�[�c�]8���^
alter table �Z�� add constraint PK_�Z��_�нs�ҽs�ǭ� Primary KEY (�ҵ{�s��,�б½s��,�Ǹ�)
go
alter table �Z�� add constraint FK_�Z��_�нs Foreign KEY (�б½s��) references �б�(�б½s��)
go
alter table �Z�� add constraint FK_�Z��_�ҽs Foreign KEY (�ҵ{�s��) references �ҵ{(�ҵ{�s��)
go
alter table �Z�� add constraint FK_�Z��_�Ǹ� Foreign KEY (�Ǹ�) references �ǥ�(�Ǹ�)
go


--2.�Ыإߡy�Ыǡz��ƪ�ܡyG1�z�s�աA�æs�J�H�U��ơC�]5���^
create table �Ы�
( �Ыǽs�� nchar(5) primary key,
  �Ы�     nvarchar(10)	not null) on G1
go

insert �Ы� 
values	('100-M','�@��Ы�1'),
		('180-M','�@��Ы�2'),
		('221-S','�S��Ы�1'),
		('321-M','�@��Ы�3'),
		('327-S','�S��Ы�1'),
		('380-L','�M�~�Ы�1'),
		('500-K','�M�~�Ы�2'),
		('622-G','�M�~�Ы�3')
GO

--3.�Ь��y���u�z��ƪ�إߡy�q�ܡz�����\��NULLL���ˬd����
alter table ���u with nocheck add constraint CK_���u_�q�� CHECK (�q�� is not null)
go


--4.�бN�ҵ{�y�p�ⷧ�סz�אּ�y�p������סz�C�]2���^
select * from �ҵ{ where �W��='�p�ⷧ��'
go
update �ҵ{ set �W��='�p�������' where �ҵ{�s��='CS101'
go

--5.�����yG1�z�s�աC
sp_helpdb schdb
TRUNCATE TABLE �Ы�
GO
drop TABLE  �Ы�
go
alter database schdb remove file schdb_2
go

sp_helpfilegroup G1
alter database schdb remove FILEGROUP G1
go


--�C�D�����]���Ʒ��^
--�@�B�d�ߡi�ǥ͡j��ƪ��Ҧ��ǥͪ��Ǹ��B�m�W�M�ͤ�A�Y�L��ƽХH�y�����ѡz���
SELECT �Ǹ�, �m�W, isnull(cast(�ͤ� as nvarchar(10)),'������') �ͤ� FROM �ǥ�
GO
--�G�B�p��C����u���~���b�B(���J-��X)
SELECT �����Ҧr��, �m�W,�~��-�O�I-���| AS �~���b�B FROM ���u
GO
--�T�B�p��ǥͪ��~�֡A�Y�L��ƽХH�y�����ѡz���
SELECT �Ǹ�, �m�W, GETDATE() AS ����,isnull(cast(DATEDIFF(year, �ͤ�, GETDATE()) as nvarchar(10)) ,'������') AS �~�� 
FROM �ǥ�
GO
--�|�B��X�~���̰����e3�W���u
SELECT TOP 3 �~��,* FROM ���u ORDER BY  1  DESC
GO
--���B��X�~���̧C���e10%�W���u
SELECT TOP 10 PERCENT WITH TIES �~��,* FROM ���u ORDER BY 1
GO
--���B�b�i�ҵ{�j��ƪ��X�Ǥ��Ƴ̤֪�3���ҵ{�O����ơA���Y���ۦP�Ǥ��ƪ��O���]�@����X��
SELECT TOP 3 WITH TIES * FROM �ҵ{ ORDER BY �Ǥ�
GO
--�C�B�b�i�ǥ͡j��ƪ��X�Ҧ��k�P�Ǫ���ơC
SELECT  *  FROM �ǥ� WHERE �ʧO = '�k'
GO
--�K�B�b�i�Z�šj��ƪ�p�⦳�X��ǥͤWCS203���ҡC
SELECT �ҵ{�s��, COUNT(*) FROM �Z�� 
WHERE �ҵ{�s�� = 'CS203' GROUP BY �ҵ{�s��
GO
--�E�B�b�i�Z�šj��ƪ��X�б�I002�@�дX���ҡC
SELECT COUNT(*) �Ҽ� FROM �Z�� WHERE �б½s��='I002' 
GO
--�Q�B�b�i�Z�šj��ƪ��X�W�L3��ǥͤW�Ҫ��ҵ{�C
SELECT �ҵ{�s��, COUNT(*) �H�� FROM �Z�� GROUP BY �ҵ{�s��
HAVING COUNT(*) >= 3
GO
--�Q�@�B�d�ߡi���u�j��ƪ�Ҧ����u���O�I�`�M�P����
SELECT SUM(�O�I), AVG(�O�I) FROM ���u
GO
--�Q�G�B�d�ߡi�Z�šj��ƪ��A�W�ұЫǬO�b�G�Ӫ����(�Ыǲ�2�X�N��Ӽh)
SELECT DISTINCT �ҵ{�s��, �W�Үɶ�, �Ы�  FROM �Z��  WHERE �Ы� LIKE '_2%'
GO
--�Q�T�B��X1990�~2���1990�~10��X�ͪ��ǥ�
SELECT * FROM �ǥ� WHERE �ͤ� BETWEEN '1990-2-1' AND '1990-10-31'
GO
SELECT * FROM �ǥ� 
WHERE  DATEFROMPARTS ( YEAR(�ͤ�), MONTH(�ͤ�), DAY(�ͤ�)) >= '1990-01-01' AND  DATEFROMPARTS ( YEAR(�ͤ�), MONTH(�ͤ�), DAY(�ͤ�)) <= '1990-10-31'
GO

--�Q�|�B�ǥͤw�g�פFCS101�BCS222�BCS100�MCS213���|���ҡA�����ǥͬd�߬ݬ��٦�����ҵ{�i�H��
SELECT * FROM �ҵ{ WHERE �ҵ{�s�� NOT IN ('CS101', 'CS222', 'CS100', 'CS213')
GO
--�Q���B�Ч�X��b���A���o�S���d�q�ܪ����u
select * from ���u where ����='���' AND �q�� is null
go
--�Q���B�d�ߡi�ҵ{�j��ƪ��ҵ{�s�����]�t'2'���r��A�H�νҵ{�W����즳'�{��'���r��ξǤ��j�󵥩�4�����
SELECT * FROM �ҵ{
WHERE �ҵ{�s�� LIKE '%2%'  AND (�W�� LIKE '%�{��%' OR  �Ǥ�>=4)
go
--�Q�C�B�Ч�X�b���J�C��40000�������u
select * from ���u where (�~��-�O�I-���|)<40000
go
--�Q�K�B�вέp�i���u�j��ƪ��A�C�ӫ����������u�ơB�~���`�B�Υ����~��
SELECT ����,SUM(�~��) AS �~���`�B, avg(�~��) AS �~������ ,count(�����Ҧr��) ���u��
FROM ���u  group by ���� 
GO
--�Q�E�B�ХΡi�Z�šj��ƪ��X�u���б�1���ҵ{���б�
select �б½s��,count(distinct �ҵ{�s��) �б½ҵ{�ƶq 
FROM �Z�� 
group by �б½s�� having count(distinct �ҵ{�s��)=1
go

--�G�Q�B�ϥ�Grouping sets�p��б�I001�MI003�б½ҵ{���ǥͼơB�p�p�M�`�p
SELECT �б½s��, �ҵ{�s��, COUNT(�Ǹ�) AS �`��  FROM �Z�� 
WHERE �б½s�� IN ('I001', 'I003')
GROUP BY GROUPING SETS ((�б½s��, �ҵ{�s��),�б½s��,())
GO

--�C�D�����]�h��Ʒ��^
--�@�B�Ч�X�b���J�̰����Юv
SELECT  TOP 1  T.�б½s��,E.�m�W,E.�~��-E.�O�I-E.���| �b���J 
FROM  �б� T  INNER JOIN ���u E  ON T.�����Ҧr�� = E.�����Ҧr��
ORDER  BY  �b���J  DESC
GO
--�G�B�д��Ѥ@���̾Ǹ����W�ƧǪ��ǥͭ׷~�ҵ{��ơA��ƻݥ]�t�Ǹ��B�ǥͩm�W�B�׷~�ҵ{�B�½ұб¡B�W�ұЫǤΤW�Үɶ�
SELECT �ǥ�.�Ǹ�,�ǥ�.�m�W,�Z��.�ҵ{�s��,�ҵ{.�W��,�Z��.�б½s��,���u.�m�W,�Z��.�Ы�,�Z��.�W�Үɶ� 
FROM �ǥ� INNER JOIN �Z�� ON �ǥ�.�Ǹ� = �Z��.�Ǹ�  
		  INNER JOIN �ҵ{ ON �Z��.�ҵ{�s�� = �ҵ{.�ҵ{�s�� 
		  INNER JOIN �б� ON �Z��.�б½s�� = �б�.�б½s�� 
		  INNER JOIN ���u ON ���u.�����Ҧr�� = �б�.�����Ҧr�� 
ORDER BY  �ǥ�.�Ǹ�
GO
--�T�B�d��100-M�B221-S�B500-K���ЫǩҶ}�]���ҵ{�P�W�Үɶ�
SELECT DISTINCT �Z��.�Ы�,�Z��.�ҵ{�s��,�ҵ{.�W��,�Z��.�W�Үɶ� 
FROM  �Z�� INNER JOIN �ҵ{ ON �Z��.�ҵ{�s�� = �ҵ{.�ҵ{�s��
WHERE �Ы� IN ('100-M' ,'221-S' , '500-K')
GO
--�|�B�έp�C�@���ҵ{���׽ҤH�ơA�åH�ҵ{�W�ٻ��W�Ƨ�
SELECT O.�ҵ{�s��,O.�W��, COUNT(C.�ҵ{�s��)  �׽ҤH��
FROM �ҵ{ O  LEFT  JOIN �Z�� C  ON  C.�ҵ{�s�� = O.�ҵ{�s�� 
GROUP BY O.�ҵ{�s��,O.�W��
ORDER BY  O.�W��
GO
--���B��X�׽ҤH�ƧC��3�H���ҵ{�W��
SELECT O.�ҵ{�s��,O.�W��, COUNT(C.�ҵ{�s��)  �׽ҤH��
FROM �ҵ{ O  LEFT  JOIN �Z�� C  ON  C.�ҵ{�s�� = O.�ҵ{�s�� 
GROUP BY O.�ҵ{�s��,O.�W��
HAVING  COUNT(C.�ҵ{�s��) < 3
GO
--���B��X�ǥͻP���u�P�W�P�m���W�r
SELECT �m�W FROM �ǥ�  INTERSECT SELECT �m�W FROM ���u
GO
--�C�B�ϥΤl�d�ߧ�X�~���W�L5�U�����u���
SELECT ���~���u.�m�W, ���~���u.�q��, ���~���u.�~�� 
FROM (SELECT �����Ҧr��, �m�W, �q��, �~�� FROM ���u WHERE �~��>50000) AS ���~���u 
GO
--�K�B�ШϥΤl�d�ߧ�X�~�����󥭧��Ȫ����u���
SELECT * FROM  ���u WHERE �~��>(SELECT AVG(�~��) FROM ���u)
GO
--�E�B�Эp��ǥͱi�L�ҥ��Ǵ�����Ҽ�(�мg�X�ϥΤl�d�ߤΤ����X�֬d�ߪ��y�k)
SELECT COUNT(*) AS �W�Ҽ� FROM �Z�� WHERE �Ǹ� = (SELECT �Ǹ� FROM �ǥ� WHERE �m�W='�i�L��')
GO
SELECT COUNT(*) AS �W�Ҽ� FROM �Z�� C JOIN �ǥ� S ON C.�Ǹ�=S.�Ǹ� WHERE  S.�m�W = '�i�L��'
GO
--�Q�B�Ч�X�Ǹ�S004�S���W���ҵ{�M��
SELECT * FROM �ҵ{ WHERE �ҵ{�s�� NOT IN (SELECT �ҵ{�s�� FROM �Z�� WHERE �Ǹ�='S004')
GO
